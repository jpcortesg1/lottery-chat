"use strict";

import {
  DataTypes,
  Sequelize,
  Model,
  CreationOptional,
  InferAttributes,
  InferCreationAttributes,
} from "sequelize";

export class User extends Model<InferAttributes<User>, InferCreationAttributes<User>> {
  declare id: CreationOptional<number>;
  declare documentType: string;
  declare document: number;
  declare expeditionDate: Date | null;
  declare countryCodePhone: string;
  declare cellphone: number;
  declare email: string;
  declare name: string | null;
  declare address: string | null;
  declare postalCode: string | null;
  declare readonly createdAt: CreationOptional<Date>;
  declare readonly updatedAt: CreationOptional<Date>;
}

const initializeUser = (sequelize: Sequelize) => {
  User.init(
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      documentType: {
        type: DataTypes.STRING(12),
        allowNull: false,
      },
      document: {
        type: DataTypes.BIGINT,
        unique: true,
        allowNull: false,
      },
      expeditionDate: {
        type: DataTypes.DATEONLY,
        allowNull: true,
      },
      countryCodePhone: {
        type: DataTypes.STRING(3),
        defaultValue: "+57",
        allowNull: false,
      },
      cellphone: {
        type: DataTypes.BIGINT,
        unique: true,
        allowNull: false,
      },
      email: {
        type: DataTypes.STRING(64),
        unique: true,
        allowNull: false,
      },
      name: {
        type: DataTypes.STRING(64),
        allowNull: true,
      },
      address: {
        type: DataTypes.STRING(128),
        allowNull: true,
      },
      postalCode: {
        type: DataTypes.STRING(10),
        allowNull: true,
      },
      createdAt: DataTypes.DATE,
      updatedAt: DataTypes.DATE,
    },
    {
      sequelize,
      modelName: "User",
      tableName: "Users",
    }
  );
  return User;
};

export default initializeUser;
