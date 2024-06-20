import { Request, Response } from "express";
import { lotteryService } from "../../services/lottery.service";

export const read = async (req: Request, res: Response) => {
  try {
    const lotteries = await lotteryService.read(req.query);
    return res.json({
      message: "Lotteries found",
      status: "success",
      data: lotteries,
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
}