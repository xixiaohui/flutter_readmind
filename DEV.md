# DEV.md

# ReadMeet Quotes

Production-grade Flutter application specification.

Version: 1.0

---

# Product Definition

ReadMeet Quotes｜墨光 是一款专为深度阅读者打造的阅读摘录与海报分享应用。

核心流程：

Import → Read → Highlight → Note → Poster → Share

本产品不是 Kindle 替代品。

本产品不是 AI 聊天工具。

本产品专注于：

* 导入个人电子书
* 阅读与摘录
* 高亮与笔记
* 知识沉淀
* 海报分享

目标平台：

* iOS App Store
* Google Play

---

# Product Positioning

对标：

* Apple Books
* Kindle
* Readwise Reader
* Matter Reader

差异化：

ReadMeet Quotes = Reader + Highlight + Poster

重点不是阅读。

重点是摘录与分享。

---

# Technical Requirements

## Flutter

Use latest stable Flutter SDK.

Minimum requirements:

* Flutter 3.35+
* Dart latest stable

---

## Architecture

Must use:

Clean Architecture

Structure:

lib/

core/

shared/

features/

library/

reader/

highlights/

notes/

posters/

settings/

data/

domain/

presentation/

---

Mandatory patterns:

* Riverpod
* Repository Pattern
* UseCase Pattern
* Dependency Injection

Forbidden:

* GetX
* MVC
* Massive Widget
* Business logic inside UI

---

# State Management

Use:

flutter_riverpod

All state must be immutable.

Use AsyncValue for async states.

---

# Routing

Use:

go_router

Required routes:

/

/library

/book/:id

/highlights

/posters

/settings

---

# Database

Use:

Drift

Storage:

SQLite

Must support migration.

---

# Book Import System

## Supported Formats

### EPUB

Requirements:

* Parse metadata
* Parse chapters
* Parse cover image
* Store locally

Libraries:

epubx

---

### TXT

Requirements:

Support:

* UTF-8
* UTF-16
* GBK
* Shift-JIS

Auto detect encoding.

Store parsed content.

---

### PDF

Requirements:

Support text-based PDF.

Must support:

* Zoom
* Pagination
* Reading position restore

Libraries:

pdfx

---

# Library Module

Display:

* Cover
* Title
* Author
* Progress

Features:

* Search
* Sort
* Recently Read
* Favorites

---

# Reader Module

## EPUB Reader

Support:

* Pagination Mode
* Scroll Mode

Settings:

* Font Size
* Line Height
* Margin
* Theme

Themes:

* Light
* Dark
* Sepia

---

## TXT Reader

Support:

* Auto pagination
* Progress sync

---

## PDF Reader

Support:

* Pinch zoom
* Page navigation
* Restore reading position

---

# Reading Progress

Persist automatically.

Track:

* Book
* Chapter
* Page
* Position

Database table:

reading_progress

Fields:

id

book_id

chapter_index

page

position

updated_at

---

# Highlight System

Long press text.

Menu:

* Highlight
* Note
* Copy
* Share

Highlight colors:

* Yellow
* Green
* Blue
* Pink

Database:

highlights

Fields:

id

book_id

chapter

content

color

created_at

---

# Notes System

User can attach note to highlight.

Database:

notes

Fields:

id

highlight_id

content

created_at

updated_at

---

# Quotes Center

Dedicated screen.

Features:

* All Highlights
* Filter by Book
* Search
* Sort by Time

Display:

* Quote
* Book
* Author
* Date

---

# Poster Generator

Core Feature.

Generate beautiful quote cards.

Supported ratios:

* 1:1
* 4:5
* 9:16

---

# Poster Templates

Required templates:

## Minimal

White background

Black text

---

## Dark

Dark background

Elegant typography

---

## Paper

Paper texture

Book style

---

## Cover

Book cover included

---

# Poster Content

Poster must support:

* Quote
* Book Title
* Author
* Date

Optional:

* User Note

---

# Export

Formats:

* PNG
* JPG

Resolutions:

1080x1080

1080x1350

1080x1920

Generation time:

Under 1 second

---

# Sharing

Use:

share_plus

Support:

* Save Image
* System Share

Target platforms:

* WeChat
* Instagram
* Facebook
* Threads
* X
* LINE

---

# Search Engine

Search:

* Book Title
* Author
* Highlight Content
* Notes

Use SQLite FTS5.

---

# Local Storage Policy

Everything local first.

Books never uploaded automatically.

No cloud dependency in MVP.

---

# Settings

Support:

Theme

Language

Font

Backup Export

Privacy

About

Languages:

* English
* Simplified Chinese
* Japanese

---

# Monetization

Freemium

Free:

* 3 Books
* 50 Highlights
* 10 Posters

Pro:

One-time purchase

USD 4.99

Unlock:

* Unlimited Books
* Unlimited Highlights
* Unlimited Posters

Use:

in_app_purchase

No subscription.

---

# Analytics

Use:

Firebase Analytics

Track:

* Book Imported
* Highlight Created
* Poster Generated
* Share Triggered
* Purchase Completed

Do not track reading content.

---

# Crash Reporting

Use:

Firebase Crashlytics

Required in release builds.

---

# Performance Targets

Cold Start:

< 2 seconds

Open Book:

< 500 ms

Poster Generation:

< 1 second

100MB EPUB Import:

< 3 seconds

Memory:

Avoid loading entire book into memory.

Implement lazy loading.

---

# Security

No hidden tracking.

No uploading user books.

No collecting reading content.

Follow:

* App Store Review Guidelines
* Google Play User Data Policy
* GDPR
* Privacy Manifest

---

# Accessibility

Required:

* Dynamic Type
* VoiceOver
* TalkBack
* High Contrast

---

# Design Language

Inspired by:

Apple Books

Notion

Readwise

Kindle

Principles:

* Minimal
* Typography First
* Spacious Layout
* Premium Feel

---

# CI/CD

Use GitHub Actions.

Required pipelines:

* Flutter Analyze
* Flutter Test
* Build Android
* Build iOS

---

# Testing

Minimum coverage:

70%

Include:

* Unit Tests
* Widget Tests
* Repository Tests

---

# Deliverables

Generate:

1. Complete Flutter project structure
2. Domain layer
3. Data layer
4. Presentation layer
5. Drift database
6. Repositories
7. Use Cases
8. Riverpod providers
9. Localization
10. Theme system
11. Reader module
12. Highlight module
13. Notes module
14. Poster generator
15. Purchase module
16. Analytics module
17. Crash reporting
18. Unit tests
19. Widget tests
20. GitHub Actions
21. README
22. App Store release guide
23. Google Play release guide

All code must be production-ready.

No placeholders.

No pseudo-code.

No demo implementations.

Assume this application will be submitted to App Store and Google Play immediately after development.
