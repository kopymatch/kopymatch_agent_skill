---
name: composition-patterns-vi
description: "React Composition Patterns - tổ chức component scalable, tránh boolean props — Việt hoá từ Vercel"
metadata:
  author: kopymatch (Việt hoá từ vercel)
  version: "1.0.0"
  source: "https://github.com/vercel-labs/agent-skills/tree/main/skills/composition-patterns"
  license: "MIT"
---

# React Composition Patterns (Việt hoá)

> **Nguồn gốc**: Đã Việt hoá từ [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) — License MIT

## Mục tiêu

Patterns tổ chức component React linh hoạt, tránh "boolean prop hell", dễ bảo trì và mở rộng.

## Khi nào dùng

- Refactor component có quá nhiều boolean props
- Xây dựng component library dùng chung
- Thiết kế API component mới
- Review kiến trúc component

## Rules theo Ưu tiên

### 1. Kiến trúc Component (CAO)

- `architecture-avoid-boolean-props` — Không thêm boolean props để tuỳ biến hành vi → dùng composition
- `architecture-compound-components` — Tổ chức component phức tạp với shared context

### 2. Quản lý State (TRUNG BÌNH)

- `state-decouple-implementation` — Provider là nơi duy nhất biết state được quản lý thế nào
- `state-context-interface` — Định nghĩa interface generic: state, actions, meta
- `state-lift-state` — Đẩy state lên provider để siblings truy cập

### 3. Patterns (TRUNG BÌNH)

- `patterns-explicit-variants` — Tạo variant components thay vì boolean modes
- `patterns-children-over-render-props` — Dùng children thay vì renderX props

### 4. React 19 APIs (TRUNG BÌNH)

> ⚠️ Chỉ áp dụng cho React 19+

- `react19-no-forwardref` — Không dùng `forwardRef`; dùng `use()` thay `useContext()`

## Ví dụ

```tsx
// ❌ SAI: Boolean prop hell
<Card isCompact isHighlighted hasShadow isRounded />

// ✅ ĐÚNG: Composition
<Card variant="compact" />
<Card.Highlight>
  <Card.Content>...</Card.Content>
</Card.Highlight>
```

## Nguồn gốc/License

- **Nguồn**: [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
- **License**: MIT
- **Đã Việt hoá từ skill gốc**
