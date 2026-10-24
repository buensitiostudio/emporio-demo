-- Emporio Italia · demo de pedidos (Buen Sitio Studio)
create table if not exists public.emporio_orders (id text primary key, data jsonb not null, updated_at timestamptz not null default now());
create table if not exists public.emporio_clients (id text primary key, data jsonb not null, updated_at timestamptz not null default now());
alter table public.emporio_orders enable row level security;
alter table public.emporio_clients enable row level security;
drop policy if exists "emporio read orders" on public.emporio_orders;
drop policy if exists "emporio write orders" on public.emporio_orders;
drop policy if exists "emporio update orders" on public.emporio_orders;
create policy "emporio read orders" on public.emporio_orders for select to anon, authenticated using (true);
create policy "emporio write orders" on public.emporio_orders for insert to anon, authenticated with check (true);
create policy "emporio update orders" on public.emporio_orders for update to anon, authenticated using (true) with check (true);
drop policy if exists "emporio read clients" on public.emporio_clients;
drop policy if exists "emporio write clients" on public.emporio_clients;
drop policy if exists "emporio update clients" on public.emporio_clients;
create policy "emporio read clients" on public.emporio_clients for select to anon, authenticated using (true);
create policy "emporio write clients" on public.emporio_clients for insert to anon, authenticated with check (true);
create policy "emporio update clients" on public.emporio_clients for update to anon, authenticated using (true) with check (true);
do $$ begin
  begin alter publication supabase_realtime add table public.emporio_orders; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.emporio_clients; exception when duplicate_object then null; end;
end $$;
insert into public.emporio_orders (id, data) values
('1041', '{"n":1041,"client":"c2","when":"Hoy · 9:12 a. m.","status":"route","driver":"d1","seen":true,"log":{"new":"9:12 a. m.","recv":"9:20 a. m.","prep":"10:05 a. m.","route":"11:30 a. m."},"delivery":null,"note":null,"lines":[{"id":"p18","pack":"box","q":2},{"id":"p22","pack":"box","q":1},{"id":"p1","pack":"box","q":3}]}'),
('1040', '{"n":1040,"client":"c3","when":"Ayer · 4:30 p. m.","status":"done","driver":"d2","seen":true,"log":{"new":"4:30 p. m.","recv":"4:41 p. m.","prep":"5:10 p. m.","route":"Hoy 8:15 a. m.","done":"Hoy 9:02 a. m."},"delivery":null,"note":null,"lines":[{"id":"p14","pack":"unit","q":2},{"id":"p15","pack":"unit","q":4},{"id":"p24","pack":"box","q":2}]}'),
('1039', '{"n":1039,"client":"c1","when":"Lun · 11:05 a. m.","status":"done","driver":"d1","seen":true,"log":{"new":"11:05 a. m.","recv":"11:09 a. m.","prep":"11:40 a. m.","route":"2:10 p. m.","done":"3:00 p. m."},"delivery":null,"note":null,"lines":[{"id":"p4","pack":"box","q":2},{"id":"p11","pack":"unit","q":3},{"id":"p12","pack":"unit","q":2}]}')
on conflict (id) do nothing;
