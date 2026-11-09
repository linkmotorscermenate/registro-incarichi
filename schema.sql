-- ============================================================
-- Registro Incarichi Vendita — schema del database (Supabase)
-- Esegui questo script UNA VOLTA nel SQL Editor di Supabase.
-- ============================================================

-- 1) Tabella dei veicoli
create table if not exists public.veicoli (
  id          uuid primary key default gen_random_uuid(),
  nome        text default '',
  cognome     text default '',
  tel         text default '',
  num         text default '',
  tipo        text default 'Auto',
  data        text default '',   -- data incarico (AAAA-MM-GG)
  scad        text default '',   -- scadenza     (AAAA-MM-GG)
  modello     text default '',
  targa       text default '',
  imm         text default '',   -- immatricolazione (MM/AAAA)
  carr        text default '',
  colore      text default '',
  km          numeric default 0,
  pot         text default '',
  alim        text default '',
  cambio      text default '',
  prezzo      numeric default 0,
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- 2) Row Level Security: nessuno accede ai dati senza autorizzazione
alter table public.veicoli enable row level security;

-- 3) Policy: accesso ai dati solo per gli utenti autenticati.
--    L'accesso al sito avviene con un PIN, che è la password di un unico
--    utente creato in Authentication. Chi non conosce il PIN non si
--    autentica, quindi non legge e non scrive nulla.
drop policy if exists "registro_owner" on public.veicoli;
create policy "registro_owner" on public.veicoli
  for all
  to authenticated
  using      ( true )
  with check ( true );

-- 4) Sincronizzazione in tempo reale tra i tuoi dispositivi
alter publication supabase_realtime add table public.veicoli;

-- 5) updated_at automatico ad ogni modifica
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

drop trigger if exists trg_veicoli_touch on public.veicoli;
create trigger trg_veicoli_touch before update on public.veicoli
  for each row execute function public.touch_updated_at();
