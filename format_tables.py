import sys
import re
import unicodedata
from pathlib import Path

def get_display_width(text):
    """Calculate display width accounting for Vietnamese full-width chars."""
    width = 0
    for char in text:
        w = unicodedata.east_asian_width(char)
        if w in ('F', 'W'):
            width += 2
        elif unicodedata.combining(char):
            width += 0
        else:
            width += 1
    return width

def is_table_row(line):
    s = line.strip()
    return s.startswith('|') and s.endswith('|') and len(s) > 2

def is_separator_row(line):
    s = line.strip()
    return bool(re.match(r'^\|[\s\-:|]+\|$', s))

def parse_table_cells(line):
    """Parse a table row into a list of cell strings."""
    s = line.strip()
    # Remove leading/trailing |
    s = s[1:] if s.startswith('|') else s
    s = s[:-1] if s.endswith('|') else s
    return [c.strip() for c in s.split('|')]

def format_table(table_lines):
    """Return a list of formatted table lines with proper padding."""
    rows = [parse_table_cells(l) for l in table_lines]
    num_cols = max(len(r) for r in rows)

    # Pad rows to same column count
    for r in rows:
        while len(r) < num_cols:
            r.append('')

    # Calculate max width per column (skip separator row)
    col_widths = []
    for c in range(num_cols):
        max_w = 3  # minimum
        for r_idx, row in enumerate(rows):
            if is_separator_row(table_lines[r_idx]):
                continue
            max_w = max(max_w, get_display_width(row[c]))
        col_widths.append(max_w)

    # Format rows
    out = []
    for r_idx, row in enumerate(rows):
        if is_separator_row(table_lines[r_idx]):
            parts = ['-' * w for w in col_widths]
        else:
            parts = []
            for c, cell in enumerate(row):
                pad = col_widths[c] - get_display_width(cell)
                parts.append(cell + ' ' * pad)
        out.append('| ' + ' | '.join(parts) + ' |')
    return out

def table_is_aligned(table_lines):
    """Check if table is already aligned (all rows same formatted length)."""
    formatted = format_table(table_lines)
    return table_lines == formatted

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8', newline='') as f:
        content = f.read()

    # Detect line ending
    crlf = '\r\n' in content
    lines = content.splitlines()

    new_lines = []
    i = 0
    table_buf = []        # raw lines of current table
    table_start = []      # line indices where table started
    misaligned_tables = []
    fixed = False

    while i < len(lines):
        line = lines[i]
        if is_table_row(line):
            table_buf.append(line)
        else:
            if len(table_buf) >= 2:
                formatted = format_table(table_buf)
                if formatted != table_buf:
                    misaligned_tables.append(len(new_lines) + 1)
                    new_lines.extend(formatted)
                    fixed = True
                else:
                    new_lines.extend(table_buf)
                table_buf = []
            elif table_buf:
                new_lines.extend(table_buf)
                table_buf = []
            new_lines.append(line)
        i += 1

    # Flush remaining table
    if len(table_buf) >= 2:
        formatted = format_table(table_buf)
        if formatted != table_buf:
            misaligned_tables.append(len(new_lines) + 1)
            new_lines.extend(formatted)
            fixed = True
        else:
            new_lines.extend(table_buf)
    elif table_buf:
        new_lines.extend(table_buf)

    sep = '\r\n' if crlf else '\n'
    new_content = sep.join(new_lines)
    # Preserve trailing newline
    if content.endswith('\r\n') or content.endswith('\n'):
        new_content += sep

    if fixed:
        with open(filepath, 'w', encoding='utf-8', newline='') as f:
            f.write(new_content)

    return misaligned_tables

# --- Main ---
print("=" * 60)
print("MARKDOWN TABLE AUDIT")
print("=" * 60)

total_files = 0
total_fixed = 0
report = []

skip_dirs = {'node_modules', '.git', 'third_party', '_tmp_upstream'}

for p in sorted(Path('.').rglob('*.md')):
    # Skip unwanted dirs
    parts = set(p.parts)
    if parts & skip_dirs:
        continue

    total_files += 1
    bad_tables = process_file(p)
    if bad_tables:
        total_fixed += 1
        report.append((str(p), bad_tables))

if report:
    print(f"\n{'FILE':<60} MISALIGNED TABLE (line)")
    print("-" * 70)
    for f, lines in report:
        print(f"  ✏️  {f:<56} line {lines}")
else:
    print("\n✅ Không có bảng nào bị lệch!")

print()
print(f"Tổng: {total_files} file đã kiểm tra, {total_fixed} file được sửa.")
