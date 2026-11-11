-- ============================================================
-- Pagina "Chiamate" (ricerca auto) — tabella aggiuntiva
-- Esegui questo script UNA VOLTA nel SQL Editor di Supabase.
-- ============================================================

create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

-- Annunci trovati dalla ricerca auto, con tracciamento chiamate
create table if not exists public.lead (
  id             uuid primary key default gen_random_uuid(),
  fonte          text default '',   -- Subito | AutoScout24
  marca          text default '',
  modello        text default '',
  versione       text default '',
  prezzo         numeric default 0,
  anno           numeric default 0,
  km             numeric default 0,
  comune         text default '',
  prov           text default '',
  telefono       text default '',
  link           text default '',   -- URL dell'annuncio (chiave anti-doppioni all'import)
  pubblicato     text default '',
  commerciale    text default '',   -- chi chiama (Thomas / Roberta / Oussama / ...)
  data_chiamata  text default '',   -- data della chiamata (AAAA-MM-GG)
  esito          text default 'da_chiamare',
  note           text default '',
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);

alter table public.lead enable row level security;
drop policy if exists "lead_auth" on public.lead;
create policy "lead_auth" on public.lead
  for all to authenticated using ( true ) with check ( true );

alter publication supabase_realtime add table public.lead;

drop trigger if exists trg_lead_touch on public.lead;
create trigger trg_lead_touch before update on public.lead
  for each row execute function public.touch_updated_at();
