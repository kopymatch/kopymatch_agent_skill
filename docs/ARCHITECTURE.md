# Architecture — KopyMatch Agent Skills

## Tổng quan

Repo này cung cấp **skills** cho AI coding agents (Antigravity, Codex). Mỗi skill là một thư mục chứa hướng dẫn + tài nguyên mà agent đọc để thực hiện tác vụ cụ thể.

## Cấu trúc

```
kopymatch-agent-skill/
├── shared/              ← Tài nguyên dùng chung (schemas, taxonomies, templates)
├── kopymatch-core/      ← 8 skill đặc thù KopyMatch (domain-specific)
├── repo-overlays/       ← 11 skill dev chung (generic dev skills)
├── packs/               ← YAML manifests định nghĩa nhóm skills
├── scripts/             ← Install, doctor, sync, validate
├── third_party/         ← Bản gốc upstream (KHÔNG sửa)
└── docs/                ← Hướng dẫn contribute và kiến trúc
```

## Skill Structure

Mỗi skill gồm:

```
skill-name/
├── SKILL.md             ← Hướng dẫn chính (YAML frontmatter + markdown)
├── SKILL.en.md          ← (Optional) English version
├── resources/           ← JSON schemas, taxonomies, keyword lists
├── examples/            ← Sample inputs/outputs
└── scripts/             ← Helper scripts (Python, TypeScript)
```

## Luồng hoạt động

```
1. Agent nhận request từ user
2. Agent đọc SKILL.md để hiểu quy trình
3. Agent đọc resources/ để lấy schemas, taxonomies
4. Agent tham khảo examples/ để hiểu format output
5. Agent thực thi theo quy trình, sử dụng resources
6. Agent validate output theo schema
```

## Pack System

Packs là YAML manifests nhóm các skills lại:

- `kopymatch-core.yaml` — 8 skills core (có dependency graph)
- `repo-overlays.yaml` — 11 skills dev
- `full.yaml` — tất cả skills

Dùng `scripts/install.sh` với `--pack` để cài chọn lọc.

## Agent Compatibility

| Agent       | Skill Directory   | Install Command                                         |
| ----------- | ----------------- | ------------------------------------------------------- |
| Antigravity | `.agent/skills/`  | `bash scripts/install.sh <project> --agent antigravity` |
| Codex       | `.agents/skills/` | `bash scripts/install.sh <project> --agent codex`       |
| Both        | cả hai            | `bash scripts/install.sh <project> --agent both`        |
