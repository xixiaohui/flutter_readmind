# ReadMeet Quotes 实施计划

## 概述

本计划将指导从零开始构建 "ReadMeet Quotes" Flutter 应用，遵循 **Clean Architecture** 和 **CLAUDE.md** 的所有规范。

**总预估时间**: 5.5 周 (39 天)
**任务总数**: 136 个任务 (TASKS.md)
**MVP 范围**: 导入、阅读、高亮、笔记、海报、分享、购买

---

## 实施阶段

### Phase 1: 项目基础 (Day 1-2)
**目标**: 可构建、可运行的 Flutter 应用骨架

**任务**:
- TASK-001: 创建 Flutter 项目结构
- TASK-002: 配置 pubspec.yaml 依赖
- TASK-003: 创建 ARCHITECTURE.md 定义的目录结构
- TASK-004: 设置 core/di/injection.dart (DI 入口)
- TASK-005: 配置 analysis_options.yaml (严格模式)
- TASK-006: 设置 .gitignore 和 .gitattributes
- TASK-007: 配置 CI/CD 流水线 (GitHub Actions)
- TASK-008: 创建测试目录结构
- TASK-009: 创建 README.md

**关键文件**:
```
lib/
├── core/
│   ├── di/injection.dart
│   └── constants/app_constants.dart
├── features/ (空目录结构)
└── main.dart (最小脚手架)
```

**验收标准**:
- [ ] `flutter pub get` 成功
- [ ] `flutter analyze` 零警告
- [ ] `flutter test` 通过
- [ ] `flutter run` 启动空白脚手架
- [ ] CI 流水线触发并成功

---

### Phase 2: 核心基础设施 (Day 3-6)
**目标**: 所有横切关注点实现 - 导航、主题、本地化、DI

**并行轨道**:

#### Track 2a: 依赖注入 & 核心服务
- TASK-010: 实现 core/di/injection.dart
- TASK-014: 创建 core/error/failure.dart
- TASK-015: 创建 core/error/error_handler.dart
- TASK-016: 创建 core/use_case/use_case.dart

#### Track 2b: 导航 & 应用外壳
- TASK-018: 配置 GoRouter 所有 MVP 路由
- TASK-019: 创建带 BottomNavigationBar 的应用外壳

#### Track 2c: 主题 & 本地化
- TASK-022: 实现 Light 主题 (ColorScheme)
- TASK-023: 实现 Dark 主题
- TASK-024: 实现 Sepia 主题
- TASK-025: 创建 ThemeController (Riverpod)
- TASK-027: 设置本地化 ARB 文件 (EN, ZH, JA)
- TASK-028: 创建本地化委托设置

**关键文件**:
```
lib/
├── core/
│   ├── di/injection.dart
│   ├── error/failure.dart
│   ├── theme/app_theme.dart
│   └── use_case/use_case.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_zh.arb
│   └── app_ja.arb
├── router/app_router.dart
└── features/shared/presentation/widgets/app_shell.dart
```

**验收标准**:
- [ ] 应用启动并显示 ProviderScope → MaterialApp.router → GoRouter
- [ ] GoRouter 在 4 个标签页间导航
- [ ] 主题在 Light → Dark → Sepia 间切换并持久化
- [ ] 所有 3 个语言环境正确渲染
- [ ] `flutter analyze` 零警告
- [ ] 无硬编码字符串

---

### Phase 3: 数据库层 (Day 7-12)
**目标**: 完整的 Drift 数据库实现，包含 DATABASE.md 中所有 20+ 表

**任务**:
- TASK-011: 定义所有数据库表 (20+ 表)
- TASK-012: 实现 AppDatabase (Drift) 和迁移
- TASK-013: 创建 BookDao
- TASK-014: 创建 HighlightDao
- TASK-015: 创建 NoteDao
- TASK-016: 创建所有 Repository 接口 (domain 层)
- TASK-017: 实现 BookRepositoryImpl
- TASK-018: 实现 HighlightRepositoryImpl
- TASK-019: 实现 NoteRepositoryImpl
- TASK-020: 在 DI 中注册所有 DAO 和 Repository

**关键表** (来自 DATABASE.md):
1. **books** - id, title, author, file_path, file_type, cover_path, total_pages
2. **highlights** - id, book_id, content, color, position_start, position_end
3. **notes** - id, book_id, highlight_id, content
4. **tags** - id, name, color
5. **generated_posters** - id, book_id, template_id, image_path

**关键文件**:
```
lib/
├── core/database/
│   ├── app_database.dart
│   └── tables/
│       ├── books_table.dart
│       ├── highlights_table.dart
│       └── notes_table.dart
├── features/shared/data/
│   ├── dao/
│   │   ├── book_dao.dart
│   │   └── highlight_dao.dart
│   └── repositories/
│       └── book_repository_impl.dart
└── domain/repositories/
    ├── book_repository.dart
    └── highlight_repository.dart
```

**验收标准**:
- [ ] `dart run build_runner build` 生成 app_database.g.dart 无错误
- [ ] 数据库首次启动时创建所有表
- [ ] 每个 DAO 有单元测试：insert, query, update, delete
- [ ] `flutter analyze` 零警告
- [ ] DI 容器解析所有 repository 无运行时错误

---

### Phase 4: 导入引擎 (Day 13-16)
**目标**: 用户可以导入 EPUB、TXT、PDF 文件到应用

**任务**:
- TASK-031: 创建文件选择器 UI (导入页面)
- TASK-032: 实现 EPUB 解析器服务
- TASK-033: 实现 TXT 解析器服务
- TASK-034: 实现 PDF 解析器服务
- TASK-035: 提取书籍元数据 (标题、作者、封面)
- TASK-036: 存储解析的书籍到数据库
- TASK-037: 优雅处理导入错误

**关键文件**:
```
lib/features/import/
├── data/datasources/
│   ├── epub_parser.dart
│   ├── txt_parser.dart
│   └── pdf_parser.dart
├── domain/use_cases/
│   └── import_book_use_case.dart
└── presentation/
    ├── controllers/import_controller.dart
    └── pages/import_page.dart
```

**验收标准**:
- [ ] 用户可以选择 EPUB 文件并导入到书架
- [ ] EPUB 元数据正确提取
- [ ] TXT 文件正确导入
- [ ] 导入错误显示用户友好的错误消息
- [ ] `flutter analyze` 零警告

---

### Phase 5: 阅读器核心 (Day 17-22)
**目标**: 用户可以打开并阅读书籍

**性能约束** (来自 CLAUDE.md):
- 打开书籍 < 500ms
- 阅读器性能优先

**任务**:
- TASK-047: 创建阅读器页面外壳
- TASK-048: 实现 EPUB 阅读器
- TASK-049: 实现 PDF 阅读器
- TASK-050: 实现 TXT 阅读器 (自定义分页视图)
- TASK-051: 跟踪阅读进度
- TASK-052: 退出时持久化阅读位置
- TASK-053: 创建 ReaderController (Riverpod)

**关键文件**:
```
lib/features/reader/
├── domain/entities/
│   ├── book_content.dart
│   └── reading_position.dart
└── presentation/
    ├── controllers/reader_controller.dart
    ├── pages/reader_page.dart
    └── widgets/
        ├── epub_reader_view.dart
        ├── pdf_reader_view.dart
        └── txt_reader_view.dart
```

**验收标准**:
- [ ] 点击书架上的书籍在 < 500ms 内打开
- [ ] EPUB 页面平滑翻页
- [ ] 阅读位置保存并在重新打开时恢复
- [ ] `flutter analyze` 零警告
- [ ] 翻页时无卡顿

---

### Phase 6: 高亮 & 笔记 (Day 23-26)
**目标**: 用户可以选择文本创建高亮，添加笔记

**任务**:
- TASK-056: 实现文本选择覆盖层
- TASK-057: 文本选择时创建高亮
- TASK-058: 实现高亮颜色选择器
- TASK-059: 在阅读器中显示高亮
- TASK-060: 在高亮上创建笔记
- TASK-061: 编辑/删除高亮
- TASK-062: 编辑/删除笔记

**关键文件**:
```
lib/features/highlights/
├── domain/entities/highlight.dart
└── presentation/
    ├── controllers/highlights_controller.dart
    └── widgets/highlight_color_picker.dart

lib/features/notes/
├── domain/entities/note.dart
└── presentation/
    ├── controllers/notes_controller.dart
    └── widgets/note_editor_sheet.dart
```

**验收标准**:
- [ ] 阅读器中文本选择显示自定义工具栏
- [ ] 高亮以彩色文本覆盖显示
- [ ] 高亮持久化到数据库
- [ ] 点击高亮打开笔记编辑器
- [ ] 所有字符串已本地化

---

### Phase 7: 海报生成 (Day 27-30)
**目标**: 用户可以将高亮转换为视觉吸引人的海报图片

**性能约束** (来自 CLAUDE.md):
- 海报生成 < 1s

**任务**:
- TASK-074: 设计海报模板 (5 个默认)
- TASK-075: 创建海报预览 UI
- TASK-076: 实现海报生成 (截图)
- TASK-077: 添加背景图片选择
- TASK-078: 实现海报保存到相册
- TASK-079: 创建 PosterController (Riverpod)

**关键文件**:
```
lib/features/poster/
├── domain/entities/
│   ├── poster.dart
│   └── poster_template.dart
└── presentation/
    ├── controllers/poster_controller.dart
    ├── pages/poster_generator_page.dart
    └── widgets/
        ├── poster_template_selector.dart
        ├── poster_preview.dart
        └── poster_share_button.dart
```

**验收标准**:
- [ ] 在高亮上点击"创建海报"打开海报生成器
- [ ] 5 个默认模板正确渲染高亮文本
- [ ] "保存到相册"将图片文件写入设备存储
- [ ] 海报生成在 < 1s 内完成
- [ ] 所有海报字符串已本地化

---

### Phase 8: 分享 & 导出 (Day 31-32)
**目标**: 用户可以通过系统分享分享海报

**任务**:
- TASK-084: 实现系统分享表单
- TASK-085: 通过平台分享分享海报图片
- TASK-086: 添加分享文本格式化

**验收标准**:
- [ ] "分享"按钮打开平台分享表单并附加海报图片
- [ ] 分享文本包含书名、作者、高亮内容
- [ ] `flutter analyze` 零警告

---

### Phase 9: 货币化 (Day 33-35)
**目标**: 应用内购买流程

**任务**:
- TASK-101: 设置 in_app_purchase 包
- TASK-102: 配置产品 ID
- TASK-103: 创建 PurchaseController (Riverpod)
- TASK-104: 实现购买流程 UI
- TASK-105: 验证购买收据
- TASK-106: 购买后解锁 Pro 功能

**验收标准**:
- [ ] 购买页面显示可用产品
- [ ] 购买流程完成并更新 Pro 状态
- [ ] 恢复购买检索以前的购买
- [ ] Pro 状态在应用重启后持久化

---

### Phase 10: 优化 & 发布 (Day 36-39)
**目标**: 性能调优、边界情况处理、完整测试覆盖、商店提交资源

**任务**:
- TASK-107-T110: 性能分析和优化
- TASK-111-T120: 边界情况处理 (空状态、错误)
- TASK-121-T125: 完整测试套件 (unit + widget + integration)
- TASK-126-T136: 商店资源、启动画面、图标、发布构建

**验收标准**:
- [ ] 应用启动 < 2s (release 构建实测)
- [ ] 打开书籍 < 500ms
- [ ] 海报生成 < 1s
- [ ] 代码库中零 `TODO` 注释
- [ ] 零占位符/假实现
- [ ] domain 和 data 层测试覆盖率 > 80%
- [ ] `flutter analyze` 零警告
- [ ] Release APK/AAB 构建成功
- [ ] Release IPA 构建成功 (如果 macOS)

---

## 关键架构规则

### Clean Architecture 依赖规则
```
Presentation → Domain → Data
```
- ✅ Presentation 可以导入 Domain
- ✅ Domain 可以导入 Data
- ❌ 反向依赖禁止

### 文件大小限制 (CLAUDE.md)
- Widget: 300 行
- Page: 500 行
- Controller: 300 行
- Repository: 400 行

### 禁止事项 (CLAUDE.md)
- ❌ Demo 代码
- ❌ 教程代码
- ❌ 占位符实现
- ❌ TODO 注释
- ❌ 假 repository/service
- ❌ 全局可变状态

### 性能目标 (CLAUDE.md)
- 应用启动 < 2s
- 打开书籍 < 500ms
- 海报生成 < 1s
- 搜索 < 100ms

---

## 验证检查点

每个 Phase 完成后必须:
1. ✅ `flutter analyze` 零警告
2. ✅ `flutter test` 通过
3. ✅ 所有字符串已本地化 (grep 验证)
4. ✅ 文件大小符合限制
5. ✅ 架构依赖方向正确
6. ✅ 无 TODO 注释
7. ✅ 无占位符代码

---

## 总结

这个实施计划:
- ✅ 遵循所有文档规范 (CLAUDE.md, ARCHITECTURE.md, DATABASE.md, UI_DESIGN.md, PRD.md, TASKS.md)
- ✅ 按依赖顺序组织阶段
- ✅ 每个阶段交付可测试的生产级代码
- ✅ 符合 Clean Architecture 和所有性能目标
- ✅ 完整覆盖 MVP 范围

**准备开始实施 Phase 1: 项目基础**
