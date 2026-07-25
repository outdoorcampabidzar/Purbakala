-- Jalankan SEKALI di Supabase SQL Editor. Katalog website akan membaca tabel ini.
create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text unique not null,
  category text not null default 'Perlengkapan',
  description text not null,
  specs jsonb not null default '[]'::jsonb,
  price numeric(12,2) not null check (price >= 0),
  stock integer not null default 0 check (stock >= 0),
  is_featured boolean not null default false,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.items enable row level security;
drop policy if exists "Anyone reads active items" on public.items;
drop policy if exists "Admin manages items" on public.items;
create policy "Anyone reads active items" on public.items for select using (is_active = true);
create policy "Admin manages items" on public.items for all using (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin')) with check (exists (select 1 from public.profiles where id = auth.uid() and role = 'admin'));

insert into public.items (title,slug,category,description,specs,price,stock,is_featured) values
('Tenda Dome 2P','tenda-dome-2p','Tenda','Ringkas dan nyaman untuk dua orang.','["Kapasitas 2 orang","Termasuk pasak & flysheet"]',70000,5,false),
('Tenda Family 4P','tenda-family-4p','Tenda','Lebih luas untuk camping bersama keluarga atau teman.','["Kapasitas 4 orang","Termasuk pasak & flysheet"]',120000,3,true),
('Carrier 60L','carrier-60l','Carrier','Carrier kuat untuk perjalanan pendakian beberapa hari.','["Kapasitas 60 liter","Rain cover tersedia"]',45000,6,false),
('Sleeping Bag','sleeping-bag','Tidur','Hangat dan ringan untuk malam yang lebih nyaman.','["Model mummy","Sudah dicuci bersih"]',25000,12,false),
('Cooking Set','cooking-set','Masak','Peralatan masak praktis untuk kebutuhan camp.','["Kompor & gas","Nesting set"]',35000,7,false),
('Lampu Camp','lampu-camp','Penerangan','Lampu LED terang untuk tenda dan area camping.','["Baterai isi ulang","Kabel pengisian tersedia"]',15000,10,false)
on conflict (slug) do nothing;
