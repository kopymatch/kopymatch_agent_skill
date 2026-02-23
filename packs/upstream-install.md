# Upstream Install Guide

Repo này đã vendor 3 upstream skill packs:

| Nguồn | Thư mục | License |
| --- | --- | --- |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `third_party/vercel-agent-skills/` | MIT |
| [anthropics/courses](https://github.com/anthropics/courses) | `third_party/anthropics-skills/` | CC-BY-SA-4.0 |
| [openai/codex](https://github.com/openai/codex) | `third_party/openai-skills/` | Apache-2.0 |

## Cập nhật upstream

```bash
# Clone mới vào _tmp_upstream
cd _tmp_upstream
git clone --depth 1 https://github.com/vercel-labs/agent-skills.git vercel-agent-skills
git clone --depth 1 https://github.com/anthropics/courses.git anthropics-skills
git clone --depth 1 https://github.com/openai/codex.git openai-skills

# Copy vào third_party (KHÔNG sửa)
cp -r vercel-agent-skills/skills/* ../third_party/vercel-agent-skills/
cp -r anthropics-skills/{real_world_prompting,tool_use,prompt_evaluations} ../third_party/anthropics-skills/
cp -r openai-skills/{AGENTS.md,.codex,docs} ../third_party/openai-skills/
```
