---
name: kopy-risk-signal-extractor
description: "Trích xuất tín hiệu rủi ro (risk signals) từ dữ liệu crawl/evidence để phát hiện scam tài chính"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "kopymatch"
---

# KopyMatch — Trích xuất Tín hiệu Rủi ro

## Mục tiêu

> Phân tích dữ liệu từ Evidence Pack hoặc normalized entity để trích xuất các tín hiệu rủi ro (risk signals) — từng signal gồm type, severity, evidence span, và source reference.

## Khi nào dùng

- ✅ Khi đã có Evidence Pack hoặc normalized entity cần phân tích
- ✅ Khi cần đánh giá nhanh mức độ rủi ro của một entity/website
- ✅ Khi xây dựng hồ sơ rủi ro tổng hợp
- ❌ KHÔNG dùng khi chưa có dữ liệu (crawl trước bằng `kopy-crawl-url-to-markdown`)
- ❌ KHÔNG dùng để ra kết luận cuối cùng (dùng `kopy-trace-report`)

## Đầu vào (Input)

| Tên               | Kiểu     | Bắt buộc | Mô tả                                                    |
| ----------------- | -------- | -------- | -------------------------------------------------------- |
| evidence_pack     | object   | Có\*     | Evidence Pack JSON (hoặc)                                |
| normalized_entity | object   | Có\*     | Entity đã chuẩn hoá                                      |
| analysis_depth    | enum     | Không    | "quick" (5 phút), "standard" (15 phút), "deep" (30 phút) |
| focus_areas       | string[] | Không    | ["roi_claims", "social_proof", "payment", "legal"]       |

\*Cần ít nhất 1 trong 2

## Đầu ra (Output)

```json
{
  "risk_analysis": {
    "entity_ref": "ent_trader_binance_abc123",
    "analyzed_at": "2025-01-15T10:35:00Z",
    "overall_risk_level": "high",
    "overall_risk_score": 0.85,
    "risk_signals": [
      {
        "signal_id": "sig_001",
        "type": "unrealistic_return_promise",
        "severity": "critical",
        "confidence": 0.95,
        "evidence_span": "Cam kết lợi nhuận 15-30% mỗi tuần, không rủi ro",
        "source_ref": {
          "evidence_pack_id": "ep_20250115_abc123",
          "item_id": "item_002",
          "location": "content line 15"
        },
        "explanation": "Lợi nhuận 15-30%/tuần = 780-1560%/năm, vượt xa mọi benchmark hợp pháp",
        "category": "financial_fraud_indicator"
      },
      {
        "signal_id": "sig_002",
        "type": "pressure_tactics",
        "severity": "high",
        "confidence": 0.88,
        "evidence_span": "Chỉ còn 5 slot VIP, đăng ký ngay hôm nay",
        "source_ref": {
          "evidence_pack_id": "ep_20250115_abc123",
          "item_id": "item_002",
          "location": "content line 28"
        },
        "explanation": "Kỹ thuật tạo khan hiếm giả (false scarcity) để ép nạn nhân quyết định nhanh",
        "category": "social_engineering"
      },
      {
        "signal_id": "sig_003",
        "type": "new_domain",
        "severity": "medium",
        "confidence": 0.99,
        "evidence_span": "domain_age_days: 15",
        "source_ref": {
          "evidence_pack_id": "ep_20250115_abc123",
          "item_id": null,
          "location": "metadata.domain_age_days"
        },
        "explanation": "Domain mới đăng ký 15 ngày — scam sites thường dùng domain mới để tránh bị report",
        "category": "infrastructure_indicator"
      },
      {
        "signal_id": "sig_004",
        "type": "unregulated_payment",
        "severity": "high",
        "confidence": 0.92,
        "evidence_span": "Nạp tối thiểu 500 USDT qua địa chỉ ví: 0x...",
        "source_ref": {
          "evidence_pack_id": "ep_20250115_abc123",
          "item_id": "item_002",
          "location": "content line 35"
        },
        "explanation": "Thanh toán trực tiếp qua crypto wallet, không qua sàn chính thống — khó truy vết",
        "category": "financial_fraud_indicator"
      }
    ],
    "summary": {
      "total_signals": 4,
      "by_severity": { "critical": 1, "high": 2, "medium": 1, "low": 0 },
      "by_category": {
        "financial_fraud_indicator": 2,
        "social_engineering": 1,
        "infrastructure_indicator": 1
      },
      "top_risk": "Cam kết lợi nhuận phi thực tế kết hợp thanh toán crypto không qua sàn"
    }
  }
}
```

## Phân loại Risk Signal Types

| Type                         | Severity mặc định | Mô tả                                                 |
| ---------------------------- | ----------------- | ----------------------------------------------------- |
| `unrealistic_return_promise` | critical          | Cam kết lợi nhuận phi thực tế (>100%/năm)             |
| `guaranteed_no_risk`         | critical          | Cam kết "không rủi ro" — vi phạm nguyên tắc tài chính |
| `pressure_tactics`           | high              | Tạo khan hiếm giả, ép quyết định nhanh                |
| `unregulated_payment`        | high              | Thanh toán qua kênh không kiểm soát                   |
| `fake_testimonials`          | high              | Đánh giá/chứng nhận giả                               |
| `new_domain`                 | medium            | Domain mới (<30 ngày)                                 |
| `hidden_identity`            | medium            | Không công khai danh tính người vận hành              |
| `platform_migration`         | medium            | Chuyển nền tảng liên tục (YT→Telegram→Web)            |
| `copy_paste_content`         | low               | Nội dung copy từ site khác                            |
| `missing_legal`              | medium            | Thiếu điều khoản, chính sách bảo mật                  |
| `suspicious_social_proof`    | medium            | Followers/likes tăng bất thường                       |

## Quy trình

1. **Load dữ liệu**: Đọc Evidence Pack hoặc normalized entity
2. **Text analysis**: Quét content tìm từ khoá rủi ro (cam kết, lợi nhuận, VIP, nạp tiền...)
3. **Pattern matching**: So sánh với danh sách signal types ở trên
4. **Context analysis**: Đánh giá severity dựa trên context (số tiền, thời gian, đối tượng)
5. **Metadata analysis**: Kiểm tra domain age, SSL, social proof
6. **Cross-reference**: So sánh với database entities đã biết (nếu có)
7. **Tạo risk_signals[]**: Mỗi signal có đủ trường bắt buộc
8. **Tính overall score**: Trung bình có trọng số (critical=1.0, high=0.7, medium=0.4, low=0.1)
9. **Tạo summary**: Tổng hợp by_severity, by_category, top_risk

## Checklist

- [ ] Mỗi signal có `signal_id` unique
- [ ] Mỗi signal có `evidence_span` (đoạn text cụ thể)
- [ ] Mỗi signal có `source_ref` trỏ đúng evidence pack/item
- [ ] Severity phù hợp với type (xem bảng trên)
- [ ] `confidence` trong khoảng 0.0 - 1.0
- [ ] Summary tổng hợp chính xác
- [ ] Không có signal nào bị bịa (phải có evidence)

## Lỗi thường gặp

| Lỗi                    | Nguyên nhân                     | Cách khắc phục                                       |
| ---------------------- | ------------------------------- | ---------------------------------------------------- |
| False positive         | Từ khoá xuất hiện ngoài context | Kiểm tra context xung quanh, không chỉ match keyword |
| Thiếu evidence_span    | Chỉ ghi type mà không trích dẫn | Luôn copy đoạn text gốc                              |
| Severity không phù hợp | Không dùng bảng phân loại       | Tham chiếu bảng Signal Types                         |
| Missing signal         | Không quét hết content          | Đảm bảo quét toàn bộ items trong Evidence Pack       |

## An toàn

- 🚫 **Anti-hallucination**: TUYỆT ĐỐI không bịa risk signal. Mọi signal PHẢI có evidence_span từ dữ liệu thực.
- 📌 **Dẫn chứng bắt buộc**: Mỗi signal → 1 source_ref → trỏ đúng evidence item.
- ⚠️ **Khi không chắc chắn**: Ghi `"confidence": 0.5` hoặc thấp hơn, KHÔNG tăng confidence để "đẹp report".
- 🔒 **Không kết luận**: Skill này chỉ TRÍCH XUẤT signals, KHÔNG ra kết luận "đây là scam". Kết luận thuộc về `kopy-trace-report`.

## Tài nguyên đi kèm

- **Signal Taxonomy**: `resources/signal-taxonomy.json` — phân loại signal types, severity mặc định, keywords
- **Risk Keywords (VI)**: `resources/risk-keywords-vi.json` — danh sách từ khoá rủi ro tiếng Việt
- **Ví dụ**: `examples/sample-analysis.json` — mẫu output hoàn chỉnh
