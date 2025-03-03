-- Revert myapp:my_app_schema from pg

BEGIN;

DROP SCHEMA my_app;

COMMIT;
