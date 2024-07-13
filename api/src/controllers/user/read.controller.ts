import { Request, Response } from "express";
import { userService } from "../../services/user.service";

export const read = async (req: Request, res: Response) => {
  try {
    const users = await userService.read(req.query);

    return res.json({
      message: "Lotteries found",
      status: "success",
      data: users,
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
