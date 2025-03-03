-- Deploy myapp:users_table to pg

BEGIN;

create table users (id integer, name text);

COMMIT;
