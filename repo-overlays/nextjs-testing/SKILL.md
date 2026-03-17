---
name: nextjs-testing-vi
description: "Hướng dẫn testing Next.js app — unit, integration, e2e — cho team KopyMatch"
metadata:
  author: kopymatch
  version: "1.0.0"
---

# Next.js Testing Guide (Việt hoá)

## Mục tiêu

Hướng dẫn viết test cho Next.js app — unit test, integration test, E2E — phù hợp cho cả kopymatch và crawler.

## Khi nào dùng

- ✅ Viết test cho component/API route mới
- ✅ Refactor và cần đảm bảo không break
- ✅ Review test PR
- ❌ KHÔNG dùng cho script one-off

## Các loại Test

### 1. Unit Test (Vitest / Jest)

```bash
npm install -D vitest @testing-library/react @testing-library/jest-dom
```

```tsx
// __tests__/utils/normalize.test.ts
import { normalizeEntity } from "@/utils/normalize";

describe("normalizeEntity", () => {
  it("should lowercase display name", () => {
    const result = normalizeEntity({ displayName: "CryptoMaster_VN" });
    expect(result.normalized_name).toBe("cryptomaster_vn");
  });

  it("should handle empty input gracefully", () => {
    expect(() => normalizeEntity({})).toThrow("displayName is required");
  });
});
```

### 2. Component Test (Testing Library)

```tsx
// __tests__/components/RiskBadge.test.tsx
import { render, screen } from "@testing-library/react";
import { RiskBadge } from "@/components/RiskBadge";

describe("RiskBadge", () => {
  it("renders critical severity in red", () => {
    render(<RiskBadge severity="critical" />);
    expect(screen.getByText("critical")).toHaveClass("text-red-500");
  });
});
```

### 3. API Route Test

```tsx
// __tests__/api/evidence.test.ts
import { POST } from "@/app/api/evidence/route";

describe("POST /api/evidence", () => {
  it("should validate evidence pack schema", async () => {
    const req = new Request("http://localhost/api/evidence", {
      method: "POST",
      body: JSON.stringify({ invalid: true }),
    });
    const res = await POST(req);
    expect(res.status).toBe(400);
  });
});
```

### 4. E2E Test (Playwright)

```bash
npx playwright install
```

```ts
// e2e/dashboard.spec.ts
import { test, expect } from "@playwright/test";

test("dashboard hiển thị entity list", async ({ page }) => {
  await page.goto("/dashboard");
  await expect(page.getByRole("heading", { name: "Entities" })).toBeVisible();
});
```

## Checklist Test

- [ ] Mọi utility function có unit test
- [ ] Component quan trọng có component test
- [ ] API routes có test validate input/output
- [ ] Happy path + error path đều được test
- [ ] Test chạy trong CI (GitHub Actions)

## Nguồn gốc/License

- **Tạo bởi**: KopyMatch team
- **Tham khảo**: Next.js docs, Vercel testing guides
