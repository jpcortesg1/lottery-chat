import {
  InferAttributes,
  InferCreationAttributes,
  WhereOptions,
} from "sequelize";

import db from "../db/models";
import { Lottery } from "../db/models/Lottery";

class LotteryService {
  model = db.Lottery;

  async create(data: InferCreationAttributes<Lottery>) {
    try {
      const newLottery = await this.model.create(data);
      return newLottery;
    } catch (error) {
      throw error;
    }
  }

  async read(
    data: WhereOptions<InferAttributes<Lottery, { omit: never }>> | undefined
  ) {
    try {
      const lottery = await this.model.findAll({
        where: data,
      });
      return lottery;
    } catch (error) {
      throw error;
    }
  }
}

export const lotteryService = new LotteryService();
