# TALIMATLAR — guvenlik-dev

Bu dosyadaki `- [ ]` maddeleri Copilot Agent ile uygulayın.
Uyguladıktan sonra her maddeyi `- [x]` ile işaretleyin.

## E1-004 — Validasyon auth ve guvenlik onlemleri
> sprint: E1 | durum: in_progress

- [ ] `src/middleware/auth.js` — `Authorization: Bearer <API_KEY>` header kontrolü
- [ ] `src/middleware/validate.js` — Joi şemasıyla request body/query validasyonu
- [ ] `src/middleware/rateLimit.js` — IP başına dakikada 60 istek limiti
- [ ] `helmet` middleware aktif (XSS, HSTS, Content-Type sniffing önleme)
- [ ] `src/validation/itemSchema.js` — Item create/update için Joi şemaları
- [ ] Geçersiz input → `422 Unprocessable Entity` + alan bazlı hata detayı
- [ ] Auth hatası → `401 Unauthorized` (hangi key olduğu açıklanmaz)
- [ ] Rate limit aşımı → `429 Too Many Requests` + Retry-After header
- [ ] `agents/validate.sh` kalite kapısı geçiyor
