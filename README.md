# KopyMatch Agent Skill Repo

> Bộ skill chuẩn cho AI agent (Antigravity + Codex) — phục vụ hệ thống anti-scam tài chính KopyMatch.

## 🎯 Mục tiêu

Repo này chứa **skill packs** cho AI coding agents, chia làm 3 nhóm:

| Nhóm                    | Thư mục           | Mô tả                                                            |
| ----------------------- | ----------------- | ---------------------------------------------------------------- |
| **KopyMatch Core**      | `kopymatch-core/` | 8 skill đặc thù cho KopyMatch (anti-scam, evidence, crawl, risk) |
| **Repo Overlays (Dev)** | `repo-overlays/`  | 11 skill dev đã Việt hoá (React, testing, security, workflow)    |
| **Third-party (gốc)**   | `third_party/`    | Bản gốc upstream — KHÔNG chỉnh sửa, để đối chiếu                 |

## 🚀 Cách dùng

### Antigravity

```bash
# Cài tất cả skills
bash scripts/install.sh /đường/dẫn/tới/project --agent antigravity

# Cài chỉ KopyMatch Core
bash scripts/install.sh /đường/dẫn/tới/project --pack kopymatch-core --agent antigravity
```

Skills sẽ nằm tại `<project>/.agent/skills/` — Antigravity tự phát hiện qua file `SKILL.md` trong mỗi thư mục con.

### Codex

```bash
bash scripts/install.sh /đường/dẫn/tới/project --agent codex
```

Skills sẽ nằm tại `<project>/.agents/skills/`.

### Claude Code

> [!NOTE]
> **Giả định**: Claude Code tính đến thời điểm viết (03/2026) đọc skill/instruction từ thư mục `.claude/` hoặc file `AGENTS.md` tại root project. Hướng dẫn dưới đây là **tối thiểu / giả định** — maintainer cần xác nhận lại khi Claude Code cập nhật tài liệu chính thức.

```bash
# Copy thủ công vào project
mkdir -p /đường/dẫn/tới/project/.claude/skills
cp -r kopymatch-core/* /đường/dẫn/tới/project/.claude/skills/
cp -r repo-overlays/* /đường/dẫn/tới/project/.claude/skills/
```

Nếu Claude Code dùng `AGENTS.md`, bạn có thể thêm đường dẫn tới các SKILL.md trong file đó.

### Cài cho nhiều agent cùng lúc

```bash
# Antigravity + Codex
bash scripts/install.sh /đường/dẫn/tới/project --agent both

# Ghi đè skills đã cài
bash scripts/install.sh /đường/dẫn/tới/project --force
```

### Packs

| Pack              | Skills | File                        | Mô tả                    |
| ----------------- | ------ | --------------------------- | ------------------------ |
| `kopymatch-core`  | 8      | `packs/kopymatch-core.yaml` | Skills đặc thù KopyMatch |
| `repo-overlays`   | 11     | `packs/repo-overlays.yaml`  | Skills dev chung         |
| `full` (mặc định) | 19     | `packs/full.yaml`           | Tất cả                   |

## 📋 Danh sách Skill

### KopyMatch Core (8 skill)

| Skill                            | Mô tả                                  | Resources |
| -------------------------------- | -------------------------------------- | --------- |
| `kopy-spec-sdd`                  | Đặc tả thiết kế hệ thống (SDD)         | ✅        |
| `kopy-evidence-pack-schema`      | Schema Evidence Pack JSON              | ✅        |
| `kopy-crawl-url-to-markdown`     | Crawl URL → Markdown + metadata        | ✅        |
| `kopy-normalize-entity`          | Chuẩn hoá entity (trader, sàn, nhóm)   | ✅        |
| `kopy-risk-signal-extractor`     | Trích xuất tín hiệu rủi ro             | ✅        |
| `kopy-trace-report`              | Báo cáo truy vết tổng hợp              | ✅        |
| `kopy-marketplace-chat-evidence` | Bằng chứng chat marketplace            | ✅        |
| `kopy-finetune-dataset-kit`      | Dataset kit cho fine-tune LlamaFactory | ✅        |

### Repo Overlays — Dev chung (11 skill)

| Skill                  | Mô tả                                     | Nguồn             |
| ---------------------- | ----------------------------------------- | ----------------- |
| `react-best-practices` | 57 rules tối ưu React/Next.js             | Vercel (Việt hoá) |
| `composition-patterns` | Composition patterns, tránh boolean props | Vercel (Việt hoá) |
| `web-design-audit`     | Audit UI/UX theo Web Interface Guidelines | Vercel (Việt hoá) |
| `nextjs-testing`       | Testing guide: unit, integration, E2E     | Nội bộ            |
| `security-basics`      | Checklist bảo mật web app                 | Nội bộ            |
| `repo-hygiene`         | Dọn dẹp repo: lint, format, commit, CI    | Nội bộ            |
| `api-doc-generator`    | Tạo API doc (OpenAPI/Swagger)             | Nội bộ            |
| `deploy-preview`       | Deploy preview trước production           | Nội bộ            |
| `git-workflow`         | Git branching, PR, conflict resolution    | Nội bộ            |
| `code-review`          | Code review checklist                     | Nội bộ            |
| `markdown-formatting`  | Chuẩn hoá & căn chỉnh file .md            | Nội bộ            |

## 🔧 Scripts

| Script        | Mô tả                                            |
| ------------- | ------------------------------------------------ |
| `install.sh`  | Unified installer (thay thế 3 scripts cũ)        |
| `doctor.sh`   | Health check — kiểm tra repo và installed skills |
| `sync.sh`     | Cập nhật third_party từ upstream repos           |
| `validate.sh` | Validate SKILL.md và YAML frontmatter            |

## ✅ Validate & Doctor

```bash
# Validate tất cả skills
bash scripts/validate.sh

# Health check toàn diện
bash scripts/doctor.sh

# Check installed skills
bash scripts/doctor.sh --installed /đường/dẫn/tới/project
```

## 📁 Cấu trúc Repo

```
kopymatch-agent-skill/
├── manifest.json              # Version tracking & skill registry
├── shared/                    # Tài nguyên dùng chung
│   ├── schemas/               # JSON schemas (evidence-pack, entity, risk, report)
│   ├── taxonomies/            # Enum/taxonomy data (signal types, violations, providers)
│   └── templates/             # SKILL.md templates (VI + EN)
├── kopymatch-core/            # 8 skill KopyMatch (mỗi skill có resources/ + examples/)
├── repo-overlays/             # 11 skill dev (VI)
├── packs/                     # YAML pack manifests
├── scripts/                   # install, doctor, sync, validate
├── third_party/               # Bản gốc upstream (KHÔNG sửa)
└── docs/                      # CONTRIBUTING.md, ARCHITECTURE.md
```

## 🤝 Đóng góp

- Xem [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) để biết cách tạo skill mới.
- Xem [docs/ISSUE_WORKFLOW.md](docs/ISSUE_WORKFLOW.md) để biết quy trình tạo issue và PR.
- Khi tạo issue, vui lòng chọn đúng template (Bug / Feature / Task).
- PR cần link issue và có checklist tự review.

> 📝 Hiện tại tài liệu và template đều bằng **tiếng Việt**. Khi contributor ngoài team tăng, có thể chuyển sang song ngữ.

## 📜 License

- **Skills KopyMatch Core & Overlays nội bộ**: © KopyMatch team
- **Third-party skills**: Giữ nguyên license gốc (MIT) — xem `third_party/*/LICENSE`
