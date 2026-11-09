# Registro Incarichi Vendita

Sito interattivo per il registro degli incarichi di conto vendita (auto e moto),
con calcolo automatico delle provvigioni. Dati salvati su **Supabase** (database
cloud gratuito), accesso riservato via email, sincronizzazione in tempo reale tra
i tuoi dispositivi. Pensato per essere pubblicato su **GitHub Pages**.

## Cosa contiene la cartella
| File | A cosa serve |
|---|---|
| `index.html` | Il sito vero e proprio |
| `config.js` | Le 2 chiavi del tuo progetto Supabase (le incolli tu) |
| `schema.sql` | Crea la tabella e le regole di sicurezza nel database |
| `seed.sql` | Carica i tuoi 45 veicoli iniziali |
| `.nojekyll` | Serve a GitHub Pages per pubblicare correttamente |

## Provvigioni (già configurate)
- fino a **8.000 €** → **8%** + IVA
- da 8.001 a **12.000 €** → **7,5%** + IVA
- oltre **12.000 €** → **6%** + IVA
- IVA al 22%. Per cambiarle, modifica le funzioni `rateFor` e `VAT` in `index.html`.

---

## Passo 1 — Crea il progetto Supabase (gratis)
1. Vai su https://supabase.com e registrati / accedi.
2. **New project** → dai un nome (es. `registro-incarichi`), scegli una password
   per il database e la regione (es. *Central EU*). Attendi ~2 minuti.

## Passo 2 — Crea la tabella e carica i dati
1. Nel progetto, menu a sinistra → **SQL Editor** → **New query**.
2. Apri `schema.sql`, copia tutto, incolla e premi **Run**.
3. Nuova query: apri `seed.sql`, copia, incolla e premi **Run** (carica i 45 veicoli).

> ⚠️ In `schema.sql` l'accesso è limitato all'email **omniscent.finance@gmail.com**.
> Se usi un'altra email, cambiala nella policy (è spiegato nel file) prima di eseguire.

## Passo 3 — Attiva l'accesso via email
1. Menu → **Authentication** → **Providers** → verifica che **Email** sia attivo.
2. (Consigliato) **Authentication → Providers → Email**: disattiva *"Confirm email"*
   non serve, e il **magic link** funziona di default.

## Passo 4 — Copia le tue 2 chiavi in `config.js`
1. Menu → **Project Settings** → **Data API** (o **API**).
2. Copia **Project URL** e la chiave **anon public**.
3. Apri `config.js` e incollale al posto dei segnaposto. Salva.

La chiave `anon` può stare tranquillamente nel codice pubblico: i dati restano
protetti dalle regole del database. **Non** mettere mai la chiave `service_role`.

## Passo 5 — Pubblica su GitHub Pages
1. Crea un repository su GitHub (es. `registro-incarichi`).
2. Carica **tutti** i file di questa cartella nel repository
   (anche `config.js` già compilato e `.nojekyll`).
3. Repository → **Settings** → **Pages** → *Build and deployment* →
   Source: **Deploy from a branch**, Branch: **main** / **/ (root)** → **Save**.
4. Dopo ~1 minuto il sito sarà su `https://<tuo-utente>.github.io/registro-incarichi/`.

## Passo 6 — Ultimo collegamento (importante)
Aggiungi l'indirizzo del sito tra quelli consentiti da Supabase, altrimenti il
link di accesso via email non ti riporta al sito:
- Supabase → **Authentication** → **URL Configuration** →
  - **Site URL**: `https://<tuo-utente>.github.io/registro-incarichi/`
  - **Redirect URLs**: aggiungi lo stesso indirizzo.

## Uso quotidiano
- Apri il sito, inserisci la tua email, ricevi il **link di accesso**, aprilo.
- Da lì aggiungi / modifichi / elimini veicoli: le modifiche si salvano nel cloud
  e compaiono su ogni tuo dispositivo. Non serve essere sul PC di casa.

---

### Nota privacy
GitHub Pages serve pagine **pubbliche**: chiunque può aprire l'indirizzo del sito,
**ma** non vedrà alcun dato senza aver effettuato l'accesso con l'email autorizzata
(i dati sono protetti dalle regole di Supabase). Non pubblicare mai la chiave
`service_role` né il file `.env` di Supabase.
