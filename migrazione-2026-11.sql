-- ============================================================
-- Aggiornamento tabelle esistenti — esegui UNA VOLTA nel SQL Editor
-- di Supabase se hai già creato le tabelle in precedenza.
-- (Chi crea le tabelle da zero con gli schema aggiornati non serve.)
-- ============================================================

-- Trattative: commerciale che segue la trattativa
alter table public.trattative
  add column if not exists commerciale text default '';

-- Vendite: id del veicolo preso dal registro (per toglierlo dagli incarichi)
alter table public.vendite
  add column if not exists veicolo_id text default '';
