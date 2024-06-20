import { InferCreationAttributes } from "sequelize";

import db from "../db/models";
import { User } from "../db/models/User";

class UserService {
  model = db.User;

  async create(data: InferCreationAttributes<User>){
    try {
      const newUser = await this.model.create(data);
      return newUser;
    } catch (error) {
      throw error;
    }
  }
}

export const userService = new UserService();