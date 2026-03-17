---
name: code-review-vi
description: "Hướng dẫn code review — checklist, patterns, anti-patterns cho team KopyMatch"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Code Review Guide (Việt hoá)

## Mục tiêu

Hướng dẫn code review hiệu quả — checklist cho reviewer, patterns cần chú ý, feedback constructive.

## Khi nào dùng

- ✅ Khi review PR của team member
- ✅ Khi self-review trước khi tạo PR
- ✅ Khi AI agent review code

## Checklist Review

### 1. Correctness (Đúng logic)

- [ ] Logic xử lý đúng requirement
- [ ] Edge cases được handle (null, empty, max)
- [ ] Error handling đầy đủ (try/catch, validation)
- [ ] Types đúng (TypeScript strict)

### 2. Security

- [ ] Không hardcode secrets
- [ ] Input được validate
- [ ] SQL/NoSQL injection safe
- [ ] XSS safe (no dangerouslySetInnerHTML)

### 3. Performance

- [ ] Không có N+1 queries
- [ ] Không có unnecessary re-renders
- [ ] Large lists dùng virtualization
- [ ] Images optimized (next/image)

### 4. Readability

- [ ] Tên biến/hàm rõ ràng
- [ ] Không có magic numbers
- [ ] Comments cho logic phức tạp
- [ ] Consistent formatting

### 5. KopyMatch-specific

- [ ] Evidence data có hash integrity
- [ ] PII được mask/encrypt
- [ ] Rate limiting cho crawl operations
- [ ] Anti-hallucination checks cho AI outputs

## Feedback Template

```
✅ LGTM — [mô tả ngắn]
⚠️ NIT — [suggestion, không blocking]
❌ BLOCK — [issue cần fix trước khi merge]
❓ QUESTION — [cần clarify]
```

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
