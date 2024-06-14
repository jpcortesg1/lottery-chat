"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Users", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      documentType: {
        type: Sequelize.STRING(12),
        allowNull: false,
      },
      document: {
        type: Sequelize.BIGINT,
        unique: true,
        allowNull: false,
      },
      expeditionDate: {
        type: Sequelize.DATEONLY,
        allowNull: true,
      },
      countryCodePhone: {
        type: Sequelize.STRING(3),
        defaultValue: "+57",
        allowNull: false,
      },
      cellphone: {
        type: Sequelize.BIGINT,
        unique: true,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING(64),
        unique: true,
        allowNull: false,
      },
      name: {
        type: Sequelize.STRING(64),
        allowNull: true,
      },
      address: {
        type: Sequelize.STRING(128),
        allowNull: true,
      },
      postalCode: {
        type: Sequelize.STRING(10),
        allowNull: true,
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
    await queryInterface.dropTable("Users");
  },
};
