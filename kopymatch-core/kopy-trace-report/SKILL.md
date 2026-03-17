---
name: kopy-trace-report
description: "Tạo báo cáo truy vết (trace report) tổng hợp từ risk signals, evidence packs, và entity data"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "kopymatch"
---

# KopyMatch — Báo cáo Truy vết (Trace Report)

## Mục tiêu

> Tổng hợp tất cả risk signals, evidence packs, và entity data thành một báo cáo truy vết có cấu trúc — gồm what_we_know/unknown, citations, timeline, và conclusion.

## Khi nào dùng

- ✅ Khi đã có ≥1 risk analysis từ `kopy-risk-signal-extractor`
- ✅ Khi cần tạo báo cáo tổng hợp cho người dùng/cơ quan chức năng
- ✅ Khi cần timeline sự kiện cho một vụ việc nghi ngờ scam
- ❌ KHÔNG dùng khi chưa có risk signals (chạy extractor trước)
- ❌ KHÔNG dùng để thay thế tư vấn pháp lý

## Đầu vào (Input)

| Tên            | Kiểu     | Bắt buộc | Mô tả                                     |
| -------------- | -------- | -------- | ----------------------------------------- |
| risk_analyses  | object[] | Có       | Danh sách risk analysis outputs           |
| evidence_packs | object[] | Có       | Evidence packs liên quan                  |
| entities       | object[] | Không    | Normalized entities liên quan             |
| report_type    | enum     | Không    | "summary" (mặc định), "detailed", "legal" |
| language       | string   | Không    | "vi" (mặc định)                           |

## Đầu ra (Output)

```json
{
  "trace_report": {
    "report_id": "rpt_20250115_abc123",
    "report_type": "detailed",
    "generated_at": "2025-01-15T11:00:00Z",
    "language": "vi",
    "subject": {
      "entity_ref": "ent_trader_binance_abc123",
      "display_name": "CryptoMaster_VN",
      "entity_type": "trader"
    },
    "sections": {
      "what_we_know": [
        {
          "fact_id": "fact_001",
          "statement": "Website example-scam-trading.com đăng ký ngày 01/01/2025 qua Namecheap",
          "confidence": "high",
          "sources": ["ep_20250115_abc123.metadata.domain_age_days"]
        },
        {
          "fact_id": "fact_002",
          "statement": "Website cam kết lợi nhuận 15-30% mỗi tuần (= 780-1560%/năm)",
          "confidence": "high",
          "sources": ["ep_20250115_abc123.item_002"]
        },
        {
          "fact_id": "fact_003",
          "statement": "Thanh toán yêu cầu nạp USDT trực tiếp vào ví cá nhân, không qua sàn",
          "confidence": "high",
          "sources": ["ep_20250115_abc123.item_002", "sig_004"]
        }
      ],
      "what_we_dont_know": [
        {
          "question": "Danh tính thật của người vận hành CryptoMaster_VN?",
          "attempts": "Không tìm thấy thông tin đăng ký kinh doanh hoặc CMND công khai",
          "impact": "Không thể xác minh tư cách pháp lý"
        },
        {
          "question": "Tổng số nạn nhân và thiệt hại tài chính?",
          "attempts": "Chưa thu thập testimonials từ nạn nhân",
          "impact": "Không thể đánh giá quy mô thiệt hại"
        }
      ]
    },
    "citations": [
      {
        "citation_id": "cite_001",
        "type": "evidence_pack",
        "ref": "ep_20250115_abc123",
        "description": "Evidence Pack thu thập từ website example-scam-trading.com lúc 10:30 ngày 15/01/2025"
      },
      {
        "citation_id": "cite_002",
        "type": "risk_analysis",
        "ref": "risk_20250115_001",
        "description": "Phân tích rủi ro: 4 signals detected (1 critical, 2 high, 1 medium)"
      }
    ],
    "timeline_events": [
      {
        "event_id": "evt_001",
        "date": "2025-01-01",
        "description": "Domain example-scam-trading.com được đăng ký",
        "source": "cite_001",
        "confidence": "high"
      },
      {
        "event_id": "evt_002",
        "date": "2025-01-10",
        "description": "Bắt đầu quảng cáo trên Telegram group",
        "source": "cite_001",
        "confidence": "medium"
      },
      {
        "event_id": "evt_003",
        "date": "2025-01-15",
        "description": "KopyMatch phát hiện và thu thập bằng chứng",
        "source": "cite_001",
        "confidence": "high"
      }
    ],
    "conclusion": {
      "risk_verdict": "high_risk",
      "summary": "Entity CryptoMaster_VN có nhiều dấu hiệu đặc trưng của scam tài chính: cam kết lợi nhuận phi thực tế, domain mới, thanh toán crypto không kiểm soát, kỹ thuật ép quyết định.",
      "recommended_actions": [
        "Cảnh báo người dùng về entity này",
        "Theo dõi thêm hoạt động của domain và Telegram group",
        "Lưu hồ sơ để phối hợp cơ quan chức năng nếu cần"
      ],
      "confidence_level": "medium-high",
      "disclaimer": "Báo cáo này dựa trên dữ liệu công khai thu thập được và phân tích tự động. Không thay thế tư vấn pháp lý chuyên nghiệp."
    }
  }
}
```

## Quy trình

1. **Thu thập inputs**: Gom tất cả risk analyses, evidence packs, entities liên quan
2. **Xây dựng what_we_know**: Liệt kê các sự thật có dẫn chứng, gán confidence
3. **Xây dựng what_we_dont_know**: Liệt kê câu hỏi chưa trả lời được, ghi attempts
4. **Tạo citations**: Tham chiếu tất cả nguồn dữ liệu
5. **Xây dựng timeline**: Sắp xếp sự kiện theo thời gian, với source
6. **Viết conclusion**: Tổng hợp risk verdict, summary, recommended actions
7. **Thêm disclaimer**: Luôn có disclaimer về giới hạn của báo cáo
8. **Review toàn bộ**: Kiểm tra tính nhất quán giữa các sections

## Checklist

- [ ] Mỗi fact trong `what_we_know` có `sources[]` không rỗng
- [ ] `what_we_dont_know` ghi rõ đã thử gì (`attempts`)
- [ ] `citations` liệt kê đủ mọi nguồn được sử dụng
- [ ] `timeline_events` sắp xếp đúng thứ tự thời gian
- [ ] `conclusion.risk_verdict` phù hợp với evidence
- [ ] `conclusion.disclaimer` luôn có mặt
- [ ] Không có claim nào trong report thiếu citation
- [ ] Output JSON valid

## Lỗi thường gặp

| Lỗi                 | Nguyên nhân                             | Cách khắc phục                               |
| ------------------- | --------------------------------------- | -------------------------------------------- |
| Conclusion quá mạnh | Thiếu evidence nhưng kết luận chắc chắn | Hạ confidence, thêm vào what_we_dont_know    |
| Thiếu citation      | Fact không trỏ về nguồn                 | Kiểm tra từng fact có sources[]              |
| Timeline thiếu      | Bỏ qua sự kiện quan trọng               | Đọc lại tất cả evidence packs                |
| Report thiên vị     | Chỉ liệt kê signals tiêu cực            | Thêm vào what_we_know cả thông tin trung lập |

## An toàn

- 🚫 **Anti-hallucination**: KHÔNG bịa fact hoặc timeline event. Mọi thứ PHẢI có source.
- 📌 **Dẫn chứng bắt buộc**: fact → sources[], event → source, conclusion → dựa trên facts.
- ⚠️ **Khi không chắc chắn**: Đưa vào `what_we_dont_know`, KHÔNG bỏ qua.
- ⚖️ **Cân bằng**: Ghi cả thông tin có lợi và bất lợi cho entity. Không thiên vị.
- 📜 **Disclaimer**: LUÔN có disclaimer. Report KHÔNG thay thế tư vấn pháp lý.

## Tài nguyên đi kèm

- **Report Template**: `resources/trace-report-template.md` — template markdown cho báo cáo
- **Ví dụ**: `examples/sample-trace-report.json` — mẫu output hoàn chỉnh
