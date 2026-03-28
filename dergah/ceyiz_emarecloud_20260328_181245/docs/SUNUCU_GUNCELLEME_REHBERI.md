# 🚀 Emare Sunucu Güncelleme Rehberi

> Son güncelleme: Mart 2026

---

## 📡 Altyapı Haritası

> Not: 77.92.152.3 kapatıldı. Aşağıdaki tablo güncel operasyonel topolojiyi gösterir.

| Alan Adı | Sunucu | DC | Teknoloji | Port |
|---|---|---|---|---|
| `emarecloud.tr` | 185.189.54.107 | DC-2 | Flask/Gunicorn | 5555 |
| `www.emarecloud.tr` | 185.189.54.107 | DC-2 | CNAME → emarecloud.tr | — |
| `api.emarecloud.tr` | 185.189.54.107 | DC-2 | FastAPI/Uvicorn | 8000 |
| `token.emarecloud.tr` | 185.189.54.107 | DC-2 | Next.js (emare-dapp) | 3000 |
| `webdizayn.emarecloud.tr` | 185.189.54.107 | DC-2 | Nginx Static / panel entegrasyonu | 80 |
| `asistan.emarecloud.tr` | 185.189.54.107 | DC-2 | Ingress teyidi gerekli | 443 |
| `finans.emarecloud.tr` | 185.189.54.107 | DC-2 | Laravel/PHP-FPM | 443 |
| `ecomaiq.com` | 185.189.54.104 | DC-1 | Node origin | 443 |
| `ecomaiq.emarecloud.tr` | 185.189.54.107 | DC-2 | Nginx reverse proxy → 185.189.54.104 | 443 |

**SSH Bağlantıları:**
```bash
# Origin (ecomaiq)
ssh -i ~/.ssh/id_ed25519 root@185.189.54.104

# Aktif ingress / panel
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107
```

---

## 1️⃣ EmareCloud Paneli — `emarecloud.tr`

**Konum:** DC-2 › `/opt/emarecloud/`  
**Servis:** `emarecloud.service` (gunicorn)

```bash
# Dosyaları güncelle (local'den)
scp -i ~/.ssh/id_ed25519 değişen_dosya.py root@185.189.54.107:/opt/emarecloud/

# Birden fazla dosya veya klasör
scp -i ~/.ssh/id_ed25519 -r routes/ templates/ root@185.189.54.107:/opt/emarecloud/

# Servisi yeniden başlat
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'systemctl restart emarecloud && sleep 2 && curl -s -o /dev/null -w "HTTP: %{http_code}" http://localhost/ -H "Host: emarecloud.tr"'
```

**DB Migrasyonu gerekiyorsa:**
```bash
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'cd /opt/emarecloud && source venv/bin/activate && python3 -c "
from app import create_app; from extensions import db
app = create_app()
with app.app_context(): db.create_all()
print(\"Migration OK\")
"'
```

---

## 2️⃣ Emare Asistan — `asistan.emarecloud.tr`

**Durum:** 77.92.152.3 kapatıldığı için origin yerleşimi teyit gerektiriyor.  
**Operasyon notu:** Yeni deploy veya müdahale öncesi aktif vhost ve servis yerleşimi 107 üzerinde doğrulanmalı.

---

## 3️⃣ Emare Finance — `finans.emarecloud.tr`

**Konum:** DC-2 › `/var/www/emarefinance/`  
**Servis:** PHP-FPM + Nginx

**A) Küçük güncelleme (birkaç PHP dosyası):**
```bash
# Dosyaları kopyala
scp -i ~/.ssh/id_ed25519 app/Http/Controllers/FaturaController.php \
  root@185.189.54.107:/var/www/emarefinance/app/Http/Controllers/

# Cache temizle (zorunlu)
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'cd /var/www/emarefinance && php artisan config:cache && php artisan route:cache && php artisan view:cache'
```

**B) Büyük güncelleme (migration, composer değişikliği, npm build):**
```bash
# 1. Tüm dosyaları kopyala
scp -i ~/.ssh/id_ed25519 -r \
  app/ routes/ resources/ database/ \
  root@185.189.54.107:/var/www/emarefinance/

# 2. Deploy script çalıştır
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'cd /var/www/emarefinance && bash deploy.sh'
```

**C) Sadece frontend değişti (Blade/CSS/JS):**
```bash
# Dosyaları kopyala
scp -i ~/.ssh/id_ed25519 -r resources/views/ \
  root@185.189.54.107:/var/www/emarefinance/resources/views/

# View cache'i yenile (yeterli)
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'cd /var/www/emarefinance && php artisan view:cache && echo OK'
```

---

## 4️⃣ Emare API — `api.emarecloud.tr`

**Konum:** DC-2 › `/opt/emareapi/`  
**Servis:** uvicorn port 8000  
**Teknoloji:** FastAPI + Python

```bash
# Dosyaları güncelle
scp -i ~/.ssh/id_ed25519 değişen_dosya.py root@185.189.54.107:/opt/emareapi/

# Servisi yeniden başlat
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'systemctl restart emareapi 2>/dev/null || pkill -f "uvicorn" && cd /opt/emareapi && source venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000 --daemon 2>/dev/null || nohup uvicorn main:app --host 0.0.0.0 --port 8000 &'

# Test
curl -s https://api.emarecloud.tr/docs -o /dev/null -w "HTTP: %{http_code}"
```

---

## 5️⃣ Emare Token DApp — `token.emarecloud.tr`

**Konum:** DC-2 › `/opt/emare-dapp/`  
**Servis:** PM2 (`emare-dapp`)  
**Teknoloji:** Next.js

```bash
# Dosyaları güncelle
scp -i ~/.ssh/id_ed25519 -r src/ public/ \
  root@185.189.54.107:/opt/emare-dapp/

# Build + PM2 yeniden başlat
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 '
  cd /opt/emare-dapp
  npm run build
  pm2 restart emare-dapp
  sleep 3
  pm2 status emare-dapp
'
```

---

## 6️⃣ Web Dizayn Hosting — `webdizayn.emarecloud.tr/{slug}`

Web dizayn müşteri sitelerini **panel üzerinden** yönet:  
→ `https://emarecloud.tr/webdizayn`

```bash
# Manuel ZIP yükleme (panel yerine CLI kullanmak istersen)
scp -i ~/.ssh/id_ed25519 site.zip root@185.189.54.107:/tmp/
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 '
  cd /var/www/webdizayn/piramitbilgisayar
  rm -rf *
  unzip /tmp/site.zip -d . && rm /tmp/site.zip
  restorecon -Rv /var/www/webdizayn/piramitbilgisayar/
  echo Done
'
```

---

## 🔄 Nginx Güncelleme

```bash
# Config test + reload (aktif ingress)
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'nginx -t && systemctl reload nginx && echo OK'
```

---

## 🌐 Cloudflare DNS Yönetimi

```bash
# Yeni subdomain ekle
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/a72e4fe4787b786fb91d41a3491949eb/dns_records" \
  -H "Authorization: Bearer YSaZrmVvW07MDCEwJSPJNeYKXVUrpK1lykaLDSQ9" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"yenisubdomain","content":"185.189.54.107","ttl":1,"proxied":true}'

# Tüm kayıtları listele
curl -s "https://api.cloudflare.com/client/v4/zones/a72e4fe4787b786fb91d41a3491949eb/dns_records?per_page=100" \
  -H "Authorization: Bearer YSaZrmVvW07MDCEwJSPJNeYKXVUrpK1lykaLDSQ9" | \
  python3 -c "import json,sys; [print(r['type'], r['name'], '→', r['content']) for r in json.load(sys.stdin)['result']]"
```

---

## ✅ Güncelleme Sonrası Kontrol Listesi

```bash
# Tüm servisleri hızlı test
for domain in emarecloud.tr finans.emarecloud.tr api.emarecloud.tr token.emarecloud.tr webdizayn.emarecloud.tr ecomaiq.emarecloud.tr; do
  code=$(curl -m 10 -s -o /dev/null -w "%{http_code}" https://$domain)
  printf "%-40s → %s\n" "$domain" "$code"
done
```

**Beklenen sonuçlar:**
| Alan Adı | Beklenen |
|---|---|
| `emarecloud.tr` | 200 veya 302 |
| `finans.emarecloud.tr` | 200 |
| `api.emarecloud.tr` | 200 (FastAPI docs) |
| `token.emarecloud.tr` | 404 normal (root yok, /dashboard kullan) |
| `webdizayn.emarecloud.tr` | 302 (panele yönlenir) |
| `ecomaiq.emarecloud.tr` | 200 |

---

## ⚠️ SELinux Notları (AlmaLinux/CentOS)

Yeni dosya kopyaladıktan sonra nginx okuyamıyorsa:
```bash
# /var/www altı için
restorecon -Rv /var/www/webdizayn/

# /opt altı için (zaten httpd_sys_content_t değilse)
semanage fcontext -a -t httpd_sys_content_t "/opt/emareapi(/.*)?"
restorecon -Rv /opt/emareapi/
```

---

## 🚨 Acil Durum

```bash
# Aktif ingress servislerini kontrol et
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 \
  'systemctl status emarecloud nginx && pm2 status'

# ecomaiq origin durumu
ssh -i ~/.ssh/id_ed25519 root@185.189.54.104 \
  'curl -k -I --max-time 10 --resolve ecomaiq.com:443:127.0.0.1 https://ecomaiq.com | sed -n "1,10p"'

# Hata logları
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 'journalctl -u emarecloud -n 30'
ssh -i ~/.ssh/id_ed25519 root@185.189.54.107 'tail -20 /var/www/emarefinance/storage/logs/laravel.log'
```
