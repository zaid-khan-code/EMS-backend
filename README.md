# EMS Backend

Node.js/Express backend for an Employee Management System (EMS), using PostgreSQL for persistence and a modular MVC-style structure (routes → controllers → services → models → database).

## Tech Stack

- Runtime: Node.js (ES modules)
- Framework: Express 5
- Database: PostgreSQL
- ORM/DB Client: `pg` (query builder via SQL strings)
- Auth: JWT (`jsonwebtoken`) + password hashing (`bcrypt`)
- Env/config: `dotenv`
- Dev tooling: `nodemon`

## Project Structure

- [server.js](server.js) — Express app bootstrap, CORS, JSON middleware, and route mounting.
- [src/config/db.js](src/config/db.js) — PostgreSQL pool configuration using environment variables.
- [src/routes](src/routes) — Route definitions grouped by domain (employees, auth, leaves, payroll, etc.).
- [src/controllers](src/controllers) — Request/response handlers; validate input, call services, shape HTTP responses.
- [src/services](src/services) — Business logic layer; orchestrates models and cross-cutting logic.
- [src/models](src/models) — Direct DB access using SQL with `pg` (one file per table/domain).
- [database/creatingtables.sql](database/creatingtables.sql) — SQL schema for PostgreSQL tables.
- [ALL_MODELS_AND_SQL.md](ALL_MODELS_AND_SQL.md) — Documentation for models and corresponding SQL structure.

### Main Routes (high level)

All routes are mounted under `/api` in [server.js](server.js):

- Employees:
  - `/api` → employee info and extra employee info
  - `/api/job-status` → job status
  - `/api/job-info` → job information
  - `/api/reporting-managers` → reporting manager mapping
- Organization setup:
  - `/api/departments` → departments
  - `/api/designations` → designations
  - `/api/employment-types` → employment types
  - `/api/work-modes` → work modes
  - `/api/work-locations` → work locations
  - `/api/shifts` → shift definitions
- Leaves:
  - `/api/leave-types` → leave types
  - `/api/leave-policies` → leave policies
  - `/api/leave-balances` → leave balances
- Payroll & tax:
  - `/api/payroll-components` → payroll components
  - `/api/tax-config` → tax configuration
- Users & auth:
  - `/api/auth` → login/authentication
  - `/api/users` → user management
- Customization:
  - `/api/custom-fields` → custom field definitions

> For exact HTTP methods, request bodies, and response formats, inspect the corresponding files under `src/routes`, `src/controllers`, and `src/models`, or extend this README with per-endpoint docs as needed.

## Getting Started

### Prerequisites

- Node.js (LTS recommended)
- PostgreSQL instance

### Installation

1. Install dependencies:

   ```bash
   npm install
   ```

2. Create the database schema in PostgreSQL using the script:

   ```bash
   # Inside psql or a client of your choice
   \i database/creatingtables.sql
   ```

3. Create a `.env` file in the project root (same folder as `server.js`) with database and server configuration (see next section).

### Environment Variables

The app uses `dotenv` and [src/config/db.js](src/config/db.js) to configure the database pool. Typical variables:

```env
PORT=3000
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ems_db
JWT_SECRET=your_jwt_secret
BCRYPT_SALT_ROUNDS=10
```

Adjust names/values according to your local PostgreSQL setup and any additional variables used in controllers/services.

## Running the Server

Start the development server with nodemon:

```bash
npm start
```

By default the server listens on `http://localhost:3000` (or the `PORT` you set). The CORS configuration in [server.js](server.js) currently allows requests from `http://localhost:5173` by default.

You can verify that the server is up via:

```bash
curl http://localhost:3000/
```

which should return a JSON message:

```json
{ "message": "server is running" }
```

## Code Organization

- Each domain (e.g., employees, departments, leaves, payroll, auth) typically has:
  - a model in `src/models` (DB queries),
  - a service in `src/services` (business logic),
  - a controller in `src/controllers` (HTTP handling), and
  - a route file in `src/routes` (URL mapping).
- Shared middleware (e.g., auth) lives under `src/middleware`.

This separation keeps responsibilities clear and makes it easier to extend the system.

## Extending the API

To add a new domain/module:

1. Create a new table (or tables) in PostgreSQL and update `database/creatingtables.sql`.
2. Add a model file in `src/models` with the necessary queries.
3. Add a service in `src/services` that uses the model.
4. Add a controller in `src/controllers` that calls the service and handles HTTP details.
5. Add a route file in `src/routes` that maps URLs and methods to controller functions.
6. Mount the new routes in [server.js](server.js) under `/api/...`.

## Notes

- Error handling is centralized via the Express error middleware at the bottom of [server.js](server.js).
- Authentication and authorization behavior depends on the implementations in `src/middleware` and the auth/user modules; review and harden them before production use.
- Consider adding tests and more detailed endpoint documentation (OpenAPI/Swagger) as a next step.
