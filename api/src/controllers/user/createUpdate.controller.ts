import { Request, Response } from "express";
import { userService } from "../../services/user.service";
import { Op } from "sequelize";

export const createUpdate = async (req: Request, res: Response) => {
  try {
    const data = req.body;
    const { document, cellphone, email } = data;

    const users = await userService.read({
      [Op.or]: [{ document }, { cellphone }, { email }],
    });

    if (users.length >= 2) {
      return res.json({
        message:
          "User cannot be created or updated, there are already two users with the same document, cellphone or email",
        error: "Bad Request",
        status: 400,
      });
    }

    if (users.length <= 0) {
      const newUser = await userService.create({
        ...data,
        documentType: "cedula",
      });
      return res.json({
        message: "User created",
        status: 200,
        data: newUser,
      });
    }

    const user = users[0];
    const userUpdated = await userService.update(data, { id: user.id });

    return res.json({
      message: "User search and updated successfully",
      status: "200",
      data: userUpdated,
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
