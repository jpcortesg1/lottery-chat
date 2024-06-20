import Joi from "joi";
import { InferCreationAttributes } from "sequelize";

import { Lottery } from "../../db/models/Lottery";

export const create = Joi.object<InferCreationAttributes<Lottery>>({
  lotteryCode: Joi.string().required(),
  lotteryName: Joi.string().required(),
  frequency: Joi.string().valid("daily", "weekly", "extraordinary").required(),
  gameDay: Joi.string().required(),
  gameTime: Joi.string().required(),
  drawNumber: Joi.number().required(),
  headquarterCity: Joi.string().required(),
  whatsApp: Joi.string(),
  website: Joi.string().required(),
  fractionNumber: Joi.number().required(),
  maxSeries: Joi.number().required(),
  minSeries: Joi.number().required(),
});
