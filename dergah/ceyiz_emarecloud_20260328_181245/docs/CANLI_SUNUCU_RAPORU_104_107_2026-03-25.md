# Canli Sunucu Raporu

Son guncelleme: 25 Mart 2026

Bu belge sadece bu oturumda alinabilen canli bulgulari icerir.

## 185.189.54.107 Raporu

### Canli Servisler

- nginx.service: running
- php-fpm.service: running
- postgresql.service: running
- emarecloud.service: running
- emareapi.service: running
- PM2: emare-dapp online

### Dinleyen Portlar

- 80 -> nginx
- 443 -> nginx
- 5555 -> gunicorn
- 8000 -> uvicorn
- 3000 -> next-server
- 5432 -> postgresql

### Aktif Vhostlar

- api.dc1-107.emare.cloud -> 127.0.0.1:8000
- ciftlik.emarecloud.tr -> /var/www/ciftlik/public
- ecomaiq.com, www.ecomaiq.com, ecomaiq.emarecloud.tr -> proxy_pass https://185.189.54.104
- emarecloud.tr, www.emarecloud.tr -> 127.0.0.1:5555
- finans.emarecloud.tr -> /var/www/emarefinance/public

### HTTP Sonuclari

- emarecloud.tr -> 200
- finans.emarecloud.tr -> 200
- ciftlik.emarecloud.tr -> 302
- ecomaiq.emarecloud.tr -> 200

### Sonuc

107 uzerinde hem uygulama hem de ingress gorevi var. Ayrica ecomaiq icin gecici degil fiilen aktif reverse proxy katmani olarak calisiyor.

## 185.189.54.104 Raporu

### Dogrudan Canli Bulgular

- ecomaiq.com HTTPS origin testi -> 200
- 8000/tcp -> no route to host
- 3002/tcp -> no route to host

### Cikarim

- ecomaiq origin aktif.
- 104 uzerindeki diger belgelemis servisler bu oturumda dis ag veya 107 uzerinden dogrulanamadi.
- Bu nedenle 104 icin tam servis envanteri degil, kisitli canli rapor uretilmistir.

## ecomaiq Ozel Notu

- 107 uzerinde /var/www/ecomaiq yok.
- Bu nedenle ecomaiq iki sunucuda uygulama olarak calismiyor.
- Guncel model: 104 origin + 107 reverse proxy.