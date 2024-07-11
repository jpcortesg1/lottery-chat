import {
  Attributes,
  InferAttributes,
  InferCreationAttributes,
  UpdateOptions,
  WhereOptions,
} from "sequelize";

import db from "../db/models";
import { User } from "../db/models/User";

class UserService {
  model = db.User;

  async read(
    data: WhereOptions<InferAttributes<User, { omit: never }>> | undefined
  ) {
    try {
      const users = await this.model.findAll({
        where: data,
      });
      return users;
    } catch (error) {
      throw error;
    }
  }

  async create(data: InferCreationAttributes<User>) {
    try {
      const newUser = await this.model.create(data);
      return newUser;
    } catch (error) {
      throw error;
    }
  }

  async update(
    data: InferAttributes<User>,
    where: WhereOptions<InferAttributes<User, { omit: never }>>
  ) {
    try {
      const user = await this.model.update(data, { returning: true, where });
      return user;
    } catch (error) {
      throw error;
    }
  }
}

export const userService = new UserService();
