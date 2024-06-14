import { InferCreationAttributes } from "sequelize";
import Joi from "joi";

import { User } from "../../db/models/user";

export const create = Joi.object<InferCreationAttributes<User>>({
  documentType: Joi.string().required(),
  document: Joi.number().required(),
  expeditionDate: Joi.date(),
  cellphone: Joi.number().required(),
  email: Joi.string().email().required(),
  name: Joi.string(),
  address: Joi.string(),
  postalCode: Joi.string(),
})

