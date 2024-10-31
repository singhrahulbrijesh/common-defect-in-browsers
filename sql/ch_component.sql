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
-- Name: ch_component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_component (
    id integer NOT NULL,
    name text,
    source text
);


ALTER TABLE public.ch_component OWNER TO postgres;

--
-- Data for Name: ch_component; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ch_component (id, name, source) FROM stdin;
215	chromeos	\N
81	v8	\N
178	native_client	\N
140	notification	\N
98	android	\N
216	ios	\N
200	speed	b
201	platform	b
202	os	b
203	upboarding	b
204	internals	b
206	webstore	b
207	privacy	b
208	enterprise	b
210	admin	b
240	shell	\N
211	io	b
212	mobile	b
213	security	b
214	design	b
3	ui	b
45	services	b
75	fuchsia	b
125	infra	b
171	tools	b
188	blink	b
1	courgette	\N
218	download	\N
219	cookies	\N
220	cache	\N
221	css	\N
222	autocomplete	\N
223	autofill	\N
224	bookmarks	\N
225	desktop	\N
226	dns	\N
227	dom	\N
228	keyboard	\N
229	layout	\N
230	monitor	\N
231	password	\N
232	permission	\N
233	performance	\N
234	parser	\N
235	preferences	\N
241	themes	\N
4	skia	\N
6	url	\N
7	content	\N
17	cloud_print	\N
242	toolbar	\N
243	webapps	\N
244	webtools	\N
245	widget	\N
37	headless	\N
42	remoting	\N
46	mash	\N
49	ash	\N
54	views	\N
56	crypto	\N
58	aura	\N
59	rlz	\N
61	printing	\N
71	athena	\N
73	mandoline	\N
85	net	\N
91	mojo	\N
105	google_apis	\N
107	gfx	\N
110	sync	\N
113	utils	\N
116	ppapi	\N
119	o3d	\N
130	breakpad	\N
135	ipc	\N
141	media	\N
142	device	\N
143	extensions	\N
147	app	\N
150	weblayer	\N
158	storage	\N
164	sdch	\N
165	sandbox	\N
172	webrunner	\N
189	google_update	\N
191	cc	\N
193	gpu	\N
199	docs	\N
236	profile	\N
238	reporting	\N
239	search	\N
\.


--
-- Name: ch_component component_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_component
    ADD CONSTRAINT component_id_unique UNIQUE (id);


--
-- Name: ch_component component_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_component
    ADD CONSTRAINT component_name_unique UNIQUE (name);


--
-- Name: component_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_id_idx ON public.ch_component USING btree (id);


--
-- Name: component_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_name_idx ON public.ch_component USING btree (name);


--
-- PostgreSQL database dump complete
--

