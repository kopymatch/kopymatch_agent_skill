## Mô tả

<!-- Tóm tắt thay đổi trong PR này. -->

## Issue liên quan

<!-- Link đến issue mà PR này giải quyết. -->

Closes #

## Thay đổi chính

<!-- Liệt kê các thay đổi chính, nhóm theo file hoặc component. -->

- ...

## Cách verify

<!-- Hướng dẫn để reviewer kiểm tra thay đổi hoạt động đúng. -->

1. ...
2. ...

```bash
# VD: Chạy doctor để kiểm tra
bash scripts/doctor.sh
```

## Ảnh hưởng compatibility

<!-- Thay đổi này có ảnh hưởng đến:
  - Schema JSON hiện tại?
  - Skill interface (input/output)?
  - Install script?
  - Dự án đã cài skills cũ?
Nếu không có ảnh hưởng breaking, ghi "Không có." -->

## Checklist tự review

- [ ] Đã đọc lại toàn bộ diff trước khi tạo PR
- [ ] SKILL.md có đúng YAML frontmatter (`name`, `description`)
- [ ] Nếu thêm/sửa resources: JSON valid, path đúng
- [ ] Nếu sửa script: đã test trên local
- [ ] Nếu sửa docs: format markdown sạch, link không bị hỏng
- [ ] `bash scripts/doctor.sh` pass (nếu áp dụng)
- [ ] Không chứa secret, PII, hoặc file lớn (>1MB)
