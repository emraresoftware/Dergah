# Aktif Sunucu Envanteri

Son guncelleme: 25 Mart 2026

Bu belge operasyonel gercegi yansitir. Eski dokumanlarda gecen 77.92.152.3 artik aktif envantere dahil edilmemelidir.

## Ozet

- Aktif giris katmani: 185.189.54.107
- ecomaiq origin uygulamasi: 185.189.54.104
- 77.92.152.3: kapatildi, aktif uretim envanterinden cikarilmali

## Sunucu Rol Haritasi

| Sunucu | Rol | Durum | Not |
|---|---|---|---|
| 185.189.54.107 | Ana ingress, reverse proxy, EmareCloud, EmareAPI, DApp, Finans, Ciftlik | Aktif | Dis erisim alan domainlerin buyuk kismi bu katmandan geciyor |
| 185.189.54.104 | ecomaiq origin | Aktif | Uygulama 107'de degil, 107 sadece proxy |
| 77.92.152.3 | Eski DC-2 | Kapali | Tarihsel kayitlarda geciyor, guncellenmeli |

## 185.189.54.107 Uzerinde Canli Dogrulananlar

- nginx: aktif
- php-fpm: aktif
- postgresql: aktif
- emarecloud.service: aktif
- emareapi.service: aktif
- PM2 uzerinde emare-dapp: aktif

Dinleyen kritik portlar:

- 80/tcp nginx
- 443/tcp nginx
- 5555/tcp gunicorn
- 8000/tcp uvicorn
- 3000/tcp next-server
- 5432/tcp postgresql

Canli domain sonuclari:

- emarecloud.tr -> 200
- finans.emarecloud.tr -> 200
- ciftlik.emarecloud.tr -> 302
- ecomaiq.emarecloud.tr -> 200

## 185.189.54.104 Uzerinde Canli Dogrulananlar

Bu sunucuda dogrudan SSH veya tam servis listesi bu oturumda alinmadi. Ancak 107 uzerinden origin testleri yapildi.

Canli origin sonuclari:

- ecomaiq.com 443 -> 200
- 8000/tcp -> erisilemiyor, no route to host
- 3002/tcp -> erisilemiyor, no route to host

Yorum:

- 104 uzerindeki ecomaiq origin HTTPS isteklerine cevap veriyor.
- 104'te belgelenen diger servisler bu oturumda ag seviyesinde dogrulanamadi.

## ecomaiq Topolojisi

Guncel akis su sekilde:

1. ecomaiq.emarecloud.tr veya ecomaiq.com istegi 107'ye gelir.
2. 107 uzerindeki nginx vhost istegi 104'e proxy eder.
3. Asil ecomaiq uygulamasi 104'te calisir.

Not: 107 uzerinde /var/www/ecomaiq dizini bulunmadi. Bu nedenle 107 uzerinde ikinci bir ecomaiq uygulama kopyasi yok.