# ARCHITECTURE.md

# ReadMeet Quotes

Flutter Clean Architecture

Version 1.0

---

# Architecture Goals

The architecture must be:

* Scalable
* Testable
* Maintainable
* Offline First
* Feature Oriented

---

# Core Principles

Dependency Direction:

Presentation

↓

Domain

↓

Data

Never reverse.

---

# Forbidden

Presentation calling SQLite directly

Widget calling Repository directly

Data depending on Presentation

Business logic inside UI

Global mutable state

Singleton abuse

---

# Tech Stack

Flutter

Riverpod

GoRouter

Drift

SQLite

Firebase Analytics

Firebase Crashlytics

In App Purchase

---

# Root Structure

```text
lib/

app/

core/

shared/

features/

main.dart
```

---

# App Layer

```text
app/

app.dart

router/

app_router.dart

theme/

app_theme.dart

localization/

app_localizations.dart
```

Purpose:

Global application configuration.

---

# Core Layer

Contains reusable infrastructure.

```text
core/

constants/

errors/

extensions/

network/

storage/

utils/

services/
```

---

# Constants

```text
core/constants/

app_constants.dart

route_constants.dart

theme_constants.dart
```

---

# Errors

```text
core/errors/

app_exception.dart

failure.dart
```

---

# Services

```text
core/services/

analytics_service.dart

crashlytics_service.dart

purchase_service.dart

share_service.dart
```

---

# Shared Layer

Reusable UI components.

```text
shared/

widgets/

dialogs/

bottom_sheets/

animations/

icons/
```

Examples

AppButton

AppCard

AppTextField

LoadingIndicator

EmptyStateWidget

---

# Features Layer

Feature First Structure.

```text
features/

library/

reader/

highlights/

notes/

posters/

settings/

search/

purchase/
```

Every feature is isolated.

---

# Feature Structure

Each feature:

```text
feature_name/

data/

domain/

presentation/
```

---

# Data Layer

Responsible for:

Database

File Parsing

Storage

Repositories

---

Structure

```text
data/

datasources/

models/

repositories/
```

---

# Datasources

Examples

```text
datasources/

book_local_datasource.dart

highlight_local_datasource.dart

poster_local_datasource.dart
```

Only data access.

No business logic.

---

# Models

Database DTOs.

```text
models/

book_model.dart

highlight_model.dart

note_model.dart
```

---

# Repositories

Repository implementations.

```text
repositories/

book_repository_impl.dart

highlight_repository_impl.dart
```

Maps

Model ↔ Entity

---

# Domain Layer

Most important layer.

Contains business rules.

---

Structure

```text
domain/

entities/

repositories/

usecases/
```

---

# Entities

Pure business objects.

```text
entities/

book.dart

highlight.dart

note.dart

poster.dart
```

No package dependencies.

No JSON.

No Drift.

---

# Repository Contracts

```text
repositories/

book_repository.dart

highlight_repository.dart
```

Abstract interfaces only.

---

# Use Cases

One business action per file.

```text
usecases/

import_book.dart

get_books.dart

create_highlight.dart

delete_highlight.dart

create_note.dart

generate_poster.dart
```

---

Example

Good

```text
GeneratePosterUseCase
```

Bad

```text
PosterManager
```

---

# Presentation Layer

Contains UI.

---

Structure

```text
presentation/

pages/

widgets/

providers/

controllers/
```

---

# Pages

Full screens.

```text
pages/

library_page.dart

reader_page.dart

poster_page.dart
```

---

# Widgets

Reusable feature widgets.

```text
widgets/

book_card.dart

quote_card.dart

poster_preview.dart
```

---

# Providers

Riverpod providers.

```text
providers/

book_provider.dart

highlight_provider.dart
```

---

# Controllers

StateNotifiers

AsyncNotifiers

Business coordination only.

```text
controllers/

library_controller.dart

reader_controller.dart

poster_controller.dart
```

---

# Riverpod Rules

Use:

Notifier

AsyncNotifier

Provider

FutureProvider

StreamProvider

---

Avoid:

StateProvider abuse

Global mutable variables

---

# Dependency Injection

Single source:

```text
core/di/

injection.dart
```

Register:

Repositories

Datasources

Services

UseCases

---

# Database Module

```text
core/storage/

app_database.dart

tables/

daos/
```

---

# Tables

```text
tables/

books_table.dart

highlights_table.dart

notes_table.dart

posters_table.dart
```

---

# DAOs

```text
daos/

book_dao.dart

highlight_dao.dart
```

Only SQL access.

---

# Reader Module Architecture

reader/

data/

epub/

pdf/

txt/

domain/

presentation/

---

Parsers

```text
reader/data/parsers/

epub_parser.dart

pdf_parser.dart

txt_parser.dart
```

---

# Poster Module Architecture

poster/

data/

templates/

renderer/

export/

---

Renderer

```text
poster_renderer.dart
```

Responsibilities

Build image

Apply typography

Export PNG

Export JPG

---

# Search Module

Uses SQLite FTS5

Structure

```text
search/

data/

domain/

presentation/
```

---

# Purchase Module

purchase/

data/

domain/

presentation/

---

Use Cases

PurchasePro

RestorePurchase

CheckPurchaseStatus

---

# Analytics Architecture

UI

↓

Analytics Service

↓

Firebase

---

Never call Firebase directly.

Always use wrapper service.

---

# Routing Rules

GoRouter only.

---

Routes

/

/library

/book/:id

/highlights

/posters

/settings

/purchase

---

# Testing Structure

```text
test/

unit/

widget/

integration/
```

---

Unit Tests

UseCases

Repositories

Services

---

Widget Tests

BookCard

QuoteCard

PosterPreview

---

Integration Tests

Import EPUB

Create Highlight

Generate Poster

Purchase Flow

---

# Build Configurations

```text
dev

staging

production
```

Separate Firebase configs.

---

# CI/CD

GitHub Actions

Pipeline

Analyze

↓

Test

↓

Build Android

↓

Build iOS

↓

Release

---

# Dependency Flow

Presentation

↓

UseCase

↓

Repository

↓

Datasource

↓

Database

Never reverse.

---

# Golden Rule

UI must not know where data comes from.

UseCases must not know how data is stored.

Repositories must not know how UI works.

Every layer has exactly one responsibility.
