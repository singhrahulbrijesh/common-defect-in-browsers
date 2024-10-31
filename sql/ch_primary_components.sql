--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)

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
-- Name: ch_primary_components; Type: TABLE; Schema: public; Owner: taj
--

CREATE TABLE public.ch_primary_components (
    id numeric,
    component_name text
);


ALTER TABLE public.ch_primary_components OWNER TO taj;

--
-- Data for Name: ch_primary_components; Type: TABLE DATA; Schema: public; Owner: taj
--

COPY public.ch_primary_components (id, component_name) FROM stdin;
\N	\N
181	jingle
71	athena
141	media
171	tools
110	sync
58	aura
62	site_scons
26	chrome_elf
114	gin
7	content
195	tests
17	cloud_print
108	chrome_cleaner
37	headless
53	chrome
49	ash
70	chromeos
191	cc
164	sdch
75	fuchsia
59	rlz
54	views
21	build
165	sandbox
40	components
190	buildtools
142	device
66	base
143	extensions
6	url
42	remoting
138	ios
193	gpu
4	skia
34	chrome_frame
98	android_webview
147	app
130	breakpad
188	blink
81	win8
155	pdf
189	google_update
116	ppapi
199	docs
3	ui
91	mojo
24	apps
107	gfx
87	"third_party
113	utils
119	o3d
46	mash
135	ipc
174	dartium_tools
93	codelabs
159	webkit
158	storage
22	chromecast
73	mandoline
105	google_apis
61	printing
172	webrunner
56	crypto
79	sql
176	src
140	notification_helper
45	services
168	blimp
85	net
150	weblayer
100	courgette
157	dbus
125	infra
76	gears
178	native_client_sdk
8	chrome
\.


--
-- PostgreSQL database dump complete
--

