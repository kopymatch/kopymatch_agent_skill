---
name: video-animation-editor
description: "Chỉnh sửa video/animation cho web app — xoá nền, trim, crop, chuyển đổi định dạng — sử dụng ffmpeg"
metadata:
  author: kopymatch
  version: "1.0.0"
  license: "MIT"
---

# Video & Animation Editor

> Skill hướng dẫn agent chỉnh sửa video/animation để nhúng vào web app.

## Mục tiêu

Xử lý video/animation cho frontend: xoá background, trim đoạn thừa, crop watermark, chuyển đổi format, tối ưu kích thước.

## Khi nào dùng

- Khi cần "xoá nền video", "transparent video", "làm video trong suốt"
- Khi cần "trim video", "cắt đầu/cuối video", "crop video"
- Khi cần "chuyển mp4 sang webm", "optimise video for web"
- Khi cần xoá watermark (crop) khỏi video
- Khi cần chỉnh sửa mascot/animation trên trang web

## Yêu cầu

- **ffmpeg** phải được cài (`winget install Gyan.FFmpeg` trên Windows, `brew install ffmpeg` trên macOS)
- Kiểm tra bằng: `ffmpeg -version`

## Quy trình

### 1. Xoá nền video (Background Removal → Transparent WebM)

Dùng `colorkey` filter để chuyển màu nền thành trong suốt → output VP9+alpha WebM:

```bash
ffmpeg -i input.mp4 \
  -vf "colorkey=0x000000:similarity=0.25:blend=0.1" \
  -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 \
  -an output-alpha.webm
```

**Tuỳ chỉnh**:
- `0x000000` = màu nền cần xoá (hex). Dùng `0x000000` cho nền đen, `0x00FF00` cho green screen
- `similarity=0.25` = độ "rộng" của vùng màu bị xoá (0.01–1.0, cao hơn = xoá nhiều hơn)
- `blend=0.1` = độ mượt viền (0.0–1.0)

> **Lưu ý**: Chỉ WebM (VP9) hỗ trợ alpha channel trên web. MP4/H.264 KHÔNG hỗ trợ.

### 2. Trim video (Cắt đầu/cuối)

```bash
# Cắt bỏ 0.5 giây đầu (ví dụ: flash trắng)
ffmpeg -i input.webm -ss 0.5 -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 -an output-trimmed.webm

# Cắt giữ từ giây 1 đến giây 5
ffmpeg -i input.webm -ss 1 -to 5 -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 -an output-trimmed.webm
```

### 3. Crop video (Cắt vùng — xoá watermark)

```bash
# Crop bỏ 10% dưới cùng (xoá watermark)
ffmpeg -i input.webm \
  -vf "crop=iw:ih*0.9:0:0" \
  -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 \
  -an output-cropped.webm

# Crop chính xác: width:height:x:y
ffmpeg -i input.webm \
  -vf "crop=640:480:0:0" \
  -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 \
  -an output-cropped.webm
```

### 4. Kết hợp nhiều bước (Pipeline)

Ví dụ thực tế: xoá nền đen + trim 0.5s đầu + crop watermark dưới cùng:

```bash
ffmpeg -i original.mp4 \
  -ss 0.5 \
  -vf "colorkey=0x000000:similarity=0.25:blend=0.1,crop=iw:ih*0.88:0:0" \
  -c:v libvpx-vp9 -pix_fmt yuva420p -auto-alt-ref 0 \
  -an final-output.webm
```

### 5. Nhúng vào React/HTML

```jsx
{/* Container trong suốt, tỷ lệ vuông */}
<div className="relative aspect-square w-full overflow-hidden">
    <video
        src="/assets/video-alpha.webm"
        autoPlay muted loop playsInline
        preload="auto"
        aria-hidden="true"
        className="absolute inset-0 block h-full w-full object-contain"
    />
</div>
```

**Lưu ý khi nhúng**:
- Dùng `object-contain` (không phải `object-cover`) để giữ tỷ lệ gốc
- KHÔNG thêm `background`, `border`, `shadow` lên container nếu video có alpha
- KHÔNG thêm gradient overlay lên video transparent
- Dùng `aspect-square` hoặc `aspect-video` để cố định tỷ lệ container

## Kiểm tra kết quả

1. **Probe video**: `ffprobe -v quiet -print_format json -show_streams output.webm` → kiểm tra `pix_fmt: yuva420p` (có alpha)
2. **Xem trên browser**: Mở file WebM trong Chrome/Edge — nền phải trong suốt (hiển thị checkerboard pattern)
3. **Kiểm tra kích thước**: Video web nên < 5MB, lý tưởng < 2MB

## Gotchas & Troubleshooting

| Vấn đề | Nguyên nhân | Giải pháp |
|--------|-------------|-----------|
| Video vẫn có nền | `similarity` quá thấp | Tăng lên 0.3–0.5 |
| Viền video bị "glow" | `blend` quá cao | Giảm xuống 0.05 |
| CSS blend-mode không tốt | Phụ thuộc màu nền page | Dùng transparent WebM thay vì CSS trick |
| File quá lớn | Bitrate cao | Thêm `-b:v 1M` hoặc `-crf 30` |
| Nháy trắng đầu video | Frame đầu bị lỗi | Trim 0.3–0.5s đầu bằng `-ss` |
| Watermark còn sót | Crop chưa đủ | Tăng % crop hoặc dùng toạ độ chính xác |

## Nguồn gốc / License

- **Tác giả**: KopyMatch team
- **License**: MIT
- **Dựa trên kinh nghiệm thực tế**: mascot video transparent trên homepage KopyMatch
