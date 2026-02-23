---
name: web-design-audit-vi
description: "Review UI/UX theo Web Interface Guidelines — kiểm tra accessibility, design, UX — Việt hoá từ Vercel"
metadata:
  author: kopymatch (Việt hoá từ vercel)
  version: "1.0.0"
  source: "https://github.com/vercel-labs/agent-skills/tree/main/skills/web-design-guidelines"
  license: "MIT"
---

# Web Design Audit (Việt hoá)

> **Nguồn gốc**: Đã Việt hoá từ [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — License MIT

## Mục tiêu

Review code UI theo Web Interface Guidelines — kiểm tra accessibility, responsive, design patterns.

## Khi nào dùng

- Khi cần "review UI", "check accessibility", "audit design"
- Review UX trước khi deploy
- Kiểm tra site theo best practices

## Quy trình

1. Fetch guidelines mới nhất từ source URL
2. Đọc các file cần review (hoặc hỏi user)
3. Kiểm tra theo tất cả rules
4. Output findings theo format `file:line`

## Nguồn Guidelines

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

## Cách dùng

- Agent tự fetch guidelines → đọc files → output findings
- Nếu không có file cụ thể, hỏi user cần review file nào

## Nguồn gốc/License

- **Nguồn**: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- **License**: MIT
- **Đã Việt hoá từ skill gốc**
