import { NextFunction, Request, Response, Router } from "express";

import {
  createLotterySchema,
  readLotterySchema,
} from "../schemas/lottery/index.schema";
import { validateSchemaMiddleware } from "../middlewares/schema/index.middleware.schema";
import { createLotteryController, readLotteryController } from "../controllers/lottery/index.controller";

const lotteryRouter = Router();

lotteryRouter.post(
  "/",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, createLotterySchema),
  createLotteryController
);

lotteryRouter.get(
  "/",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, readLotterySchema),
  readLotteryController
);

export default lotteryRouter;
