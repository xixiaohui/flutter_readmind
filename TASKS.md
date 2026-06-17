# TASKS.md

# ReadMeet Quotes

Development Roadmap

Version 1.0

---

# Project Goal

Build production-ready Flutter application.

Target:

* iOS App Store
* Google Play

Architecture:

* Flutter
* Riverpod
* Drift
* Clean Architecture

---

# Priority Levels

P0 = Blocking

P1 = Core MVP

P2 = Nice to Have

P3 = Future

---

# EPIC 01

Project Foundation

Status:

P0

---

TASK-001

Create Flutter project

---

TASK-002

Configure analysis_options.yaml

---

TASK-003

Configure lint rules

---

TASK-004

Setup Riverpod

---

TASK-005

Setup GoRouter

---

TASK-006

Setup localization

EN

ZH

JA

---

TASK-007

Setup themes

Light

Dark

Sepia

---

TASK-008

Configure environments

dev

staging

production

---

TASK-009

Configure Firebase

Analytics

Crashlytics

---

TASK-010

Create dependency injection

---

# EPIC 02

Database

Status:

P0

---

TASK-011

Setup Drift

---

TASK-012

Create books table

---

TASK-013

Create chapters table

---

TASK-014

Create highlights table

---

TASK-015

Create notes table

---

TASK-016

Create bookmarks table

---

TASK-017

Create collections table

---

TASK-018

Create generated_posters table

---

TASK-019

Create settings table

---

TASK-020

Implement migrations

---

TASK-021

Create DAOs

---

TASK-022

Create repository implementations

---

# EPIC 03

Library Module

Status:

P1

---

TASK-023

Create library domain entities

---

TASK-024

Create import use cases

---

TASK-025

Create library page

---

TASK-026

Create book card widget

---

TASK-027

Implement search

---

TASK-028

Implement sorting

---

TASK-029

Implement favorites

---

TASK-030

Implement delete book

---

# EPIC 04

EPUB Import

Status:

P1

---

TASK-031

Setup epub parser

---

TASK-032

Extract metadata

---

TASK-033

Extract cover image

---

TASK-034

Extract chapters

---

TASK-035

Persist to database

---

TASK-036

Handle malformed EPUB

---

# EPIC 05

TXT Import

Status:

P1

---

TASK-037

Implement file picker

---

TASK-038

Detect encoding

UTF8

UTF16

GBK

Shift-JIS

---

TASK-039

Parse text content

---

TASK-040

Split chapters

---

TASK-041

Save to database

---

# EPIC 06

PDF Import

Status:

P1

---

TASK-042

Integrate pdfx

---

TASK-043

Extract metadata

---

TASK-044

Generate thumbnail

---

TASK-045

Save PDF reference

---

TASK-046

Restore reading position

---

# EPIC 07

Reader Module

Status:

P1

---

TASK-047

Reader page layout

---

TASK-048

Pagination mode

---

TASK-049

Scroll mode

---

TASK-050

Theme switching

---

TASK-051

Font size control

---

TASK-052

Line height control

---

TASK-053

Reading progress sync

---

TASK-054

Auto save position

---

TASK-055

Reading statistics

---

# EPIC 08

Highlight System

Status:

P1

---

TASK-056

Text selection engine

---

TASK-057

Highlight menu

---

TASK-058

Highlight storage

---

TASK-059

Highlight colors

---

TASK-060

Edit highlight

---

TASK-061

Delete highlight

---

TASK-062

Copy highlight

---

# EPIC 09

Notes System

Status:

P1

---

TASK-063

Add note

---

TASK-064

Edit note

---

TASK-065

Delete note

---

TASK-066

Link note to highlight

---

TASK-067

Note list screen

---

# EPIC 10

Quotes Center

Status:

P1

---

TASK-068

Highlights page

---

TASK-069

Search highlights

---

TASK-070

Filter by book

---

TASK-071

Filter by tag

---

TASK-072

Favorites section

---

TASK-073

Collections section

---

# EPIC 11

Poster Generator

Status:

P1

Core Feature

---

TASK-074

Poster rendering engine

---

TASK-075

Template system

---

TASK-076

Minimal template

---

TASK-077

Dark template

---

TASK-078

Paper template

---

TASK-079

Cover template

---

TASK-080

Live preview

---

TASK-081

Image export

PNG

---

TASK-082

Image export

JPG

---

TASK-083

Poster history

---

# EPIC 12

Sharing

Status:

P1

---

TASK-084

Save image

---

TASK-085

System share

---

TASK-086

Instagram compatibility

---

TASK-087

Facebook compatibility

---

TASK-088

X compatibility

---

# EPIC 13

Search

Status:

P1

---

TASK-089

Setup FTS5

---

TASK-090

Index highlights

---

TASK-091

Index notes

---

TASK-092

Index books

---

TASK-093

Search page

---

TASK-094

Recent search history

---

# EPIC 14

Settings

Status:

P1

---

TASK-095

Theme settings

---

TASK-096

Language settings

---

TASK-097

Font settings

---

TASK-098

Privacy page

---

TASK-099

About page

---

TASK-100

Export settings

---

# EPIC 15

Monetization

Status:

P1

---

TASK-101

Integrate in_app_purchase

---

TASK-102

Pro purchase flow

---

TASK-103

Restore purchase

---

TASK-104

Feature gating

---

TASK-105

Paywall page

---

TASK-106

Purchase validation

---

# EPIC 16

Analytics

Status:

P2

---

TASK-107

Track book import

---

TASK-108

Track highlight creation

---

TASK-109

Track poster generation

---

TASK-110

Track purchase conversion

---

# EPIC 17

Backup

Status:

P2

---

TASK-111

Export JSON

---

TASK-112

Export ZIP

---

TASK-113

Restore JSON

---

TASK-114

Restore ZIP

---

# EPIC 18

Accessibility

Status:

P1

---

TASK-115

Dynamic font support

---

TASK-116

VoiceOver labels

---

TASK-117

TalkBack labels

---

TASK-118

Large touch targets

---

# EPIC 19

Testing

Status:

P0

---

TASK-119

Unit tests

Entities

---

TASK-120

Unit tests

UseCases

---

TASK-121

Repository tests

---

TASK-122

Widget tests

---

TASK-123

Integration tests

Book import

---

TASK-124

Integration tests

Highlight flow

---

TASK-125

Integration tests

Poster generation

---

# EPIC 20

Release

Status:

P0

---

TASK-126

App icon

---

TASK-127

Splash screen

---

TASK-128

Privacy policy

---

TASK-129

Terms of use

---

TASK-130

App Store screenshots

---

TASK-131

Google Play screenshots

---

TASK-132

App Store metadata

---

TASK-133

Google Play metadata

---

TASK-134

Prepare release builds

---

TASK-135

Submit to App Store

---

TASK-136

Submit to Google Play

---

# MVP Definition

MVP Complete When:

✓ Import EPUB

✓ Import TXT

✓ Import PDF

✓ Read Books

✓ Create Highlights

✓ Create Notes

✓ Generate Posters

✓ Share Posters

✓ Purchase Pro

✓ Pass Store Review

---

Estimated Timeline

Phase 1 Foundation

Week 1

---

Phase 2 Reading Engine

Week 2-3

---

Phase 3 Highlight System

Week 4

---

Phase 4 Poster Generator

Week 5

---

Phase 5 Purchase

Week 6

---

Phase 6 Testing

Week 7

---

Phase 7 Store Release

Week 8

---

Final Goal

Build the best quote-sharing reading app for independent readers.
