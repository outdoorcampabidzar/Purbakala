-- Jalankan SEKALI di Supabase SQL Editor setelah supabase-schema.sql.
alter table public.profiles add column if not exists role text not null default 'user'
  check (role in ('user','admin'));

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  invoice_no text unique not null default ('PBK-' || to_char(now(), 'YYMMDD') || '-' || upper(substr(replace(gen_random_uuid()::text, '-', ''), 1, 5))),
  user_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'menunggu' check (status in ('menunggu','dibayar','diproses','disewa','selesai','dibatalkan','dikembalikan')),
  rental_start date not null,
  rental_end date not null,
  renter_name text not null,
  renter_phone text not null,
  identity_type text not null,
  identity_number text not null,
  address text not null,
  guarantee text not null,
  items jsonb not null,
  subtotal numeric(12,2) not null,
  discount numeric(12,2) not null default 0,
  total numeric(12,2) not null,
  voucher_code text,
  created_at timestamptz not null default now()
);

alter table public.orders enable row level security;
drop policy if exists "User creates own orders" on public.orders;
drop policy if exists "User views own orders" on public.orders;
drop policy if exists "Admin views all orders" on public.orders;
drop policy if exists "Admin updates orders" on public.orders;
create policy "User creates own orders" on public.orders for insert with check (auth.uid() = user_id);
create policy "User views own orders" on public.orders for select using (auth.uid() = user_id);
create policy "Admin views all orders" on public.orders for select using (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'));
create policy "Admin updates orders" on public.orders for update using (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'));

-- Jadikan akun Anda admin: ganti email di bawah lalu jalankan hanya baris ini.
-- update public.profiles set role = 'admin' where email = 'emailadmin@contoh.com';
