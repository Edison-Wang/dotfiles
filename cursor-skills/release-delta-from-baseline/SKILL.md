---
name: release-delta-from-baseline
description: >-
  Compares git baseline ref to dev (or user target branch), summarizes commits,
  and outputs Simplified Chinese release copy with heading "# Release v".
  After output, writes TARGET HEAD to .cursor/ai/docs/release-baseline.txt and
  syncs the same SHA into CHANGELOG.md 「当前基线」 line.
  Use for incremental release notes, 补充更新, release delta, or slash command
  release-delta-from-baseline.
disable-model-invocation: true
---

# Release Delta from Baseline

> **适用**：仓库根目录有 `CHANGELOG.md`、主开发分支常命名为 `dev` 的项目（例如 Expo / React Native）。若各项目 `CHANGELOG` 的维护小节标题不同，Agent 应以**实际文件**为准查找 `**当前基线**：` 行。

## 何时使用

用户给出 **基线**（或可自文件读取），需要列出相对 **目标分支**（默认 `dev`）的增量，并输出**可直接粘贴**的对外说明（简体中文）；并在流程**末尾**将 **TARGET HEAD** 写入本地基线文件，并**同步** `CHANGELOG.md` 中「当前基线」一行，便于下次 `git log` 对齐。

## 基线读取顺序（必须按序尝试）

1. 用户在本轮对话中**明确写出**的 SHA / tag。
2. 读取 **`.cursor/ai/docs/release-baseline.txt`**：取**第一行**非空内容；若为 `待填写` 或无效 SHA 格式则忽略，进入下一项。
3. 读取 **`CHANGELOG.md`** 中 `**当前基线**：` 后的值；无效则进入下一项。
4. 仍无法解析则**向用户索要基线**，禁止猜测。

> **说明**：`release-baseline.txt` 位于已 git 忽略的 `.cursor/` 下，**不进入仓库**；收尾时会将与 `CHANGELOG.md`「当前基线」**相同的完整 SHA** 写入两处（`CHANGELOG.md` **会入库**，请自行检视 diff 后再 commit）。

## 操作步骤

1. 在仓库根目录执行：`git fetch origin dev 2>/dev/null`（失败则忽略，继续用本地 `dev`）。
2. 按上一节解析 **BASELINE**。
3. **TARGET** 默认 `dev`；用户指定其他分支则以用户为准。
4. 执行：
   - `git log -1 --oneline TARGET`
   - `git log BASELINE..TARGET --oneline --no-decorate`
5. 对影响说明的非 merge commit，必要时 `git show <sha> --stat` 或 `-p` 归纳**用户可见**变化。
6. 按功能域合并同类项（如：永续合约、流动性、借贷、钱包、IM 等）。

## 输出格式（必须遵守）

使用**简体中文**：

```text
# Release vX.Y.Z(build)

更新内容:

## 模块名称
• 第一条说明
• 第二条说明

## 另一模块
• …
```

规则：

- 第一行：`# Release v` + 版本 + `(` + build 号 + `)`；若用户未提供版本 / build，第一行写 `# Release v（请填写版本(build)）`，并在回复中提醒补全。
- 空一行，再写 `更新内容:`。
- 空一行，再写各 `## 模块名称`；条目前使用 **`• `**（U+2022），**不要用** Markdown `-` 列表。
- 若无新 commit，在正文中明确写：`（与基线无差异）`，仍给出当前 HEAD 供核对。

在输出块**之后**，用一两行注明 **Git**：`BASELINE → HEAD`（短 SHA 即可）。

## 写回基线（必须执行）

在交付上述内容后 **立刻** 执行（顺序不限，但必须全部完成）：

1. `git rev-parse TARGET`（`TARGET` 为本次使用的分支名，如 `dev`），得到完整 **40 位 SHA**，记为 `NEW_HEAD`。
2. **覆盖写入** **`.cursor/ai/docs/release-baseline.txt`**：内容**仅一行** `NEW_HEAD`，末尾至多一个换行。
3. **更新仓库根目录 `CHANGELOG.md`**：在 **`## 团队怎么维护（请全员按此执行）`** 一节内，找到以 **`**当前基线**：`** 开头的**整整一行**（位于 **「### 5.」** 小节末尾），将整行替换为：

   `**当前基线**：\`NEW_HEAD\``

   要求：`NEW_HEAD` 为步骤 1 的**完整** 40 位 SHA，与 `release-baseline.txt` **完全一致**；勿改本节其他段落。若找不到该行或出现多行匹配，须在回复中说明并停手，勿擅自插入重复小节。（若目标仓库尚未采用此 `CHANGELOG` 模板，应与用户确认后再改或仅更新本地 `release-baseline.txt`。）

4. 若目录不存在则先创建 `.cursor/ai/docs/`。

若无法写文件，须在回复中给出用户可复制的手动命令：`git rev-parse dev` 后自行粘贴两处。

## 与 Cursor Command 的差别

| | **Skill（本文件）** | **Command（.cursor/commands 下）** |
|--|---------------------|-----------------------------------|
| 作用 | 教会 Agent **如何做**（git 步骤、输出模板、写基线文件） | 用户 **快捷入口**：一键插入与本流程对齐的提示词 |
| 是否必须 | 可被 @ 技能名引用 | 可选；减少打字 |

二者可并存：Command 内指向本 Skill，并强调「最后写 `release-baseline.txt` + 更新 `CHANGELOG.md` 当前基线行」。

## 语言

- Skill 输出的**发布文案块**：**简体中文**。
- 与用户对话语言遵循项目对话规范；说明段落可用繁体，**发布文案块本身仍为简体**。

## 安装到 Cursor

将本目录复制或 symlink 到 Cursor User skills，例如：

```bash
mkdir -p ~/.cursor/skills
ln -sf ~/dotfiles/cursor-skills/release-delta-from-baseline ~/.cursor/skills/release-delta-from-baseline
```

或在项目内使用 `.cursor/skills/release-delta-from-baseline/`（需项目未忽略 `.cursor/skills` 或自行纳入版控）。
