import { InferCreationAttributes } from "sequelize";

import db from "../db/models";
import { Lottery } from "../db/models/Lottery";

class LotteryService {
  model = db.Lottery;

  async create(data: InferCreationAttributes<Lottery>){
    try {
      const newLottery = await this.model.create(data);
      return newLottery;
    } catch (error) {
      throw error;
    }
  }
}

export const lotteryService = new LotteryService();