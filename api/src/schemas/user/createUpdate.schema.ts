import { InferCreationAttributes } from "sequelize";
import Joi from "joi";

import { User } from "../../db/models/User";

export const createUpdate = Joi.object<InferCreationAttributes<User>>({
  document: Joi.number().required(),
  cellphone: Joi.number().required(),
  email: Joi.string().email().required(),
  name: Joi.string().required(),
})

