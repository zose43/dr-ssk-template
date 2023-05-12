--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Debian 13.5-1.pgdg110+1)
-- Dumped by pg_dump version 13.5 (Debian 13.5-1.pgdg110+1)

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
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: zose
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO zose;

--
-- Name: urldecode_arr(text); Type: FUNCTION; Schema: public; Owner: zose
--

CREATE FUNCTION public.urldecode_arr(url text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE ret text;



BEGIN
    BEGIN



        WITH STR AS (
            SELECT

                -- array with all non encoded parts, prepend with '' when the string start is encoded
                case when $1 ~ '^%[0-9a-fA-F][0-9a-fA-F]'
                         then array['']
                    end
                    || regexp_split_to_array ($1,'(%[0-9a-fA-F][0-9a-fA-F])+', 'i') plain,

                -- array with all encoded parts
                array(select (regexp_matches ($1,'((?:%[0-9a-fA-F][0-9a-fA-F])+)', 'gi'))[1]) encoded
        )
        SELECT  string_agg(plain[i] || coalesce( convert_from(decode(replace(encoded[i], '%',''), 'hex'), 'utf8'),''),'')
        FROM STR,
             (SELECT  generate_series(1, array_upper(encoded,1)+2) i FROM STR)blah



        INTO ret;



    EXCEPTION WHEN OTHERS THEN
        raise notice 'failed: %',url;
        return $1;
    END;



    RETURN coalesce(ret,$1); -- when the string has no encoding;



END;



$_$;


ALTER FUNCTION public.urldecode_arr(url text) OWNER TO zose;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: proxy; Type: TABLE; Schema: public; Owner: zose
--

CREATE TABLE public.proxy (
    id integer NOT NULL,
    proxy text NOT NULL,
    use_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    type smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.proxy OWNER TO zose;

--
-- Name: proxy_id_seq; Type: SEQUENCE; Schema: public; Owner: zose
--

CREATE SEQUENCE public.proxy_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.proxy_id_seq OWNER TO zose;

--
-- Name: proxy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zose
--

ALTER SEQUENCE public.proxy_id_seq OWNED BY public.proxy.id;

--
-- Name: proxy id; Type: DEFAULT; Schema: public; Owner: zose
--

ALTER TABLE ONLY public.proxy ALTER COLUMN id SET DEFAULT nextval('public.proxy_id_seq'::regclass);

--
-- Data for Name: proxy; Type: TABLE DATA; Schema: public; Owner: zose
--

COPY public.proxy (id, proxy, use_time, created_at, type) FROM stdin;
1	https://fncnsidbc0Y8YI:dTKNmBbbQu@91.201.40.130:17385	\N	2023-03-06 11:57:16.893779+00	6
2	https://fncnsidbc0Y8YI:dTKNmBbbQu@91.201.40.130:17019	\N	2023-03-06 11:57:16.893779+00	6
\.


--
-- Name: proxy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zose
--

SELECT pg_catalog.setval('public.proxy_id_seq', 2, true);

--
-- Name: proxy proxy_pkey; Type: CONSTRAINT; Schema: public; Owner: zose
--

ALTER TABLE ONLY public.proxy
    ADD CONSTRAINT proxy_pkey PRIMARY KEY (id);
--
-- PostgreSQL database dump complete
--

