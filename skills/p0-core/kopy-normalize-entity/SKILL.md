---
name: kopy-normalize-entity
description: "Chuẩn hoá entity (sàn giao dịch, trader, nhóm tín hiệu) từ dữ liệu thô thành schema thống nhất"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "cả hai"
---

# KopyMatch — Chuẩn hoá Entity

## Mục tiêu

> Chuẩn hoá các entity (sàn giao dịch, trader profile, nhóm tín hiệu, channel Telegram, website) từ nhiều nguồn dữ liệu thô thành một schema thống nhất, phục vụ matching, dedup, và phân tích rủi ro.

## Khi nào dùng

- ✅ Khi nhận dữ liệu crawl thô từ nhiều nguồn khác nhau
- ✅ Khi cần merge/dedup entity từ nhiều lần crawl
- ✅ Khi chuẩn bị dữ liệu cho matching engine
- ❌ KHÔNG dùng cho entity đã chuẩn hoá (kiểm tra `normalized: true`)
- ❌ KHÔNG dùng để phân tích rủi ro (dùng `kopy-risk-signal-extractor`)

## Đầu vào (Input)

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| raw_entity | object | Có | Entity thô từ crawl output |
| source_provider | string | Có | "binance", "okx", "telegram", "web", ... |
| entity_type | enum | Có | "exchange", "trader", "signal_group", "website", "person" |
| existing_entities | object[] | Không | Entities đã chuẩn hoá (để dedup) |

## Đầu ra (Output)

```json
{
  "normalized_entity": {
    "entity_id": "ent_trader_binance_abc123",
    "entity_type": "trader",
    "provider": "binance",
    "display_name": "CryptoMaster_VN",
    "normalized_name": "cryptomaster_vn",
    "identifiers": [
      {"type": "platform_uid", "value": "BNC-12345678"},
      {"type": "telegram", "value": "@cryptomaster_vn"},
      {"type": "website", "value": "https://cryptomaster-vn.com"}
    ],
    "attributes": {
      "followers_count": 15000,
      "roi_30d": 45.2,
      "roi_90d": 120.5,
      "max_drawdown": -22.3,
      "win_rate": 0.68,
      "total_trades": 342,
      "active_since": "2024-03-15",
      "verified": false,
      "description": "Copy trading expert - Cam kết lợi nhuận ổn định"
    },
    "metrics": {
      "consistency_score": 0.45,
      "risk_score": 0.78,
      "data_completeness": 0.85
    },
    "sources": [
      {
        "crawl_id": "crawl_20250115_001",
        "url": "https://binance.com/copy-trading/lead/abc123",
        "fetched_at": "2025-01-15T10:30:00Z"
      }
    ],
    "dedup": {
      "is_duplicate": false,
      "potential_matches": ["ent_trader_okx_xyz789"],
      "match_confidence": 0.72
    },
    "normalized_at": "2025-01-15T10:30:05Z"
  }
}
```

## Quy trình

1. **Parse raw entity**: Trích thông tin từ raw data theo provider-specific schema
2. **Normalize tên**: Lowercase, strip special chars, trim whitespace → `normalized_name`
3. **Extract identifiers**: Platform UID, social links, website, email
4. **Map attributes**: Chuyển metrics theo standard schema (ROI, drawdown, win_rate)
5. **Tính derived metrics**: consistency_score, risk_score, data_completeness
6. **Dedup check**: So sánh với entities hiện có qua normalized_name + identifiers
7. **Gán entity_id**: Format: `ent_{type}_{provider}_{hash}`
8. **Validate output**: Kiểm tra trường bắt buộc, kiểu dữ liệu

### Provider-specific Mappings

| Provider | ROI field | Followers field | UID field |
|----------|-----------|-----------------|-----------|
| Binance  | `roi` / `pnl` | `copierCount` | `leadPortfolioId` |
| OKX      | `yield` | `copyCount` | `uniqueName` |
| Telegram | — | `members_count` | `chat_id` |
| Web      | (từ text) | — | URL |

## Checklist

- [ ] `entity_id` unique và đúng format
- [ ] `normalized_name` đã lowercase, strip special chars
- [ ] `identifiers` liệt kê đủ (platform UID + social links)
- [ ] `attributes` có đủ metrics cần thiết
- [ ] `sources` trỏ đúng crawl_id
- [ ] Dedup check đã chạy (nếu có existing_entities)
- [ ] Output JSON valid

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách khắc phục |
|-----|-------------|----------------|
| Duplicate entity | Không chạy dedup | Luôn so sánh với existing_entities |
| Sai metric mapping | Field khác nhau giữa providers | Dùng bảng Provider-specific Mappings |
| Mất Unicode | Strip quá mạnh | Chỉ strip control chars, giữ Unicode |
| Entity ID trùng | Hash collision | Thêm timestamp vào hash input |

## An toàn

- 🚫 **Anti-hallucination**: Không bịa metrics. Nếu provider không có ROI, để `null`.
- 📌 **Dẫn chứng bắt buộc**: Mỗi attribute phải trỏ về `sources[].crawl_id`.
- ⚠️ **Khi không chắc chắn**: Ghi `"confidence": "low"` cho dedup matches < 0.8.
