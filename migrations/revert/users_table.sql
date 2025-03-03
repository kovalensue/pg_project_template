-- Revert myapp:users_table from pg

BEGIN;

create table users (id integer, name text);

COMMIT;
