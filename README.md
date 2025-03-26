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

To init sqitch use:

`./sqitch init my_app --uri https://github.com/kovalensue/pg_project_template.git --engine pg --top-dir migrations`.

Issuing this command above you will initialize all directories and files *sqitch* needs to work.

> Feel free to just fork this project as is and edit whatever you want to suit your needs. :-)

```
.
├── docker
│   ├── docker-compose.yml
│   ├── Dockerfile.my_app
│   └── init.sql
├── migrations
│   ├── default
│   ├── my_app
│   └── my_app_replica
│       ├── deploy
│       ├── revert
│       ├── verify
│       └── sqitch.plan
├── scripts
├── LICENSE
├── Makefile
├── README.md
├── sqitch
└── sqitch.conf
```

- **docker** - contains all neccessary configurations for running your dockerized db environment
  - `docker-compose.yml` - definition of all containers, networks and more you need to run your local environment
  - `Dockerfile.my_app` - used to build new custom image of PostgreSQL with given version and specific set of extensions (you still need to run migrations with `CREATE EXTENSION ...` though)
  - `init.sql` - runs during database initialization during container startup. Creates all stuff you need to have before development - roles, database, replication slots, extensions, ...
- **migrations** - contains all db changes created over time, subdirectories represent available targets specified in `sqitch.conf`. `Default` directory was created automatically during sqitch project initialization and right now serve no purpose. Subdirectories are created automatically when new target is added.
- **scripts** - directory for helper scripts of any kind
- **Makefile** - backbone of the project containing all targets needed to efficiently interact with your environment using `make` command. For more info about each command see **Usage** section bellow.
- **README.md** - this readme, but it should be your project readme :rolling_on_the_floor_laughing:
- **sqitch** - exacutable shell script allowing to run **sqitch** command using docker container (so no installation is needed)
- **sqitch.conf** - project wise **sqitch** configuration file - contains db, engine, project name, targets, etc.

## Usage

> :warning: WORK IN PROGRESS

In this section is described basic usage and how the project structure was actually created.

### Make

The whole project can be easily controlled using `make` command using targets defined in `Makefile`. Here are all available targets.

```shell
  db              Initialize and start dockerized db environment.
  db.stop         Stops local docker environments and remove all containers, networks etc.
  migr            Create **sqitch** migrations for given target.
  help            Displays help and usage information.
  image           Builds image according to docker file specified in `./docker`
```

Make targets are here to make your life easier, but if you are a skilled **Sqitch** or **Docker** user feel free to use these tools directly.

#### make db

Starts all services according to their definition inside `docker-compose.yml` file. If given services are running we stop them first. When databases are ready apply all migrations for all targets prefixed with `local@`.

**Example:**
```shell
make db
```
**Output:**
```shell
Starting local database(s)...
[+] Running 3/3
 ✔ Container my_app_replica      Removed                                               0.5s
 ✔ Container my_app              Removed                                               0.5s
 ✔ Network docker_my_app_db-dev  Removed                                               0.3s
[+] Running 3/3
 ✔ Network docker_my_app_db-dev  Created                                               0.2s
 ✔ Container my_app              Started                                               0.7s
 ✔ Container my_app_replica      Started                                               0.7s
Waiting for database(s) .......... Database(s) ready!
Adding registry tables to local@my_app
Deploying changes to local@my_app
  + create_schema .. ok
  + test ........... ok
Adding registry tables to local@my_app_replica
Deploying changes to local@my_app_replica
  + create_schema .. ok
  + mega-zmena ..... ok
```

#### make db.stop

This command will stop all databases created by `./docker/docker-compose.yml`. This command is here just for consistency and you won't need it much. :smiley:

**Example:**
```shell
make db.stop
```
**Output**
```shell
Stoping local database(s)...
[+] Running 3/3
 ✔ Container my_app              Removed                                               0.3s
 ✔ Container my_app_replica      Removed                                               0.3s
 ✔ Network docker_my_app_db-dev  Removed                                               0.1s
```

#### make migr

This command will start an interactive wizard which will help you to create a new migration to the database. Wizard will guide you through the all steps by prompting for a name (name of an actual SQL script), the change description and the target database you want to create a change for. All of this data is passed to **sqitch** which will prepare SQL scripts and add essential information to the correct `sqitch.plan` file.

The targets in the wizard are used to decided the correct directory for the sql scripts and to choose correct plan file. All targets prefixed with `local@` will be shown there.

**Example:**
```shell
make migr
Enter change name: my_app_first_change
Enter change description: The first change test.
1) local@my_app
2) local@my_app_replica
Select target(s) (comma-separated numbers): 1
Created migrations/my_app/deploy/my_app_first_change.sql
Created migrations/my_app/revert/my_app_first_change.sql
Created migrations/my_app/verify/my_app_first_change.sql
Added "my_app_first_change" to migrations/my_app/sqitch.plan
```

This is equivalent to call this **sqitch** command:
```shell
./sqitch add -m "The first change test" my_app_first_change local@my_app
```
So feel free to use **sqitch** directly if you like it more.

### Sqitch

All sqitch related things were done according to basic PostgreSQL tutorial available here: https://sqitch.org/docs/manual/sqitchtutorial/


TODO... basic config, creating migrations, etc.
