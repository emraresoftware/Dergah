# Diger Mac'leri Dergah'a Baglama

Bu rehber worker Mac'leri mevcut Dergah sistemine katmak icin en kisa operasyon akisini verir.

## 1) Her worker Mac'te repo ve venv hazir olmalı

```bash
cd /Users/emre/Dergah
source .venv/bin/activate
```

## 2) Worker env dosyasini olustur

Worker1 icin:

```bash
cd /Users/emre/Dergah
scripts/join_mac_node.sh \
  --role worker1 \
  --m5-host 100.127.160.48 \
  --github-owner ORG_VEYA_USER \
  --github-repo REPO_ADI \
  --github-issue 12 \
  --github-token GITHUB_TOKEN \
  --start-status
```

Worker2 icin:

```bash
cd /Users/emre/Dergah
scripts/join_mac_node.sh \
  --role worker2 \
  --m5-host 100.127.160.48 \
  --github-owner ORG_VEYA_USER \
  --github-repo REPO_ADI \
  --github-issue 12 \
  --github-token GITHUB_TOKEN \
  --start-status
```

Bu komut `.env.worker1.local` veya `.env.worker2.local` dosyasini olusturur. `start_node.sh` artik bu local dosyalari, example dosyalarina tercih eder.

## 3) Durumu kontrol et

```bash
cd /Users/emre/Dergah
scripts/start_node.sh worker1 status
scripts/start_node.sh worker2 status
```

Beklenen:

- `OPENAI_API_BASE` M5 adresini gostermeli.
- `GITHUB_RELAY=configured` olmali.

## 4) Mesaj kanalina baglan

```bash
cd /Users/emre/Dergah
scripts/start_node.sh worker1 relay-listen
```

veya:

```bash
cd /Users/emre/Dergah
scripts/start_node.sh worker2 relay-listen
```

Log:

- `/tmp/dervis_relay.log`

## 5) OpenClaw worker baslat

```bash
cd /Users/emre/Dergah
scripts/start_node.sh worker1 openclaw
```

OpenClaw CLI yoksa once `OPENCLAW_BIN` tanimlanmali ya da resmi CLI kurulumu yapilmali.

## 6) Orchestrator tarafi

M5 cihazinda:

```bash
cd /Users/emre/Dergah
source .env.m5-orchestrator.example
/Users/emre/Dergah/.venv/bin/python scripts/dergah_orkestrator.py --operator --github-announce --github-heartbeat
```

## 7) Hata ayiklama

- Relay env eksikse `scripts/dervis_haberlesme_github.py` ValueError verir.
- Exo hala stabil degilse worker'lar `DERGAH_LLM_FALLBACK_OLLAMA=1` ile fallback kullanir.
- Mesaj sistemi icin ayni repo ve ayni issue tum cihazlarda ortak olmalidir.

## 8) SSH varsa uzaktan tek komutla bagla

Bu makineden diger Mac'e anahtarsiz ya da hazir SSH erisimi varsa:

```bash
cd /Users/emre/Dergah
scripts/bootstrap_remote_mac.sh \
  --host 192.168.1.60 \
  --user emre \
  --role worker1 \
  --m5-host 100.127.160.48 \
  --github-owner ORG_VEYA_USER \
  --github-repo REPO_ADI \
  --github-issue 12 \
  --github-token GITHUB_TOKEN \
  --start-relay
```

Not: Bunun calismasi icin hedef Mac'te `Remote Login` acik olmali ve bu makineden SSH baglantisi kabul edilmeli.
