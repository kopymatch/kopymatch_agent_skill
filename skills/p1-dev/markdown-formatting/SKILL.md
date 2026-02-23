---
name: markdown-formatting-vi
description: "Chuẩn hoá file Markdown — căn chỉnh bảng (tables), format headers, lists, và code blocks"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Markdown Formatting (Việt hoá)

## Mục tiêu

Đảm bảo tất cả các file Markdown (`.md`) trong repo (đặc biệt là tài liệu SOPs, SKILLs, README) luôn sạch sẽ, dễ đọc trên mọi kích thước màn hình và chuẩn format.

## Khi nào dùng

- ✅ Khi tạo mới một file tài liệu hoặc thư mục kỹ năng (skill).
- ✅ Khi cập nhật nội dung bảng (tables) khiến các cột bị lệch, vỡ layout.
- ✅ Khi review PR có chứa thay đổi về documentation.

## Các Quy Tắc Chuẩn Hoá

### 1. Bảng (Tables)

Bảng trong Markdown rất dễ bị vỡ hoặc khó đọc trên màn hình nhỏ nếu có quá nhiều cột hoặc nội dung quá dài.

- **Giới hạn số cột**: Tối đa 3-4 cột cho một bảng để đảm bảo hiển thị tốt trên laptop. Nếu có nhiều thông tin hơn, hãy cân nhắc sử dụng Component dạng danh sách (Lists) kết hợp in đậm.
- **Căn lề (Padding)**: Bắt buộc phải có khoảng trắng (space) giữa dấu ngoặc đứng `|` và nội dung.
  - Sai: `|Cột 1|Cột 2|`
  - Đúng: `| Cột 1 | Cột 2 |`
- **Ngắt dòng tự nhiên**: Tránh tạo các cột có nội dung quá dài (hàng trăm ký tự) trên cùng một hàng. Nếu quá dài, hãy tóm tắt nội dung và giải thích chi tiết ở bên dưới bảng.

### 2. Tiêu đề (Headers)

- Luôn dùng khoảng trắng sau dấu `#`.
  - Sai: `##Tiêu đề`
  - Đúng: `## Tiêu đề`
- Cấu trúc phân cấp rõ ràng (`#` -> `##` -> `###`). Không nhảy cóc từ `H1` xuống `H3`.

### 3. Lists (Danh sách)

- Dùng `-` cho danh sách không thứ tự (Unordered List) để có sự đồng nhất, thay vì dùng lẫn lộn `*` và `-`.
- Dùng `1.`, `2.` cho các bước quy trình bắt buộc phải theo thứ tự.

### 4. Code Blocks

- Luôn khai báo ngôn ngữ cho code blocks để render syntax highlight chính xác (VD: ` ```json`, ` ```ts`, ` ```bash`).
- Các câu lệnh console/terminal nên là `bash` hoặc `sh`.

## Công cụ hỗ trợ

Khuyến khích tích hợp Prettier vào dự án để tự động format file Markdown.

```json
// package.json script ví dụ
{
  "scripts": {
    "format:md": "prettier --write \"**/*.md\" --prose-wrap never"
  }
}
```

> **Lưu ý:** Tùy chọn `--prose-wrap never` giúp công cụ không tự động bẻ gãy (ngắt dòng) văn bản bên trong bảng hay đoạn văn, giữ nguyên cấu trúc mong muốn của tác giả.

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
