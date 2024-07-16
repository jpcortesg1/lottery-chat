# Nodejs API Lottery Chat

This project is a Node.js API designed specifically for the Lottery Chat application. Written in TypeScript, this API provides the backend services for the application, including user authentication, chat rooms, and lottery ticket purchases.

## Prerequisites

Ensure you have the following installed and configured before running the application:

1. **Node.js:** Install Node.js from the official website. (Version 22.2.0 or higher)
2. **NPM:** Node.js comes with npm installed. You can check the version by running `npm -v`.
3. **PostgreSQL:** Install PostgreSQL on your system. You can download it from the official website.

## Set up

### Environment Variables

Create a `.env` file in the root directory of the project and add the following environment variables:

```bash Copy code
DATABASE_URI=postgres://<username>:<password>@localhost:5432/lottery_chat
```

### Database configuration

Update the config.json file located in src/db/config/ to configure your database connection settings:

```json Copy code
{
  "development": {
    "username": "<username>",
    "password": "<password",
    "database": "lottery_chat",
    "host": "localhost",
    "dialect": "postgres"
  }
}
```

### Install Dependencies

Navigate to the project directory and run:

```bash Copy code
npm install
```

### Database Migration

Navigate to the src/db directory and run the following command to create the database tables:

```bash Copy code
npx sequelize-cli db:migrate
```

### Start the server

## Development Mode

To start the server in development mode, run:

```bash Copy code
npm run dev
```

### Alternatively
```bash Copy code
npm run dev:tsc
```

## Build and Run

To build the project and start the server, run:

```bash Copy code
npm run build
npm start
```

