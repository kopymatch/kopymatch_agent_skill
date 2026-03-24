# Catalog — KopyMatch Agent Skills

> Bảng tổng hợp skills có trong repo.

## P0 — Core KopyMatch (Domain-Specific)

| Skill                            | Chức năng                         |
| -------------------------------- | --------------------------------- |
| `kopy-spec-sdd`                  | Đặc tả kiến trúc (SDD)           |
| `kopy-evidence-pack-schema`      | Tạo/validate gói bằng chứng số   |
| `kopy-crawl-url-to-markdown`     | Crawl URL → Markdown + metadata  |
| `kopy-normalize-entity`          | Chuẩn hoá entity từ nhiều nguồn  |
| `kopy-risk-signal-extractor`     | Trích xuất tín hiệu rủi ro       |
| `kopy-trace-report`              | Tổng hợp báo cáo truy vết        |
| `kopy-marketplace-chat-evidence` | Phân tích chat phát hiện vi phạm  |
| `kopy-finetune-dataset-kit`      | Chuẩn bị dataset fine-tune       |

> Xem chi tiết Input/Output trong từng file `SKILL.md` tại `kopymatch-core/<tên>/`

## Archived — P1 Dev Skills

> Các skill dev chung (react, testing, markdown, git, v.v.) đã bị loại bỏ vì
> AI agent đã có sẵn kiến thức này. Chỉ giữ lại P0 — những skill domain-specific
> mà agent không thể tự biết.
>
> Nếu cần tham khảo, xem `third_party/` cho upstream skills từ Vercel, Anthropic, OpenAI.
