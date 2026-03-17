# Quy trình Issue & PR — KopyMatch Agent Skills

> Hướng dẫn khi nào tạo loại issue nào, cần cung cấp thông tin gì, và khi nào issue đủ rõ để xử lý.

## Khi nào tạo Bug?

Chọn template **🐛 Báo lỗi** khi:

- Skill cho output sai so với schema/ví dụ trong `examples/`
- Script (`install.sh`, `doctor.sh`, `validate.sh`, `sync.sh`) chạy lỗi hoặc cho kết quả sai
- JSON Schema / taxonomy trong `shared/` hoặc `resources/` có lỗi format hoặc sai nội dung
- Agent đọc SKILL.md nhưng không thể thực hiện đúng vì hướng dẫn mâu thuẫn hoặc thiếu thông tin
- Đường dẫn (`resources/`, `examples/`) trong SKILL.md bị hỏng hoặc trỏ sai file

**Thông tin tối thiểu cần cung cấp:**

1. Tên skill / file bị ảnh hưởng
2. Môi trường (Antigravity / Codex / Claude Code / local)
3. Cách tái hiện (càng cụ thể càng tốt)
4. Output mong đợi vs output thực tế
5. Mức độ ảnh hưởng
6. Tiêu chí hoàn thành

## Khi nào tạo Feature Request?

Chọn template **💡 Đề xuất tính năng** khi:

- Muốn thêm provider mới (VD: Bybit, BitGet) vào skill normalize
- Muốn thêm signal type mới vào taxonomy
- Muốn thêm skill mới vào `kopymatch-core/` hoặc `repo-overlays/`
- Muốn cải thiện script (VD: thêm flag, thêm output format)
- Muốn thêm resource hoặc example cho skill hiện có

**Thông tin tối thiểu cần cung cấp:**

1. Vấn đề hiện tại (tại sao cần thay đổi?)
2. Use case cụ thể
3. Đề xuất thay đổi
4. Tiêu chí hoàn thành

## Khi nào tạo Task?

Chọn template **📝 Task** khi:

- Cập nhật tài liệu (README, CONTRIBUTING, ARCHITECTURE, SKILL.md)
- Sửa typo, format, hoặc căn chỉnh bảng
- Dọn dẹp file thừa, cập nhật `.gitignore`
- Refactor nhỏ không ảnh hưởng interface (VD: đổi tên biến trong script)
- Tổ chức lại thư mục con bên trong skill

## Khi nào issue đủ rõ để xử lý?

Một issue được coi là _sẵn sàng_ (ready for work) khi:

| Tiêu chí                           | Bug | Feature | Task |
| ---------------------------------- | --- | ------- | ---- |
| Có mô tả rõ ràng vấn đề / mục tiêu | ✅  | ✅      | ✅   |
| Có file / skill liên quan          | ✅  | ✅      | ✅   |
| Có cách tái hiện                   | ✅  | —       | —    |
| Có scope rõ ràng                   | —   | ✅      | ✅   |
| Có tiêu chí hoàn thành             | ✅  | ✅      | ✅   |

> **Mẹo cho người tạo issue**: Viết issue như thể bạn đang giao việc cho một AI agent — càng cấu trúc và cụ thể thì agent hoặc maintainer càng dễ xử lý.

## Quy trình tổng quan

```
1. Người tạo chọn đúng template → điền đầy đủ thông tin
2. Maintainer review issue → gán label nếu cần → confirm "ready"
3. Contributor (người hoặc agent) tạo branch → thực hiện → tạo PR link issue
4. PR được review → merge → issue tự đóng
```

## Ghi chú

- Hiện tại issue và template đều bằng **tiếng Việt**. Khi số contributor ngoài team tăng, có thể chuyển sang song ngữ (VI/EN).
- Blank issue bị tắt — vui lòng luôn chọn template phù hợp.
- Nếu không chắc chọn template nào, chọn **📝 Task** là an toàn nhất.
