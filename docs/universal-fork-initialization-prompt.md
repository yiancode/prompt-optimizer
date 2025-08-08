# 通用GitHub Fork初始化结构化提示词

## 基础信息模板

在使用本提示词前，请准备以下信息：

```
原始仓库URL: https://github.com/[ORIGINAL_OWNER]/[REPO_NAME]
Fork仓库URL: https://github.com/[YOUR_USERNAME]/[REPO_NAME]
GitHub Token: ghp_[YOUR_TOKEN]
目标工作分支: [main/develop/master]
```

---

## 完整结构化提示词

```
我需要你帮我完整初始化一个GitHub Fork项目，从代码库分析到提交第一行代码。请严格按照以下步骤执行：

## 第一阶段：项目深度分析
请使用以下工具和步骤分析项目：

### 1.1 项目结构分析
- 使用LS工具查看根目录结构，识别项目类型（单体/Monorepo）
- 使用Glob工具查找所有package.json文件，分析包管理结构
- 使用Read工具读取根目录package.json，识别包管理器类型和版本要求
- 如果是workspace项目，读取workspace配置文件（pnpm-workspace.yaml/lerna.json等）

### 1.2 技术栈识别
- 查看package.json中的dependencies和devDependencies
- 识别主要框架（React/Vue/Angular等）
- 识别构建工具（Vite/Webpack/Rollup等）
- 识别测试框架和工具链

### 1.3 项目文档分析
- 读取README.md了解项目功能和部署方式
- 查找dev.md或CONTRIBUTING.md了解开发流程
- 检查是否存在.cursorrules或.github/copilot-instructions.md
- 分析项目的开发规范和约定

### 1.4 构建和开发命令识别
- 从package.json中提取所有scripts
- 识别开发、构建、测试、部署命令
- 如果是Monorepo，分析子包的构建依赖关系
- 总结常用开发工作流

## 第二阶段：Fork配置和分支同步

### 2.1 远程仓库配置诊断和修复
```bash
# 1. 检查当前远程仓库配置
git remote -v

# 2. 如果配置不正确，重新配置
git remote remove origin  # 如果需要
git remote add origin https://[YOUR_TOKEN]@github.com/[YOUR_USERNAME]/[REPO_NAME].git
git remote add upstream https://github.com/[ORIGINAL_OWNER]/[REPO_NAME].git

# 3. 验证配置正确性
git remote -v
```

### 2.2 上游分支同步
```bash
# 1. 获取上游所有分支和标签
git fetch upstream

# 2. 查看所有分支结构
git branch -a

# 3. 根据项目情况同步主要分支
# 如果上游有master分支，创建本地main分支
git checkout -b main upstream/master
git push origin main

# 如果上游有develop分支，同步develop分支
git checkout develop
git reset --hard upstream/develop  
git push origin develop --force

# 4. 设置正确的跟踪关系
git branch --set-upstream-to=origin/main main
git branch --set-upstream-to=origin/develop develop

# 5. 验证分支配置
git branch -vv
```

### 2.3 创建同步工具
创建sync-upstream.sh脚本，内容根据项目的分支结构调整：
```bash
#!/bin/bash
echo "正在从上游仓库获取最新更改..."
git fetch upstream

echo "同步主分支..."
git checkout [main/master]
git merge upstream/[master/main] --ff-only
git push origin [main/master]

echo "同步开发分支..."
git checkout develop
git merge upstream/develop --ff-only
git push origin develop

echo "同步完成！"
git branch -vv
```

## 第三阶段：项目开发文档创建

### 3.1 检查现有CLAUDE.md
- 使用Read工具检查是否已存在CLAUDE.md文件
- 如果存在，分析其内容并决定是否需要改进

### 3.2 创建/更新CLAUDE.md
请创建CLAUDE.md文件，包含以下结构和内容：

#### 必需内容：
1. **项目概述**: 
   - 项目类型和主要功能
   - 技术栈概述
   - 架构类型（单体/Monorepo等）

2. **环境要求**:
   - Node.js版本要求
   - 包管理器要求（npm/yarn/pnpm）
   - 其他依赖要求

3. **开发命令清单**:
   - 安装依赖命令
   - 开发模式命令
   - 构建命令  
   - 测试命令
   - 清理命令

4. **项目架构**:
   - 如果是Monorepo，详细说明包结构
   - 构建依赖关系
   - 核心模块说明

5. **开发规范**:
   - 代码风格要求
   - 提交信息规范
   - 测试要求

6. **重要开发注意事项**:
   - 平台兼容性问题
   - 特殊配置要求
   - 常见开发陷阱

#### 内容原则：
- 简洁直接，避免重复README内容
- 重点突出项目特有的架构和约束
- 提供具体可执行的命令示例
- 包含实际开发中需要注意的事项

## 第四阶段：首次代码提交

### 4.1 提交前检查
```bash
# 检查工作区状态
git status

# 查看具体更改内容
git diff

# 如果有未跟踪的文件，检查它们
```

### 4.2 标准化提交流程
```bash
# 1. 添加文件到暂存区
git add [FILES]

# 2. 规范化提交信息
git commit -m "$(cat <<'EOF'
docs: 添加项目初始化文档和开发指南

- 添加 CLAUDE.md：为 Claude Code 提供项目开发指南
- 添加 sync-upstream.sh：自动化上游仓库同步脚本  
- 完善项目开发文档和工作流

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

# 3. 推送到fork仓库
git push origin [BRANCH_NAME]

# 4. 验证提交
git log --oneline -3
```

## 第五阶段：总结和文档化

### 5.1 创建完整的初始化指南
请创建一个名为`github-fork-initialization-guide.md`的文档，详细记录：
- 项目分析发现的关键信息
- 执行的所有配置步骤
- 遇到的问题和解决方案
- 创建的文档和工具
- 适用于类似项目的最佳实践

### 5.2 验证完整性
确认以下工作已完成：
- [ ] 项目结构已充分分析和理解
- [ ] 远程仓库配置正确（origin指向fork，upstream指向原仓库）
- [ ] 主要分支已同步（main/master和develop）
- [ ] CLAUDE.md文档已创建，内容完整准确
- [ ] 同步工具脚本已创建并可执行
- [ ] 首次提交已完成，提交信息规范
- [ ] 完整的初始化指南已创建

## 执行要求

1. **严格按步骤执行**: 请按照1-5的顺序逐步完成，不要跳过任何步骤
2. **使用正确工具**: 优先使用LS、Read、Glob等工具进行分析
3. **保持专业性**: 提交信息要规范，文档要专业完整
4. **适应性调整**: 根据具体项目的特点调整命令和配置
5. **错误处理**: 如果遇到问题，要诊断原因并提供解决方案
6. **验证完成**: 每个阶段完成后要验证结果的正确性

现在开始执行，项目信息如下：
原始仓库：[填入原始仓库URL]
Fork仓库：[填入fork仓库URL]  
GitHub Token：[填入token]
```

---

## 使用说明

### 适用场景
- Fork任何GitHub开源项目进行贡献
- 初始化Monorepo项目的开发环境
- 建立标准化的Git工作流
- 团队协作项目的统一初始化

### 使用方式
1. 复制上方完整的结构化提示词
2. 替换方括号中的具体信息：
   - `[ORIGINAL_OWNER]`: 原仓库所有者
   - `[REPO_NAME]`: 仓库名称
   - `[YOUR_USERNAME]`: 你的GitHub用户名
   - `[YOUR_TOKEN]`: 你的GitHub访问令牌
   - `[BRANCH_NAME]`: 目标工作分支
3. 将完整提示词发送给AI助手
4. AI会按照结构化流程完成所有初始化工作

### 预期结果
执行完成后，你将得到：
- 完全配置好的本地Git环境
- 与上游仓库同步的分支结构
- 完整的项目开发指南（CLAUDE.md）
- 自动化同步工具脚本
- 规范的首次代码提交
- 详细的初始化过程文档

### 扩展性
本提示词具有良好的适应性，可以处理：
- 不同的项目类型（React/Vue/Node.js等）
- 不同的架构模式（单体/Monorepo/微前端等）
- 不同的包管理器（npm/yarn/pnpm）
- 不同的分支策略（GitFlow/GitHub Flow等）

---

*这个结构化提示词经过实际项目验证，可以确保完整、专业的Fork项目初始化流程。*