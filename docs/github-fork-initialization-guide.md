# GitHub Fork项目初始化完整指南

## 概述

本文档详细记录了从分析开源项目到提交第一行代码的完整流程，包括项目分析、fork配置、分支同步、代码提交等所有步骤。

## 项目背景

**项目**: Prompt Optimizer (提示词优化器)  
**原始仓库**: https://github.com/linshenkx/prompt-optimizer  
**Fork仓库**: https://github.com/yiancode/prompt-optimizer  
**项目类型**: AI提示词优化工具，支持多平台部署的Monorepo项目

## 第一阶段：项目分析与理解

### 1.1 代码库结构分析

**执行的分析步骤**:
1. **项目概览分析**: 通过`LS`工具查看根目录结构
2. **包管理分析**: 检查`package.json`和`pnpm-workspace.yaml`了解依赖关系
3. **架构分析**: 分析`packages/`目录下的子包结构
4. **文档分析**: 阅读`README.md`和`dev.md`了解项目功能和开发流程
5. **配置分析**: 检查`.cursorrules`等开发规范文件

**关键发现**:
- Monorepo架构，使用pnpm workspace管理
- 包含6个子包：core、ui、web、extension、desktop、mcp-server
- 构建依赖关系：core → ui → (web/extension/desktop并行)
- 支持多平台部署：Web、桌面、Chrome扩展、Docker、MCP服务器

### 1.2 开发环境要求识别

**技术栈**:
- Node.js >= 18
- pnpm >= 8 (强制要求，不支持npm/yarn)
- TypeScript
- Vue 3 + Element Plus
- Electron (桌面应用)
- Vite (构建工具)

**关键开发命令**:
```bash
# 开发模式
pnpm dev               # Web开发
pnpm dev:desktop       # 桌面应用开发
pnpm dev:fresh         # 完整重置开发环境

# 构建命令
pnpm build            # 构建所有包
pnpm build:core       # 构建核心包
pnpm test            # 运行测试
```

## 第二阶段：Fork配置与分支同步

### 2.1 远程仓库配置

**问题诊断**: 发现本地origin指向原始仓库而非fork

**解决步骤**:
```bash
# 1. 检查当前配置
git remote -v

# 2. 重新配置远程仓库
git remote remove origin
git remote add origin https://TOKEN@github.com/USERNAME/REPO.git
git remote add upstream https://github.com/ORIGINAL_OWNER/REPO.git

# 3. 验证配置
git remote -v
```

**最终配置**:
- `origin`: 指向个人fork仓库 (用于推送代码)
- `upstream`: 指向原始仓库 (用于同步更新)

### 2.2 分支同步策略

**上游分支结构**:
- `master`: 主分支 (稳定版本)
- `develop`: 开发分支 (最新开发版本)
- 其他版本分支: `1.2.0` 等

**同步操作**:
```bash
# 1. 获取上游所有分支
git fetch upstream

# 2. 创建并同步main分支
git checkout -b main upstream/master
git push origin main

# 3. 同步develop分支
git checkout develop
git reset --hard upstream/develop
git push origin develop --force

# 4. 设置分支跟踪关系
git branch --set-upstream-to=origin/main main
git branch --set-upstream-to=origin/develop develop
```

### 2.3 创建同步工具

创建`sync-upstream.sh`脚本用于日常同步:
```bash
#!/bin/bash
echo "正在从上游仓库获取最新更改..."
git fetch upstream

echo "同步main分支..."
git checkout main
git merge upstream/master --ff-only
git push origin main

echo "同步develop分支..."
git checkout develop  
git merge upstream/develop --ff-only
git push origin develop

echo "同步完成！"
```

## 第三阶段：项目文档创建

### 3.1 CLAUDE.md创建

**目的**: 为Claude Code提供项目开发指南

**内容结构**:
1. **项目概述**: 项目介绍和技术栈
2. **开发环境要求**: Node.js、pnpm版本要求
3. **常用命令**: 开发、构建、测试命令清单
4. **项目架构**: Monorepo结构和包依赖关系
5. **开发规范**: 代码风格、测试要求、提交规范
6. **重要特性**: 存储架构、跨平台兼容性等
7. **常见开发任务**: 添加模型、模板、修改存储等

**关键信息**:
- 构建依赖顺序：core → ui → (web/extension/desktop)
- 存储抽象层支持多平台
- 统一的API格式和错误处理

### 3.2 文档质量标准

**遵循原则**:
- 简洁直接，避免冗余信息
- 提供具体的命令示例
- 突出项目特有的架构和约束
- 包含实际开发中的注意事项

## 第四阶段：代码提交

### 4.1 提交准备

**检查工作区状态**:
```bash
git status          # 查看未跟踪文件
git diff            # 查看更改内容
```

**文件添加**:
```bash
git add CLAUDE.md sync-upstream.sh
```

### 4.2 提交信息规范

**提交格式**:
```
<type>(<scope>): <subject>

<body>

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**实际提交**:
```bash
git commit -m "$(cat <<'EOF'
docs: 添加 CLAUDE.md 开发指南和上游同步脚本

- 添加 CLAUDE.md：为 Claude Code 提供项目结构、开发命令和架构说明
- 添加 sync-upstream.sh：用于同步上游仓库更改的便利脚本
- 完善 monorepo 项目的开发文档

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### 4.3 推送到GitHub

```bash
git push origin develop
```

**验证提交**:
```bash
git log --oneline -3  # 查看最近3条提交记录
```

## 总结

### 完成的工作

1. ✅ **项目分析**: 深入理解了Monorepo架构和技术栈
2. ✅ **环境配置**: 正确配置了fork和上游仓库关系
3. ✅ **分支同步**: 同步了main和develop分支到个人fork
4. ✅ **文档创建**: 创建了CLAUDE.md开发指南
5. ✅ **工具创建**: 提供了同步脚本便于日常维护
6. ✅ **代码提交**: 规范地提交了第一批文档代码

### 关键成果

**文档产出**:
- `CLAUDE.md`: 166行的详细开发指南
- `sync-upstream.sh`: 自动化同步脚本
- 本指南文档: 完整的流程记录

**配置成果**:
- 正确的远程仓库配置 (origin + upstream)
- 同步的分支结构 (main + develop)
- 标准的Git工作流设置

### 最佳实践总结

1. **先分析后行动**: 充分理解项目结构再进行配置
2. **标准化配置**: 使用origin/upstream的标准命名
3. **自动化工具**: 创建脚本减少重复工作
4. **规范提交**: 遵循项目的提交信息格式
5. **文档先行**: 为后续开发提供清晰指南

## 适用场景

本流程适用于以下场景:
- Fork开源项目进行贡献
- Monorepo项目的初始化
- 需要与上游仓库保持同步的长期开发
- 团队协作中的标准化工作流建立

---

*本文档记录了完整的项目初始化过程，可作为其他类似项目的参考模板。*