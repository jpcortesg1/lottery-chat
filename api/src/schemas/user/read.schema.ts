import Joi from "joi";
import { InferCreationAttributes } from "sequelize";
import { User } from "../../db/models/User";

export const read = Joi.object<InferCreationAttributes<User>>({
  document: Joi.number(),
})