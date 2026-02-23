---
name: security-basics-vi
description: "Kiểm tra bảo mật cơ bản cho web app — secrets, deps, headers, auth — dành cho team KopyMatch"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Security Basics (Việt hoá)

## Mục tiêu

Checklist bảo mật cơ bản cho web app KopyMatch — quản lý secrets, dependency audit, security headers, auth.

## Khi nào dùng

- ✅ Trước khi deploy / push code
- ✅ Khi thêm dependency mới
- ✅ Review PR liên quan auth / API
- ❌ KHÔNG thay thế pentest chuyên nghiệp

## Checklist Bảo mật

### 1. Quản lý Secrets

- [ ] `.env` trong `.gitignore`
- [ ] Không hardcode API key / token trong source code
- [ ] Dùng biến môi trường cho tất cả credentials
- [ ] Secret rotation có kế hoạch

```bash
# Kiểm tra nhanh secrets bị leak
grep -rn "API_KEY\|SECRET\|TOKEN\|PASSWORD" --include="*.ts" --include="*.tsx" --include="*.js" src/
```

### 2. Dependency Audit

```bash
npm audit
npx better-npm-audit audit
```

- [ ] Không có vulnerability critical/high
- [ ] Dependencies được update định kỳ (monthly)
- [ ] Lock file (`package-lock.json`) được commit

### 3. Security Headers

```ts
// next.config.js
const securityHeaders = [
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'Referrer-Policy', value: 'origin-when-cross-origin' },
  { key: 'X-XSS-Protection', value: '1; mode=block' },
];
```

### 4. API Security

- [ ] Rate limiting trên mọi endpoint
- [ ] Input validation (zod / joi)
- [ ] CORS cấu hình đúng (không `*` trên production)
- [ ] Auth middleware cho protected routes

### 5. Data Protection

- [ ] PII (thông tin cá nhân) được mã hoá khi lưu
- [ ] Logs không chứa sensitive data
- [ ] Database queries dùng parameterized queries (chống SQL injection)

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
- **Tham khảo**: OWASP Top 10, Next.js Security docs
