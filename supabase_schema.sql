-- PENG GOODS WHOLESALE — SUPABASE SETUP
-- Run this entire script in Supabase SQL Editor.
-- Then create Auth users in Authentication > Users and add matching profiles below.

create table if not exists public.pgw_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  role text not null default 'staff' check (role in ('owner','staff')),
  created_at timestamptz not null default now()
);

create table if not exists public.pgw_app_data (
  id integer primary key check (id = 1),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.pgw_profiles enable row level security;
alter table public.pgw_app_data enable row level security;

revoke all on public.pgw_profiles from anon;
revoke all on public.pgw_app_data from anon;

grant select on public.pgw_profiles to authenticated;
grant select, insert, update, delete on public.pgw_app_data to authenticated;

drop policy if exists "profile_self_read" on public.pgw_profiles;
create policy "profile_self_read"
on public.pgw_profiles
for select to authenticated
using (id = auth.uid());

drop policy if exists "app_data_authenticated_read" on public.pgw_app_data;
create policy "app_data_authenticated_read"
on public.pgw_app_data
for select to authenticated
using (true);

drop policy if exists "app_data_authenticated_insert" on public.pgw_app_data;
create policy "app_data_authenticated_insert"
on public.pgw_app_data
for insert to authenticated
with check (id = 1);

drop policy if exists "app_data_authenticated_update" on public.pgw_app_data;
create policy "app_data_authenticated_update"
on public.pgw_app_data
for update to authenticated
using (id = 1)
with check (id = 1);

drop policy if exists "app_data_authenticated_delete" on public.pgw_app_data;
create policy "app_data_authenticated_delete"
on public.pgw_app_data
for delete to authenticated
using (id = 1);

-- Realtime is used so another phone/laptop can receive changes.
alter publication supabase_realtime add table public.pgw_app_data;

-- Example profile rows:
-- 1) In Authentication > Users, create an owner user, e.g. admin@yourdomain.com.
-- 2) Copy that user's UUID and run:
-- insert into public.pgw_profiles (id, username, role)
-- values ('AUTH-USER-UUID-HERE', 'admin', 'owner');
--
-- Repeat for staff:
-- insert into public.pgw_profiles (id, username, role)
-- values ('AUTH-USER-UUID-HERE', 'staff', 'staff');

-- IMPORTANT:
-- The browser must use only the Supabase Publishable Key.
-- Never paste a service_role/secret key into index.html or supabase-config.js.
