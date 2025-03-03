-- Verify myapp:my_app_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('my_app', 'usage');

ROLLBACK;
