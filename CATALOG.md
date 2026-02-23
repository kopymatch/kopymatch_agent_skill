# Catalog — KopyMatch Agent Skills

> Bảng tổng hợp tất cả skills có trong repo.

## P0 — Core KopyMatch

| Skill                              | Chức năng                              |
| ---------------------------------- | -------------------------------------- |
| `kopy-spec-sdd`                    | Đặc tả kiến trúc (SDD)                |
| `kopy-evidence-pack-schema`        | Tạo/validate gói bằng chứng số        |
| `kopy-crawl-url-to-markdown`       | Crawl URL → Markdown + metadata       |
| `kopy-normalize-entity`            | Chuẩn hoá entity từ nhiều nguồn       |
| `kopy-risk-signal-extractor`       | Trích xuất tín hiệu rủi ro            |
| `kopy-trace-report`                | Tổng hợp báo cáo truy vết             |
| `kopy-marketplace-chat-evidence`   | Phân tích chat phát hiện vi phạm       |
| `kopy-finetune-dataset-kit`        | Chuẩn bị dataset fine-tune LlamaFactory|

> Xem chi tiết Input/Output trong từng file `SKILL.md` tại `skills/p0-core/<tên>/`

## P1 — Dev chung (Việt hoá)

| Skill                    | Chức năng                        | Nguồn  |
| ------------------------ | -------------------------------- | ------ |
| `react-best-practices`   | Tối ưu React/Next.js             | Vercel |
| `composition-patterns`   | Refactor component architecture  | Vercel |
| `web-design-audit`       | Audit UI/UX theo chuẩn quốc tế   | Vercel |
| `nextjs-testing`         | Unit, Integration, E2E testing   | Nội bộ |
| `security-basics`        | Checklist bảo mật web app        | Nội bộ |
| `repo-hygiene`           | Lint, format, conventional commit| Nội bộ |
| `api-doc-generator`      | Tạo API doc (OpenAPI/Swagger)    | Nội bộ |
| `deploy-preview`         | Deploy preview (Vercel/Docker)   | Nội bộ |
| `git-workflow`           | Branching, PR, conflict          | Nội bộ |
| `code-review`            | Checklist review code & PR       | Nội bộ |
| `markdown-formatting`    | Chuẩn hoá & căn chỉnh file .md  | Nội bộ |

> Xem chi tiết trong từng file `SKILL.md` tại `skills/p1-dev/<tên>/`
