import {
  CreationOptional,
  DataTypes,
  InferAttributes,
  InferCreationAttributes,
  Model,
  Sequelize,
} from "sequelize";

export class Lottery extends Model<
  InferAttributes<Lottery>,
  InferCreationAttributes<Lottery>
> {
  declare id: CreationOptional<number>;
  declare lotteryCode: string;
  declare lotteryName: string;
  declare frequency: string;
  declare gameDay: string;
  declare gameTime: string;
  declare drawNumber: number;
  declare headquarterCity: string;
  declare whatsApp: CreationOptional<string>;
  declare website: string;
  declare fractionNumber: number;
  declare maxSeries: number;
  declare minSeries: number;
  declare createdAt: CreationOptional<Date>;
  declare updatedAt: CreationOptional<Date>;
}

const initializeLottery = (sequelize: Sequelize) => {
  Lottery.init(
    {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: DataTypes.INTEGER,
      },
      lotteryCode: {
        type: DataTypes.STRING(10),
        allowNull: false,
      },
      lotteryName: {
        type: DataTypes.STRING(48),
        allowNull: false,
      },
      frequency: {
        type: DataTypes.ENUM("daily", "weekly", "extraordinary"),
        allowNull: false,
      },
      gameDay: {
        type: DataTypes.STRING(12),
        allowNull: false,
      },
      gameTime: {
        type: DataTypes.TIME,
        allowNull: false,
      },
      drawNumber: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      headquarterCity: {
        type: DataTypes.STRING(64),
        allowNull: false,
      },
      whatsApp: {
        type: DataTypes.STRING(16),
        allowNull: true,
      },
      website: {
        type: DataTypes.STRING(64),
        allowNull: false,
      },
      fractionNumber: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      maxSeries: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      minSeries: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      createdAt: {
        allowNull: false,
        type: DataTypes.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: DataTypes.DATE,
      },
    },
    {
      sequelize,
      modelName: "Lottery",
      tableName: "Lotteries",
    }
  );

  return Lottery;
};

export default initializeLottery;
