
create extension if not exists pgcrypto;
create table if not exists public.rwd_shared_documents (
 id uuid primary key default gen_random_uuid(),
 doc_type text not null default 'quote',
 status text not null default 'Draft',
 customer_name text,
 customer_phone text,
 vin text,
 document jsonb not null default '{}'::jsonb,
 signature jsonb,
 approved_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.rwd_vin_cache (
 vin text primary key,
 decoded jsonb not null default '{}'::jsonb,
 source text,
 confidence text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.rwd_vendor_price_cache (
 id uuid primary key default gen_random_uuid(),
 part_query text not null,
 vendor text,
 part_number text,
 description text,
 price numeric,
 availability text,
 phone text,
 url text,
 source text,
 checked_at timestamptz not null default now()
);
alter table public.rwd_shared_documents enable row level security;
alter table public.rwd_vin_cache enable row level security;
alter table public.rwd_vendor_price_cache enable row level security;
drop policy if exists "rwd shared select" on public.rwd_shared_documents;
create policy "rwd shared select" on public.rwd_shared_documents for select to anon using (true);
drop policy if exists "rwd shared insert" on public.rwd_shared_documents;
create policy "rwd shared insert" on public.rwd_shared_documents for insert to anon with check (true);
drop policy if exists "rwd shared update" on public.rwd_shared_documents;
create policy "rwd shared update" on public.rwd_shared_documents for update to anon using (true) with check (true);
drop policy if exists "rwd vin all" on public.rwd_vin_cache;
create policy "rwd vin all" on public.rwd_vin_cache for all to anon using (true) with check (true);
drop policy if exists "rwd vendor all" on public.rwd_vendor_price_cache;
create policy "rwd vendor all" on public.rwd_vendor_price_cache for all to anon using (true) with check (true);
