# TALIMATLAR — api-dev

Bu dosyadaki `- [ ]` maddeleri Copilot Agent ile uygulayın.
Uyguladıktan sonra her maddeyi `- [x]` ile işaretleyin.

## E1-002 — REST endpoint tasarimi ve implementasyon
> sprint: E1 | durum: in_progress

- [ ] `src/routes/items.js` — tüm CRUD route'ları tanımlı
- [ ] `src/controllers/itemsController.js` — iş mantığı (veri katmanını çağırır)
- [ ] `docs/API.md` — tüm endpoint'ler tablo formatında belgelenmiş
- [ ] `GET /api/v1/items` → `{ "data": [...], "total": N }` döner
- [ ] `GET /api/v1/items/:id` → bulunamazsa `404 { "error": "Not found" }`
- [ ] `POST /api/v1/items` → `201` + oluşturulan nesne
- [ ] `PUT /api/v1/items/:id` → `200` + güncellenmiş nesne
- [ ] `DELETE /api/v1/items/:id` → `204 No Content`
- [ ] `agents/validate.sh` kalite kapısı geçiyor
