--
-- PostgreSQL database dump
--

\restrict odyTVcvfBIE8wOrT4RS4AdHUf8QhYRNw4gerGNHvfuZdw8b7mcYxIpYUuI2a5EO

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-04 12:07:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 27607)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 279 (class 1255 OID 27619)
-- Name: generate_csid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_csid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.csid := 'CS-' || LPAD(nextval('public.customer_seq')::TEXT, 8, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_csid() OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 27620)
-- Name: generate_do_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_do_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.do_id := 'DO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.do_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_do_id() OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 27621)
-- Name: generate_grn_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_grn_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.grn_id := 'GRN-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.grn_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_grn_id() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 27622)
-- Name: generate_invoice_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_invoice_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.invoice_id := 'INV-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.invoice_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_invoice_id() OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 27623)
-- Name: generate_po_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_po_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.po_id := 'PO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.po_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_po_id() OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 27624)
-- Name: generate_pr_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_pr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.pr_id := 'PR-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.pr_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_pr_id() OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 27625)
-- Name: generate_quotation_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_quotation_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.quotation_id := 'QUO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.quotation_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_quotation_id() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 27626)
-- Name: generate_vendor_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_vendor_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.vendor_id := 'V-' || LPAD(nextval('public.vendor_seq')::TEXT, 8, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_vendor_id() OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 27618)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.updated_at = CURRENT_TIMESTAMP; RETURN NEW; END; $$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 252 (class 1259 OID 27980)
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    shift_id uuid NOT NULL,
    date date NOT NULL,
    check_in time without time zone,
    check_out time without time zone,
    status character varying(20) DEFAULT 'absent'::character varying NOT NULL,
    notes text,
    marked_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT attendance_status_check CHECK (((status)::text = ANY (ARRAY['present'::text, 'absent'::text, 'late'::text, 'half_day'::text, 'holiday'::text, 'on_leave'::text])))
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 27999)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    action text,
    table_name text,
    record_id uuid,
    reason text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT audit_logs_action_check CHECK ((action = ANY (ARRAY['INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 27627)
-- Name: customer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_seq OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 27762)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    csid character varying(12),
    customer_name text NOT NULL,
    company_name text NOT NULL,
    customer_type text NOT NULL,
    phone text NOT NULL,
    email text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 28144)
-- Name: delivery_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    delivery_order_id uuid,
    product_name text NOT NULL,
    quantity integer NOT NULL,
    remarks text,
    product_id uuid NOT NULL,
    CONSTRAINT delivery_order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.delivery_order_items OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 28130)
-- Name: delivery_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    do_id character varying(20),
    issued_to_type text,
    issued_to_id uuid,
    issued_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_remarks text,
    status text,
    quotation_id uuid,
    CONSTRAINT delivery_orders_issued_to_type_check CHECK ((issued_to_type = ANY (ARRAY['EMPLOYEE'::text, 'CUSTOMER'::text]))),
    CONSTRAINT delivery_orders_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text])))
);


ALTER TABLE public.delivery_orders OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 27792)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_code text NOT NULL,
    department_name text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    parent_department_id uuid
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 27636)
-- Name: designations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.designations OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 27628)
-- Name: do_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.do_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.do_seq OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 27806)
-- Name: employee_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_info (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    name character varying(100) NOT NULL,
    father_name character varying(100) NOT NULL,
    cnic character varying(20) NOT NULL,
    date_of_birth character varying(15) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_info OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 27872)
-- Name: employee_job_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_job_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    department_id uuid NOT NULL,
    designation_id uuid NOT NULL,
    manager_emp_id character varying(10),
    start_date date NOT NULL,
    end_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employee_job_history OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 27650)
-- Name: employment_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employment_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type_name character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.employment_types OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 27837)
-- Name: extra_employee_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_employee_info (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    contact_1 character varying(15) NOT NULL,
    contact_2 character varying(15),
    emergence_contact_1 character varying(15),
    emergence_contact_2 character varying(15),
    bank_name character varying(100),
    bank_acc_num character varying(15),
    perment_address character varying(255),
    postal_address character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.extra_employee_info OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 28070)
-- Name: grn_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grn_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    grn_id uuid,
    product_id uuid NOT NULL,
    product_name text NOT NULL,
    quantity_received integer NOT NULL,
    remarks text,
    CONSTRAINT grn_items_quantity_received_check CHECK ((quantity_received >= 0))
);


ALTER TABLE public.grn_items OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 27629)
-- Name: grn_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grn_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grn_seq OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 28060)
-- Name: grns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    grn_id character varying(20),
    po_id uuid,
    received_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.grns OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 28157)
-- Name: inventory_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    serial_number text NOT NULL,
    current_status text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT inventory_items_current_status_check CHECK ((current_status = ANY (ARRAY['AVAILABLE'::text, 'ALLOCATED'::text, 'INSTALLED'::text, 'RETURNED'::text, 'DAMAGED'::text])))
);


ALTER TABLE public.inventory_items OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 28172)
-- Name: inventory_movements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    inventory_item_id uuid,
    movement_type text,
    reference_type text,
    reference_id uuid,
    moved_by uuid,
    remarks text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT inventory_movements_movement_type_check CHECK ((movement_type = ANY (ARRAY['STOCK_IN'::text, 'STOCK_OUT'::text, 'TRANSFER'::text, 'RETURN'::text])))
);


ALTER TABLE public.inventory_movements OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 28122)
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    invoice_id uuid,
    product_id uuid NOT NULL,
    quantity integer,
    unit_price numeric(10,2)
);


ALTER TABLE public.invoice_items OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 27630)
-- Name: invoice_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoice_seq OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 28106)
-- Name: invoices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    invoice_id character varying(20),
    quotation_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    approved_by uuid,
    approved_at timestamp with time zone,
    payment_status text,
    remarks text,
    approval_status text,
    CONSTRAINT invoices_approval_statuses_check CHECK ((approval_status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text]))),
    CONSTRAINT invoices_payment_status_check CHECK ((payment_status = ANY (ARRAY['UNPAID'::text, 'PAID'::text])))
);


ALTER TABLE public.invoices OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 27738)
-- Name: item_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category_name text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.item_categories OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 27852)
-- Name: job_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_info (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    department_id uuid NOT NULL,
    designation_id uuid NOT NULL,
    employment_type_id uuid NOT NULL,
    job_status_id uuid NOT NULL,
    work_mode_id uuid NOT NULL,
    work_location_id uuid NOT NULL,
    shift_id uuid NOT NULL,
    date_of_joining date NOT NULL,
    date_of_exit date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.job_info OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 27664)
-- Name: job_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_statuses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    status_name character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.job_statuses OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 27917)
-- Name: leave_balances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_balances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    leave_type_id uuid NOT NULL,
    year integer NOT NULL,
    balance integer DEFAULT 0 NOT NULL,
    used integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.leave_balances OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 27899)
-- Name: leave_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_id uuid NOT NULL,
    leave_type_id uuid NOT NULL,
    days_allowed integer NOT NULL,
    year integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT leave_policies_days_allowed_check CHECK ((days_allowed >= 0))
);


ALTER TABLE public.leave_policies OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 27960)
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    leave_type_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    end_by_force date,
    reason text,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_end_by_force CHECK (((end_by_force IS NULL) OR ((end_by_force >= start_date) AND (end_by_force <= end_date)))),
    CONSTRAINT chk_leave_dates CHECK ((end_date >= start_date)),
    CONSTRAINT leave_requests_status_check CHECK (((status)::text = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'cancelled'::text])))
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 27724)
-- Name: leave_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.leave_types OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 27631)
-- Name: pay_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pay_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pay_seq OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 27749)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    permission_key character varying(150) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 27632)
-- Name: po_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.po_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.po_seq OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 27633)
-- Name: pr_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pr_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pr_seq OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 27824)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_name text NOT NULL,
    category_id uuid,
    product_type text,
    tracking_type text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    quantity integer,
    CONSTRAINT items_item_type_check CHECK ((product_type = ANY (ARRAY['ASSET'::text, 'CONSUMABLE'::text, 'SERVICE'::text]))),
    CONSTRAINT items_tracking_type_check CHECK ((tracking_type = ANY (ARRAY['SERIAL'::text, 'IMEI'::text, 'NONE'::text])))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 28048)
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_order_id uuid,
    product_id uuid,
    product_name text NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2),
    remarks text,
    CONSTRAINT purchase_order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.purchase_order_items OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 28035)
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    po_id character varying(20),
    pr_id uuid,
    vendor_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.purchase_orders OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 28023)
-- Name: purchase_request_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_request_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    purchase_request_id uuid,
    product_id uuid,
    product_name text NOT NULL,
    quantity integer NOT NULL,
    remarks text,
    CONSTRAINT purchase_request_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.purchase_request_items OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 28010)
-- Name: purchase_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pr_id character varying(20),
    requested_by uuid,
    department_id uuid,
    status text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_remarks text,
    CONSTRAINT purchase_requests_status_check CHECK ((status = ANY (ARRAY['PENDING'::text, 'APPROVED'::text, 'REJECTED'::text])))
);


ALTER TABLE public.purchase_requests OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 28098)
-- Name: quotation_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotation_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quotation_id uuid,
    quantity integer,
    unit_price numeric(10,2),
    product_id uuid NOT NULL
);


ALTER TABLE public.quotation_items OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 27634)
-- Name: quotation_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quotation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.quotation_seq OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 28083)
-- Name: quotations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quotations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quotation_id character varying(20),
    customer_id uuid,
    status text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    approved_by uuid,
    approved_at timestamp with time zone,
    approval_remarks text,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    CONSTRAINT quotations_status_check CHECK ((status = ANY (ARRAY['DRAFT'::text, 'APPROVED'::text, 'REJECTED'::text])))
);


ALTER TABLE public.quotations OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 27935)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 27885)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    department_id uuid NOT NULL,
    role_name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 27706)
-- Name: shifts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shifts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    late_after_minutes integer DEFAULT 15 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.shifts OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 27942)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    employee_id character varying(10) NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role_id uuid,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 27635)
-- Name: vendor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendor_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendor_seq OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 27779)
-- Name: vendors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    vendor_id character varying(10),
    vendor_name text NOT NULL,
    contact_person text,
    phone text,
    email text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.vendors OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 27692)
-- Name: work_locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.work_locations OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 27678)
-- Name: work_modes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_modes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    mode_name character varying(50) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.work_modes OWNER TO postgres;

--
-- TOC entry 5463 (class 0 OID 27980)
-- Dependencies: 252
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, employee_id, shift_id, date, check_in, check_out, status, notes, marked_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5464 (class 0 OID 27999)
-- Dependencies: 253
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, user_id, action, table_name, record_id, reason, created_at) FROM stdin;
\.


--
-- TOC entry 5449 (class 0 OID 27762)
-- Dependencies: 238
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, csid, customer_name, company_name, customer_type, phone, email, created_at) FROM stdin;
\.


--
-- TOC entry 5476 (class 0 OID 28144)
-- Dependencies: 265
-- Data for Name: delivery_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_order_items (id, delivery_order_id, product_name, quantity, remarks, product_id) FROM stdin;
\.


--
-- TOC entry 5475 (class 0 OID 28130)
-- Dependencies: 264
-- Data for Name: delivery_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_orders (id, do_id, issued_to_type, issued_to_id, issued_by, created_at, approved_by, approved_at, approval_remarks, status, quotation_id) FROM stdin;
\.


--
-- TOC entry 5451 (class 0 OID 27792)
-- Dependencies: 240
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, department_code, department_name, created_at, parent_department_id) FROM stdin;
53df87ee-5c68-4dc7-8f1a-9a292f023397	OPS	Operations	2026-04-04 12:05:17.39826+05	\N
b8538da9-e3ef-4a7f-82eb-1d099b258e35	FIN	Finance	2026-04-04 12:05:17.39826+05	\N
418fb27f-b1da-4066-bf86-8e55998b2dca	ADMIN	Administration	2026-04-04 12:05:17.39826+05	\N
0b172a24-aa30-4c49-9eb5-517eecbeb3c8	SALES_INV	Sales & Inventory	2026-04-04 12:05:17.39826+05	\N
a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	IT	Information Technology	2026-04-04 12:05:17.39826+05	\N
b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e	HR	Human Resources	2026-04-04 12:05:17.39826+05	\N
\.


--
-- TOC entry 5440 (class 0 OID 27636)
-- Dependencies: 229
-- Data for Name: designations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.designations (id, title, is_active, created_at, updated_at) FROM stdin;
d0000001-0000-4000-a000-000000000001	CEO	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000002	CTO	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000003	Manager	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000004	Senior Developer	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000005	Developer	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000006	QA Engineer	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000007	HR Executive	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d0000001-0000-4000-a000-000000000008	Accountant	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5452 (class 0 OID 27806)
-- Dependencies: 241
-- Data for Name: employee_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_info (id, employee_id, name, father_name, cnic, date_of_birth, created_at, updated_at) FROM stdin;
11000001-0000-4000-a000-000000000001	EMP-001	Ahmed Khan	Tariq Khan	35201-1234567-1	1985-03-15	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000002	EMP-002	Sara Ali	Imran Ali	35202-2345678-2	1990-07-22	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000003	EMP-003	Hassan Raza	Amir Raza	35203-3456789-3	1988-11-05	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000004	EMP-004	Fatima Noor	Khalid Noor	35204-4567890-4	1992-01-18	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000005	EMP-005	Usman Tariq	Rashid Tariq	35205-5678901-5	1991-06-30	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000006	EMP-006	Ayesha Malik	Zahid Malik	35206-6789012-6	1995-09-10	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000007	EMP-007	Bilal Ahmad	Nasir Ahmad	35207-7890123-7	1993-04-25	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
11000001-0000-4000-a000-000000000008	EMP-008	Zainab Shah	Faisal Shah	35208-8901234-8	1989-12-02	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5456 (class 0 OID 27872)
-- Dependencies: 245
-- Data for Name: employee_job_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_job_history (id, employee_id, department_id, designation_id, manager_emp_id, start_date, end_date, created_at, updated_at) FROM stdin;
1a9a219f-72f9-4dba-80a5-488771b4983a	EMP-005	53df87ee-5c68-4dc7-8f1a-9a292f023397	d0000001-0000-4000-a000-000000000005	EMP-003	2021-09-20	2023-08-31	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
a0d24e89-3e4c-4af0-b40b-45cec1502f9a	EMP-005	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000004	EMP-003	2023-09-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
93c5f37f-dcc5-4a3a-a83d-4631b5249ffc	EMP-006	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000005	EMP-005	2025-06-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
ab21f2d4-0ead-412f-bc2e-a0ff924e6433	EMP-008	b8538da9-e3ef-4a7f-82eb-1d099b258e35	d0000001-0000-4000-a000-000000000008	EMP-001	2021-11-01	2023-05-31	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
c6eb2514-0c31-4ce4-aa01-d7d846864b36	EMP-008	0b172a24-aa30-4c49-9eb5-517eecbeb3c8	d0000001-0000-4000-a000-000000000003	EMP-001	2023-06-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5441 (class 0 OID 27650)
-- Dependencies: 230
-- Data for Name: employment_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employment_types (id, type_name, is_active, created_at, updated_at) FROM stdin;
e0000001-0000-4000-a000-000000000001	Full-Time	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
e0000001-0000-4000-a000-000000000002	Part-Time	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
e0000001-0000-4000-a000-000000000003	Contract	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
e0000001-0000-4000-a000-000000000004	Intern	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5454 (class 0 OID 27837)
-- Dependencies: 243
-- Data for Name: extra_employee_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_employee_info (id, employee_id, contact_1, contact_2, emergence_contact_1, emergence_contact_2, bank_name, bank_acc_num, perment_address, postal_address, created_at, updated_at) FROM stdin;
c30613aa-019f-44bd-baab-27a8d3251ac0	EMP-001	03001234567	03211234567	03009876543	\N	HBL	1234567890	12 Main Boulevard, DHA Lahore	12 Main Boulevard, DHA Lahore	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
e658a9ba-c932-4080-b346-e11eb8e65997	EMP-002	03002345678	\N	03112345678	\N	Meezan Bank	2345678901	45 Garden Town, Lahore	45 Garden Town, Lahore	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
5b84ccda-f256-4c45-8a52-58d20b04ccc5	EMP-003	03003456789	03223456789	03213456789	\N	UBL	3456789012	78 Blue Area, Islamabad	78 Blue Area, Islamabad	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
4f3466dc-2e1c-4408-a8d5-21ae4d364e88	EMP-004	03004567890	\N	03314567890	\N	Allied Bank	4567890123	23 Clifton Block 5, Karachi	23 Clifton Block 5, Karachi	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
3c76b7bc-8f76-4c60-9d4b-704766bc0d78	EMP-005	03005678901	03235678901	03415678901	\N	Bank Alfalah	5678901234	56 Johar Town, Lahore	56 Johar Town, Lahore	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
2c4ac9f6-44a1-4074-a5e7-ff71c295d301	EMP-006	03006789012	\N	03516789012	\N	HBL	6789012345	89 Model Town, Lahore	89 Model Town, Lahore	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
7487621b-3efd-4205-a0d0-c62e907f0147	EMP-007	03007890123	03247890123	03617890123	\N	MCB	7890123456	34 F-8 Markaz, Islamabad	34 F-8 Markaz, Islamabad	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
a69587c5-e8b6-4cd6-9b85-7d407b0665b2	EMP-008	03008901234	\N	03718901234	\N	Standard Chartered	8901234567	67 Gulberg III, Lahore	67 Gulberg III, Lahore	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5470 (class 0 OID 28070)
-- Dependencies: 259
-- Data for Name: grn_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grn_items (id, grn_id, product_id, product_name, quantity_received, remarks) FROM stdin;
\.


--
-- TOC entry 5469 (class 0 OID 28060)
-- Dependencies: 258
-- Data for Name: grns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grns (id, grn_id, po_id, received_by, created_at) FROM stdin;
\.


--
-- TOC entry 5477 (class 0 OID 28157)
-- Dependencies: 266
-- Data for Name: inventory_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_items (id, product_id, serial_number, current_status, created_at) FROM stdin;
\.


--
-- TOC entry 5478 (class 0 OID 28172)
-- Dependencies: 267
-- Data for Name: inventory_movements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventory_movements (id, inventory_item_id, movement_type, reference_type, reference_id, moved_by, remarks, created_at) FROM stdin;
\.


--
-- TOC entry 5474 (class 0 OID 28122)
-- Dependencies: 263
-- Data for Name: invoice_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_items (id, invoice_id, product_id, quantity, unit_price) FROM stdin;
\.


--
-- TOC entry 5473 (class 0 OID 28106)
-- Dependencies: 262
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoices (id, invoice_id, quotation_id, created_at, created_by, total_amount, approved_by, approved_at, payment_status, remarks, approval_status) FROM stdin;
\.


--
-- TOC entry 5447 (class 0 OID 27738)
-- Dependencies: 236
-- Data for Name: item_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_categories (id, category_name, description, created_at) FROM stdin;
40000001-0000-4000-a000-000000000001	Networking Equipment	Switches, routers, cables, access points	2026-04-04 12:05:17.39826+05
40000001-0000-4000-a000-000000000002	Computing Devices	Laptops, desktops, monitors, peripherals	2026-04-04 12:05:17.39826+05
40000001-0000-4000-a000-000000000003	Office Supplies	Paper, pens, toner, stationery	2026-04-04 12:05:17.39826+05
40000001-0000-4000-a000-000000000004	Furniture	Desks, chairs, cabinets	2026-04-04 12:05:17.39826+05
40000001-0000-4000-a000-000000000005	Software Licenses	OS, productivity, development tools	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5455 (class 0 OID 27852)
-- Dependencies: 244
-- Data for Name: job_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_info (id, employee_id, department_id, designation_id, employment_type_id, job_status_id, work_mode_id, work_location_id, shift_id, date_of_joining, date_of_exit, created_at, updated_at) FROM stdin;
11dff067-4842-411e-9941-21776f11a53f	EMP-001	418fb27f-b1da-4066-bf86-8e55998b2dca	d0000001-0000-4000-a000-000000000001	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2020-01-15	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
2780f2b8-4569-411b-a9bb-fe050fcbbf00	EMP-002	b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e	d0000001-0000-4000-a000-000000000007	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2021-03-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
d21d8c50-9198-4513-8f0c-9ead69c95738	EMP-003	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000002	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000003	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2020-06-15	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
38556758-605c-481a-bf41-4161969fb765	EMP-004	b8538da9-e3ef-4a7f-82eb-1d099b258e35	d0000001-0000-4000-a000-000000000008	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000003	c0000001-0000-4000-a000-000000000001	2022-01-10	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
bd1c98d1-7b55-4e21-880a-6f943a021327	EMP-005	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000004	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000002	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2021-09-20	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
af58a150-2fa0-4bb7-9332-73503f387fae	EMP-006	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000005	e0000001-0000-4000-a000-000000000004	f0000001-0000-4000-a000-000000000002	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2025-06-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
cbc19cf4-183a-45a2-9c86-a636a01e1ee9	EMP-007	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	d0000001-0000-4000-a000-000000000006	e0000001-0000-4000-a000-000000000003	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000002	c0000001-0000-4000-a000-000000000001	2023-02-15	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
27a5e988-b869-4503-8ac6-b5e7f79d583d	EMP-008	0b172a24-aa30-4c49-9eb5-517eecbeb3c8	d0000001-0000-4000-a000-000000000003	e0000001-0000-4000-a000-000000000001	f0000001-0000-4000-a000-000000000001	a0000001-0000-4000-a000-000000000001	b0000001-0000-4000-a000-000000000001	c0000001-0000-4000-a000-000000000001	2021-11-01	\N	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5442 (class 0 OID 27664)
-- Dependencies: 231
-- Data for Name: job_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_statuses (id, status_name, is_active, created_at, updated_at) FROM stdin;
f0000001-0000-4000-a000-000000000001	Active	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
f0000001-0000-4000-a000-000000000002	On Probation	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
f0000001-0000-4000-a000-000000000003	Resigned	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
f0000001-0000-4000-a000-000000000004	Terminated	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
f0000001-0000-4000-a000-000000000005	On Notice	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5459 (class 0 OID 27917)
-- Dependencies: 248
-- Data for Name: leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_balances (id, employee_id, leave_type_id, year, balance, used, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5458 (class 0 OID 27899)
-- Dependencies: 247
-- Data for Name: leave_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_policies (id, department_id, leave_type_id, days_allowed, year, is_active, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5462 (class 0 OID 27960)
-- Dependencies: 251
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, employee_id, leave_type_id, start_date, end_date, end_by_force, reason, status, reviewed_by, reviewed_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5446 (class 0 OID 27724)
-- Dependencies: 235
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_types (id, name, is_active, created_at, updated_at) FROM stdin;
10000001-0000-4000-a000-000000000001	Annual	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
10000001-0000-4000-a000-000000000002	Sick	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
10000001-0000-4000-a000-000000000003	Casual	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
10000001-0000-4000-a000-000000000004	Maternity	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
10000001-0000-4000-a000-000000000005	Paternity	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5448 (class 0 OID 27749)
-- Dependencies: 237
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, permission_key, description, created_at) FROM stdin;
d1be73fc-36bb-41e2-800f-5d56e38e91e2	CREATE_DEPT	Can create departments	2026-04-04 12:05:17.39826+05
2a9d3085-24f4-47f5-a5dc-f51183c11b2f	EDIT_DEPT	Can edit departments	2026-04-04 12:05:17.39826+05
589ebe5d-0390-4dad-a1a3-ada9176516d5	DELETE_DEPT	Can delete departments	2026-04-04 12:05:17.39826+05
dc3939e1-1017-4492-a4c8-702f8fd1c09c	CREATE_ROLE	Can create roles	2026-04-04 12:05:17.39826+05
cc0828dc-aea2-41af-a170-0b1c5a263809	EDIT_ROLE	Can edit roles	2026-04-04 12:05:17.39826+05
b86a55ce-4e1a-4a51-a05e-d4979db2bba0	DELETE_ROLE	Can delete roles	2026-04-04 12:05:17.39826+05
4f1efd09-9a4d-4016-b484-c2b535600fac	CREATE_USER	Can create users	2026-04-04 12:05:17.39826+05
ab4f6f1e-a56e-43d9-a852-b55a12909d8f	EDIT_USER	Can edit users	2026-04-04 12:05:17.39826+05
0c65b8e5-4350-40b0-9fc1-bf6a0d9a4c35	DELETE_USER	Can delete users	2026-04-04 12:05:17.39826+05
12b04cf6-6e16-47a0-bf80-19fa23fe26ea	CREATE_VENDOR	Can create vendors	2026-04-04 12:05:17.39826+05
e6d6db7b-4be5-4a0f-98c0-996e21dcbc20	EDIT_VENDOR	Can edit vendors	2026-04-04 12:05:17.39826+05
8af7630d-4350-4157-8d5f-9645dcc053ff	DELETE_VENDOR	Can delete vendors	2026-04-04 12:05:17.39826+05
f1f7e76d-2c44-47f4-b98b-b26138fb8fe0	CREATE_PR	Can create purchase request	2026-04-04 12:05:17.39826+05
3dc4cb26-4295-4c27-868b-f0a2f6634796	APPROVE_PR	Can approve purchase requests	2026-04-04 12:05:17.39826+05
f705f2dd-b4bd-4acf-af4b-80f182138ff7	CREATE_PO	Can create purchase order	2026-04-04 12:05:17.39826+05
4401c722-9b57-4dbb-967d-c4fbecd53114	CREATE_GRN	Can create GRN	2026-04-04 12:05:17.39826+05
b9a3506b-dec7-4eac-9aa8-a3dd0580d415	STOCK_IN	Can stock in inventory	2026-04-04 12:05:17.39826+05
ffcc9e31-7a7c-4b9b-a1e0-6c70415d33c6	STOCK_OUT	Can stock out inventory	2026-04-04 12:05:17.39826+05
35357366-b43f-4fca-93fe-efee93c020c7	CREATE_QUOTATION	Can create quotation	2026-04-04 12:05:17.39826+05
f97b0d7b-64b5-4a44-9a08-4fbca099fd40	APPROVE_QUOTATION	Can approve quotation	2026-04-04 12:05:17.39826+05
4588286d-7240-489a-ae11-08f8d5c098d2	CREATE_INVOICE	Can create invoice	2026-04-04 12:05:17.39826+05
9008be81-1c63-4722-899d-adf20eeaf36b	APPROVE_INVOICE	Can approve invoice	2026-04-04 12:05:17.39826+05
05fd37ba-9ab9-4bf2-9209-2fb3ad66ae98	CREATE_DO	Can create delivery order	2026-04-04 12:05:17.39826+05
b2eb3594-6afc-4cd4-b023-25ee8b96bb65	APPROVE_DO	Can approve delivery order	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5453 (class 0 OID 27824)
-- Dependencies: 242
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, product_name, category_id, product_type, tracking_type, created_at, quantity) FROM stdin;
\.


--
-- TOC entry 5468 (class 0 OID 28048)
-- Dependencies: 257
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_order_items (id, purchase_order_id, product_id, product_name, quantity, unit_price, remarks) FROM stdin;
\.


--
-- TOC entry 5467 (class 0 OID 28035)
-- Dependencies: 256
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_orders (id, po_id, pr_id, vendor_id, created_at, created_by, total_amount) FROM stdin;
\.


--
-- TOC entry 5466 (class 0 OID 28023)
-- Dependencies: 255
-- Data for Name: purchase_request_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_request_items (id, purchase_request_id, product_id, product_name, quantity, remarks) FROM stdin;
\.


--
-- TOC entry 5465 (class 0 OID 28010)
-- Dependencies: 254
-- Data for Name: purchase_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_requests (id, pr_id, requested_by, department_id, status, created_at, approved_by, approved_at, approval_remarks) FROM stdin;
\.


--
-- TOC entry 5472 (class 0 OID 28098)
-- Dependencies: 261
-- Data for Name: quotation_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quotation_items (id, quotation_id, quantity, unit_price, product_id) FROM stdin;
\.


--
-- TOC entry 5471 (class 0 OID 28083)
-- Dependencies: 260
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quotations (id, quotation_id, customer_id, status, created_by, created_at, approved_by, approved_at, approval_remarks, total_amount) FROM stdin;
\.


--
-- TOC entry 5460 (class 0 OID 27935)
-- Dependencies: 249
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_id, permission_id) FROM stdin;
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	d1be73fc-36bb-41e2-800f-5d56e38e91e2
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	2a9d3085-24f4-47f5-a5dc-f51183c11b2f
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	589ebe5d-0390-4dad-a1a3-ada9176516d5
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	dc3939e1-1017-4492-a4c8-702f8fd1c09c
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	cc0828dc-aea2-41af-a170-0b1c5a263809
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	b86a55ce-4e1a-4a51-a05e-d4979db2bba0
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	4f1efd09-9a4d-4016-b484-c2b535600fac
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	f1f7e76d-2c44-47f4-b98b-b26138fb8fe0
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	3dc4cb26-4295-4c27-868b-f0a2f6634796
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	f705f2dd-b4bd-4acf-af4b-80f182138ff7
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	35357366-b43f-4fca-93fe-efee93c020c7
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	f97b0d7b-64b5-4a44-9a08-4fbca099fd40
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	4588286d-7240-489a-ae11-08f8d5c098d2
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	9008be81-1c63-4722-899d-adf20eeaf36b
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	05fd37ba-9ab9-4bf2-9209-2fb3ad66ae98
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	b2eb3594-6afc-4cd4-b023-25ee8b96bb65
20000001-0000-4000-a000-000000000001	f1f7e76d-2c44-47f4-b98b-b26138fb8fe0
20000001-0000-4000-a000-000000000001	3dc4cb26-4295-4c27-868b-f0a2f6634796
20000001-0000-4000-a000-000000000002	f1f7e76d-2c44-47f4-b98b-b26138fb8fe0
20000001-0000-4000-a000-000000000002	f705f2dd-b4bd-4acf-af4b-80f182138ff7
\.


--
-- TOC entry 5457 (class 0 OID 27885)
-- Dependencies: 246
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, department_id, role_name, description, created_at) FROM stdin;
3973ff42-4bb7-445a-94ac-a5b9dd03fffb	418fb27f-b1da-4066-bf86-8e55998b2dca	SYSTEM_ADMIN	Full system access	2026-04-04 12:05:17.39826+05
20000001-0000-4000-a000-000000000001	b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e	HR_MANAGER	HR module full access	2026-04-04 12:05:17.39826+05
20000001-0000-4000-a000-000000000002	a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d	DEPARTMENT_MANAGER	Manage IT department operations	2026-04-04 12:05:17.39826+05
20000001-0000-4000-a000-000000000003	53df87ee-5c68-4dc7-8f1a-9a292f023397	EMPLOYEE	Basic employee access	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5445 (class 0 OID 27706)
-- Dependencies: 234
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shifts (id, name, start_time, end_time, late_after_minutes, is_active, created_at, updated_at) FROM stdin;
c0000001-0000-4000-a000-000000000001	Morning Shift	09:00:00	18:00:00	15	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
c0000001-0000-4000-a000-000000000002	Evening Shift	14:00:00	23:00:00	15	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
c0000001-0000-4000-a000-000000000003	Night Shift	22:00:00	07:00:00	20	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5461 (class 0 OID 27942)
-- Dependencies: 250
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, employee_id, email, password, role_id, created_at, updated_at) FROM stdin;
c03e185b-e800-4ff9-860a-7f5dfe1f0483	EMP-001	ahmed.khan@company.com	admin123	3973ff42-4bb7-445a-94ac-a5b9dd03fffb	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000001	EMP-002	sara.ali@company.com	sara2024	20000001-0000-4000-a000-000000000001	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000002	EMP-003	hassan.raza@company.com	hassan2024	20000001-0000-4000-a000-000000000002	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000003	EMP-004	fatima.noor@company.com	fatima2024	20000001-0000-4000-a000-000000000003	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000004	EMP-005	usman.tariq@company.com	usman2024	20000001-0000-4000-a000-000000000003	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000005	EMP-006	ayesha.malik@company.com	ayesha2024	20000001-0000-4000-a000-000000000003	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000006	EMP-007	bilal.ahmad@company.com	bilal2024	20000001-0000-4000-a000-000000000003	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
30000001-0000-4000-a000-000000000007	EMP-008	zainab.shah@company.com	zainab2024	20000001-0000-4000-a000-000000000002	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5450 (class 0 OID 27779)
-- Dependencies: 239
-- Data for Name: vendors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendors (id, vendor_id, vendor_name, contact_person, phone, email, created_at) FROM stdin;
\.


--
-- TOC entry 5444 (class 0 OID 27692)
-- Dependencies: 233
-- Data for Name: work_locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_locations (id, location_name, is_active, created_at, updated_at) FROM stdin;
b0000001-0000-4000-a000-000000000001	Head Office Lahore	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
b0000001-0000-4000-a000-000000000002	Branch Office Islamabad	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
b0000001-0000-4000-a000-000000000003	Branch Office Karachi	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5443 (class 0 OID 27678)
-- Dependencies: 232
-- Data for Name: work_modes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.work_modes (id, mode_name, is_active, created_at, updated_at) FROM stdin;
a0000001-0000-4000-a000-000000000001	On-Site	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
a0000001-0000-4000-a000-000000000002	Remote	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
a0000001-0000-4000-a000-000000000003	Hybrid	t	2026-04-04 12:05:17.39826+05	2026-04-04 12:05:17.39826+05
\.


--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 220
-- Name: customer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_seq', 1, false);


--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 221
-- Name: do_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.do_seq', 1, false);


--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 222
-- Name: grn_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grn_seq', 1, false);


--
-- TOC entry 5488 (class 0 OID 0)
-- Dependencies: 223
-- Name: invoice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_seq', 1, false);


--
-- TOC entry 5489 (class 0 OID 0)
-- Dependencies: 224
-- Name: pay_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pay_seq', 1, false);


--
-- TOC entry 5490 (class 0 OID 0)
-- Dependencies: 225
-- Name: po_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.po_seq', 1, false);


--
-- TOC entry 5491 (class 0 OID 0)
-- Dependencies: 226
-- Name: pr_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pr_seq', 1, false);


--
-- TOC entry 5492 (class 0 OID 0)
-- Dependencies: 227
-- Name: quotation_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quotation_seq', 1, false);


--
-- TOC entry 5493 (class 0 OID 0)
-- Dependencies: 228
-- Name: vendor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendor_seq', 1, false);


--
-- TOC entry 5147 (class 2606 OID 27996)
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- TOC entry 5154 (class 2606 OID 28009)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5092 (class 2606 OID 27778)
-- Name: customers customers_csid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_csid_key UNIQUE (csid);


--
-- TOC entry 5094 (class 2606 OID 27776)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 5190 (class 2606 OID 28156)
-- Name: delivery_order_items delivery_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5186 (class 2606 OID 28143)
-- Name: delivery_orders delivery_orders_do_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_do_id_key UNIQUE (do_id);


--
-- TOC entry 5188 (class 2606 OID 28141)
-- Name: delivery_orders delivery_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 5100 (class 2606 OID 27805)
-- Name: departments departments_department_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_code_key UNIQUE (department_code);


--
-- TOC entry 5102 (class 2606 OID 27803)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- TOC entry 5058 (class 2606 OID 27647)
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- TOC entry 5060 (class 2606 OID 27649)
-- Name: designations designations_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_title_key UNIQUE (title);


--
-- TOC entry 5104 (class 2606 OID 27823)
-- Name: employee_info employee_info_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_cnic_key UNIQUE (cnic);


--
-- TOC entry 5106 (class 2606 OID 27821)
-- Name: employee_info employee_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 5108 (class 2606 OID 27819)
-- Name: employee_info employee_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_pkey PRIMARY KEY (id);


--
-- TOC entry 5120 (class 2606 OID 27884)
-- Name: employee_job_history employee_job_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT employee_job_history_pkey PRIMARY KEY (id);


--
-- TOC entry 5062 (class 2606 OID 27661)
-- Name: employment_types employment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employment_types
    ADD CONSTRAINT employment_types_pkey PRIMARY KEY (id);


--
-- TOC entry 5064 (class 2606 OID 27663)
-- Name: employment_types employment_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employment_types
    ADD CONSTRAINT employment_types_type_name_key UNIQUE (type_name);


--
-- TOC entry 5112 (class 2606 OID 27851)
-- Name: extra_employee_info extra_employee_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT extra_employee_info_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 5114 (class 2606 OID 27849)
-- Name: extra_employee_info extra_employee_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT extra_employee_info_pkey PRIMARY KEY (id);


--
-- TOC entry 5172 (class 2606 OID 28082)
-- Name: grn_items grn_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5168 (class 2606 OID 28069)
-- Name: grns grns_grn_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_grn_id_key UNIQUE (grn_id);


--
-- TOC entry 5170 (class 2606 OID 28067)
-- Name: grns grns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_pkey PRIMARY KEY (id);


--
-- TOC entry 5192 (class 2606 OID 28169)
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5194 (class 2606 OID 28171)
-- Name: inventory_items inventory_items_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_serial_number_key UNIQUE (serial_number);


--
-- TOC entry 5196 (class 2606 OID 28182)
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- TOC entry 5184 (class 2606 OID 28129)
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5180 (class 2606 OID 28121)
-- Name: invoices invoices_invoice_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_id_key UNIQUE (invoice_id);


--
-- TOC entry 5182 (class 2606 OID 28119)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 5086 (class 2606 OID 27748)
-- Name: item_categories item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_categories
    ADD CONSTRAINT item_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 5116 (class 2606 OID 27871)
-- Name: job_info job_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 5118 (class 2606 OID 27869)
-- Name: job_info job_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_pkey PRIMARY KEY (id);


--
-- TOC entry 5066 (class 2606 OID 27675)
-- Name: job_statuses job_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_statuses
    ADD CONSTRAINT job_statuses_pkey PRIMARY KEY (id);


--
-- TOC entry 5068 (class 2606 OID 27677)
-- Name: job_statuses job_statuses_status_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_statuses
    ADD CONSTRAINT job_statuses_status_name_key UNIQUE (status_name);


--
-- TOC entry 5130 (class 2606 OID 27932)
-- Name: leave_balances leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (id);


--
-- TOC entry 5126 (class 2606 OID 27914)
-- Name: leave_policies leave_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT leave_policies_pkey PRIMARY KEY (id);


--
-- TOC entry 5145 (class 2606 OID 27979)
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5082 (class 2606 OID 27737)
-- Name: leave_types leave_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_name_key UNIQUE (name);


--
-- TOC entry 5084 (class 2606 OID 27735)
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);


--
-- TOC entry 5088 (class 2606 OID 27761)
-- Name: permissions permissions_permission_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_permission_key_key UNIQUE (permission_key);


--
-- TOC entry 5090 (class 2606 OID 27759)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 5110 (class 2606 OID 27836)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 5166 (class 2606 OID 28059)
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5162 (class 2606 OID 28045)
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 5164 (class 2606 OID 28047)
-- Name: purchase_orders purchase_orders_po_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_id_key UNIQUE (po_id);


--
-- TOC entry 5160 (class 2606 OID 28034)
-- Name: purchase_request_items purchase_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5156 (class 2606 OID 28020)
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 5158 (class 2606 OID 28022)
-- Name: purchase_requests purchase_requests_pr_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pr_id_key UNIQUE (pr_id);


--
-- TOC entry 5178 (class 2606 OID 28105)
-- Name: quotation_items quotation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5174 (class 2606 OID 28095)
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- TOC entry 5176 (class 2606 OID 28097)
-- Name: quotations quotations_quotation_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_quotation_id_key UNIQUE (quotation_id);


--
-- TOC entry 5134 (class 2606 OID 27941)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- TOC entry 5122 (class 2606 OID 27898)
-- Name: roles roles_department_id_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_department_id_role_name_key UNIQUE (department_id, role_name);


--
-- TOC entry 5124 (class 2606 OID 27896)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 5078 (class 2606 OID 27723)
-- Name: shifts shifts_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_name_key UNIQUE (name);


--
-- TOC entry 5080 (class 2606 OID 27721)
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- TOC entry 5152 (class 2606 OID 27998)
-- Name: attendance unique_attendance_per_day; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT unique_attendance_per_day UNIQUE (employee_id, date);


--
-- TOC entry 5132 (class 2606 OID 27934)
-- Name: leave_balances unique_balance; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT unique_balance UNIQUE (employee_id, leave_type_id, year);


--
-- TOC entry 5128 (class 2606 OID 27916)
-- Name: leave_policies unique_policy_per_type_year; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT unique_policy_per_type_year UNIQUE (leave_type_id, department_id, year);


--
-- TOC entry 5136 (class 2606 OID 27959)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5138 (class 2606 OID 27957)
-- Name: users users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- TOC entry 5140 (class 2606 OID 27955)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5096 (class 2606 OID 27789)
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- TOC entry 5098 (class 2606 OID 27791)
-- Name: vendors vendors_vendor_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_vendor_id_key UNIQUE (vendor_id);


--
-- TOC entry 5074 (class 2606 OID 27705)
-- Name: work_locations work_locations_location_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_locations
    ADD CONSTRAINT work_locations_location_name_key UNIQUE (location_name);


--
-- TOC entry 5076 (class 2606 OID 27703)
-- Name: work_locations work_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_locations
    ADD CONSTRAINT work_locations_pkey PRIMARY KEY (id);


--
-- TOC entry 5070 (class 2606 OID 27691)
-- Name: work_modes work_modes_mode_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_modes
    ADD CONSTRAINT work_modes_mode_name_key UNIQUE (mode_name);


--
-- TOC entry 5072 (class 2606 OID 27689)
-- Name: work_modes work_modes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_modes
    ADD CONSTRAINT work_modes_pkey PRIMARY KEY (id);


--
-- TOC entry 5148 (class 1259 OID 28183)
-- Name: idx_attendance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_date ON public.attendance USING btree (date);


--
-- TOC entry 5149 (class 1259 OID 28184)
-- Name: idx_attendance_employee_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_employee_date ON public.attendance USING btree (employee_id, date);


--
-- TOC entry 5150 (class 1259 OID 28185)
-- Name: idx_attendance_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_status ON public.attendance USING btree (status);


--
-- TOC entry 5141 (class 1259 OID 28186)
-- Name: idx_leave_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_dates ON public.leave_requests USING btree (start_date, end_date);


--
-- TOC entry 5142 (class 1259 OID 28187)
-- Name: idx_leave_employee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_employee ON public.leave_requests USING btree (employee_id);


--
-- TOC entry 5143 (class 1259 OID 28188)
-- Name: idx_leave_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_status ON public.leave_requests USING btree (status);


--
-- TOC entry 5277 (class 2620 OID 28203)
-- Name: attendance trg_attendance_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5267 (class 2620 OID 28205)
-- Name: customers trg_csid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_csid BEFORE INSERT ON public.customers FOR EACH ROW EXECUTE FUNCTION public.generate_csid();


--
-- TOC entry 5260 (class 2620 OID 28189)
-- Name: designations trg_designations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_designations_updated_at BEFORE UPDATE ON public.designations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5283 (class 2620 OID 28206)
-- Name: delivery_orders trg_do_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_do_id BEFORE INSERT ON public.delivery_orders FOR EACH ROW EXECUTE FUNCTION public.generate_do_id();


--
-- TOC entry 5269 (class 2620 OID 28196)
-- Name: employee_info trg_employee_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employee_info_updated_at BEFORE UPDATE ON public.employee_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5272 (class 2620 OID 28199)
-- Name: employee_job_history trg_employee_job_history_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employee_job_history_updated_at BEFORE UPDATE ON public.employee_job_history FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5261 (class 2620 OID 28190)
-- Name: employment_types trg_employment_types_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employment_types_updated_at BEFORE UPDATE ON public.employment_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5270 (class 2620 OID 28197)
-- Name: extra_employee_info trg_extra_employee_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_extra_employee_info_updated_at BEFORE UPDATE ON public.extra_employee_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5280 (class 2620 OID 28207)
-- Name: grns trg_grn_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_grn_id BEFORE INSERT ON public.grns FOR EACH ROW EXECUTE FUNCTION public.generate_grn_id();


--
-- TOC entry 5282 (class 2620 OID 28208)
-- Name: invoices trg_invoice_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invoice_id BEFORE INSERT ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.generate_invoice_id();


--
-- TOC entry 5271 (class 2620 OID 28198)
-- Name: job_info trg_job_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_job_info_updated_at BEFORE UPDATE ON public.job_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5262 (class 2620 OID 28191)
-- Name: job_statuses trg_job_statuses_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_job_statuses_updated_at BEFORE UPDATE ON public.job_statuses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5274 (class 2620 OID 28201)
-- Name: leave_balances trg_leave_balances_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_balances_updated_at BEFORE UPDATE ON public.leave_balances FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5273 (class 2620 OID 28200)
-- Name: leave_policies trg_leave_policies_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_policies_updated_at BEFORE UPDATE ON public.leave_policies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5276 (class 2620 OID 28202)
-- Name: leave_requests trg_leave_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_requests_updated_at BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5266 (class 2620 OID 28195)
-- Name: leave_types trg_leave_types_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_types_updated_at BEFORE UPDATE ON public.leave_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5279 (class 2620 OID 28209)
-- Name: purchase_orders trg_po_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_po_id BEFORE INSERT ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.generate_po_id();


--
-- TOC entry 5278 (class 2620 OID 28210)
-- Name: purchase_requests trg_pr_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_pr_id BEFORE INSERT ON public.purchase_requests FOR EACH ROW EXECUTE FUNCTION public.generate_pr_id();


--
-- TOC entry 5281 (class 2620 OID 28211)
-- Name: quotations trg_quotation_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_quotation_id BEFORE INSERT ON public.quotations FOR EACH ROW EXECUTE FUNCTION public.generate_quotation_id();


--
-- TOC entry 5265 (class 2620 OID 28194)
-- Name: shifts trg_shifts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_shifts_updated_at BEFORE UPDATE ON public.shifts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5275 (class 2620 OID 28204)
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5268 (class 2620 OID 28212)
-- Name: vendors trg_vendor_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_vendor_id BEFORE INSERT ON public.vendors FOR EACH ROW EXECUTE FUNCTION public.generate_vendor_id();


--
-- TOC entry 5264 (class 2620 OID 28193)
-- Name: work_locations trg_work_locations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_work_locations_updated_at BEFORE UPDATE ON public.work_locations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5263 (class 2620 OID 28192)
-- Name: work_modes trg_work_modes_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_work_modes_updated_at BEFORE UPDATE ON public.work_modes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 5227 (class 2606 OID 28363)
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5255 (class 2606 OID 28503)
-- Name: delivery_order_items delivery_order_items_delivery_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_delivery_order_id_fkey FOREIGN KEY (delivery_order_id) REFERENCES public.delivery_orders(id) ON DELETE CASCADE;


--
-- TOC entry 5256 (class 2606 OID 28508)
-- Name: delivery_order_items delivery_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5252 (class 2606 OID 28493)
-- Name: delivery_orders delivery_orders_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 5253 (class 2606 OID 28488)
-- Name: delivery_orders delivery_orders_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- TOC entry 5254 (class 2606 OID 28498)
-- Name: delivery_orders delivery_orders_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- TOC entry 5197 (class 2606 OID 28213)
-- Name: departments departments_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- TOC entry 5224 (class 2606 OID 28348)
-- Name: attendance fk_attendance_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- TOC entry 5225 (class 2606 OID 28358)
-- Name: attendance fk_attendance_marked_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_marked_by FOREIGN KEY (marked_by) REFERENCES public.users(id);


--
-- TOC entry 5226 (class 2606 OID 28353)
-- Name: attendance fk_attendance_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_shift FOREIGN KEY (shift_id) REFERENCES public.shifts(id);


--
-- TOC entry 5215 (class 2606 OID 28303)
-- Name: leave_balances fk_balance_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT fk_balance_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- TOC entry 5216 (class 2606 OID 28308)
-- Name: leave_balances fk_balance_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT fk_balance_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- TOC entry 5199 (class 2606 OID 28223)
-- Name: extra_employee_info fk_employee_info_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT fk_employee_info_id FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- TOC entry 5208 (class 2606 OID 28273)
-- Name: employee_job_history fk_history_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 5209 (class 2606 OID 28278)
-- Name: employee_job_history fk_history_desig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_desig FOREIGN KEY (designation_id) REFERENCES public.designations(id);


--
-- TOC entry 5210 (class 2606 OID 28268)
-- Name: employee_job_history fk_history_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- TOC entry 5211 (class 2606 OID 28283)
-- Name: employee_job_history fk_history_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_manager FOREIGN KEY (manager_emp_id) REFERENCES public.employee_info(employee_id) ON DELETE SET NULL;


--
-- TOC entry 5200 (class 2606 OID 28233)
-- Name: job_info fk_job_department_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_department_id FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 5201 (class 2606 OID 28238)
-- Name: job_info fk_job_designation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_designation_id FOREIGN KEY (designation_id) REFERENCES public.designations(id);


--
-- TOC entry 5202 (class 2606 OID 28243)
-- Name: job_info fk_job_employment_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_employment_type_id FOREIGN KEY (employment_type_id) REFERENCES public.employment_types(id);


--
-- TOC entry 5203 (class 2606 OID 28228)
-- Name: job_info fk_job_info_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_info_id FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- TOC entry 5204 (class 2606 OID 28263)
-- Name: job_info fk_job_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_shift FOREIGN KEY (shift_id) REFERENCES public.shifts(id);


--
-- TOC entry 5205 (class 2606 OID 28248)
-- Name: job_info fk_job_status_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_status_id FOREIGN KEY (job_status_id) REFERENCES public.job_statuses(id);


--
-- TOC entry 5206 (class 2606 OID 28258)
-- Name: job_info fk_job_work_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_work_location_id FOREIGN KEY (work_location_id) REFERENCES public.work_locations(id);


--
-- TOC entry 5207 (class 2606 OID 28253)
-- Name: job_info fk_job_work_mode_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_work_mode_id FOREIGN KEY (work_mode_id) REFERENCES public.work_modes(id);


--
-- TOC entry 5221 (class 2606 OID 28333)
-- Name: leave_requests fk_leave_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- TOC entry 5222 (class 2606 OID 28343)
-- Name: leave_requests fk_leave_reviewed_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- TOC entry 5223 (class 2606 OID 28338)
-- Name: leave_requests fk_leave_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- TOC entry 5213 (class 2606 OID 28293)
-- Name: leave_policies fk_policy_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT fk_policy_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 5214 (class 2606 OID 28298)
-- Name: leave_policies fk_policy_leave_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT fk_policy_leave_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- TOC entry 5219 (class 2606 OID 28323)
-- Name: users fk_user_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- TOC entry 5240 (class 2606 OID 28428)
-- Name: grn_items grn_items_grn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_grn_id_fkey FOREIGN KEY (grn_id) REFERENCES public.grns(id) ON DELETE CASCADE;


--
-- TOC entry 5241 (class 2606 OID 28433)
-- Name: grn_items grn_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5238 (class 2606 OID 28418)
-- Name: grns grns_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id);


--
-- TOC entry 5239 (class 2606 OID 28423)
-- Name: grns grns_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.users(id);


--
-- TOC entry 5257 (class 2606 OID 28513)
-- Name: inventory_items inventory_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5258 (class 2606 OID 28518)
-- Name: inventory_movements inventory_movements_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- TOC entry 5259 (class 2606 OID 28523)
-- Name: inventory_movements inventory_movements_moved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_moved_by_fkey FOREIGN KEY (moved_by) REFERENCES public.users(id);


--
-- TOC entry 5250 (class 2606 OID 28478)
-- Name: invoice_items invoice_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- TOC entry 5251 (class 2606 OID 28483)
-- Name: invoice_items invoice_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5247 (class 2606 OID 28473)
-- Name: invoices invoices_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 5248 (class 2606 OID 28468)
-- Name: invoices invoices_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5249 (class 2606 OID 28463)
-- Name: invoices invoices_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- TOC entry 5198 (class 2606 OID 28218)
-- Name: products items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.item_categories(id);


--
-- TOC entry 5236 (class 2606 OID 28413)
-- Name: purchase_order_items purchase_order_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5237 (class 2606 OID 28408)
-- Name: purchase_order_items purchase_order_items_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- TOC entry 5233 (class 2606 OID 28403)
-- Name: purchase_orders purchase_orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5234 (class 2606 OID 28393)
-- Name: purchase_orders purchase_orders_pr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pr_id_fkey FOREIGN KEY (pr_id) REFERENCES public.purchase_requests(id);


--
-- TOC entry 5235 (class 2606 OID 28398)
-- Name: purchase_orders purchase_orders_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- TOC entry 5231 (class 2606 OID 28388)
-- Name: purchase_request_items purchase_request_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5232 (class 2606 OID 28383)
-- Name: purchase_request_items purchase_request_items_purchase_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_purchase_request_id_fkey FOREIGN KEY (purchase_request_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- TOC entry 5228 (class 2606 OID 28378)
-- Name: purchase_requests purchase_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 5229 (class 2606 OID 28373)
-- Name: purchase_requests purchase_requests_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- TOC entry 5230 (class 2606 OID 28368)
-- Name: purchase_requests purchase_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- TOC entry 5245 (class 2606 OID 28458)
-- Name: quotation_items quotation_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 5246 (class 2606 OID 28453)
-- Name: quotation_items quotation_items_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- TOC entry 5242 (class 2606 OID 28448)
-- Name: quotations quotations_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- TOC entry 5243 (class 2606 OID 28443)
-- Name: quotations quotations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5244 (class 2606 OID 28438)
-- Name: quotations quotations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 5217 (class 2606 OID 28318)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 5218 (class 2606 OID 28313)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 5212 (class 2606 OID 28288)
-- Name: roles roles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- TOC entry 5220 (class 2606 OID 28328)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


-- Completed on 2026-04-04 12:07:23

--
-- PostgreSQL database dump complete
--

\unrestrict odyTVcvfBIE8wOrT4RS4AdHUf8QhYRNw4gerGNHvfuZdw8b7mcYxIpYUuI2a5EO

