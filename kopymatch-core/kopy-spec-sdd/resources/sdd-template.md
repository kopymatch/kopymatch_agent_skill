# {{ module_name }} — System Design Document (SDD)

**Version**: {{ version }}
**Last Updated**: {{ date }}
**Author**: {{ author }}

---

## 1. Overview

> Mô tả tổng quan module và vai trò trong hệ thống KopyMatch.

{{ overview_text }}

## 2. Architecture

### 2.1 Context Diagram (C4 Level 1)

```
[User/Bot] → [KopyMatch System] → [External APIs]
```

### 2.2 Components

| Component | Type    | Responsibilities             | Dependencies |
| --------- | ------- | ---------------------------- | ------------ |
| {{ name }} | {{ type }} | {{ responsibilities }} | {{ deps }}   |

### 2.3 Data Flow

```
{{ data_flow_description }}
```

## 3. Data Model

### Entities

| Entity | Fields                        | Description |
| ------ | ----------------------------- | ----------- |
| {{ entity_name }} | {{ fields }} | {{ desc }}  |

## 4. API Contracts

### {{ endpoint_name }}

- **Method**: {{ method }}
- **Path**: {{ path }}
- **Request**: {{ request_schema }}
- **Response**: {{ response_schema }}

## 5. Security Considerations

- {{ security_item_1 }}
- {{ security_item_2 }}

## 6. Deployment

| Aspect      | Detail       |
| ----------- | ------------ |
| Environment | {{ env }}    |
| CI/CD       | {{ ci_cd }}  |
| Monitoring  | {{ monitor }} |

---

> ⚠️ Tài liệu này được tạo bởi skill `kopy-spec-sdd`. Mọi component phải trỏ được tới file/folder cụ thể trong codebase.
