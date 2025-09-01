-- Deploy my-app:02_subscriber to pg

BEGIN;

create table if not exists test_table (
    id serial primary key,
    name varchar(255) not null,
    created_at timestamp with time zone default current_timestamp
);

COMMIT;

CREATE SUBSCRIPTION my_app_sub
CONNECTION 'dbname=my_app host=myapp user=my_app_replica'
PUBLICATION my_app_pub;


alter subscription my_app_sub refresh publication with (copy_data = true);