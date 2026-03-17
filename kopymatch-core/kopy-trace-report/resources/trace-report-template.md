# {{ report_title }}

**Report ID**: {{ report_id }}
**Ngày tạo**: {{ generated_at }}
**Loại**: {{ report_type }}

---

## Đối tượng (Subject)

| Trường       | Giá trị            |
| ------------ | ------------------ |
| Entity ID    | {{ entity_ref }}   |
| Tên hiển thị | {{ display_name }} |
| Loại         | {{ entity_type }}  |

---

## Những gì đã biết (What We Know)

{{ for fact in what_we_know }}
### {{ fact.fact_id }}

> {{ fact.statement }}

- **Confidence**: {{ fact.confidence }}
- **Nguồn**: {{ fact.sources }}

{{ end }}

---

## Những gì chưa biết (What We Don't Know)

{{ for unknown in what_we_dont_know }}
### ❓ {{ unknown.question }}

- **Đã thử**: {{ unknown.attempts }}
- **Ảnh hưởng**: {{ unknown.impact }}

{{ end }}

---

## Timeline

| Ngày | Sự kiện | Confidence | Nguồn |
| ---- | ------- | ---------- | ----- |
{{ for event in timeline_events }}
| {{ event.date }} | {{ event.description }} | {{ event.confidence }} | {{ event.source }} |
{{ end }}

---

## Kết luận

- **Mức độ rủi ro**: {{ risk_verdict }}
- **Tóm tắt**: {{ conclusion.summary }}

### Khuyến nghị

{{ for action in recommended_actions }}
- {{ action }}
{{ end }}

---

> ⚠️ **Disclaimer**: {{ conclusion.disclaimer }}

---

## Dẫn chứng (Citations)

{{ for cite in citations }}
- **{{ cite.citation_id }}** ({{ cite.type }}): {{ cite.description }}
{{ end }}
