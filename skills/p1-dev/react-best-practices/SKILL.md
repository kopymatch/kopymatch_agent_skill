---
name: react-best-practices-vi
description: "Hướng dẫn tối ưu hiệu suất React/Next.js — Việt hoá từ Vercel Engineering"
metadata:
  author: kopymatch (Việt hoá từ vercel)
  version: "1.0.0"
  source: "https://github.com/vercel-labs/agent-skills/tree/main/skills/react-best-practices"
  license: "MIT"
---

# React & Next.js Best Practices (Việt hoá)

> **Nguồn gốc**: Đã Việt hoá từ skill gốc [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — License MIT

## Mục tiêu

Hướng dẫn tối ưu hiệu suất cho ứng dụng React/Next.js, 57 rules chia 8 nhóm ưu tiên.

## Khi nào dùng

- Viết component React mới hoặc refactor
- Code review cho performance
- Tối ưu bundle size, load time
- Implement data fetching (client/server)

## Nhóm Rules theo Ưu tiên

| Ưu tiên | Nhóm                      | Mức ảnh hưởng     |
| ------- | ------------------------- | ----------------- |
| 1       | Loại bỏ Waterfalls        | CỰC CAO           |
| 2       | Tối ưu Bundle Size        | CỰC CAO           |
| 3       | Server-Side Performance   | CAO               |
| 4       | Client-Side Data Fetching | TRUNG BÌNH - CAO  |
| 5       | Tối ưu Re-render          | TRUNG BÌNH        |
| 6       | Rendering Performance     | TRUNG BÌNH        |
| 7       | JavaScript Performance    | THẤP - TRUNG BÌNH |
| 8       | Advanced Patterns         | THẤP              |

## Quick Reference

### 1. Loại bỏ Waterfalls (CỰC CAO)

- `async-defer-await` — Di chuyển await vào branch thực sự cần
- `async-parallel` — Dùng `Promise.all()` cho operations độc lập
- `async-suspense-boundaries` — Dùng Suspense để stream content

### 2. Tối ưu Bundle Size (CỰC CAO)

- `bundle-barrel-imports` — Import trực tiếp, tránh barrel files
- `bundle-dynamic-imports` — Dùng `next/dynamic` cho component nặng
- `bundle-defer-third-party` — Load analytics/logging sau hydration

### 3. Server-Side Performance (CAO)

- `server-cache-react` — Dùng `React.cache()` để dedup per-request
- `server-parallel-fetching` — Tái cấu trúc component để fetch song song
- `server-serialization` — Giảm thiểu data truyền sang client component

### 4. Client-Side (TRUNG BÌNH-CAO)

- `client-swr-dedup` — Dùng SWR để dedup request tự động
- `client-passive-event-listeners` — Dùng passive listeners cho scroll

### 5. Re-render (TRUNG BÌNH)

- `rerender-memo` — Tách expensive work vào memoized component
- `rerender-derived-state` — Subscribe derived boolean, không raw value
- `rerender-transitions` — Dùng `startTransition` cho non-urgent updates

## Cách dùng

Đọc chi tiết rules trong thư mục `rules/` của bản gốc:

```
third_party/vercel-agent-skills/react-best-practices/rules/
```

## Nguồn gốc/License

- **Nguồn**: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- **License**: MIT
- **Đã Việt hoá từ skill gốc**
