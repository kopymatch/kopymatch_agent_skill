---
name: git-workflow-vi
description: "Git workflow chuẩn cho team — branching, PR, code review, conflict resolution"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Git Workflow (Việt hoá)

## Mục tiêu

Quy trình Git chuẩn cho team KopyMatch — branching strategy, PR flow, conflict resolution.

## Khi nào dùng

- ✅ Bắt đầu feature mới
- ✅ Fix bug
- ✅ Release version mới
- ✅ Onboard thành viên mới

## Branch Strategy

```
main ← production-ready
  └── develop ← integration branch
        ├── feature/add-entity-api
        ├── feature/risk-dashboard
        ├── fix/crawl-timeout
        └── hotfix/security-patch
```

## Quy trình

### 1. Bắt đầu Feature

```bash
git checkout develop
git pull origin develop
git checkout -b feature/ten-feature
```

### 2. Commit

```bash
# Conventional Commits
git commit -m "feat(crawler): thêm support OKX API"
git commit -m "fix(ui): sửa lỗi hiển thị risk badge"
git commit -m "docs: cập nhật API documentation"
git commit -m "chore: update dependencies"
```

### 3. Push & PR

```bash
git push origin feature/ten-feature
# Tạo PR trên GitHub → develop
```

### 4. PR Checklist

- [ ] Title theo format: `feat/fix/docs: mô tả ngắn`
- [ ] Description có: What, Why, How
- [ ] Lint & build pass
- [ ] Tests pass
- [ ] Screenshots (nếu UI change)
- [ ] Reviewer assigned

### 5. Resolve Conflicts

```bash
git checkout develop
git pull origin develop
git checkout feature/ten-feature
git rebase develop
# Resolve conflicts → git add → git rebase --continue
```

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
