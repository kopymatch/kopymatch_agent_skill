---
name: kopy-spec-sdd
description: "Tạo tài liệu đặc tả kỹ thuật (SDD) cho hệ thống KopyMatch anti-scam tài chính"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "kopymatch"
---

# KopyMatch — Đặc tả Thiết kế Hệ thống (SDD)

## Mục tiêu

> Tạo tài liệu SDD (System Design Document) chuẩn cho hệ thống KopyMatch, bao gồm kiến trúc tổng thể, luồng dữ liệu, các module chính và tiêu chuẩn kỹ thuật.

## Khi nào dùng

- ✅ Khi bắt đầu một module mới hoặc refactor module hiện tại
- ✅ Khi cần trình bày kiến trúc cho stakeholder / nhà đầu tư
- ✅ Khi onboard thành viên mới vào team
- ❌ KHÔNG dùng khi chỉ fix bug nhỏ, không ảnh hưởng kiến trúc
- ❌ KHÔNG dùng thay thế cho PRD (Product Requirement Doc)

## Đầu vào (Input)

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| module_name | string | Có | Tên module cần đặc tả |
| scope | string | Có | Phạm vi: "full-system" hoặc tên module cụ thể |
| existing_docs | string[] | Không | Đường dẫn tới tài liệu hiện có |
| tech_stack | object | Không | Stack công nghệ đang dùng |

## Đầu ra (Output)

```json
{
  "sdd": {
    "title": "KopyMatch - Module Crawler SDD",
    "version": "1.0.0",
    "last_updated": "2025-01-15",
    "sections": {
      "overview": "Mô tả tổng quan module...",
      "architecture": {
        "diagram_type": "C4",
        "components": [
          {
            "name": "CrawlerEngine",
            "type": "service",
            "responsibilities": ["Thu thập dữ liệu từ sàn giao dịch"],
            "dependencies": ["Puppeteer", "Socket.IO"],
            "data_flow": "URL → Browser → NetworkCapture → Normalize → Store"
          }
        ]
      },
      "data_model": {
        "entities": [
          {
            "name": "CrawlJob",
            "fields": [
              {"name": "id", "type": "string", "description": "UUID duy nhất"},
              {"name": "url", "type": "string", "description": "URL nguồn cần crawl"},
              {"name": "status", "type": "enum", "values": ["pending", "running", "done", "failed"]}
            ]
          }
        ]
      },
      "api_contracts": [],
      "security_considerations": [
        "Không lưu thông tin đăng nhập người dùng",
        "Rate limiting cho mọi endpoint"
      ],
      "deployment": {
        "environment": "Docker + Node.js",
        "ci_cd": "GitHub Actions"
      }
    }
  }
}
```

## Quy trình

1. **Thu thập thông tin**: Đọc codebase hiện có, xác định module/scope cần đặc tả
2. **Phân tích kiến trúc**: Xác định components, dependencies, data flow
3. **Vẽ sơ đồ**: Tạo C4 diagram (Context → Container → Component)
4. **Viết data model**: Liệt kê entities, fields, relationships
5. **Định nghĩa API contracts**: Endpoint, request/response schema
6. **Security review**: Liệt kê các cân nhắc bảo mật
7. **Tạo output JSON**: Theo schema trên
8. **Review & validate**: Kiểm tra tính nhất quán với code thực tế

## Checklist

- [ ] Module/scope đã được xác định rõ
- [ ] Components và dependencies đã liệt kê đủ
- [ ] Data flow đã mô tả rõ ràng
- [ ] Data model khớp với code thực tế
- [ ] Security considerations đã review
- [ ] Output JSON hợp lệ
- [ ] Có dẫn chiếu tới file/code cụ thể

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách khắc phục |
|-----|-------------|----------------|
| SDD không khớp code | Viết SDD mà không đọc code | Luôn đọc codebase trước khi viết |
| Thiếu dependency | Bỏ sót package/service ẩn | Kiểm tra package.json, docker-compose |
| Data model outdated | Schema đã thay đổi | So sánh với migration files |
| Quá trừu tượng | Không đủ chi tiết kỹ thuật | Thêm code snippet minh hoạ |

## An toàn

- 🚫 **Anti-hallucination**: Không bịa kiến trúc. Mọi component phải tồn tại trong code.
- 📌 **Dẫn chứng bắt buộc**: Mỗi component phải trỏ được tới file/folder cụ thể.
- ⚠️ **Khi không chắc chắn**: Ghi rõ "CẦN XÁC MINH - chưa tìm thấy trong codebase".
