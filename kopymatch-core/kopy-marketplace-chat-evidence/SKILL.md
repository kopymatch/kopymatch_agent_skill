---
name: kopy-marketplace-chat-evidence
description: "Trích xuất bằng chứng từ lịch sử chat marketplace (Telegram, Zalo, Facebook) — phát hiện vi phạm ép giá, chuyển nền tảng"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "kopymatch"
---

# KopyMatch — Bằng chứng Chat Marketplace

## Mục tiêu

> Phân tích lịch sử chat (Telegram, Zalo, Facebook Messenger, web chat) để trích xuất điều khoản giao dịch, phát hiện vi phạm (ép giá, chuyển nền tảng, đe doạ), và tạo evidence objects chuẩn hoá.

## Khi nào dùng

- ✅ Khi có lịch sử chat giữa nạn nhân và đối tượng nghi ngờ scam
- ✅ Khi cần phân loại các chiêu trò trong conversation (ép giá, tạo trust, chuyển nền tảng)
- ✅ Khi cần tạo evidence cho trace report từ chat data
- ❌ KHÔNG dùng cho chat công khai (dùng `kopy-crawl-url-to-markdown`)
- ❌ KHÔNG dùng khi không có sự đồng ý của nạn nhân chia sẻ chat

## Đầu vào (Input)

| Tên               | Kiểu     | Bắt buộc | Mô tả                                                |
| ----------------- | -------- | -------- | ---------------------------------------------------- |
| chat_log          | object[] | Có       | Mảng tin nhắn, mỗi tin có sender, timestamp, content |
| platform          | enum     | Có       | "telegram", "zalo", "facebook", "web_chat", "other"  |
| reporter_id       | string   | Có       | ID người báo cáo (nạn nhân)                          |
| subject_id        | string   | Không    | ID đối tượng bị báo cáo                              |
| consent_confirmed | boolean  | Có       | Xác nhận đã có đồng ý chia sẻ chat                   |

### Chat Log Format

```json
[
  {
    "msg_id": "msg_001",
    "sender": "subject",
    "sender_name": "Admin VIP Trading",
    "timestamp": "2025-01-10T09:00:00Z",
    "content": "Chào bạn, bạn đã sẵn sàng tham gia nhóm VIP chưa?",
    "type": "text"
  },
  {
    "msg_id": "msg_002",
    "sender": "reporter",
    "sender_name": "Nạn nhân",
    "timestamp": "2025-01-10T09:05:00Z",
    "content": "Tôi muốn tìm hiểu thêm trước",
    "type": "text"
  },
  {
    "msg_id": "msg_003",
    "sender": "subject",
    "sender_name": "Admin VIP Trading",
    "timestamp": "2025-01-10T09:06:00Z",
    "content": "Hôm nay là ngày cuối ưu đãi, chỉ 500 USDT thay vì 2000 USDT. Nạp ngay ví này: TRC20:TXyz...",
    "type": "text",
    "attachments": []
  }
]
```

## Đầu ra (Output)

```json
{
  "chat_analysis": {
    "analysis_id": "chat_20250115_abc",
    "platform": "telegram",
    "total_messages": 45,
    "time_range": {
      "first_message": "2025-01-10T09:00:00Z",
      "last_message": "2025-01-14T22:30:00Z"
    },
    "extracted_terms": [
      {
        "term_id": "term_001",
        "type": "financial_commitment",
        "description": "Yêu cầu nạp 500 USDT vào ví TRC20",
        "amount": { "value": 500, "currency": "USDT" },
        "evidence_msgs": ["msg_003"],
        "timestamp": "2025-01-10T09:06:00Z"
      },
      {
        "term_id": "term_002",
        "type": "return_promise",
        "description": "Cam kết gấp đôi trong 2 tuần",
        "claimed_return": "200% trong 14 ngày",
        "evidence_msgs": ["msg_010"],
        "timestamp": "2025-01-11T14:00:00Z"
      }
    ],
    "violations": [
      {
        "violation_id": "vio_001",
        "type": "pressure_pricing",
        "severity": "high",
        "description": "Ép giá bằng cách tạo khan hiếm giả: 'hôm nay ngày cuối ưu đãi'",
        "evidence_msgs": ["msg_003"],
        "pattern": "false_urgency",
        "explanation": "Kỹ thuật ép giá cổ điển: giảm giá có thời hạn giả để ép quyết định nhanh"
      },
      {
        "violation_id": "vio_002",
        "type": "platform_migration",
        "severity": "high",
        "description": "Yêu cầu chuyển sang nền tảng khác: 'Chat riêng qua Telegram nhé, Facebook không tiện'",
        "evidence_msgs": ["msg_015"],
        "pattern": "platform_shifting",
        "explanation": "Chuyển sang nền tảng ít kiểm soát hơn để tránh bị report/trace"
      },
      {
        "violation_id": "vio_003",
        "type": "identity_concealment",
        "severity": "medium",
        "description": "Từ chối cung cấp thông tin cá nhân: 'Tôi chỉ liên hệ qua Telegram thôi'",
        "evidence_msgs": ["msg_022"],
        "pattern": "anonymity_maintenance",
        "explanation": "Giấu danh tính thật để tránh trách nhiệm pháp lý"
      }
    ],
    "conversation_phases": [
      {
        "phase": "approach",
        "msgs": ["msg_001", "msg_002"],
        "description": "Tiếp cận, tạo thiện cảm"
      },
      {
        "phase": "trust_building",
        "msgs": ["msg_005", "msg_008"],
        "description": "Chia sẻ 'thành công', ảnh lợi nhuận"
      },
      {
        "phase": "pressure",
        "msgs": ["msg_003", "msg_010"],
        "description": "Ép giá, tạo khan hiếm"
      },
      {
        "phase": "onboarding",
        "msgs": ["msg_012", "msg_015"],
        "description": "Chuyển nền tảng, yêu cầu nạp tiền"
      }
    ],
    "evidence_objects": [
      {
        "item_id": "chat_ev_001",
        "type": "chat_log",
        "format": "application/json",
        "content_summary": "45 tin nhắn giữa nạn nhân và Admin VIP Trading qua Telegram, 5 ngày",
        "key_messages": ["msg_003", "msg_010", "msg_015", "msg_022"],
        "violations_count": 3,
        "captured_at": "2025-01-15T11:00:00Z"
      }
    ]
  }
}
```

## Phân loại Violation Types

| Type                   | Mô tả                                         | Pattern                          |
| ---------------------- | --------------------------------------------- | -------------------------------- |
| `pressure_pricing`     | Ép giá bằng khan hiếm/thời hạn giả            | `false_urgency`, `limited_slots` |
| `platform_migration`   | Chuyển sang nền tảng ít kiểm soát             | `platform_shifting`              |
| `identity_concealment` | Giấu danh tính, không chịu cung cấp thông tin | `anonymity_maintenance`          |
| `threat`               | Đe doạ khi nạn nhân muốn rút tiền             | `withdrawal_threat`              |
| `gaslighting`          | Đổ lỗi nạn nhân khi thua lỗ                   | `victim_blaming`                 |
| `false_authority`      | Giả danh chuyên gia, cơ quan                  | `impersonation`                  |
| `isolation`            | Khuyên nạn nhân không nói với ai              | `social_isolation`               |

## Quy trình

1. **Validate consent**: Kiểm tra `consent_confirmed === true`; nếu false → DỪNG
2. **Parse chat log**: Đọc và validate format tin nhắn
3. **Identify participants**: Phân biệt reporter vs subject
4. **Phase detection**: Phân loại conversation thành phases (approach → trust → pressure → onboard)
5. **Extract terms**: Trích xuất điều khoản tài chính (số tiền, lời hứa, deadline)
6. **Detect violations**: So sánh patterns với bảng Violation Types
7. **Create evidence objects**: Đóng gói theo Evidence Pack schema
8. **Tạo output JSON**: Theo schema trên

## Checklist

- [ ] `consent_confirmed` = true (BẮT BUỘC)
- [ ] Mỗi violation có `evidence_msgs[]` trỏ đúng msg_id
- [ ] Mỗi term có `evidence_msgs[]`
- [ ] Conversation phases hợp lý theo timeline
- [ ] Evidence objects đúng schema
- [ ] Không leak PII không cần thiết (ẩn SĐT, CMND nếu có)

## Lỗi thường gặp

| Lỗi                      | Nguyên nhân              | Cách khắc phục                           |
| ------------------------ | ------------------------ | ---------------------------------------- |
| False positive violation | Ngữ cảnh bị hiểu sai     | Đọc context ≥3 tin nhắn xung quanh       |
| Thiếu consent            | Quên check consent       | Luôn kiểm tra consent_confirmed đầu tiên |
| Sai phase                | Phân loại nhầm giai đoạn | So sánh timeline với violation patterns  |
| PII leak                 | Chat chứa CMND/STK       | Mask PII trước khi tạo evidence objects  |

## An toàn

- 🚫 **Anti-hallucination**: KHÔNG bịa tin nhắn. Chỉ trích xuất từ chat_log thực.
- 📌 **Dẫn chứng bắt buộc**: Mỗi violation → `evidence_msgs[]` → msg_id cụ thể.
- ⚠️ **Consent**: PHẢI có `consent_confirmed = true`. Không phân tích chat khi chưa có đồng ý.
- 🔒 **PII**: Mask/ẩn SĐT, CMND, email cá nhân trong evidence objects trừ khi cần thiết cho case.
- ⚖️ **Cân bằng**: Ghi cả tin nhắn trung lập/có lợi cho subject, không chỉ tiêu cực.

## Tài nguyên đi kèm

- **Violation Patterns**: `resources/violation-patterns.json` — phân loại vi phạm, patterns, keywords
- **Ví dụ Input**: `examples/sample-chat-log.json` — mẫu chat log đầu vào
- **Ví dụ Output**: `examples/sample-analysis.json` — mẫu kết quả phân tích
