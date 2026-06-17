# DATABASE.md

# ReadMeet Quotes Database Design

Version 1.0

Database Engine:

SQLite

ORM:

Drift

Schema Version:

1

---

# Design Principles

Local First

Offline First

Migration Friendly

Search Optimized

Future Cloud Sync Ready

---

# Table Overview

books

book_chapters

reading_progress

highlights

notes

tags

highlight_tags

poster_templates

generated_posters

favorites

collections

collection_items

bookmarks

search_history

user_settings

purchase_status

analytics_events

sync_queue

app_metadata

---

# books

Stores imported books.

```sql
CREATE TABLE books (
id INTEGER PRIMARY KEY AUTOINCREMENT,

uuid TEXT NOT NULL UNIQUE,

title TEXT NOT NULL,

author TEXT,

description TEXT,

language TEXT,

publisher TEXT,

isbn TEXT,

cover_path TEXT,

file_path TEXT NOT NULL,

file_type TEXT NOT NULL,

file_size INTEGER,

total_pages INTEGER,

total_chapters INTEGER,

last_opened_at INTEGER,

created_at INTEGER NOT NULL,

updated_at INTEGER NOT NULL
);
```

Indexes

```sql
CREATE INDEX idx_books_title
ON books(title);

CREATE INDEX idx_books_author
ON books(author);
```

---

# book_chapters

EPUB/TXT chapter structure.

```sql
CREATE TABLE book_chapters (

id INTEGER PRIMARY KEY AUTOINCREMENT,

book_id INTEGER NOT NULL,

chapter_index INTEGER NOT NULL,

title TEXT,

content_path TEXT,

word_count INTEGER,

created_at INTEGER,

FOREIGN KEY(book_id)
REFERENCES books(id)
ON DELETE CASCADE
);
```

Index

```sql
CREATE INDEX idx_chapter_book
ON book_chapters(book_id);
```

---

# reading_progress

Current reading position.

```sql
CREATE TABLE reading_progress (

id INTEGER PRIMARY KEY AUTOINCREMENT,

book_id INTEGER NOT NULL,

chapter_index INTEGER,

page_number INTEGER,

scroll_position REAL,

progress_percent REAL,

reading_minutes INTEGER DEFAULT 0,

updated_at INTEGER NOT NULL,

FOREIGN KEY(book_id)
REFERENCES books(id)
ON DELETE CASCADE
);
```

---

# highlights

Most important table.

```sql
CREATE TABLE highlights (

id INTEGER PRIMARY KEY AUTOINCREMENT,

uuid TEXT NOT NULL UNIQUE,

book_id INTEGER NOT NULL,

chapter_index INTEGER,

page_number INTEGER,

selected_text TEXT NOT NULL,

start_offset INTEGER,

end_offset INTEGER,

highlight_color TEXT,

created_at INTEGER NOT NULL,

updated_at INTEGER NOT NULL,

FOREIGN KEY(book_id)
REFERENCES books(id)
ON DELETE CASCADE
);
```

Indexes

```sql
CREATE INDEX idx_highlight_book
ON highlights(book_id);

CREATE INDEX idx_highlight_created
ON highlights(created_at);
```

---

# notes

Notes attached to highlights.

```sql
CREATE TABLE notes (

id INTEGER PRIMARY KEY AUTOINCREMENT,

highlight_id INTEGER NOT NULL,

content TEXT NOT NULL,

created_at INTEGER NOT NULL,

updated_at INTEGER NOT NULL,

FOREIGN KEY(highlight_id)
REFERENCES highlights(id)
ON DELETE CASCADE
);
```

---

# tags

User-defined tags.

```sql
CREATE TABLE tags (

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL UNIQUE,

created_at INTEGER NOT NULL
);
```

Examples

Reading

Wisdom

Business

Philosophy

AI

Life

---

# highlight_tags

Many-to-many relation.

```sql
CREATE TABLE highlight_tags (

highlight_id INTEGER NOT NULL,

tag_id INTEGER NOT NULL,

PRIMARY KEY(highlight_id, tag_id),

FOREIGN KEY(highlight_id)
REFERENCES highlights(id)
ON DELETE CASCADE,

FOREIGN KEY(tag_id)
REFERENCES tags(id)
ON DELETE CASCADE
);
```

---

# poster_templates

Built-in templates.

```sql
CREATE TABLE poster_templates (

id INTEGER PRIMARY KEY AUTOINCREMENT,

template_key TEXT UNIQUE,

name TEXT,

preview_image TEXT,

is_premium INTEGER DEFAULT 0
);
```

Default

minimal

paper

dark

cover

---

# generated_posters

Generated poster history.

```sql
CREATE TABLE generated_posters (

id INTEGER PRIMARY KEY AUTOINCREMENT,

highlight_id INTEGER NOT NULL,

template_key TEXT,

ratio TEXT,

image_path TEXT,

created_at INTEGER NOT NULL,

FOREIGN KEY(highlight_id)
REFERENCES highlights(id)
ON DELETE CASCADE
);
```

---

# favorites

Favorite highlights.

```sql
CREATE TABLE favorites (

id INTEGER PRIMARY KEY AUTOINCREMENT,

highlight_id INTEGER NOT NULL UNIQUE,

created_at INTEGER NOT NULL,

FOREIGN KEY(highlight_id)
REFERENCES highlights(id)
ON DELETE CASCADE
);
```

---

# collections

Custom quote collections.

```sql
CREATE TABLE collections (

id INTEGER PRIMARY KEY AUTOINCREMENT,

name TEXT NOT NULL,

description TEXT,

created_at INTEGER NOT NULL
);
```

Examples

Best Quotes

2026 Reading

Startup Ideas

人生感悟

---

# collection_items

Collection relation.

```sql
CREATE TABLE collection_items (

collection_id INTEGER,

highlight_id INTEGER,

PRIMARY KEY(collection_id, highlight_id),

FOREIGN KEY(collection_id)
REFERENCES collections(id)
ON DELETE CASCADE,

FOREIGN KEY(highlight_id)
REFERENCES highlights(id)
ON DELETE CASCADE
);
```

---

# bookmarks

Reading bookmarks.

```sql
CREATE TABLE bookmarks (

id INTEGER PRIMARY KEY AUTOINCREMENT,

book_id INTEGER NOT NULL,

chapter_index INTEGER,

page_number INTEGER,

note TEXT,

created_at INTEGER NOT NULL,

FOREIGN KEY(book_id)
REFERENCES books(id)
ON DELETE CASCADE
);
```

---

# search_history

Recent searches.

```sql
CREATE TABLE search_history (

id INTEGER PRIMARY KEY AUTOINCREMENT,

keyword TEXT NOT NULL,

created_at INTEGER NOT NULL
);
```

---

# user_settings

Local settings.

```sql
CREATE TABLE user_settings (

key TEXT PRIMARY KEY,

value TEXT
);
```

Examples

theme

font_size

language

line_height

page_mode

---

# purchase_status

IAP state.

```sql
CREATE TABLE purchase_status (

id INTEGER PRIMARY KEY,

product_id TEXT,

purchase_token TEXT,

is_active INTEGER,

purchased_at INTEGER,

expires_at INTEGER
);
```

For V1

Only one-time purchase.

---

# analytics_events

Local analytics cache.

```sql
CREATE TABLE analytics_events (

id INTEGER PRIMARY KEY AUTOINCREMENT,

event_name TEXT,

payload TEXT,

created_at INTEGER
);
```

---

# sync_queue

Future cloud sync.

```sql
CREATE TABLE sync_queue (

id INTEGER PRIMARY KEY AUTOINCREMENT,

entity_type TEXT,

entity_id INTEGER,

action TEXT,

created_at INTEGER
);
```

Actions

create

update

delete

---

# app_metadata

Internal app info.

```sql
CREATE TABLE app_metadata (

key TEXT PRIMARY KEY,

value TEXT
);
```

Examples

db_version

last_backup_time

first_launch_time

---

# Full Text Search

Critical Requirement

Use SQLite FTS5

---

# highlights_fts

```sql
CREATE VIRTUAL TABLE highlights_fts
USING fts5(

selected_text,

content='highlights',

content_rowid='id'
);
```

Search Targets

Highlight Text

Notes

Book Title

Author

---

# Drift Migration Strategy

Version 1

Initial Release

---

Version 2

Cloud Sync

---

Version 3

AI Classification

---

Version 4

Kindle Import

---

# Backup Strategy

Export JSON

Export ZIP

Restore ZIP

Restore JSON

---

# Data Retention

All user data remains local.

No automatic upload.

No reading content collection.

---

# Performance Targets

Books

10,000+

Highlights

1,000,000+

Search

<100ms

Poster Generation

<1s

Database Open

<200ms

---

# Final Rule

Every table must:

Support migration.

Support future sync.

Support offline use.

Support export/import.

Never depend on a server.
