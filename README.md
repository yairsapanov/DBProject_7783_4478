# Database Project - Phase A ♟️
**Chess Tournament Management System - Engines, Bots, and UIs**

**Submitted by:**
* Yair Sapanov (ID: 216737783)
* Daniel Sasson (ID: 217464478)
* Academic Institution: Jerusalem College of Technology (Machon Lev)

---

## Table of Contents
1. [Introduction & System Architecture](#introduction--system-architecture)
2. [User Interface (UI) Mockups](#user-interface-ui-mockups)
3. [Diagrams & Design Decisions](#diagrams--design-decisions)
4. [Data Population](#data-population)
5. [Database Backup](#database-backup)

---

## Introduction & System Architecture
Our project focuses on the technological infrastructure behind a chess tournament management system. We manage physical computational servers (HardwareNodes), the chess engines running on them (LocalEngine) or accessed remotely (CloudEngine), and automated bots utilizing these engines. 

The system architecture was finalized at **12 tables**, ensuring strict adherence to relational database principles, including:
* Unified interface management (UIClient).
* Disjoint inheritance for engines (Local vs. Cloud).
* Weak entity management (ServerComponent).
* Many-to-Many relationships (Engine_UI_Support, Installed_On).

[**Click here to view the full Data Dictionary and Specification Document (PDF)**](./Stage_1/Data_Dictionary.pdf)

---

## User Interface (UI) Mockups
*The initial HTML/CSS prototype for these screens was designed and generated using Google AI Studio.*
👉 **[Click here to view the Google AI Studio Prompt & Generation](https://ai.studio/apps/a5e57c20-f100-45bc-9296-17f3dcfbc5b2)**

We built an HTML/CSS Dashboard mockup displaying the core entities of our project:
1. **Bot Management:** A list of active bots, their linked engines, and difficulty levels.
2. **Server Monitor:** Real-time tracking of temperature and CPU usage for our computational servers.
3. **Engine Evaluations Explorer:** An interface featuring a chessboard to search for opening positions (FEN) and engine evaluations.
4. **Add Engine:** A form for inserting a new engine and linking it to supported interfaces.

---

## Diagrams & Design Decisions

### Entity-Relationship Diagram (ERD)
Our final schema resolved previous design issues by:
* **Flattening UI Inheritance:** Moving from complex sub-classes to a unified `UIClient` table for better maintainability.
* **Weak Entity Implementation:** Introduced `ServerComponent` as a weak entity dependent on `HardwareNode` (utilizing `ON DELETE CASCADE`).
* **Relationship Junctions:** Added `Installed_On` and `Engine_UI_Support` to handle M:N relationships correctly.

![ERD Diagram](./Stage_1/erd.png)

### Relational Schema (DSD)
Mapping of the 12-table database tables and foreign keys.
![Relational Schema Diagram](./Stage_1/schema.png)

---

## Data Population
We populated the database using 3 methods to ensure realistic volume and integrity:

1. **Manual Insertion (`insertTables.sql`):** Essential SQL scripts for infrastructure data (20 HardwareNodes, 20 Engines, OpeningPositions).
2. **Mockaroo:** Generating 500+ automated rows for the `Bot` table to simulate a realistic user environment.
3. **Big Data Insertion via Python:**
   A custom Python script was developed to generate high-volume data:
   * **HardwareTelemetry:** ~21,900 rows (20 servers, daily logs for 3 years).
   * **EngineEvaluation:** ~25,000 rows, utilizing batch processing for optimized insertion.

![Python Execution Proof](./Stage_1/pythonEXEProof.png)

---

## Database Backup
The code was executed on PostgreSQL (version 16+). All tables were created with strict constraints (CHECK, NOT NULL), and foreign key integrity was verified during population.
The full database backup file is included in the repository as `Backup.sql`.

![Successful Backup Proof](./Stage_1/BackupScreenshot.png)
