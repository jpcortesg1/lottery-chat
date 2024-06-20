import { Request, Response } from "express";

import { lotteryService } from "../../services/lottery.service";

export const create = async (req: Request, res: Response) => {
  try {
    const newLottery = await lotteryService.create(req.body);
    return res.json({
      message: "Lottery created",
      status: "success",
      data: newLottery,
    });
  } catch (error) {
    if (error instanceof Error) {
      return res
        .json({
          message: error.message,
          error: "Internal Server Error",
          status: 500,
        })
        .status(500);
    }
  }
};
