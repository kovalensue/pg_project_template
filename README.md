# pg_project_template

Template repository for PostgreSQL dockerized dev environment. Migrations powered by sqitch, build powered by Make.

> Warning: This is still WIP and pretty much everything is subject to change. :D

## Requirements

### Sqitch
1) `docker pull sqitch/sqitch`
2) `curl -L https://git.io/JJKCn -o sqitch && chmod +x sqitch`

more info here: https://sqitch.org/download/docker/

### PostgreSQL

In this project we are using [official PosgreSQL image](https://hub.docker.com/_/postgres).

### psql

> Don't bother if you are using sqitch in docker - as mentioned in [sqitch documentation](https://sqitch.org/docs/manual/sqitchtutorial) psql is already included in the sqitch container ;-)

Install psql client to execute migrations, on Debian based distros you can use `sudo apt install postgresql-client`

## Project structure

> :warning: WORK IN PROGRESS

To init sqitch use:

`./sqitch init my_app --uri https://github.com/kovalensue/pg_project_template.git --engine pg --top-dir migrations`.

Issuing this command above you will initialize all directories and files *sqitch* needs to work.

> Feel free to just fork this project as is and edit whatever you want to suit your needs. :-)

```
.
├── docker
│   ├── docker-compose.yml
│   └── Dockerfile.my_app
├── LICENSE
├── Makefile
├── migrations
│   ├── deploy
│   ├── revert
│   ├── sqitch.plan
│   └── verify
├── my_app.conf
├── README.md
├── sqitch
└── sqitch.conf
```

### Docker

This folder contains all necessary configurations needed to run you dockerized db environment.

**Files:**
- `docker-compose.yml` - definition of all containers, networks and more you need to run your local environment
- `Dockerfile.my_app` - used to build new custom image of PostgreSQL with given version and specific set of extensions (you still need to run migrations with `CREATE EXTENSION ...` though)

### Makefile

Backbone of the project containing all targets needed to efficiently interact with your environment using `make` command.

For more info about each command see **Usage** section bellow.

## Usage

> :warning: WORK IN PROGRESS

In this section is described basic usage and how the project structure was actually created.

### Sqitch

All sqitch related things were done according to basic PostgreSQL tutorial available here: https://sqitch.org/docs/manual/sqitchtutorial/


TODO... basic config, creating migrations, etc.
