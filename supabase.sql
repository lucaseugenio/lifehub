-- LifeHUB | Execute no SQL Editor do Supabase.
-- ATENÇÃO: este modelo sem login usa políticas públicas para a chave anon.
-- Qualquer pessoa que obtenha a URL e a chave pública poderá ler/alterar os dados.

create extension if not exists pgcrypto;

create table if not exists public.accounts (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  institution text,
  owner text,
  balance numeric(14,2) not null default 0,
  opening_date date not null default current_date,
  goal numeric(14,2),
  icon text default '▣',
  created_at timestamptz not null default now()
);

create table if not exists public.cards (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  bank text,
  brand text,
  holder text,
  last_four text,
  "limit" numeric(14,2) not null default 0,
  closing_day integer check (closing_day between 1 and 31),
  due_day integer check (due_day between 1 and 31),
  created_at timestamptz not null default now()
);

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  icon text default '◇',
  color text default '#eaf6ef',
  kind text not null default 'expense' check (kind in ('expense','income','both')),
  created_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  description text not null,
  amount numeric(14,2) not null check (amount > 0),
  type text not null check (type in ('income','expense','transfer')),
  date date not null default current_date,
  person text,
  category_id uuid references public.categories(id) on delete set null,
  payment_method text not null default 'account' check (payment_method in ('account','card')),
  account_id uuid references public.accounts(id) on delete set null,
  card_id uuid references public.cards(id) on delete set null,
  due_date date,
  status text not null default 'open' check (status in ('open','paid')),
  notes text,
  created_at timestamptz not null default now(),
  constraint transaction_payment_source check (
    (payment_method='account' and card_id is null) or
    (payment_method='card' and card_id is not null)
  )
);

create index if not exists transactions_date_idx on public.transactions(date);
create index if not exists transactions_account_idx on public.transactions(account_id);
create index if not exists transactions_category_idx on public.transactions(category_id);

alter table public.accounts enable row level security;
alter table public.cards enable row level security;
alter table public.categories enable row level security;
alter table public.transactions enable row level security;

drop policy if exists "public access accounts" on public.accounts;
drop policy if exists "public access cards" on public.cards;
drop policy if exists "public access categories" on public.categories;
drop policy if exists "public access transactions" on public.transactions;
create policy "public access accounts" on public.accounts for all to anon using (true) with check (true);
create policy "public access cards" on public.cards for all to anon using (true) with check (true);
create policy "public access categories" on public.categories for all to anon using (true) with check (true);
create policy "public access transactions" on public.transactions for all to anon using (true) with check (true);

grant usage on schema public to anon;
grant select, insert, update, delete on public.accounts, public.cards, public.categories, public.transactions to anon;

insert into public.categories (name,icon,color,kind) values
 ('Moradia','⌂','#eaf2ff','expense'),('Alimentação','✿','#fff0e7','expense'),
 ('Transporte','↗','#eaf6ef','expense'),('Saúde','✚','#fcecf0','expense'),
 ('Educação','▤','#f2edff','expense'),('Lazer','♫','#fff4df','expense'),
 ('Compras','◇','#fceef2','expense'),('Assinaturas','◷','#edf3ff','expense'),
 ('Contas da casa','⌁','#e9f7f2','expense'),('Salário','＋','#e5f7ef','income'),
 ('Renda extra','✦','#f0edff','income'),('Investimentos','◈','#e9f1ff','income'),
 ('Outros','•••','#f1f4f2','both')
on conflict do nothing;
