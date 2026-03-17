# Contributing to KopyMatch Agent Skills

## Cách tạo skill mới

### 1. Chọn nhóm

- **kopymatch-core/**: Skill đặc thù cho hệ thống KopyMatch (anti-scam, evidence, crawl, risk)
- **repo-overlays/**: Skill dev chung (React, testing, security, workflow)

### 2. Tạo thư mục

```bash
mkdir -p kopymatch-core/ten-skill-moi/{resources,examples}
```

### 3. Tạo SKILL.md

Sử dụng template:

- Tiếng Việt: `shared/templates/SKILL.vi.template.md`
- Tiếng Anh: `shared/templates/SKILL.en.template.md`

**Bắt buộc có:**

- YAML frontmatter (`name`, `description`)
- Sections: Mục tiêu, Khi nào dùng, Đầu vào, Đầu ra, Quy trình, Checklist, An toàn
- Section "Tài nguyên đi kèm" trỏ tới `resources/` và `examples/`

### 4. Tạo resources

- JSON Schema cho output → `resources/*.schema.json`
- Taxonomy/enum data → `resources/*.json`
- Helper scripts → `scripts/*.py` hoặc `scripts/*.ts`

### 5. Tạo examples

- Mẫu output hoàn chỉnh → `examples/sample-*.json`
- Mẫu input (nếu có) → `examples/sample-*-input.json`

### 6. Đăng ký vào pack

Thêm vào file YAML tương ứng trong `packs/`:

- `packs/kopymatch-core.yaml` cho P0 skills
- `packs/repo-overlays.yaml` cho P1 skills

### 7. Validate

```bash
bash scripts/doctor.sh
```

## Quy tắc

- **Không sửa** files trong `third_party/` — đây là bản gốc upstream
- **Anti-hallucination**: Mọi skill PHẢI có section "An toàn"
- **Self-contained**: Skill không được phụ thuộc path ngoài thư mục của nó
- **Bilingual**: Khuyến khích có cả `SKILL.md` (VI) và `SKILL.en.md` (EN)
