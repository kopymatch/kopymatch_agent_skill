---
name: deploy-preview-vi
description: "Quy trình deploy preview (Vercel/Docker) — kiểm tra trước khi production"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Deploy Preview (Việt hoá)

## Mục tiêu

Quy trình deploy preview cho mỗi PR/branch — kiểm tra trực quan trước khi merge vào production.

## Khi nào dùng

- ✅ Trước khi merge PR vào main
- ✅ Khi cần demo feature cho stakeholder
- ✅ Khi cần test trên môi trường gần production

## Cách 1: Vercel Preview (KopyMatch web)

Mỗi PR tự động tạo preview URL nếu đã connect repo với Vercel.

```bash
# Deploy manual
npx vercel --prod=false
```

### Checklist Preview

- [ ] Build thành công (không error)
- [ ] Các trang chính load được
- [ ] API endpoints hoạt động
- [ ] Responsive mobile/tablet OK
- [ ] Không có console errors

## Cách 2: Docker Preview (Crawler bot)

```bash
# Build
docker build -t kopymatch-crawler:preview .

# Run
docker run -p 8787:8787 --env-file .env.preview kopymatch-crawler:preview
```

### Checklist Docker

- [ ] Docker build thành công
- [ ] Container start không crash
- [ ] Health check endpoint OK
- [ ] Crawl test URL thành công
- [ ] Memory usage hợp lý (<512MB)

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
