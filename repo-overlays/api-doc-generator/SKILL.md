---
name: api-doc-generator-vi
description: "Tạo API documentation tự động từ code — OpenAPI/Swagger cho API routes KopyMatch"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# API Documentation Generator (Việt hoá)

## Mục tiêu

Tạo API documentation chuẩn OpenAPI/Swagger cho các API routes trong project KopyMatch.

## Khi nào dùng

- ✅ Khi thêm API route mới
- ✅ Khi cần export API docs cho team/stakeholder
- ✅ Khi cần generate API client từ schema

## Quy trình

### 1. Annotate API Routes

```ts
// app/api/entities/route.ts
/**
 * @openapi
 * /api/entities:
 *   get:
 *     summary: Lấy danh sách entities
 *     parameters:
 *       - name: provider
 *         in: query
 *         schema: { type: string, enum: [binance, okx] }
 *     responses:
 *       200:
 *         description: Danh sách entities đã normalize
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items: { $ref: '#/components/schemas/NormalizedEntity' }
 */
export async function GET(req: Request) { ... }
```

### 2. Generate OpenAPI spec

```bash
npx swagger-jsdoc -d swaggerDef.js -o openapi.json
```

### 3. Serve Swagger UI (dev)

```bash
npx swagger-ui-express  # hoặc dùng next-swagger-doc
```

### 4. Schema Definitions

```yaml
components:
  schemas:
    NormalizedEntity:
      type: object
      required: [entity_id, entity_type, provider]
      properties:
        entity_id: { type: string }
        entity_type: { type: string, enum: [trader, exchange, signal_group] }
        provider: { type: string }
        display_name: { type: string }
        metrics: { $ref: "#/components/schemas/EntityMetrics" }
```

## Checklist

- [ ] Mọi API route có JSDoc annotation
- [ ] OpenAPI spec generate thành công
- [ ] Schema definitions đầy đủ
- [ ] Request/response examples có mặt

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
