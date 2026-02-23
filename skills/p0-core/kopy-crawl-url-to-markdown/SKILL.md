---
name: kopy-crawl-url-to-markdown
description: "Quy trình crawl URL thành markdown sạch kèm metadata, redirect chain, và xuất theo Evidence Pack"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "kopymatch-bot-crawler"
---

# KopyMatch — Crawl URL → Markdown

## Mục tiêu

> Crawl một URL, trích xuất nội dung thành markdown sạch, thu thập metadata (title, description, OG tags, redirect chain), và đóng gói kết quả theo chuẩn Evidence Pack.

## Khi nào dùng

- ✅ Khi cần thu thập nội dung từ URL nghi ngờ scam
- ✅ Khi cần archive trang web trước khi nó bị xoá
- ✅ Khi cần chuyển nội dung web sang dạng phân tích được
- ❌ KHÔNG dùng cho URL đã crawl trong 24h (kiểm tra cache trước)
- ❌ KHÔNG dùng cho URL yêu cầu login (dùng kopy-marketplace-chat-evidence)

## Đầu vào (Input)

| Tên | Kiểu | Bắt buộc | Mô tả |
| --- | --- | --- | --- |
| url | string | Có | URL cần crawl |
| crawl_depth | number | Không | Số tầng link con (mặc định: 0 = chỉ trang hiện tại) |
| capture_screenshot | boolean | Không | Có chụp ảnh màn hình không (mặc định: true) |
| timeout_ms | number | Không | Timeout (mặc định: 30000ms) |
| user_agent | string | Không | Custom user agent |

## Đầu ra (Output)

```json
{
  "crawl_result": {
    "url": "https://example-scam-trading.com/vip-signal",
    "final_url": "https://example-scam-trading.com/vip-signal?utm=abc",
    "redirect_chain": [
      { "url": "https://bit.ly/scam123", "status": 301 },
      {
        "url": "https://example-scam-trading.com/vip-signal?utm=abc",
        "status": 200
      }
    ],
    "metadata": {
      "title": "VIP Trading Signal - Lợi nhuận 300%",
      "description": "Tham gia nhóm VIP trading signal...",
      "og_image": "https://example-scam-trading.com/og-banner.jpg",
      "og_type": "website",
      "language": "vi",
      "charset": "utf-8",
      "server": "cloudflare",
      "ssl_valid": true,
      "domain_age_days": 15,
      "whois_registrar": "namecheap"
    },
    "content_markdown": "# VIP Trading Signal\n\n## Cam kết lợi nhuận\n\nChúng tôi cam kết **lợi nhuận 15-30% mỗi tuần**...\n\n## Tham gia ngay\n\n- Gói Bronze: 500 USDT\n- Gói Silver: 2000 USDT\n- Gói Gold: 5000 USDT\n\n> Liên hệ Telegram: @scam_admin",
    "extracted_links": [
      {
        "href": "https://t.me/scam_signal_group",
        "text": "Tham gia nhóm",
        "context": "CTA button"
      },
      {
        "href": "https://scam-payment.com/deposit",
        "text": "Nạp tiền ngay",
        "context": "Payment section"
      }
    ],
    "screenshots": [
      {
        "type": "full_page",
        "storage_ref": "local://output/screenshots/example-scam-trading_full.png",
        "hash_sha256": "abc123..."
      }
    ],
    "crawled_at": "2025-01-15T10:30:00Z",
    "crawl_duration_ms": 4500,
    "evidence_pack_ref": "ep_20250115_abc123"
  }
}
```

## Quy trình

1. **Validate URL**: Kiểm tra URL hợp lệ, không nằm trong blocklist
2. **Khởi tạo browser**: Dùng Puppeteer/Playwright headless (gợi ý: crawl4ai nếu có)
3. **Bật redirect tracking**: Ghi lại toàn bộ redirect chain (301, 302, meta refresh)
4. **Navigate & chờ load**: Mở URL, chờ `networkidle` hoặc `domcontentloaded`
5. **Thu thập metadata**: Title, meta tags, OG tags, charset, server headers
6. **Trích xuất nội dung**: HTML → Markdown (loại bỏ script, style, ads)
7. **Thu thập links**: Tất cả `<a>` tags với context xung quanh
8. **Chụp screenshot**: Full page + above-the-fold
9. **Tính hash**: SHA-256 cho screenshots và content
10. **Đóng gói Evidence Pack**: Theo schema `kopy-evidence-pack-schema`
11. **Lưu kết quả**: Local storage hoặc S3

## Công cụ gợi ý

| Công cụ    | Mục đích           | Ghi chú                      |
| ---------- | ------------------ | ---------------------------- |
| crawl4ai   | Crawl thông minh   | Tùy chọn, không bắt buộc cài |
| Puppeteer  | Browser automation | Đã có trong crawler bot      |
| Playwright | Thay thế Puppeteer | Nếu cần cross-browser        |
| Turndown   | HTML → Markdown    | Lightweight                  |
| cheerio    | Parse HTML         | Khi không cần JS render      |

## Checklist

- [ ] URL đã validate (format hợp lệ, không trong blocklist)
- [ ] Redirect chain đã ghi đầy đủ
- [ ] Metadata thu thập (title, description, OG)
- [ ] Content markdown sạch (không script/style/ads)
- [ ] Links đã trích xuất với context
- [ ] Screenshot đã chụp và hash
- [ ] Evidence Pack output hợp lệ JSON
- [ ] Tuân thủ rate limiting (không spam requests)

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách khắc phục |
| --- | --- | --- |
| Timeout | Trang load chậm/block bot | Tăng timeout, dùng proxy |
| Content rỗng | SPA chưa render JS | Dùng Puppeteer thay cheerio |
| Redirect loop | Circular redirects | Set max redirects = 10, abort nếu vượt |
| Encoding lỗi | Charset không đúng | Detect charset từ headers, fallback UTF-8 |
| Bị block | Anti-bot protection | Rotate user agent, dùng residential proxy |

## An toàn

- 🚫 **Anti-hallucination**: Không bịa nội dung markdown. Chỉ trích xuất từ HTML thực tế.
- 📌 **Dẫn chứng bắt buộc**: Mỗi crawl result phải có `crawled_at`, `url`, `final_url`.
- ⚠️ **Khi không chắc chắn**: Nếu content có thể là dynamic (JS-rendered), ghi note `"render_mode": "js_required"`.
- 🔒 **Rate limiting**: Tối đa 1 request/giây cho cùng domain. Tuân thủ robots.txt.
- ⚖️ **Pháp lý**: Chỉ crawl dữ liệu công khai. Không bypass auth.
