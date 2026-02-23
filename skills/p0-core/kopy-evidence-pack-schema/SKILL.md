---
name: kopy-evidence-pack-schema
description: "Định nghĩa schema Evidence Pack JSON cho hệ thống thu thập bằng chứng scam tài chính KopyMatch"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "cả hai"
---

# KopyMatch — Evidence Pack Schema

## Mục tiêu

> Định nghĩa cấu trúc chuẩn hoá (JSON schema) cho "Evidence Pack" — gói bằng chứng số gồm ảnh chụp, link, file ghi âm, đoạn text trích xuất, metadata — dùng làm đầu vào cho các skill phân tích và báo cáo.

## Khi nào dùng

- ✅ Khi cần tạo hoặc validate một Evidence Pack từ dữ liệu crawl
- ✅ Khi cần chuẩn hoá bằng chứng trước khi đưa vào pipeline phân tích
- ✅ Khi build API nhận/trả Evidence Pack
- ❌ KHÔNG dùng để phân tích (dùng `kopy-risk-signal-extractor` cho phân tích)
- ❌ KHÔNG dùng cho dữ liệu đã qua xử lý (đã là report)

## Đầu vào (Input)

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| raw_data | object/string | Có | Dữ liệu thô từ nguồn (crawl output, upload, API) |
| source_type | enum | Có | Loại nguồn: "url", "image", "voice", "text", "chat_log" |
| source_url | string | Không | URL gốc (nếu có) |
| collector_id | string | Không | ID người/bot thu thập |

## Đầu ra (Output)

### Evidence Pack Object

```json
{
  "evidence_pack": {
    "id": "ep_20250115_abc123",
    "version": "1.0.0",
    "created_at": "2025-01-15T10:30:00Z",
    "collector": {
      "type": "bot",
      "id": "crawler-v2",
      "session_id": "sess_xyz"
    },
    "source": {
      "type": "url",
      "original_url": "https://example-scam-site.com/signal-group",
      "final_url": "https://example-scam-site.com/signal-group?ref=abc",
      "redirect_chain": [
        "https://short.link/abc",
        "https://example-scam-site.com/signal-group?ref=abc"
      ],
      "captured_at": "2025-01-15T10:29:55Z"
    },
    "items": [
      {
        "item_id": "item_001",
        "type": "screenshot",
        "format": "image/png",
        "storage_ref": "s3://evidence/ep_20250115_abc123/screenshot_001.png",
        "hash_sha256": "a1b2c3d4...",
        "description": "Trang chủ hiển thị lợi nhuận 300%/tháng",
        "captured_at": "2025-01-15T10:29:56Z",
        "dimensions": {"width": 1920, "height": 1080}
      },
      {
        "item_id": "item_002",
        "type": "text_extract",
        "format": "text/plain",
        "content": "Cam kết lợi nhuận 15-30% mỗi tuần, không rủi ro. Nạp tối thiểu 500 USDT.",
        "source_selector": "div.promo-banner",
        "language": "vi",
        "captured_at": "2025-01-15T10:29:57Z"
      },
      {
        "item_id": "item_003",
        "type": "link",
        "url": "https://t.me/scam_signal_group",
        "anchor_text": "Tham gia nhóm VIP",
        "context": "Link Telegram trong phần CTA chính",
        "captured_at": "2025-01-15T10:29:58Z"
      },
      {
        "item_id": "item_004",
        "type": "voice_recording",
        "format": "audio/mp3",
        "storage_ref": "s3://evidence/ep_20250115_abc123/call_001.mp3",
        "hash_sha256": "e5f6g7h8...",
        "duration_seconds": 125,
        "transcript": "...bạn chỉ cần nạp 1000 đô, tôi cam kết trong 2 tuần sẽ gấp đôi...",
        "language": "vi",
        "captured_at": "2025-01-14T15:00:00Z"
      }
    ],
    "metadata": {
      "tags": ["copy-trading", "telegram", "high-yield-promise"],
      "entity_refs": ["entity_scam_site_001"],
      "risk_level_preliminary": "high",
      "notes": "Site quảng cáo lợi nhuận phi thực tế, có dấu hiệu Ponzi"
    },
    "integrity": {
      "total_items": 4,
      "hash_manifest": "sha256:xyz...",
      "signed_by": null
    }
  }
}
```

### Item Types

| Type | Format hỗ trợ | Mô tả |
|------|---------------|-------|
| `screenshot` | image/png, image/jpeg, image/webp | Ảnh chụp màn hình |
| `text_extract` | text/plain, text/html | Đoạn text trích xuất |
| `link` | — | URL thu thập được |
| `voice_recording` | audio/mp3, audio/wav, audio/ogg | Ghi âm cuộc gọi/voice |
| `document` | application/pdf, text/plain | Tài liệu đính kèm |
| `chat_message` | text/plain | Tin nhắn chat đơn lẻ |
| `chat_log` | application/json | Lịch sử chat (nhiều tin nhắn) |
| `video` | video/mp4, video/webm | Video bằng chứng |

## Quy trình

1. **Xác định nguồn**: Loại nguồn dữ liệu (url, image, voice, text, chat)
2. **Thu thập raw data**: Crawl/upload/nhận qua API
3. **Tạo item objects**: Với mỗi mẩu bằng chứng, tạo item theo đúng type
4. **Gán metadata**: Tags, entity refs, preliminary risk level
5. **Tính hash**: SHA-256 cho mỗi file, hash manifest cho cả pack
6. **Tạo Evidence Pack JSON**: Theo schema trên
7. **Validate**: Kiểm tra JSON schema, đảm bảo không thiếu trường bắt buộc

## Checklist

- [ ] Evidence Pack có đủ `id`, `version`, `created_at`
- [ ] Mọi item có `item_id`, `type`, `captured_at`
- [ ] File items có `hash_sha256`
- [ ] `source` có `original_url` (nếu là web)
- [ ] `metadata.tags` không rỗng
- [ ] JSON output valid (parse được)
- [ ] Không chứa dữ liệu cá nhân nhạy cảm (PII) trừ khi cần thiết cho bằng chứng

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách khắc phục |
|-----|-------------|----------------|
| Thiếu hash | Quên tính hash cho file | Luôn tính SHA-256 trước khi tạo pack |
| Sai type | Gán nhãn sai loại item | So sánh với bảng Item Types ở trên |
| Thiếu redirect_chain | Chỉ lưu final URL | Bật redirect tracking khi crawl |
| JSON invalid | Trailing comma, thiếu quote | Validate bằng JSON.parse() trước khi lưu |
| Duplicate item_id | Copy-paste item | Dùng UUID hoặc auto-increment |

## An toàn

- 🚫 **Anti-hallucination**: Không bịa nội dung bằng chứng. Mọi `content` và `transcript` phải từ nguồn thực.
- 📌 **Dẫn chứng bắt buộc**: Mỗi item phải có `captured_at` và trỏ về `source`.
- ⚠️ **Khi không chắc chắn**: Ghi `"confidence": "low"` trong metadata, không bỏ qua item.
- 🔒 **Bảo mật**: Không embed PII (CMND, STK ngân hàng) trực tiếp; dùng `storage_ref` trỏ tới storage mã hoá.
