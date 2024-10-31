--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.16 (Ubuntu 12.16-0ubuntu0.20.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fx_component; Type: TABLE; Schema: public; Owner: taj
--

CREATE TABLE public.fx_component (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.fx_component OWNER TO taj;

--
-- Name: tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: taj
--

CREATE SEQUENCE public.tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_id_seq OWNER TO taj;

--
-- Name: tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: taj
--

ALTER SEQUENCE public.tmp_id_seq OWNED BY public.fx_component.id;


--
-- Name: fx_component id; Type: DEFAULT; Schema: public; Owner: taj
--

ALTER TABLE ONLY public.fx_component ALTER COLUMN id SET DEFAULT nextval('public.tmp_id_seq'::regclass);


--
-- Data for Name: fx_component; Type: TABLE DATA; Schema: public; Owner: taj
--

COPY public.fx_component (id, name) FROM stdin;
1	mailnews
2	parser
3	xpfc
4	password
5	rdf
6	views
7	cdp
8	taskcluster
9	xpfe
10	hal
11	printing
12	api
14	uriloader
15	privacy
16	dom
17	bookmarks
18	autofill
19	search
20	media
21	chimera
22	extensions
23	netmonitor
24	application
25	mobile
26	tools
27	themes
28	servo
29	shell
30	nspr
31	ui
32	memory
33	profile
34	cck
35	signaling
36	experiments
37	cookies
38	canvas
39	sync
40	reporting
41	layout
42	css
43	toolbar
44	web-platform
45	remote
46	about
47	toolkit
48	camino
49	b2g
50	addons
51	build
52	autocomplete
53	desktop
54	calendar
55	gfx
56	glean
57	embedding
58	grendel
59	widget
60	notification
61	access
63	security
64	plugin
65	webapps
66	preferences
67	keyboard
70	xpcom
71	permission-manager
72	screenshots
73	message
74	wallet
75	addressbook
76	dns
77	download-manager
78	performance
79	infrastructure
80	android
81	ipc
82	os
83	expat
84	webtools
85	devtools
86	content
88	webservice
89	network
90	services
91	cache
92	enterprisepolicies
93	storage
94	gpu
\.


--
-- Name: tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taj
--

SELECT pg_catalog.setval('public.tmp_id_seq', 95, true);


--
-- Name: fx_component tmp_name_key; Type: CONSTRAINT; Schema: public; Owner: taj
--

ALTER TABLE ONLY public.fx_component
    ADD CONSTRAINT tmp_name_key UNIQUE (name);


--
-- Name: fx_component tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: taj
--

ALTER TABLE ONLY public.fx_component
    ADD CONSTRAINT tmp_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

