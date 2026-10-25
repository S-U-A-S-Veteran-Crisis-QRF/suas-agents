-- SUAS Platform PostgreSQL 16 Security Migration
-- Title: Row-Level Security (RLS) Default-Deny Policy Enforcement
-- Author: Gemini (Gem), 2026-10-24. Status: REVIEW — DO NOT RUN ON PRODUCTION.
-- Conductor note: schemas below are illustrative; must be reconciled with the real SCC v2.0 schema
-- and pass the pgTAP suite before any human runs it. See CONDUCTOR_REVIEW.md.

BEGIN;

-- 1. EXTENSIONS & SCHEMAS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS app_users;
CREATE SCHEMA IF NOT EXISTS fhir_r4;
CREATE SCHEMA IF NOT EXISTS dispatch_logs;

-- 2. APPLICATION ROLES (NON-SUPERUSER)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'suas_app_user') THEN CREATE ROLE suas_app_user NOLOGIN; END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'suas_operator') THEN CREATE ROLE suas_operator NOLOGIN; END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'suas_admin') THEN CREATE ROLE suas_admin NOLOGIN; END IF;
END $$;

-- 3. TABLES
CREATE TABLE IF NOT EXISTS app_users.profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL CHECK (role IN ('OPERATOR', 'ADMIN', 'DISPATCHER')),
    assigned_region VARCHAR(100) DEFAULT 'Santa Clara County',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fhir_r4.encrypted_resources (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    resource_type VARCHAR(64) NOT NULL,
    vet_identifier VARCHAR(64) NOT NULL, -- anonymous ID only (e.g. VET-001)
    ciphertext_payload TEXT NOT NULL,
    encrypted_dek TEXT NOT NULL,
    iv VARCHAR(64) NOT NULL,
    auth_tag VARCHAR(64) NOT NULL,
    created_by UUID REFERENCES app_users.profiles(user_id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dispatch_logs.dispatches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    vet_identifier VARCHAR(64) NOT NULL, -- anonymous ID only (e.g. VET-001)
    service_type VARCHAR(32) NOT NULL CHECK (service_type IN ('FOOD', 'RIDE', 'SHELTER')),
    status VARCHAR(32) NOT NULL DEFAULT 'REQUESTED' CHECK (status IN ('REQUESTED', 'DISPATCHED', 'COMPLETED', 'CANCELLED')),
    operator_id UUID REFERENCES app_users.profiles(user_id),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. ENABLE + FORCE RLS
ALTER TABLE app_users.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_users.profiles FORCE ROW LEVEL SECURITY;
ALTER TABLE fhir_r4.encrypted_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE fhir_r4.encrypted_resources FORCE ROW LEVEL SECURITY;
ALTER TABLE dispatch_logs.dispatches ENABLE ROW LEVEL SECURITY;
ALTER TABLE dispatch_logs.dispatches FORCE ROW LEVEL SECURITY;

-- 5. HELPER: authenticated user id from session setting
CREATE OR REPLACE FUNCTION public.current_app_user_id() RETURNS UUID AS $$
BEGIN
    RETURN NULLIF(current_setting('app.current_user_id', true), '')::UUID;
EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql STABLE;

-- 6. POLICIES (default deny; only these grant access)
-- Conductor note: policies on profiles that query profiles can recurse under FORCE RLS; see review.
DROP POLICY IF EXISTS profiles_select_policy ON app_users.profiles;
CREATE POLICY profiles_select_policy ON app_users.profiles FOR SELECT
    TO suas_app_user, suas_operator, suas_admin
    USING (user_id = public.current_app_user_id()
        OR EXISTS (SELECT 1 FROM app_users.profiles p WHERE p.user_id = public.current_app_user_id() AND p.role = 'ADMIN' AND p.is_active));

DROP POLICY IF EXISTS profiles_update_policy ON app_users.profiles;
CREATE POLICY profiles_update_policy ON app_users.profiles FOR UPDATE
    TO suas_admin
    USING (EXISTS (SELECT 1 FROM app_users.profiles p WHERE p.user_id = public.current_app_user_id() AND p.role = 'ADMIN' AND p.is_active));

DROP POLICY IF EXISTS fhir_select_policy ON fhir_r4.encrypted_resources;
CREATE POLICY fhir_select_policy ON fhir_r4.encrypted_resources FOR SELECT
    TO suas_operator, suas_admin
    USING (EXISTS (SELECT 1 FROM app_users.profiles p WHERE p.user_id = public.current_app_user_id() AND p.role IN ('OPERATOR','ADMIN') AND p.is_active));

DROP POLICY IF EXISTS fhir_insert_policy ON fhir_r4.encrypted_resources;
CREATE POLICY fhir_insert_policy ON fhir_r4.encrypted_resources FOR INSERT
    TO suas_operator, suas_admin
    WITH CHECK (EXISTS (SELECT 1 FROM app_users.profiles p WHERE p.user_id = public.current_app_user_id() AND p.role IN ('OPERATOR','ADMIN') AND p.is_active));

DROP POLICY IF EXISTS dispatch_all_policy ON dispatch_logs.dispatches;
CREATE POLICY dispatch_all_policy ON dispatch_logs.dispatches FOR ALL
    TO suas_operator, suas_admin
    USING (EXISTS (SELECT 1 FROM app_users.profiles p WHERE p.user_id = public.current_app_user_id() AND p.role IN ('OPERATOR','ADMIN') AND p.is_active));

-- 7. GRANTS
GRANT USAGE ON SCHEMA app_users TO suas_app_user, suas_operator, suas_admin;
GRANT USAGE ON SCHEMA fhir_r4 TO suas_operator, suas_admin;
GRANT USAGE ON SCHEMA dispatch_logs TO suas_operator, suas_admin;
GRANT SELECT ON app_users.profiles TO suas_app_user, suas_operator, suas_admin;
GRANT SELECT, INSERT, UPDATE ON fhir_r4.encrypted_resources TO suas_operator, suas_admin;
GRANT ALL ON dispatch_logs.dispatches TO suas_operator, suas_admin;

COMMIT;
