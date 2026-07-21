-- Jalankan di Supabase Dashboard > SQL Editor.
-- Login email/password sudah dikelola Supabase Auth; tabel ini menyimpan profil member.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  phone text,
  created_at timestamptz not null default now()
);

alter table public.profiles add column if not exists username text;
alter table public.profiles add column if not exists phone text;
alter table public.profiles add column if not exists birth_date date;
alter table public.profiles add column if not exists identity_type text;
alter table public.profiles add column if not exists identity_number text;
alter table public.profiles add column if not exists address text;
create unique index if not exists profiles_username_unique on public.profiles (lower(username)) where username is not null;

alter table public.profiles enable row level security;
create policy "Member can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Member can update own profile" on public.profiles for update using (auth.uid() = id);

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$ begin insert into public.profiles (id, email, full_name, username, phone, birth_date, identity_type, identity_number, address) values (new.id, new.email, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'username', new.raw_user_meta_data->>'phone', nullif(new.raw_user_meta_data->>'birth_date','')::date, new.raw_user_meta_data->>'identity_type', new.raw_user_meta_data->>'identity_number', new.raw_user_meta_data->>'address'); return new; end; $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
