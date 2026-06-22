# Supabase Setup

Run these SQL blocks in **Supabase SQL Editor** (https://app.supabase.com/project/_/sql), in order. All idempotent — safe to re-run.

> Fix for "Database error saving user": block 1 adds the INSERT policy + grant so the client upsert after signUp works, while the trigger stays as fallback when email confirmation is on.

## 1) Users table + auto-profile on signup

```sql
-- Users table
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default '',
  email text not null default '',
  phone text not null default '',
  location text default 'Unknown',
  is_admin boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.users enable row level security;

-- Idempotent: drop old policies
drop policy if exists "Users can read profiles" on public.users;
drop policy if exists "Users can update profiles" on public.users;
drop policy if exists "Users can insert own profile" on public.users;

-- SECURITY DEFINER helper: bypass RLS, no recursion
create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select is_admin from public.users where id = auth.uid()),
    false
  );
$$;

-- SELECT: own profile, or admin sees all
create policy "Users can read profiles"
  on public.users for select to authenticated
  using (auth.uid() = id or public.is_admin());

-- UPDATE: own profile, or admin
create policy "Users can update profiles"
  on public.users for update to authenticated
  using (auth.uid() = id or public.is_admin())
  with check (auth.uid() = id or public.is_admin());

-- INSERT: own profile (client upsert after signUp when session exists)
create policy "Users can insert own profile"
  on public.users for insert to authenticated
  with check (auth.uid() = id);

-- Trigger: auto-insert profile on new auth.users (fallback when email confirmation on)
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, name, email, phone, location, is_admin)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    new.email,
    coalesce(new.raw_user_meta_data->>'phone', ''),
    'Unknown',
    false
  )
  on conflict (id) do nothing;

  -- create empty balance row on signup
  insert into public.balances (user_id, total, withdrawn)
  values (new.id, 0, 0)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Grants
grant usage on schema public to anon, authenticated;
grant select, insert, update on public.users to authenticated;
grant execute on function public.is_admin() to authenticated;
```

## 2) Categories + Pickups

```sql
create table if not exists public.categories (
  id bigserial primary key,
  category text unique not null,
  price_per_kg integer not null,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table if not exists public.pickups (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  category text not null references public.categories(category),
  weight real not null,
  price integer not null,
  pickup_date timestamp not null,
  pickup_address text not null,
  note text,
  status text default 'waiting' check (status in ('waiting', 'confirmed', 'rejected', 'completed')),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

insert into public.categories (category, price_per_kg) values
  ('Plastik', 2500),
  ('Kertas', 1500),
  ('Logam', 5000),
  ('Kaca', 1000),
  ('Elektronik', 7500)
on conflict (category) do nothing;

alter table public.categories enable row level security;
alter table public.pickups enable row level security;

drop policy if exists "Anyone can read categories" on public.categories;
drop policy if exists "Users can read own pickups" on public.pickups;
drop policy if exists "Users can insert own pickups" on public.pickups;
drop policy if exists "Users can update own pickups" on public.pickups;

drop policy if exists "Admin can manage categories" on public.categories;

create policy "Anyone can read categories" on public.categories for select using (true);
create policy "Admin can manage categories" on public.categories for all using (public.is_admin()) with check (public.is_admin());
grant insert, update, delete on public.categories to authenticated;
create policy "Users can read own pickups" on public.pickups for select using (auth.uid() = user_id or public.is_admin());
create policy "Users can insert own pickups" on public.pickups for insert with check (auth.uid() = user_id);
create policy "Users can update own pickups" on public.pickups for update using (auth.uid() = user_id or public.is_admin());
```

## 3) Balances + Withdrawals

```sql
create table if not exists public.balances (
  id bigserial primary key,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  total integer default 0,
  withdrawn integer default 0,
  balance integer generated always as (total - withdrawn) stored,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

create table if not exists public.withdrawals (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  amount integer not null,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamp default now(),
  updated_at timestamp default now()
);

alter table public.balances enable row level security;
alter table public.withdrawals enable row level security;

drop policy if exists "Users can read own balance" on public.balances;
drop policy if exists "Users can insert own balance" on public.balances;
drop policy if exists "Users can read own withdrawals" on public.withdrawals;
drop policy if exists "Users can insert withdrawal requests" on public.withdrawals;
drop policy if exists "Admin can update withdrawal status" on public.withdrawals;

drop policy if exists "Admin can update balances" on public.balances;
drop policy if exists "Admin can insert balances" on public.balances;
drop policy if exists "Users can update own balance" on public.balances;

create policy "Users can read own balance" on public.balances for select using (auth.uid() = user_id or public.is_admin());
create policy "Users can insert own balance" on public.balances for insert with check (auth.uid() = user_id or public.is_admin());
create policy "Users can update own balance" on public.balances for update using (auth.uid() = user_id or public.is_admin());
grant select, insert, update on public.balances to authenticated;
create policy "Users can read own withdrawals" on public.withdrawals for select using (auth.uid() = user_id or public.is_admin());
create policy "Users can insert withdrawal requests" on public.withdrawals for insert with check (auth.uid() = user_id);
create policy "Admin can update withdrawal status" on public.withdrawals for update using (public.is_admin());
grant select, insert, update on public.withdrawals to authenticated;
```

## 4) Bank Accounts

```sql
create table if not exists public.bank_accounts (
  id bigserial primary key,
  user_id uuid not null unique references auth.users(id) on delete cascade,
  name_account text not null,
  number_account text not null,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

alter table public.bank_accounts enable row level security;

drop policy if exists "Users can manage own bank account" on public.bank_accounts;
drop policy if exists "Admin can read bank accounts" on public.bank_accounts;

create policy "Users can manage own bank account"
  on public.bank_accounts for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Admin can read bank accounts"
  on public.bank_accounts for select
  using (public.is_admin());

grant select, insert, update on public.bank_accounts to authenticated;
```

## Make a user admin

```sql
update public.users set is_admin = true where email = 'admin@email.com';
```
