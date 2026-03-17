---
name: kopy-finetune-dataset-kit
description: "Cấu trúc dataset và taxonomy nhãn cho fine-tune classifier/extractor/reranker dùng LlamaFactory"
metadata:
  author: kopymatch
  version: "1.0.0"
  repo_target: "cả hai"
---

# KopyMatch — Fine-tune Dataset Kit

## Mục tiêu

> Cung cấp cấu trúc dataset chuẩn, taxonomy nhãn, và quy trình chuẩn bị dữ liệu cho fine-tuning các tác vụ hẹp: classifier (phân loại scam/legit), extractor (trích xuất risk signals), reranker (xếp hạng độ tin cậy entity). Tối ưu cho LlamaFactory.

## Khi nào dùng

- ✅ Khi chuẩn bị dữ liệu training cho model fine-tune KopyMatch
- ✅ Khi cần tạo/mở rộng labeled dataset từ evidence packs
- ✅ Khi cần đánh giá chất lượng dataset hiện có
- ❌ KHÔNG dùng cho pre-training hoặc RLHF (chỉ supervised fine-tuning)
- ❌ KHÔNG dùng khi < 100 samples (cần tối thiểu 100 mẫu mới nên fine-tune)

## Đầu vào (Input)

| Tên             | Kiểu     | Bắt buộc | Mô tả                                                       |
| --------------- | -------- | -------- | ----------------------------------------------------------- |
| task_type       | enum     | Có       | "classifier", "extractor", "reranker"                       |
| raw_samples     | object[] | Có       | Dữ liệu thô cần gán nhãn                                    |
| existing_labels | object[] | Không    | Labels đã có (để mở rộng)                                   |
| target_model    | string   | Không    | "llama3-8b", "qwen2-7b", "mistral-7b" (mặc định: llama3-8b) |

## Đầu ra (Output)

### 1. Classifier Dataset (Phân loại scam/legit)

```json
{
  "dataset_meta": {
    "task": "classifier",
    "version": "1.0.0",
    "created_at": "2025-01-15",
    "total_samples": 500,
    "label_distribution": {
      "scam_confirmed": 150,
      "scam_suspected": 100,
      "legitimate": 200,
      "insufficient_data": 50
    },
    "format": "llamafactory_alpaca"
  },
  "taxonomy": {
    "labels": [
      {
        "id": "scam_confirmed",
        "description": "Có bằng chứng rõ ràng là scam",
        "min_signals": 2
      },
      {
        "id": "scam_suspected",
        "description": "Có dấu hiệu đáng ngờ, cần thêm bằng chứng",
        "min_signals": 1
      },
      {
        "id": "legitimate",
        "description": "Hợp pháp, không có dấu hiệu scam",
        "min_signals": 0
      },
      {
        "id": "insufficient_data",
        "description": "Không đủ dữ liệu để đánh giá",
        "min_signals": null
      }
    ],
    "sub_labels": [
      {
        "parent": "scam_confirmed",
        "id": "ponzi",
        "description": "Mô hình Ponzi"
      },
      {
        "parent": "scam_confirmed",
        "id": "pump_dump",
        "description": "Pump & Dump"
      },
      {
        "parent": "scam_confirmed",
        "id": "fake_signals",
        "description": "Signal giả lừa nạp tiền"
      },
      {
        "parent": "scam_confirmed",
        "id": "identity_fraud",
        "description": "Mạo danh trader/sàn uy tín"
      }
    ]
  },
  "samples": [
    {
      "instruction": "Phân loại entity sau đây là scam hay hợp pháp. Trả lời với {label, confidence, reasoning}.",
      "input": "Entity: CryptoMaster_VN trên Binance Copy Trading. ROI claim: 300%/tháng. Domain: 15 ngày tuổi. Thanh toán: chuyển USDT trực tiếp vào ví cá nhân. Followers: 15000 (tăng đột biến trong 1 tuần).",
      "output": "{\"label\": \"scam_confirmed\", \"sub_label\": \"fake_signals\", \"confidence\": 0.92, \"reasoning\": \"ROI 300%/tháng phi thực tế, domain mới, thanh toán không qua sàn, followers tăng bất thường\"}"
    },
    {
      "instruction": "Phân loại entity sau đây là scam hay hợp pháp. Trả lời với {label, confidence, reasoning}.",
      "input": "Entity: ProTrader_Asia trên OKX. ROI 90 ngày: 35%. Hoạt động 2 năm. Thanh toán qua OKX chính thức. Followers: 8000 (tăng dần đều). Có giấy phép đăng ký kinh doanh.",
      "output": "{\"label\": \"legitimate\", \"sub_label\": null, \"confidence\": 0.85, \"reasoning\": \"ROI hợp lý, hoạt động lâu, thanh toán qua sàn chính thống, followers organic, có giấy phép\"}"
    }
  ]
}
```

### 2. Extractor Dataset (Trích xuất risk signals)

```json
{
  "dataset_meta": {
    "task": "extractor",
    "format": "llamafactory_alpaca"
  },
  "samples": [
    {
      "instruction": "Trích xuất tất cả tín hiệu rủi ro từ đoạn text sau. Output JSON array risk_signals[].",
      "input": "Chào mừng bạn đến với VIP Trading Group! Chúng tôi cam kết lợi nhuận 20% mỗi tuần, hoàn toàn không rủi ro. Chỉ còn 3 slot cuối cùng hôm nay. Nạp 1000 USDT vào ví: TXyz... để bắt đầu ngay.",
      "output": "[{\"type\": \"unrealistic_return_promise\", \"severity\": \"critical\", \"evidence_span\": \"cam kết lợi nhuận 20% mỗi tuần\"}, {\"type\": \"guaranteed_no_risk\", \"severity\": \"critical\", \"evidence_span\": \"hoàn toàn không rủi ro\"}, {\"type\": \"pressure_tactics\", \"severity\": \"high\", \"evidence_span\": \"Chỉ còn 3 slot cuối cùng hôm nay\"}, {\"type\": \"unregulated_payment\", \"severity\": \"high\", \"evidence_span\": \"Nạp 1000 USDT vào ví: TXyz...\"}]"
    }
  ]
}
```

### 3. Reranker Dataset (Xếp hạng độ tin cậy)

```json
{
  "dataset_meta": {
    "task": "reranker",
    "format": "llamafactory_alpaca"
  },
  "samples": [
    {
      "instruction": "So sánh 2 entity bên dưới. Entity nào đáng tin cậy hơn? Trả lời với {preferred, reasoning}.",
      "input": "Entity A: ROI 300%/tháng, domain 15 ngày, thanh toán ví cá nhân.\nEntity B: ROI 8%/tháng, hoạt động 2 năm, thanh toán qua sàn chính thống.",
      "output": "{\"preferred\": \"B\", \"reasoning\": \"Entity B có ROI hợp lý, hoạt động lâu dài, thanh toán qua kênh kiểm soát được. Entity A có nhiều dấu hiệu scam.\"}"
    }
  ]
}
```

## LlamaFactory Integration

### File structure cho training

```
dataset/
  kopymatch_classifier_train.json    # 80% samples
  kopymatch_classifier_val.json      # 10% samples
  kopymatch_classifier_test.json     # 10% samples
  dataset_info.json                  # LlamaFactory metadata
```

### dataset_info.json

```json
{
  "kopymatch_classifier": {
    "file_name": "kopymatch_classifier_train.json",
    "columns": {
      "prompt": "instruction",
      "query": "input",
      "response": "output"
    }
  }
}
```

### Training command (LlamaFactory)

```bash
llamafactory-cli train \
  --model_name_or_path meta-llama/Meta-Llama-3-8B \
  --dataset kopymatch_classifier \
  --template llama3 \
  --finetuning_type lora \
  --lora_rank 16 \
  --output_dir output/kopymatch-classifier-v1 \
  --num_train_epochs 3 \
  --per_device_train_batch_size 4 \
  --learning_rate 2e-4 \
  --fp16 true
```

## Quy trình

1. **Xác định task type**: Classifier, extractor, hay reranker
2. **Thu thập raw samples**: Từ evidence packs, crawl outputs, chat logs
3. **Áp dụng taxonomy**: Gán nhãn theo taxonomy đã định nghĩa
4. **Viết instruction**: Tạo instruction template cho mỗi task type
5. **Format output**: Đảm bảo output JSON valid, theo đúng task schema
6. **Split dataset**: 80/10/10 (train/val/test)
7. **Tạo dataset_info.json**: Cho LlamaFactory
8. **Validate**: Kiểm tra balance, duplicates, JSON validity

## Checklist

- [ ] Tối thiểu 100 samples (lý tưởng: 500+)
- [ ] Label distribution cân bằng (không quá chênh lệch)
- [ ] Instruction template đồng nhất trong cùng task
- [ ] Output JSON valid cho mọi sample
- [ ] Không có duplicate samples
- [ ] Split 80/10/10 ngẫu nhiên
- [ ] `dataset_info.json` đúng format LlamaFactory
- [ ] Mỗi sample có reasoning (không chỉ label)

## Lỗi thường gặp

| Lỗi                      | Nguyên nhân                      | Cách khắc phục                           |
| ------------------------ | -------------------------------- | ---------------------------------------- |
| Model overfit            | Dataset quá nhỏ/ít đa dạng       | Tối thiểu 500 samples, đa dạng nguồn     |
| Label imbalance          | Quá nhiều scam, ít legit         | Cân bằng hoặc dùng class weights         |
| Output format lỗi        | JSON invalid trong output        | Validate JSON trước khi thêm vào dataset |
| Instruction inconsistent | Mỗi sample instruction khác nhau | Dùng template cố định                    |

## An toàn

- 🚫 **Anti-hallucination**: Dataset PHẢI từ dữ liệu thực. KHÔNG bịa samples.
- 📌 **Dẫn chứng**: Mỗi sample nên có truy xuất nguồn gốc (evidence pack id)
- ⚠️ **Fine-tune tác vụ hẹp**: Chỉ fine-tune cho 1 task cụ thể. KHÔNG fine-tune "general purpose".
- 🔒 **PII**: Xoá/mask PII trước khi đưa vào dataset.
- 📊 **Bias**: Review phân bổ label để tránh bias hệ thống.

## Tài nguyên đi kèm

- **Dataset Info Template**: `resources/dataset-info-template.json` — LlamaFactory metadata template
- **Split Script**: `scripts/split-dataset.py` — chia dataset 80/10/10
- **Ví dụ**: `examples/sample-dataset.json` — mẫu dataset alpaca format
