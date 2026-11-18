-- ============================================================
-- Sezione "Incassi" (provvigioni venditori) — tabella aggiuntiva
-- Esegui questo script UNA VOLTA nel SQL Editor di Supabase.
-- ============================================================

create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

-- Vendite dei commerciali, con i margini caricati al cliente.
-- Le provvigioni (lorda/netta) sono calcolate dal sito, non salvate qui:
--   * base auto = commissione_filiale (NON il prezzo di vendita)
--   * scaglione per numero di vendita NEL MESE del venditore:
--       1-5  -> auto 20% | margini 25%
--       6-10 -> auto 25% | margini 30%
--       11+  -> auto 30% | margini 35%
--   * lorda = % sui valori IVA inclusa ; netta = % sui valori netti (lorda/1,22)
--   * i margini sono SOLO il ricarico applicato al cliente (IVA inclusa)
create table if not exists public.vendite (
  id                   uuid primary key default gen_random_uuid(),
  commerciale          text default '',
  data                 text default '',   -- data vendita (AAAA-MM-GG)
  veicolo              text default '',   -- descrizione (marca modello / targa)
  veicolo_id           text default '',   -- id del veicolo nel registro (se preso da lì)
  prezzo_vendita       numeric default 0, -- prezzo auto IVA inclusa (solo informativo)
  commissione_filiale  numeric default 0, -- commissione della filiale sull'auto (base del 20/25/30%)
  margine_garanzia     numeric default 0, -- ricarico garanzia (IVA inclusa)
  margine_finanziamento numeric default 0,-- ricarico finanziamento (IVA inclusa)
  margine_trapasso     numeric default 0, -- ricarico trapasso (IVA inclusa)
  note                 text default '',
  created_at           timestamptz default now(),
  updated_at           timestamptz default now()
);

alter table public.vendite enable row level security;
drop policy if exists "vendite_auth" on public.vendite;
create policy "vendite_auth" on public.vendite
  for all to authenticated using ( true ) with check ( true );

alter publication supabase_realtime add table public.vendite;

drop trigger if exists trg_vendite_touch on public.vendite;
create trigger trg_vendite_touch before update on public.vendite
  for each row execute function public.touch_updated_at();
