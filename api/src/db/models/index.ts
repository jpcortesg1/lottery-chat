import { Sequelize } from 'sequelize';

import initializeUser from './User';
import initializeLottery from './Lottery';

const env = process.env.NODE_ENV || 'development';
const config = require(__dirname + '/../config/config.json')[env];

let sequelize: Sequelize;
if (config.use_env_variable) {
  sequelize = new Sequelize(process.env[config.use_env_variable] as string, config);
} else {
  sequelize = new Sequelize(config.database, config.username, config.password, config);
}

const db = {
  sequelize,
  User: initializeUser(sequelize),
  Lottery: initializeLottery(sequelize),
};

export default db;
