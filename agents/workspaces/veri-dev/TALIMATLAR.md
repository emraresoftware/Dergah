# TALIMATLAR — veri-dev

Bu dosyadaki `- [ ]` maddeleri Copilot Agent ile uygulayın.
Uyguladıktan sonra her maddeyi `- [x]` ile işaretleyin.

## E1-003 — Veri katmani ve model tasarimi
> sprint: E1 | durum: in_progress

- [ ] `src/models/Item.js` — Item şeması: `{ id, name, description, tags, createdAt, updatedAt, deletedAt }`
- [ ] `src/storage/fileAdapter.js` — JSON dosya okuma/yazma (atomic write ile)
- [ ] `src/storage/memoryAdapter.js` — test için in-memory adapter (aynı interface)
- [ ] `src/storage/index.js` — `NODE_ENV=test` ise memory, diğerlerinde file adapter döner
- [ ] `src/data/items.json` — başlangıç dosyası (`[]` ile)
- [ ] CRUD metodları: `findAll()`, `findById()`, `create()`, `update()`, `delete()` (soft delete)
- [ ] Tüm yazma işlemleri atomic (temp dosya → rename)
- [ ] `agents/validate.sh` kalite kapısı geçiyor
