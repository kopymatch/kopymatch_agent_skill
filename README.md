# KopyMatch Agent Skill Repo

> Bộ skill chuẩn cho AI agent (Antigravity + Codex) — phục vụ hệ thống anti-scam tài chính KopyMatch.

## 🎯 Mục tiêu

Repo này chứa **skill packs** cho AI coding agents, chia làm 3 nhóm:

| Nhóm | Thư mục | Mô tả |
| --- | --- | --- |
| **P0 — Core KopyMatch** | `skills/p0-core/` | 8 skill đặc thù cho KopyMatch (anti-scam, evidence, crawl, risk) |
| **P1 — Dev chung** | `skills/p1-dev/` | 10 skill dev đã Việt hoá (React, testing, security, workflow) |
| **Third-party (gốc)** | `third_party/` | Bản gốc upstream — KHÔNG chỉnh sửa, để đối chiếu |

## 🚀 Cách dùng

### Với Antigravity

```bash
# Tự động install
bash scripts/install-antigravity.sh /đường/dẫn/tới/project

# Hoặc thủ công
cp -r skills/p0-core/* /đường/dẫn/tới/project/.agent/skills/
cp -r skills/p1-dev/* /đường/dẫn/tới/project/.agent/skills/
```

Skill sẽ nằm tại `<project>/.agent/skills/` và Antigravity tự phát hiện.

### Với Codex

```bash
# Tự động install
bash scripts/install-codex.sh /đường/dẫn/tới/project

# Hoặc thủ công
cp -r skills/p0-core/* /đường/dẫn/tới/project/.agents/skills/
cp -r skills/p1-dev/* /đường/dẫn/tới/project/.agents/skills/
```

Skill sẽ nằm tại `<project>/.agents/skills/` và Codex tự phát hiện.

### Install cho cả hai

```bash
bash scripts/install-both.sh /đường/dẫn/tới/project
```

## 📋 Danh sách Skill

### P0 — Core KopyMatch (8 skill)

| Skill | Mô tả | Repo target |
| --- | --- | --- |
| `kopy-spec-sdd` | Đặc tả thiết kế hệ thống (SDD) | kopymatch |
| `kopy-evidence-pack-schema` | Schema Evidence Pack JSON | cả hai |
| `kopy-crawl-url-to-markdown` | Crawl URL → Markdown + metadata | crawler |
| `kopy-normalize-entity` | Chuẩn hoá entity (trader, sàn, nhóm) | cả hai |
| `kopy-risk-signal-extractor` | Trích xuất tín hiệu rủi ro | kopymatch |
| `kopy-trace-report` | Báo cáo truy vết tổng hợp | kopymatch |
| `kopy-marketplace-chat-evidence` | Bằng chứng chat marketplace | kopymatch |
| `kopy-finetune-dataset-kit` | Dataset kit cho fine-tune LlamaFactory | cả hai |

### P1 — Dev chung (10 skill)

| Skill | Mô tả | Nguồn |
| --- | --- | --- |
| `react-best-practices` | 57 rules tối ưu React/Next.js | Vercel (Việt hoá) |
| `composition-patterns` | Composition patterns, tránh boolean props | Vercel (Việt hoá) |
| `web-design-audit` | Audit UI/UX theo Web Interface Guidelines | Vercel (Việt hoá) |
| `nextjs-testing` | Testing guide: unit, integration, E2E | Nội bộ |
| `security-basics` | Checklist bảo mật web app | Nội bộ |
| `repo-hygiene` | Dọn dẹp repo: lint, format, commit, CI | Nội bộ |
| `api-doc-generator` | Tạo API doc (OpenAPI/Swagger) | Nội bộ |
| `deploy-preview` | Deploy preview trước production | Nội bộ |
| `git-workflow` | Git branching, PR, conflict resolution | Nội bộ |
| `code-review` | Code review checklist | Nội bộ |

## ✅ Validate

```bash
bash scripts/validate.sh
```

Kiểm tra tất cả skill có `SKILL.md` và YAML frontmatter hợp lệ.

## 📁 Cấu trúc Repo

```
kopymatch-agent-skill/
├── README.md              # File này
├── CATALOG.md             # Bảng catalog chi tiết
├── .gitignore
├── packs/                 # Pack manifests
│   ├── p0-core.md
│   └── upstream-install.md
├── skills/
│   ├── p0-core/           # 8 skill KopyMatch (VI)
│   └── p1-dev/            # 10 skill dev (VI)
├── third_party/           # Bản gốc (KHÔNG sửa)
│   ├── vercel-agent-skills/
│   ├── anthropics-skills/
│   └── openai-skills/
├── templates/
│   └── SKILL.vi.template.md
└── scripts/
    ├── install-antigravity.sh
    ├── install-codex.sh
    ├── install-both.sh
    └── validate.sh
```

## 📜 License

- **Skills P0/P1 nội bộ**: © KopyMatch team
- **Third-party skills**: Giữ nguyên license gốc (MIT) — xem `third_party/*/LICENSE`
