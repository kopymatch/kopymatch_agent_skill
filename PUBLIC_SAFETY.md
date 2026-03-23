# PUBLIC_SAFETY.md — KopyMatch Agent Skill

> Chính sách bảo mật cho public repo. Mọi contributor (người và AI) phải tuân thủ.

---

## ❌ KHÔNG BAO GIỜ commit

- API keys, access tokens, passwords, SSH keys, certificates
- `.env` thật, connection strings, credentials
- Internal URLs có authentication (`https://admin:pass@...`)
- Customer data, PII (email thật, phone, tên khách hàng)
- Internal docs/tickets/chat logs nguyên văn
- Production incident reports có thông tin nhạy cảm
- Private architecture details chưa public (DB schema chi tiết, internal endpoints)

## ✅ CHỈ ĐƯỢC phép commit

- Patterns trừu tượng (VD: "Payment gateway cần idempotency key")
- Examples đã sanitize (fake data, placeholder values)
- Generic coding rules (VD: "Description field max 25 chars")
- Review checklists, workflow patterns, conventions
- Schemas với sample data giả

## 🔄 Redaction — Trước khi commit, thay thế:

| Tìm | Thay bằng |
|---|---|
| Email thật | `user@example.com` |
| Phone thật | `+84-xxx-xxx-xxxx` |
| Access tokens | `YOUR_ACCESS_TOKEN` |
| Internal hostnames | `internal.service.local` |
| Account IDs thật | `acct_SAMPLE_123` |
| Customer names | `Nguyễn Văn A` |
| API keys | `YOUR_API_KEY` |
| Real URLs có credential | `https://api.example.com` |

## 🛡️ Guardrails

1. **PR review gate** — Mọi thay đổi phải qua Pull Request review
2. **Self-check** — Trước khi commit: "Nội dung này có an toàn khi public không?"
3. **Pre-commit scan** — Khuyến nghị cài `gitleaks` để tự động detect secrets
4. **Template placeholders** — Luôn dùng `YOUR_*`, `SAMPLE_*`, `example.com`

## 📋 PR Checklist (copy vào mỗi PR)

```markdown
- [ ] Không chứa API keys, tokens, passwords, SSH keys
- [ ] Không chứa internal URLs có credentials
- [ ] Không chứa customer data hoặc PII
- [ ] Không chứa internal docs/tickets nguyên văn
- [ ] Examples sử dụng fake/sample data
- [ ] Placeholders: YOUR_*, SAMPLE_*, example.com
- [ ] Nội dung có giá trị reusable khi public
```

## ⚖️ Nguyên tắc

> **"Sanitize then preserve utility"** — Không block mọi thứ, mà làm sạch rồi giữ lại giá trị sử dụng.
