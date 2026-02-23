# Catalog — KopyMatch Agent Skills

> Bảng tổng hợp tất cả skills có trong repo.

## P0 — Core KopyMatch

| Skill | Nhóm | Khi dùng | Input | Output | Repo target | Nguồn |
|-------|------|----------|-------|--------|-------------|-------|
| `kopy-spec-sdd` | Core | Đặc tả kiến trúc / onboard team | module_name, scope | SDD JSON (components, data_model, API) | kopymatch | P0 nội bộ |
| `kopy-evidence-pack-schema` | Core | Tạo/validate gói bằng chứng số | raw_data, source_type | Evidence Pack JSON (items[], metadata, integrity) | cả hai | P0 nội bộ |
| `kopy-crawl-url-to-markdown` | Crawl | Crawl URL nghi ngờ → markdown + metadata | url, crawl_depth | crawl_result JSON (markdown, links, screenshots, redirect_chain) | crawler | P0 nội bộ |
| `kopy-normalize-entity` | Data | Chuẩn hoá entity từ nhiều nguồn | raw_entity, provider, entity_type | normalized_entity JSON (identifiers, attributes, dedup) | cả hai | P0 nội bộ |
| `kopy-risk-signal-extractor` | Phân tích | Trích tín hiệu rủi ro từ evidence | evidence_pack / entity | risk_signals[] (type, severity, evidence_span, source_ref) | kopymatch | P0 nội bộ |
| `kopy-trace-report` | Báo cáo | Tổng hợp báo cáo truy vết | risk_analyses, evidence_packs | trace_report (what_we_know, unknown, citations, timeline, conclusion) | kopymatch | P0 nội bộ |
| `kopy-marketplace-chat-evidence` | Chat | Phân tích chat phát hiện vi phạm | chat_log, platform, consent | chat_analysis (terms, violations, phases, evidence_objects) | kopymatch | P0 nội bộ |
| `kopy-finetune-dataset-kit` | ML | Chuẩn bị dataset fine-tune LlamaFactory | task_type, raw_samples | dataset JSON (taxonomy, samples, LlamaFactory config) | cả hai | P0 nội bộ |

## P1 — Dev chung (Việt hoá)

| Skill | Nhóm | Khi dùng | Input | Output | Repo target | Nguồn |
|-------|------|----------|-------|--------|-------------|-------|
| `react-best-practices` | React | Viết/review React/Next.js code | Source files | Performance findings | cả hai | Upstream Việt hoá (Vercel) |
| `composition-patterns` | React | Refactor component architecture | Source files | Refactoring suggestions | cả hai | Upstream Việt hoá (Vercel) |
| `web-design-audit` | UI/UX | Audit UI theo best practices | URL/files | Findings (file:line format) | cả hai | Upstream Việt hoá (Vercel) |
| `nextjs-testing` | Testing | Viết test cho Next.js app | — | Test files (unit, e2e) | cả hai | Nội bộ |
| `security-basics` | Security | Kiểm tra bảo mật trước deploy | Source files | Security checklist results | cả hai | Nội bộ |
| `repo-hygiene` | DevOps | Setup/dọn repo | — | Config files, CI workflow | cả hai | Nội bộ |
| `api-doc-generator` | Docs | Tạo API documentation | API route files | OpenAPI spec JSON | cả hai | Nội bộ |
| `deploy-preview` | DevOps | Deploy preview trước production | Branch/PR | Preview URL | cả hai | Nội bộ |
| `git-workflow` | Git | Branching, PR, conflict | — | — | cả hai | Nội bộ |
| `code-review` | Quality | Review code hiệu quả | PR files | Review comments | cả hai | Nội bộ |
