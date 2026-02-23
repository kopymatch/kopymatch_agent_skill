---
name: repo-hygiene-vi
description: "Quy tắc dọn dẹp repo — gitignore, lint, format, commit message, branch strategy"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Repo Hygiene (Việt hoá)

## Mục tiêu

Bộ quy tắc giữ repo sạch sẽ, dễ bảo trì — áp dụng cho cả kopymatch và crawler.

## Khi nào dùng

- ✅ Setup repo mới
- ✅ Dọn dẹp repo hiện tại
- ✅ Onboard thành viên mới
- ✅ Review PR structure

## Checklist

### 1. Git

- [ ] `.gitignore` đầy đủ (`node_modules`, `.env`, `dist`, `build`, `*.log`)
- [ ] Commit message theo Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`
- [ ] Branch strategy: `main` → `develop` → `feature/*`, `fix/*`
- [ ] Không commit file > 5MB

### 2. Lint & Format

```json
// package.json scripts
{
  "lint": "eslint . --ext .ts,.tsx",
  "format": "prettier --write .",
  "lint:fix": "eslint . --ext .ts,.tsx --fix"
}
```

- [ ] ESLint cấu hình (next/recommended + typescript)
- [ ] Prettier cấu hình (semi, singleQuote, tabWidth)
- [ ] Husky + lint-staged cho pre-commit hooks

### 3. Documentation

- [ ] README.md có: mô tả, cách cài đặt, cách chạy, cấu hình
- [ ] CHANGELOG.md update theo release
- [ ] JSDoc cho functions public quan trọng

### 4. CI/CD minimal

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
      - run: npm run lint
      - run: npm run build
      - run: npm test
```

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
