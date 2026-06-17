# CLAUDE.md

# ReadMeet Quotes

Master Execution Rules

Version 1.0

This file is the highest priority instruction for all AI coding agents.

Applies to:

* Claude Code
* Cursor Agent
* Codex
* Gemini CLI
* OpenHands

---

# Mission

Build a production-ready Flutter application.

Application:

ReadMeet Quotes

Platforms:

* iOS
* Android

Target:

App Store Release

Google Play Release

---

# Source Of Truth

Always follow documents in this order:

1. CLAUDE.md
2. PRD.md
3. ARCHITECTURE.md
4. DATABASE.md
5. UI_DESIGN.md
6. TASKS.md

If conflicts exist:

Higher document wins.

---

# Core Principles

Never generate demo code.

Never generate tutorial code.

Never generate placeholder implementations.

Never leave TODO comments.

Never create fake repositories.

Never create fake services.

Every feature must be fully implemented.

---

# Production First

Assume the code will be shipped to production.

All code must be:

* maintainable
* testable
* scalable

---

# Architecture Rules

Follow Clean Architecture.

Allowed dependency direction:

Presentation

↓

Domain

↓

Data

Never reverse.

---

# Feature First

All business features live inside:

features/

Example:

features/library

features/reader

features/highlights

features/posters

---

# File Size Limits

Maximum:

Widget File

300 lines

---

Page File

500 lines

---

Controller

300 lines

---

Repository

400 lines

---

If larger:

Refactor immediately.

---

# State Management

Use:

flutter_riverpod

Allowed:

Provider

FutureProvider

StreamProvider

Notifier

AsyncNotifier

Forbidden:

Global mutable state

StateProvider abuse

Singleton state managers

---

# Dependency Injection

Single entry point:

core/di/injection.dart

No service locator scattered around project.

---

# Repository Rules

Repositories are abstractions.

UI never accesses database directly.

UI never accesses drift directly.

---

# Drift Rules

All SQL access through DAO.

Never query database inside widgets.

Never query database inside use cases.

---

# Entity Rules

Entities are pure.

Entities must not:

Import Flutter

Import Drift

Import Firebase

Import JSON annotations

---

# Model Rules

Models are data-layer only.

Models convert:

JSON

Database

Entities

---

# UI Rules

Content first.

Typography first.

Follow UI_DESIGN.md.

Never introduce visual clutter.

---

# Theme Rules

Must support:

Light

Dark

Sepia

All screens must support all themes.

---

# Localization Rules

Every string must be localized.

Never hardcode user-facing text.

Supported:

English

Chinese

Japanese

---

# Reader Rules

Reader is sacred.

Reader performance takes priority.

Never rebuild entire book unnecessarily.

Use lazy loading.

---

# EPUB Rules

Do not load entire EPUB into memory.

Parse incrementally.

Store chapter references.

---

# PDF Rules

Support resume reading.

Support page restoration.

Support zoom.

---

# Highlight Rules

Highlight creation must feel instant.

Target:

<100ms

---

# Poster Rules

Poster generation is core feature.

Must support:

PNG

JPG

Templates:

Minimal

Paper

Dark

Cover

---

# Purchase Rules

One-time purchase only.

No subscriptions.

Product ID:

readmeet_quotes_pro

---

# Privacy Rules

User books stay local.

Never upload books.

Never upload highlights.

Never upload notes.

---

# Analytics Rules

Track only:

imports

highlights

posters

purchases

Never track reading content.

---

# Accessibility Rules

Support:

Dynamic Text

VoiceOver

TalkBack

Minimum touch area:

44x44

---

# Performance Rules

App Launch

<2s

Book Open

<500ms

Poster Generation

<1s

Search

<100ms

---

# Testing Rules

Every use case requires tests.

Every repository requires tests.

Critical widgets require tests.

---

# Code Quality Rules

Before finishing any task:

Run analyze

Run tests

Fix warnings

Fix errors

---

# Error Handling

Never swallow exceptions.

Use typed failures.

User-friendly messages only.

---

# Logging Rules

Use centralized logger.

No print statements.

No debug leftovers.

---

# Git Rules

One task per commit.

Commit format:

feat:

fix:

refactor:

test:

docs:

---

# Review Checklist

Before marking task complete:

✓ Builds successfully

✓ Tests pass

✓ No analyzer warnings

✓ Localized

✓ Dark mode works

✓ Accessibility works

✓ Follows architecture

✓ Follows design guide

---

# Definition Of Done

Task is complete only if:

Code exists

Tests exist

Build passes

Review checklist passes

Documentation updated

Otherwise task is incomplete.

---

# Final Instruction

When multiple implementations are possible:

Choose:

simpler

cleaner

more maintainable

more testable

solution.

Always optimize for long-term maintainability over short-term speed.
