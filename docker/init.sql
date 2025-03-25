-- create databases
create database my_app;

-- create default role (owner of all objects)
create role my_app;

-- extensions
create extension pg_stat_statements;
create extension plpgsql_check;
