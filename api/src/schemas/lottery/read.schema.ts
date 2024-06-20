import Joi from "joi";
import { InferCreationAttributes } from "sequelize";

import { Lottery } from "../../db/models/Lottery";

export const read = Joi.object<InferCreationAttributes<Lottery>>({
  lotteryName: Joi.string()
})