import { defineConfig } from "prisma/config";

const NODE_ENV = process.env.NODE_ENV ?? 'development';
const envPath = `./config/.env.${NODE_ENV}`;

require('dotenv').config({ path: envPath });

export default defineConfig({
  schema: "prisma/schema.prisma",
  migrations: {
    path: "prisma/migrations",
  },
  datasource: {
    url: process.env["DATABASE_URL"],
  },
});
