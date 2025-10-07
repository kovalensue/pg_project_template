--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE my_app;
ALTER ROLE my_app WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "my_app" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: my_app; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE my_app WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE my_app OWNER TO postgres;

\connect my_app

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sqitch; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sqitch;


ALTER SCHEMA sqitch OWNER TO postgres;

--
-- Name: SCHEMA sqitch; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA sqitch IS 'Sqitch database deployment metadata v1.1.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: test_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_table (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.test_table OWNER TO postgres;

--
-- Name: test_table_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_table_id_seq OWNER TO postgres;

--
-- Name: test_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_table_id_seq OWNED BY public.test_table.id;


--
-- Name: changes; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.changes (
    change_id text NOT NULL,
    script_hash text,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.changes OWNER TO postgres;

--
-- Name: TABLE changes; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.changes IS 'Tracks the changes currently deployed to the database.';


--
-- Name: COLUMN changes.change_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.change_id IS 'Change primary key.';


--
-- Name: COLUMN changes.script_hash; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.script_hash IS 'Deploy script SHA-1 hash.';


--
-- Name: COLUMN changes.change; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.change IS 'Name of a deployed change.';


--
-- Name: COLUMN changes.project; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN changes.note; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.note IS 'Description of the change.';


--
-- Name: COLUMN changes.committed_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.committed_at IS 'Date the change was deployed.';


--
-- Name: COLUMN changes.committer_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.committer_name IS 'Name of the user who deployed the change.';


--
-- Name: COLUMN changes.committer_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.committer_email IS 'Email address of the user who deployed the change.';


--
-- Name: COLUMN changes.planned_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.planned_at IS 'Date the change was added to the plan.';


--
-- Name: COLUMN changes.planner_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN changes.planner_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.changes.planner_email IS 'Email address of the user who planned the change.';


--
-- Name: dependencies; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.dependencies (
    change_id text NOT NULL,
    type text NOT NULL,
    dependency text NOT NULL,
    dependency_id text,
    CONSTRAINT dependencies_check CHECK ((((type = 'require'::text) AND (dependency_id IS NOT NULL)) OR ((type = 'conflict'::text) AND (dependency_id IS NULL))))
);


ALTER TABLE sqitch.dependencies OWNER TO postgres;

--
-- Name: TABLE dependencies; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.dependencies IS 'Tracks the currently satisfied dependencies.';


--
-- Name: COLUMN dependencies.change_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.dependencies.change_id IS 'ID of the depending change.';


--
-- Name: COLUMN dependencies.type; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.dependencies.type IS 'Type of dependency.';


--
-- Name: COLUMN dependencies.dependency; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.dependencies.dependency IS 'Dependency name.';


--
-- Name: COLUMN dependencies.dependency_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.dependencies.dependency_id IS 'Change ID the dependency resolves to.';


--
-- Name: events; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.events (
    event text NOT NULL,
    change_id text NOT NULL,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    requires text[] DEFAULT '{}'::text[] NOT NULL,
    conflicts text[] DEFAULT '{}'::text[] NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL,
    CONSTRAINT events_event_check CHECK ((event = ANY (ARRAY['deploy'::text, 'revert'::text, 'fail'::text, 'merge'::text])))
);


ALTER TABLE sqitch.events OWNER TO postgres;

--
-- Name: TABLE events; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.events IS 'Contains full history of all deployment events.';


--
-- Name: COLUMN events.event; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.event IS 'Type of event.';


--
-- Name: COLUMN events.change_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.change_id IS 'Change ID.';


--
-- Name: COLUMN events.change; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.change IS 'Change name.';


--
-- Name: COLUMN events.project; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN events.note; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.note IS 'Description of the change.';


--
-- Name: COLUMN events.requires; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.requires IS 'Array of the names of required changes.';


--
-- Name: COLUMN events.conflicts; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.conflicts IS 'Array of the names of conflicting changes.';


--
-- Name: COLUMN events.tags; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.tags IS 'Tags associated with the change.';


--
-- Name: COLUMN events.committed_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.committed_at IS 'Date the event was committed.';


--
-- Name: COLUMN events.committer_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.committer_name IS 'Name of the user who committed the event.';


--
-- Name: COLUMN events.committer_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.committer_email IS 'Email address of the user who committed the event.';


--
-- Name: COLUMN events.planned_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.planned_at IS 'Date the event was added to the plan.';


--
-- Name: COLUMN events.planner_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN events.planner_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.events.planner_email IS 'Email address of the user who plan planned the change.';


--
-- Name: projects; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.projects (
    project text NOT NULL,
    uri text,
    created_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    creator_name text NOT NULL,
    creator_email text NOT NULL
);


ALTER TABLE sqitch.projects OWNER TO postgres;

--
-- Name: TABLE projects; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.projects IS 'Sqitch projects deployed to this database.';


--
-- Name: COLUMN projects.project; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.projects.project IS 'Unique Name of a project.';


--
-- Name: COLUMN projects.uri; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.projects.uri IS 'Optional project URI';


--
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.projects.created_at IS 'Date the project was added to the database.';


--
-- Name: COLUMN projects.creator_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.projects.creator_name IS 'Name of the user who added the project.';


--
-- Name: COLUMN projects.creator_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.projects.creator_email IS 'Email address of the user who added the project.';


--
-- Name: releases; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.releases (
    version real NOT NULL,
    installed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    installer_name text NOT NULL,
    installer_email text NOT NULL
);


ALTER TABLE sqitch.releases OWNER TO postgres;

--
-- Name: TABLE releases; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.releases IS 'Sqitch registry releases.';


--
-- Name: COLUMN releases.version; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.releases.version IS 'Version of the Sqitch registry.';


--
-- Name: COLUMN releases.installed_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.releases.installed_at IS 'Date the registry release was installed.';


--
-- Name: COLUMN releases.installer_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.releases.installer_name IS 'Name of the user who installed the registry release.';


--
-- Name: COLUMN releases.installer_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.releases.installer_email IS 'Email address of the user who installed the registry release.';


--
-- Name: tags; Type: TABLE; Schema: sqitch; Owner: postgres
--

CREATE TABLE sqitch.tags (
    tag_id text NOT NULL,
    tag text NOT NULL,
    project text NOT NULL,
    change_id text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.tags OWNER TO postgres;

--
-- Name: TABLE tags; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON TABLE sqitch.tags IS 'Tracks the tags currently applied to the database.';


--
-- Name: COLUMN tags.tag_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.tag_id IS 'Tag primary key.';


--
-- Name: COLUMN tags.tag; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.tag IS 'Project-unique tag name.';


--
-- Name: COLUMN tags.project; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.project IS 'Name of the Sqitch project to which the tag belongs.';


--
-- Name: COLUMN tags.change_id; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.change_id IS 'ID of last change deployed before the tag was applied.';


--
-- Name: COLUMN tags.note; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.note IS 'Description of the tag.';


--
-- Name: COLUMN tags.committed_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.committed_at IS 'Date the tag was applied to the database.';


--
-- Name: COLUMN tags.committer_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.committer_name IS 'Name of the user who applied the tag.';


--
-- Name: COLUMN tags.committer_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.committer_email IS 'Email address of the user who applied the tag.';


--
-- Name: COLUMN tags.planned_at; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.planned_at IS 'Date the tag was added to the plan.';


--
-- Name: COLUMN tags.planner_name; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.planner_name IS 'Name of the user who planed the tag.';


--
-- Name: COLUMN tags.planner_email; Type: COMMENT; Schema: sqitch; Owner: postgres
--

COMMENT ON COLUMN sqitch.tags.planner_email IS 'Email address of the user who planned the tag.';


--
-- Name: test_table id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_table ALTER COLUMN id SET DEFAULT nextval('public.test_table_id_seq'::regclass);


--
-- Name: test_table test_table_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_table
    ADD CONSTRAINT test_table_pkey PRIMARY KEY (id);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (change_id);


--
-- Name: changes changes_project_script_hash_key; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_script_hash_key UNIQUE (project, script_hash);


--
-- Name: dependencies dependencies_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_pkey PRIMARY KEY (change_id, dependency);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (change_id, committed_at);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project);


--
-- Name: projects projects_uri_key; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_uri_key UNIQUE (uri);


--
-- Name: releases releases_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags tags_project_tag_key; Type: CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_tag_key UNIQUE (project, tag);


--
-- Name: changes changes_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: dependencies dependencies_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dependencies dependencies_dependency_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_dependency_id_fkey FOREIGN KEY (dependency_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: events events_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: tags tags_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: tags tags_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: postgres
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: my_app_sub; Type: SUBSCRIPTION; Schema: -; Owner: postgres
--

CREATE SUBSCRIPTION my_app_sub CONNECTION 'dbname=my_app host=myapp user=my_app_replica' PUBLICATION my_app_pub WITH (connect = false, slot_name = 'my_app_sub');


ALTER SUBSCRIPTION my_app_sub OWNER TO postgres;

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: my_app; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA my_app;


ALTER SCHEMA my_app OWNER TO postgres;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: plpgsql_check; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql_check WITH SCHEMA public;


--
-- Name: EXTENSION plpgsql_check; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql_check IS 'extended check for plpgsql functions';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

