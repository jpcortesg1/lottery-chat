import { Request, Response } from "express";
import { userService } from "../../services/user.service";

export const create = async (req: Request, res: Response) => {
  try {
    const newUser = await userService.create(req.body);
    return res.json({
      message: "User created",
      status: "success",
      data: newUser,
    });
  } catch (error) {
    if (error instanceof Error) {
      return res
        .json({
          message: error.message,
          error: "Internal Server Error",
          status: "error",
        })
        .status(500);
    }
  }
}