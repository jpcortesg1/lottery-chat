"use strict";

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    /**
     * Add altering commands here.
     *
     * Example:
     * await queryInterface.createTable('users', { id: Sequelize.INTEGER });
     */
    await queryInterface.createTable("Lotteries", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      lotteryCode: {
        type: Sequelize.STRING(10),
        allowNull: false,
      },
      lotteryName: {
        type: Sequelize.STRING(48),
        allowNull: false,
      },
      frequency: {
        type: Sequelize.ENUM("daily", "weekly", "extraordinary"),
        allowNull: false,
      },
      gameDay: {
        type: Sequelize.STRING(12),
        allowNull: false,
      },
      gameTime: {
        type: Sequelize.TIME,
        allowNull: false,
      },
      drawNumber: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      headquarterCity: {
        type: Sequelize.STRING(64),
        allowNull: false,
      },
      whatsApp: {
        type: Sequelize.STRING(16),
        allowNull: true,
      },
      website: {
        type: Sequelize.STRING(64),
        allowNull: false,
      },
      fractionNumber: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      maxSeries: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      minSeries: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },

  async down(queryInterface, Sequelize) {
    /**
     * Add reverting commands here.
     *
     * Example:
     * await queryInterface.dropTable('users');
     */
    await queryInterface.dropTable("Lotteries");
  },
};
