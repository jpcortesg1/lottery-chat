// Import dependences
// External
import { NextFunction, Request, Response } from "express";
import Joi from "joi";

export const validate = (
  req: Request,
  res: Response,
  next: NextFunction,
  schema: Joi.ObjectSchema<any>
) => {
  try {
    // Define options
    const options: Joi.ValidationOptions = {
      abortEarly: true,
      allowUnknown: false,
      stripUnknown: false,
    };

    // Get type request and define that to validate
    const typeRequest = req.method;
    const toValidate = typeRequest === "GET" ? req.query : req.body;

    // Validate schema
    const { error, value } = schema.validate(toValidate, options);

    // Validate error and response
    if (error) {
      return res.status(400).json({
        message: "Bad request",
        status: 400,
        error: `Validation error: ${error.details
          .map((e) => e.message)
          .join(", ")}`,
      });
    }

    // Set value and next
    req.body = value;
    next();
  } catch (error: any) {
    console.log(error);
    return res.status(500).json({
      message: "Internal server error",
      status: 500,
      error: error.message,
    });
  }
};