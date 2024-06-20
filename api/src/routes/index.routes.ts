import { Router } from "express";

import userRouter from "./user.routes";
import lotteryRouter from "./lottery.routes";

const router = Router();

router.use("/users", userRouter);
router.use("/lotteries", lotteryRouter);

export default router;
