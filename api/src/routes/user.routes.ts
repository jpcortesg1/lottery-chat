import { NextFunction, Request, Response, Router } from "express";

import { createUserController, createUserUpdateController } from "../controllers/user/index.controller";
import { validateSchemaMiddleware } from "../middlewares/schema/index.middleware.schema";
import { createUserSchema, createUserUpdateSchema } from "../schemas/user/index.schema";

const userRouter = Router();

userRouter.post(
  "/",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, createUserSchema),
  createUserController
);

userRouter.post(
  "/create-update",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, createUserUpdateSchema),
  createUserUpdateController
);

export default userRouter;
