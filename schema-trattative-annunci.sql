-- ============================================================
-- Pagine "Trattative" e "Gestione annunci" — tabelle aggiuntive
-- Esegui questo script UNA VOLTA nel SQL Editor di Supabase,
-- dopo aver gia' creato la tabella "veicoli" con schema.sql.
-- ============================================================

-- Funzione updated_at (se non gia' presente da schema.sql)
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

-- ---------- 1) TRATTATIVE ----------
create table if not exists public.trattative (
  id             uuid primary key default gen_random_uuid(),
  veicolo_id     text default '',   -- id del veicolo scelto dal registro
  veicolo_label  text default '',   -- "Modello · Targa" (copiato per lo storico)
  tipo           text default 'Auto',
  prezzo_offerta numeric default 0,
  garanzia       text default 'nessuna',  -- nessuna | light | advanced | completa
  costo_garanzia numeric default 0,
  costo_trapasso numeric default 0,
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);

alter table public.trattative enable row level security;
drop policy if exists "trattative_auth" on public.trattative;
create policy "trattative_auth" on public.trattative
  for all to authenticated using ( true ) with check ( true );

alter publication supabase_realtime add table public.trattative;

drop trigger if exists trg_trattative_touch on public.trattative;
create trigger trg_trattative_touch before update on public.trattative
  for each row execute function public.touch_updated_at();

-- ---------- 2) GESTIONE ANNUNCI ----------
create table if not exists public.annunci (
  id             uuid primary key default gen_random_uuid(),
  veicolo_id     text default '',
  veicolo_label  text default '',
  tipo           text default 'Auto',
  piattaforma    text default 'subito',  -- subito | autoscout
  data_inizio    text default '',        -- data di messa online (AAAA-MM-GG)
  attivo         boolean default true,
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);

alter table public.annunci enable row level security;
drop policy if exists "annunci_auth" on public.annunci;
create policy "annunci_auth" on public.annunci
  for all to authenticated using ( true ) with check ( true );

alter publication supabase_realtime add table public.annunci;

drop trigger if exists trg_annunci_touch on public.annunci;
create trigger trg_annunci_touch before update on public.annunci
  for each row execute function public.touch_updated_at();
