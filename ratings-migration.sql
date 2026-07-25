-- Jalankan SEKALI di Supabase SQL Editor setelah supabase-schema.sql.
create table if not exists public.website_reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  display_name text not null,
  score integer not null check (score between 1 and 5),
  comment text not null check (char_length(comment) between 3 and 300),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.website_reviews enable row level security;
drop policy if exists "Anyone reads website reviews" on public.website_reviews;
drop policy if exists "User inserts own website review" on public.website_reviews;
drop policy if exists "User updates own website review" on public.website_reviews;
create policy "Anyone reads website reviews" on public.website_reviews for select using (true);
create policy "User inserts own website review" on public.website_reviews for insert with check (auth.uid() = user_id);
create policy "User updates own website review" on public.website_reviews for update using (auth.uid() = user_id);
