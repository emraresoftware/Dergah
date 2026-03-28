# TALIMATLAR — sunucu-dev

Bu dosyadaki `- [ ]` maddeleri Copilot Agent ile uygulayın.
Uyguladıktan sonra her maddeyi `- [x]` ile işaretleyin.

## E1-001 — Express server kurulumu ve middleware
> sprint: E1 | durum: in_progress

- [ ] `src/index.js` — sunucu başlatma, port dinleme, graceful shutdown
- [ ] `src/app.js` — Express app factory, middleware zinciri, route mount
- [ ] `src/middleware/errorHandler.js` — merkezi hata yakalayıcı (status + message)
- [ ] `src/middleware/requestLogger.js` — her isteği `[METHOD] /path → status ms` formatında logla
- [ ] `GET /health` endpoint'i → `{ "status": "ok", "uptime": <sn> }` döner
- [ ] `npm start` ile sunucu :3000'de çalışır, `npm run dev` nodemon ile çalışır
- [ ] `agents/validate.sh` kalite kapısı geçiyor
