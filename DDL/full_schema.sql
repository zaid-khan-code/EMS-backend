--
-- PostgreSQL database dump
--

\restrict q9QDoQBD6LWP4wdblaDXFRx65fLpoeE5WEQuQoYztSYUVDUoAr5pMDgFOmpKhqB

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: generate_csid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_csid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.csid := 'CS-' || LPAD(nextval('public.customer_seq')::TEXT, 8, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_csid() OWNER TO postgres;

--
-- Name: generate_do_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_do_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.do_id := 'DO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.do_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_do_id() OWNER TO postgres;

--
-- Name: generate_grn_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_grn_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.grn_id := 'GRN-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.grn_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_grn_id() OWNER TO postgres;

--
-- Name: generate_invoice_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_invoice_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.invoice_id := 'INV-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.invoice_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_invoice_id() OWNER TO postgres;

--
-- Name: generate_po_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_po_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.po_id := 'PO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.po_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_po_id() OWNER TO postgres;

--
-- Name: generate_pr_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_pr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.pr_id := 'PR-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.pr_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_pr_id() OWNER TO postgres;

--
-- Name: generate_quotation_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_quotation_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.quotation_id := 'QUO-' || EXTRACT(YEAR FROM NOW()) || '-' || LPAD(nextval('public.quotation_seq')::TEXT, 4, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_quotation_id() OWNER TO postgres;

--
-- Name: generate_vendor_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.generate_vendor_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN NEW.vendor_id := 'V-' || LPAD(nextval('public.vendor_seq')::TEXT, 8, '0'); RETURN NEW; END; $$;


ALTER FUNCTION public.generate_vendor_id() OWNER TO postgres;

--
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
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
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
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: customers customers_csid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_csid_key UNIQUE (csid);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: delivery_order_items delivery_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_pkey PRIMARY KEY (id);


--
-- Name: delivery_orders delivery_orders_do_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_do_id_key UNIQUE (do_id);


--
-- Name: delivery_orders delivery_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_pkey PRIMARY KEY (id);


--
-- Name: departments departments_department_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_code_key UNIQUE (department_code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: designations designations_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_title_key UNIQUE (title);


--
-- Name: employee_info employee_info_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_cnic_key UNIQUE (cnic);


--
-- Name: employee_info employee_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_employee_id_key UNIQUE (employee_id);


--
-- Name: employee_info employee_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_info
    ADD CONSTRAINT employee_info_pkey PRIMARY KEY (id);


--
-- Name: employee_job_history employee_job_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT employee_job_history_pkey PRIMARY KEY (id);


--
-- Name: employment_types employment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employment_types
    ADD CONSTRAINT employment_types_pkey PRIMARY KEY (id);


--
-- Name: employment_types employment_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employment_types
    ADD CONSTRAINT employment_types_type_name_key UNIQUE (type_name);


--
-- Name: extra_employee_info extra_employee_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT extra_employee_info_employee_id_key UNIQUE (employee_id);


--
-- Name: extra_employee_info extra_employee_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT extra_employee_info_pkey PRIMARY KEY (id);


--
-- Name: grn_items grn_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_pkey PRIMARY KEY (id);


--
-- Name: grns grns_grn_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_grn_id_key UNIQUE (grn_id);


--
-- Name: grns grns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_pkey PRIMARY KEY (id);


--
-- Name: inventory_items inventory_items_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_serial_number_key UNIQUE (serial_number);


--
-- Name: inventory_movements inventory_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_pkey PRIMARY KEY (id);


--
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_id_key UNIQUE (invoice_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: item_categories item_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_categories
    ADD CONSTRAINT item_categories_pkey PRIMARY KEY (id);


--
-- Name: job_info job_info_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_employee_id_key UNIQUE (employee_id);


--
-- Name: job_info job_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT job_info_pkey PRIMARY KEY (id);


--
-- Name: job_statuses job_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_statuses
    ADD CONSTRAINT job_statuses_pkey PRIMARY KEY (id);


--
-- Name: job_statuses job_statuses_status_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_statuses
    ADD CONSTRAINT job_statuses_status_name_key UNIQUE (status_name);


--
-- Name: leave_balances leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT leave_balances_pkey PRIMARY KEY (id);


--
-- Name: leave_policies leave_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT leave_policies_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: leave_types leave_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_name_key UNIQUE (name);


--
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_permission_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_permission_key_key UNIQUE (permission_key);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_po_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_po_id_key UNIQUE (po_id);


--
-- Name: purchase_request_items purchase_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_requests purchase_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pkey PRIMARY KEY (id);


--
-- Name: purchase_requests purchase_requests_pr_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_pr_id_key UNIQUE (pr_id);


--
-- Name: quotation_items quotation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_quotation_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_quotation_id_key UNIQUE (quotation_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: roles roles_department_id_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_department_id_role_name_key UNIQUE (department_id, role_name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: shifts shifts_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_name_key UNIQUE (name);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: attendance unique_attendance_per_day; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT unique_attendance_per_day UNIQUE (employee_id, date);


--
-- Name: leave_balances unique_balance; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT unique_balance UNIQUE (employee_id, leave_type_id, year);


--
-- Name: leave_policies unique_policy_per_type_year; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT unique_policy_per_type_year UNIQUE (leave_type_id, department_id, year);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_vendor_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_vendor_id_key UNIQUE (vendor_id);


--
-- Name: work_locations work_locations_location_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_locations
    ADD CONSTRAINT work_locations_location_name_key UNIQUE (location_name);


--
-- Name: work_locations work_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_locations
    ADD CONSTRAINT work_locations_pkey PRIMARY KEY (id);


--
-- Name: work_modes work_modes_mode_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_modes
    ADD CONSTRAINT work_modes_mode_name_key UNIQUE (mode_name);


--
-- Name: work_modes work_modes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_modes
    ADD CONSTRAINT work_modes_pkey PRIMARY KEY (id);


--
-- Name: idx_attendance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_date ON public.attendance USING btree (date);


--
-- Name: idx_attendance_employee_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_employee_date ON public.attendance USING btree (employee_id, date);


--
-- Name: idx_attendance_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_attendance_status ON public.attendance USING btree (status);


--
-- Name: idx_leave_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_dates ON public.leave_requests USING btree (start_date, end_date);


--
-- Name: idx_leave_employee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_employee ON public.leave_requests USING btree (employee_id);


--
-- Name: idx_leave_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_leave_status ON public.leave_requests USING btree (status);


--
-- Name: attendance trg_attendance_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: customers trg_csid; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_csid BEFORE INSERT ON public.customers FOR EACH ROW EXECUTE FUNCTION public.generate_csid();


--
-- Name: designations trg_designations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_designations_updated_at BEFORE UPDATE ON public.designations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: delivery_orders trg_do_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_do_id BEFORE INSERT ON public.delivery_orders FOR EACH ROW EXECUTE FUNCTION public.generate_do_id();


--
-- Name: employee_info trg_employee_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employee_info_updated_at BEFORE UPDATE ON public.employee_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employee_job_history trg_employee_job_history_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employee_job_history_updated_at BEFORE UPDATE ON public.employee_job_history FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employment_types trg_employment_types_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_employment_types_updated_at BEFORE UPDATE ON public.employment_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: extra_employee_info trg_extra_employee_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_extra_employee_info_updated_at BEFORE UPDATE ON public.extra_employee_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: grns trg_grn_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_grn_id BEFORE INSERT ON public.grns FOR EACH ROW EXECUTE FUNCTION public.generate_grn_id();


--
-- Name: invoices trg_invoice_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_invoice_id BEFORE INSERT ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.generate_invoice_id();


--
-- Name: job_info trg_job_info_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_job_info_updated_at BEFORE UPDATE ON public.job_info FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: job_statuses trg_job_statuses_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_job_statuses_updated_at BEFORE UPDATE ON public.job_statuses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_balances trg_leave_balances_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_balances_updated_at BEFORE UPDATE ON public.leave_balances FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_policies trg_leave_policies_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_policies_updated_at BEFORE UPDATE ON public.leave_policies FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_requests trg_leave_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_requests_updated_at BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_types trg_leave_types_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_leave_types_updated_at BEFORE UPDATE ON public.leave_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: purchase_orders trg_po_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_po_id BEFORE INSERT ON public.purchase_orders FOR EACH ROW EXECUTE FUNCTION public.generate_po_id();


--
-- Name: purchase_requests trg_pr_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_pr_id BEFORE INSERT ON public.purchase_requests FOR EACH ROW EXECUTE FUNCTION public.generate_pr_id();


--
-- Name: quotations trg_quotation_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_quotation_id BEFORE INSERT ON public.quotations FOR EACH ROW EXECUTE FUNCTION public.generate_quotation_id();


--
-- Name: shifts trg_shifts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_shifts_updated_at BEFORE UPDATE ON public.shifts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: vendors trg_vendor_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_vendor_id BEFORE INSERT ON public.vendors FOR EACH ROW EXECUTE FUNCTION public.generate_vendor_id();


--
-- Name: work_locations trg_work_locations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_work_locations_updated_at BEFORE UPDATE ON public.work_locations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: work_modes trg_work_modes_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_work_modes_updated_at BEFORE UPDATE ON public.work_modes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: delivery_order_items delivery_order_items_delivery_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_delivery_order_id_fkey FOREIGN KEY (delivery_order_id) REFERENCES public.delivery_orders(id) ON DELETE CASCADE;


--
-- Name: delivery_order_items delivery_order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_order_items
    ADD CONSTRAINT delivery_order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: delivery_orders delivery_orders_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: delivery_orders delivery_orders_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: delivery_orders delivery_orders_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_orders
    ADD CONSTRAINT delivery_orders_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: departments departments_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: attendance fk_attendance_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- Name: attendance fk_attendance_marked_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_marked_by FOREIGN KEY (marked_by) REFERENCES public.users(id);


--
-- Name: attendance fk_attendance_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_shift FOREIGN KEY (shift_id) REFERENCES public.shifts(id);


--
-- Name: leave_balances fk_balance_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT fk_balance_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- Name: leave_balances fk_balance_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_balances
    ADD CONSTRAINT fk_balance_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- Name: extra_employee_info fk_employee_info_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_employee_info
    ADD CONSTRAINT fk_employee_info_id FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- Name: employee_job_history fk_history_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: employee_job_history fk_history_desig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_desig FOREIGN KEY (designation_id) REFERENCES public.designations(id);


--
-- Name: employee_job_history fk_history_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- Name: employee_job_history fk_history_manager; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_job_history
    ADD CONSTRAINT fk_history_manager FOREIGN KEY (manager_emp_id) REFERENCES public.employee_info(employee_id) ON DELETE SET NULL;


--
-- Name: job_info fk_job_department_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_department_id FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: job_info fk_job_designation_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_designation_id FOREIGN KEY (designation_id) REFERENCES public.designations(id);


--
-- Name: job_info fk_job_employment_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_employment_type_id FOREIGN KEY (employment_type_id) REFERENCES public.employment_types(id);


--
-- Name: job_info fk_job_info_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_info_id FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- Name: job_info fk_job_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_shift FOREIGN KEY (shift_id) REFERENCES public.shifts(id);


--
-- Name: job_info fk_job_status_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_status_id FOREIGN KEY (job_status_id) REFERENCES public.job_statuses(id);


--
-- Name: job_info fk_job_work_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_work_location_id FOREIGN KEY (work_location_id) REFERENCES public.work_locations(id);


--
-- Name: job_info fk_job_work_mode_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_info
    ADD CONSTRAINT fk_job_work_mode_id FOREIGN KEY (work_mode_id) REFERENCES public.work_modes(id);


--
-- Name: leave_requests fk_leave_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id) ON DELETE RESTRICT;


--
-- Name: leave_requests fk_leave_reviewed_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: leave_requests fk_leave_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT fk_leave_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- Name: leave_policies fk_policy_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT fk_policy_department FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: leave_policies fk_policy_leave_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_policies
    ADD CONSTRAINT fk_policy_leave_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id);


--
-- Name: users fk_user_employee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_employee FOREIGN KEY (employee_id) REFERENCES public.employee_info(employee_id);


--
-- Name: grn_items grn_items_grn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_grn_id_fkey FOREIGN KEY (grn_id) REFERENCES public.grns(id) ON DELETE CASCADE;


--
-- Name: grn_items grn_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grn_items
    ADD CONSTRAINT grn_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: grns grns_po_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_po_id_fkey FOREIGN KEY (po_id) REFERENCES public.purchase_orders(id);


--
-- Name: grns grns_received_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grns
    ADD CONSTRAINT grns_received_by_fkey FOREIGN KEY (received_by) REFERENCES public.users(id);


--
-- Name: inventory_items inventory_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_items
    ADD CONSTRAINT inventory_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: inventory_movements inventory_movements_inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_inventory_item_id_fkey FOREIGN KEY (inventory_item_id) REFERENCES public.inventory_items(id);


--
-- Name: inventory_movements inventory_movements_moved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory_movements
    ADD CONSTRAINT inventory_movements_moved_by_fkey FOREIGN KEY (moved_by) REFERENCES public.users(id);


--
-- Name: invoice_items invoice_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: invoice_items invoice_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: invoices invoices_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: invoices invoices_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: invoices invoices_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: products items_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT items_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.item_categories(id);


--
-- Name: purchase_order_items purchase_order_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: purchase_order_items purchase_order_items_purchase_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_purchase_order_id_fkey FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id) ON DELETE CASCADE;


--
-- Name: purchase_orders purchase_orders_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: purchase_orders purchase_orders_pr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pr_id_fkey FOREIGN KEY (pr_id) REFERENCES public.purchase_requests(id);


--
-- Name: purchase_orders purchase_orders_vendor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES public.vendors(id);


--
-- Name: purchase_request_items purchase_request_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_item_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: purchase_request_items purchase_request_items_purchase_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_request_items
    ADD CONSTRAINT purchase_request_items_purchase_request_id_fkey FOREIGN KEY (purchase_request_id) REFERENCES public.purchase_requests(id) ON DELETE CASCADE;


--
-- Name: purchase_requests purchase_requests_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: purchase_requests purchase_requests_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: purchase_requests purchase_requests_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_requests
    ADD CONSTRAINT purchase_requests_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.users(id);


--
-- Name: quotation_items quotation_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: quotation_items quotation_items_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotations quotations_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: quotations quotations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: quotations quotations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: roles roles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

\unrestrict q9QDoQBD6LWP4wdblaDXFRx65fLpoeE5WEQuQoYztSYUVDUoAr5pMDgFOmpKhqB

