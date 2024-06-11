
# Installation Guide for Vachan

This guide provides step-by-step instructions to set up and run the Vachan project, which is built using Elixir and the Phoenix framework, along with Ash and LiveView. 

---
## Prerequisites

Before you begin, ensure you have the following software installed on your system:

- **Elixir** (version 1.15 or later)
- **Erlang** (version 24 or later)
- **Node.js** (version 14.0.0 or later)
- **PostgreSQL** (version 12 or later)
- **Git**

### 1. Install Elixir and Erlang

Install Elixir and Erlang using the following instructions based on your operating system:

#### On macOS:
```sh
brew install elixir
```

#### On Ubuntu/Debian:
```sh
sudo apt-get update
sudo apt-get install -y elixir
```

#### On Windows:
Download the installer from the [official Elixir website](https://elixir-lang.org/install.html) and follow the installation instructions.

### 2. Install Node.js

Install Node.js from the [official Node.js website](https://nodejs.org/) or using a version manager like `nvm`.

#### Using nvm:
```sh
nvm install 14
nvm use 14
```

### 3. Install PostgreSQL

#### On macOS:
```sh
brew install postgresql
brew services start postgresql
```

#### On Ubuntu/Debian:
```sh
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

#### On Windows:
Download the installer from the [official PostgreSQL website](https://www.postgresql.org/download/) and follow the installation instructions.

### 4. Install Git

Install Git from the [official Git website](https://git-scm.com/) or using your system's package manager.

## Setting Up the Project

### 1. Clone the Repository

Clone the Vachan project repository from GitHub:

```sh
git clone https://github.com/essentiasoftserv/vachan.git
cd vachan
```

### 2. Install Dependencies

Install Elixir dependencies:

```sh
mix deps.get
```

Install Node.js dependencies:

```sh
cd assets
npm install
cd ..
```

### 3. Configure the Database

Ensure PostgreSQL is running and create a new PostgreSQL user and database:

#### Create User and Database:
```sh
psql postgres
CREATE USER postgres WITH PASSWORD 'postgres';
ALTER USER postgres CREATEDB;
CREATE DATABASE vachan_dev;
GRANT ALL PRIVILEGES ON DATABASE vachan_dev TO postgres;
\q
```

#### Update Configuration

Make sure  `config/dev.exs` file looks like this:

```elixir
config :vachan, Vachan.Repo,
  username: "postgres",
  password: "postgres",
  database: "vachan_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

### 4. Setup the Database

Create and migrate the database:

```sh
mix ash_postgres.create
mix ash_postgres.migrate
```

## Running the Application

### 1. Start the Phoenix Server

Run the Phoenix server:

```sh
mix phx.server
```

### 2. Access the Application

Open your web browser and navigate to:

```
http://localhost:4000
```

You should see the Vachan application running.


## Troubleshooting

### Common Issues

- **Database Connection Errors**: Ensure your database credentials are correct and PostgreSQL is running.
- **Dependency Errors**: Make sure all dependencies are installed and up-to-date.
- **Port Conflicts**: Ensure port 4000 is not being used by another application.

Check the application logs for more details:

```sh
mix phx.server
```


>> This `installation.md` file should provide comprehensive steps to install, configure, and run the Vachan project.  

---
