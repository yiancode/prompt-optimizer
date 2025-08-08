# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

Prompt Optimizer是一个AI提示词优化工具，支持多平台部署（Web、桌面、Chrome扩展、Docker、MCP服务器）。项目使用pnpm workspace管理的monorepo架构。

## 开发环境要求

- Node.js >= 18
- pnpm >= 8 (必须使用pnpm，不要使用npm或yarn)
- Git >= 2.0

## 常用开发命令

### 安装依赖
```bash
pnpm install
```

### 开发模式
```bash
pnpm dev               # Web开发：构建core/ui并运行web应用
pnpm dev:fresh         # Web开发（完整重置）：清理+重装+启动
pnpm dev:desktop       # Desktop开发：构建core/ui，同时运行web和desktop
pnpm dev:desktop:fresh # Desktop开发（完整重置）：清理+重装+启动
pnpm dev:ext          # Chrome扩展开发
```

### 构建命令
```bash
pnpm build            # 构建所有包（按依赖顺序：core → ui → web/ext/desktop并行）
pnpm build:core       # 构建核心包
pnpm build:ui         # 构建UI组件包
pnpm build:web        # 构建Web应用
pnpm build:ext        # 构建Chrome扩展
pnpm build:desktop    # 构建Desktop应用（包含打包）
```

### 测试命令
```bash
pnpm test             # 运行所有包的测试
pnpm -F @prompt-optimizer/core test        # 运行core包测试
pnpm -F @prompt-optimizer/ui test          # 运行ui包测试
pnpm -F @prompt-optimizer/web test         # 运行web包测试
```

### MCP服务器命令
```bash
pnpm mcp:build        # 构建MCP服务器
pnpm mcp:dev         # MCP服务器开发模式
pnpm mcp:start       # 启动MCP服务器
pnpm mcp:test        # 测试MCP服务器
```

### 清理命令
```bash
pnpm clean           # 清理构建产物和Vite缓存
pnpm clean:dist      # 清理构建产物
pnpm clean:vite      # 清理Vite缓存
```

## 项目架构

### Monorepo包结构
- **@prompt-optimizer/core**: 核心业务逻辑包，包含所有服务层代码
- **@prompt-optimizer/ui**: Vue3+ElementPlus UI组件库
- **@prompt-optimizer/web**: Web应用，依赖ui包
- **@prompt-optimizer/extension**: Chrome扩展
- **@prompt-optimizer/desktop**: Electron桌面应用
- **@prompt-optimizer/mcp-server**: MCP协议服务器，支持与Claude Desktop等集成

### 核心服务架构 (core包)
- **services/**: 核心业务服务
  - **llm/**: LLM API调用服务，支持OpenAI、Gemini、DeepSeek等
  - **prompt/**: 提示词优化服务
  - **template/**: 模板管理服务，支持多语言
  - **model/**: 模型配置管理
  - **storage/**: 存储抽象层，支持多种存储方式
  - **history/**: 历史记录管理
  - **data/**: 数据导入导出
  - **preference/**: 偏好设置管理
  - **compare/**: 对比功能服务

### 构建依赖关系
构建必须按以下顺序进行：
1. **core** (基础服务层)
2. **ui** (依赖core的组件层)  
3. **web/extension/desktop** (可并行，都依赖ui和core)

## 开发规范

### 包管理
- 使用pnpm workspace，通过`-F`参数操作特定包
- 不要直接修改根目录的package.json依赖
- 新依赖应添加到对应子包的package.json

### 测试规范
- 每次修改后必须运行`pnpm test`确保测试通过
- core包包含单元测试和集成测试
- 新功能必须包含对应测试用例

### 代码风格
- 使用TypeScript严格模式
- 遵循项目现有的代码风格
- API调用统一使用OpenAI兼容格式

### 版本管理
- 使用`pnpm version:prepare`更新版本号（不创建tag）
- 使用`pnpm run version:tag`和`pnpm run version:publish`发布版本
- 支持语义化版本控制

## 重要开发注意事项

### 存储架构
项目使用统一的存储抽象层，支持：
- LocalStorage (Web)
- IndexedDB (桌面应用)
- FileSystem (Electron/Node.js环境)
- Memory (测试环境)

### 跨平台兼容性
- core包需要支持Web、Node.js、Electron环境
- 使用环境检测工具(`utils/environment.ts`)处理平台差异
- IPC序列化处理Electron环境下的复杂对象传递

### 模板系统
- 支持多语言模板(中文/英文)
- CSP安全的模板处理器
- 支持用户自定义模板

### API集成
- 业务逻辑与API配置解耦
- 敏感信息使用环境变量
- 统一错误处理和重试机制

## 常见开发任务

### 添加新的LLM模型支持
1. 在`services/model/`中添加模型配置
2. 在`services/llm/`中实现API调用逻辑
3. 更新UI中的模型选择器
4. 添加相应测试用例

### 添加新的优化模板
1. 在`services/template/default-templates/`中添加模板文件
2. 实现中英文双语版本
3. 在模板管理器中注册
4. 添加模板测试

### 修改存储逻辑
1. 优先修改存储抽象接口
2. 更新所有存储提供者实现
3. 确保跨平台兼容性
4. 运行存储相关测试

## 文档结构
- `dev.md`: 详细开发指南和部署说明
- `docs/`: 完整的项目文档目录
- `.cursorrules`: AI编程规范和工作流程

按照这些指导原则，你应该能够高效地在这个项目中进行开发和维护工作。