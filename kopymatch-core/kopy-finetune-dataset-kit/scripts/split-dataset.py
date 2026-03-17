#!/usr/bin/env python3
"""
split-dataset.py — Chia dataset thành train/val/test theo tỷ lệ 80/10/10.

Usage:
    python split-dataset.py input.json --output-dir ./dataset/ --seed 42

Input:  JSON array of samples (alpaca format: instruction, input, output)
Output: 3 files: *_train.json, *_val.json, *_test.json
"""

import json
import random
import argparse
from pathlib import Path


def split_dataset(data, train_ratio=0.8, val_ratio=0.1, seed=42):
    """Split dataset into train/val/test."""
    random.seed(seed)
    random.shuffle(data)

    n = len(data)
    train_end = int(n * train_ratio)
    val_end = int(n * (train_ratio + val_ratio))

    return {
        "train": data[:train_end],
        "val": data[train_end:val_end],
        "test": data[val_end:],
    }


def main():
    parser = argparse.ArgumentParser(description="Split dataset 80/10/10")
    parser.add_argument("input", help="Input JSON file (array of samples)")
    parser.add_argument("--output-dir", default="./dataset/", help="Output directory")
    parser.add_argument("--prefix", default="kopymatch", help="Output file prefix")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    args = parser.parse_args()

    with open(args.input, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not isinstance(data, list):
        print("❌ Input phải là JSON array")
        return

    print(f"📊 Tổng samples: {len(data)}")

    if len(data) < 10:
        print("⚠️  Quá ít samples (<10). Khuyến nghị tối thiểu 100.")

    splits = split_dataset(data, seed=args.seed)

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    for split_name, split_data in splits.items():
        out_file = output_dir / f"{args.prefix}_{split_name}.json"
        with open(out_file, "w", encoding="utf-8") as f:
            json.dump(split_data, f, ensure_ascii=False, indent=2)
        print(f"  ✅ {split_name}: {len(split_data)} samples → {out_file}")

    print(f"\n🎉 Hoàn tất! Files đã lưu tại {output_dir}")


if __name__ == "__main__":
    main()
