# pg_project_template
Template repository for PostgreSQL dockerized dev environment. Migrations powered by sqitch, build powered by Make.

## Requirements

### Sqitch
1) `docker pull sqitch/sqitch`
2) `curl -L https://git.io/JJKCn -o sqitch && chmod +x sqitch`

more info here: https://sqitch.org/download/docker/

### PostgreSQL

In this project we are using [official PosgreSQL image](https://hub.docker.com/_/postgres).

### PSQL

Install psql client to execute migrations, on Debian based distros you can use `sudo apt install postgresql-client`

## Usage

In this section is described basic usage and how the project structure was actually created.

### Sqitch

All sqitch related things were done according to basic PostgreSQL tutorial available here: https://sqitch.org/docs/manual/sqitchtutorial/

### Project structure

Template project structure was created using `sqitch init` command.

`./sqitch init myapp --uri https://github.com/kovalensue/pg_project_template.git --engine pg --top-dir src`.

After issuing this command your project should look like this.

> Feel free to just fork this project and update `sqitch.conf` to suit your needs :-)


```
.
├── LICENSE
├── README.md
├── sqitch
├── sqitch.conf  -- sqitch project-wise configuration
└── src
    ├── deploy       -- dir with SQL scripts to apply changes
    ├── revert       -- dir with SQL scripts to revert changes
    ├── sqitch.plan  -- file used by sqitch to apply changes in correct order
    └── verify       -- dir with SQL scripts to verify changes
```

TODO... basic config, creating migrations, etc.