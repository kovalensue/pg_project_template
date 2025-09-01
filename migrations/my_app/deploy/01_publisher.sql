-- Deploy my-app:01_publisher to pg

BEGIN;

create role my_app_replica with login replication;

create table if not exists test_table (
    id serial primary key,
    name varchar(255) not null,
    created_at timestamp with time zone default current_timestamp
);

create publication my_app_pub for table test_table;

COMMIT;
