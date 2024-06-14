import { NextFunction, Request, Response, Router } from "express";
import { createUserController } from "../controllers/user/index.controller";
import { validateSchemaMiddleware } from "../middlewares/schema/index.middleware.schema";
import { createUserSchema } from "../schemas/user/index.schema";

const userRouter = Router();

userRouter.post(
  "/",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, createUserSchema),
  createUserController
);

export default userRouter;
