import { NextFunction, Request, Response, Router } from "express";

import { createLotterySchema } from "../schemas/lottery/index.schema";
import { validateSchemaMiddleware } from "../middlewares/schema/index.middleware.schema";
import { createLotteryController } from "../controllers/lottery/index.controller";

const lotteryRouter = Router();

lotteryRouter.post(
  "/",
  (req: Request, res: Response, next: NextFunction) =>
    validateSchemaMiddleware(req, res, next, createLotterySchema),
  createLotteryController
);

export default lotteryRouter;
