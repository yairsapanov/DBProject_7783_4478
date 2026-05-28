# Database Project - Phase A ♟️
**Chess Tournament Management System - Engines, Bots, and UIs (Department 4)**

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
Our project focuses on the technological infrastructure behind a chess tournament management system. Our department (Department 4) is responsible for managing the heavy computational servers (HardwareNodes), the chess engines running on them (such as Stockfish and Komodo), and the automated bots utilizing these engines at various difficulty levels.

Additionally, the system manages access to different user interfaces (UIClient - Mobile & Web) and maintains a massive database of opening positions (OpeningPosition) alongside the engines' evaluations for these positions (EngineEvaluation).

[**Click here to view the full Data Dictionary and Specification Document (PDF)**](./Stage_1/Data_Dictionary.pdf)

---

## User Interface (UI) Mockups
We built an HTML/CSS Dashboard mockup displaying the core entities of our project:

1. **Bot Management (Bots):** A list of active bots, their linked engines, and difficulty levels.
   ![click here to view](./Stage_1/image.png)

2. **Server Monitor (Telemetry):** Real-time tracking of temperature and CPU usage for our computational servers.
   ![click here to view](./Stage_1/image-1.png)

3. **Engine Evaluations Explorer:** An interface featuring a graphical chessboard that allows searching for a FEN string of an opening position to get the best move evaluated by the engines.
   ![click here to view](./Stage_1/image-2.png)

4. **Add Engine:** A form for inserting a new engine into the database and linking it to supported interfaces.
   ![click here to view](./Stage_1/image-3.png)

---

## Diagrams & Design Decisions

### Entity-Relationship Diagram (ERD)
In this project, we incorporated a **Weak Entity** (HardwareTelemetry, which relies on HardwareNode), an **Inheritance** hierarchy (UIClient as the supertype, MobileClient and WebClient as subtypes), and a **Many-to-Many (M:N) relationship** between Engine and UIClient, represented by the `Engine_UI_Support` junction table.

![ERD Diagram](./Stage_1/erd.png)

### Relational Schema (DSD)
Mapping of the database tables and foreign keys.
![Relational Schema Diagram](./Stage_1/schema.png)

---

## Data Population
As required, we populated the database using 3 different methods:

1. **Manual Insertion (SQL Script):** Writing manual `INSERT` queries for the base tables and relationship tables (found in `insertTables.sql`).
2. **Using Mockaroo:** Generating approximately 500 automated rows for the Bot table.
   ![Mockaroo Proof](./Stage_1/mockarooScreenshot.png)
3. **Big Data Insertion via Python:**
   We wrote a Python script that generates 40,000 rows for the `OpeningPosition` and `HardwareTelemetry` tables to test load capacity.
   ![Python Execution Proof](./Stage_1/pythonEXEProof.png)

---

## Database Backup
The code was successfully executed on a PostgreSQL server (version 16+) via the pgAdmin interface. All tables were created, foreign key constraints were enforced, and data successfully populated the system. 
The full database backup file is included in the repository as `Backup.sql`.

![Successful Backup Proof](./Stage_1/BackupScreenshot.png)

---

# Phase B: Database Queries, DML & Optimization 🚀

In this phase of the project, we performed complex querying of the database, added constraints to maintain data integrity, and optimized performance using indexes. All queries incorporate grouping, sorting, sub-queries, and date extraction functions (`EXTRACT`).

## 1. Select Queries

### Dual Queries (Performance Comparison)

**Query 1: Find Active Engines in a Specific Year**
* **Description:** This query retrieves the names and versions of engines that performed deep evaluations (depth > 25) during the year 2023. This information is displayed on the Engine Management screen to identify relevant engines.
* **Efficiency Comparison:** The query was written first using `JOIN` with `DISTINCT`, and secondly using `EXISTS`. The `EXISTS` method (Query 1.B) is significantly more efficient in a one-to-many relationship, as it stops scanning the massive evaluation table once the first match is found for an engine, saving the database from performing a heavy sorting/distinct operation.
* ![Query 1.A - JOIN](./Stage_2/Screenshots/Queries/1.A.png)
* ![Query 1.B - EXISTS](./Stage_2/Screenshots/Queries/1.B.png)

**Query 2: High Difficulty Bots on Local Engines**
* **Description:** Displays the details of bots (name, difficulty, creation date) with a difficulty level of 8 or higher that are running exclusively on local engines.
* **Efficiency Comparison:** Written using a `JOIN` versus a sub-query with `IN`. When we only need data from one table (Bots) and just need to verify existence in another (LocalEngine), using `IN` avoids the heavy physical joining of all rows between the two tables, thus improving performance.
* ![Query 2.A - JOIN](./Stage_2/Screenshots/Queries/2.A.png)
* ![Query 2.B - IN](./Stage_2/Screenshots/Queries/2.B.png)

**Query 3: UIs Supporting Stockfish or Komodo**
* **Description:** Finds UI clients (Web/Mobile) that support the most popular engines (Stockfish or Komodo Dragon).
* **Efficiency Comparison:** Written using a double `JOIN` versus a nested `EXISTS`. The `EXISTS` method prevents row duplication for interfaces that support both engines simultaneously, making the `DISTINCT` keyword unnecessary and improving execution time.
* ![Query 3.A - JOIN](./Stage_2/Screenshots/Queries/3.A.png)
* ![Query 3.B - EXISTS](./Stage_2/Screenshots/Queries/3.B.png)

**Query 4: Hardware Nodes Hosting Multi-Threaded Engines**
* **Description:** Retrieves physical hardware servers hosting local engines that are configured to run with more than 16 threads.
* **Efficiency Comparison:** Compares a multi-table `JOIN` sequence with deeply nested `IN` sub-queries.
* ![Query 4.A - JOIN](./Stage_2/Screenshots/Queries/4.A.png)
* ![Query 4.B - Nested IN](./Stage_2/Screenshots/Queries/4.B.png)

### Complex Queries

**Query 5: Monthly Telemetry Averages**
* **Description:** Displays the average temperature and CPU usage for each server, grouped by month and year. Utilizes `EXTRACT` and `GROUP BY` extensively.
* ![Query 5](./Stage_2/Screenshots/Queries/5.png)

**Query 6: Engine Evaluation Statistics**
* **Description:** Shows the total number of evaluations and the maximum search depth reached for each engine that analyzed more than 100 positions (`HAVING`).
* ![Query 6](./Stage_2/Screenshots/Queries/6.png)

**Query 7: Top Openings and Recommended Moves**
* **Description:** Joins the Opening, Evaluation, and Engine tables to display the opening lines that received the highest centipawn advantage scores.
* ![Query 7](./Stage_2/Screenshots/Queries/7.png)

**Query 8: Bot Creation by Month**
* **Description:** Counts how many new automated bots were created in the system, grouped by month and year.
* ![Query 8](./Stage_2/Screenshots/Queries/8.png)

---

## 2. DML Queries (Update & Delete)

**Update 1: Upgrade Difficulty for Stockfish Bots**
* **Description:** Updates the difficulty level to 10 for all bots running Stockfish engines that were previously below level 10.
* **Before:** ![Update 1 Before](./Stage_2/Screenshots/Queries/bot_to_change.png)
* **Execution:** ![Update 1 Run](./Stage_2/Screenshots/Queries/bot_change.png)
* **After:** ![Update 1 After](./Stage_2/Screenshots/Queries/bot_after_change.png)

**Update 2: Increase RAM for Old US-East Servers**
* **Description:** Adds 128GB of RAM to servers located in the US-East zone that currently have less than 512GB of RAM.
* **Before:** ![Update 2 Before](./Stage_2/Screenshots/Queries/Node_to_change.png)
* **Execution:** ![Update 2 Run](./Stage_2/Screenshots/Queries/Node_change.png)
* **After:** ![Update 2 After](./Stage_2/Screenshots/Queries/Node_after_change.png)

**Update 3: Score Bonus for Deep 2023 Evaluations**
* **Description:** Adds a 15-centipawn bonus to the evaluation score for deep searches (depth >= 25) computed during the year 2023.
* **Before:** ![Update 3 Before](./Stage_2/Screenshots/Queries/Eval_to_change.png)
* **Execution:** ![Update 3 Run](./Stage_2/Screenshots/Queries/Eval_change.png)
* **After:** ![Update 3 After](./Stage_2/Screenshots/Queries/Eval_after_change.png)

**Delete 1: Remove Old & Weak Bots**
* **Description:** Deletes bots created in or before 2023 that have a difficulty level of 2 or lower.
* **Before:** ![Delete 1 Before](./Stage_2/Screenshots/Queries/Del1before.png)
* **Execution:** ![Delete 1 Run](./Stage_2/Screenshots/Queries/Del1.png)
* **After:** ![Delete 1 After](./Stage_2/Screenshots/Queries/Del1after.png)

**Delete 2: Clean Up Telemetry Anomalies**
* **Description:** Removes telemetry log anomalies from 2024 showing servers running over 75°C with CPU usage above 75%.
* **Before:** ![Delete 2 Before](./Stage_2/Screenshots/Queries/Del2before.png)
* **Execution:** ![Delete 2 Run](./Stage_2/Screenshots/Queries/Del2.png)
* **After:** ![Delete 2 After](./Stage_2/Screenshots/Queries/Del2after.png)

**Delete 3: Deprecate Legacy Web UI Support**
* **Description:** Deletes support records for Web UIs released before the year 2026.
* **Before:** ![Delete 3 Before](./Stage_2/Screenshots/Queries/Del3before.png)
* **Execution:** ![Delete 3 Run](./Stage_2/Screenshots/Queries/Del3.png)
* **After:** ![Delete 3 After](./Stage_2/Screenshots/Queries/Del3after.png)

---

## 3. Constraints
We implemented 3 database constraints (`Constraints.sql`) to maintain strict data integrity.
1. **Valid Evaluation Date (`CHECK`):** Ensures that the computed date of an engine evaluation is not set in the future.
   * ![Constraint 1 Error](./Stage_2/Screenshots/Constraints/Con1.png)
2. **Minimum Hardware RAM (`CHECK`):** Prevents the insertion of computational nodes with less than 16GB of RAM.
   * ![Constraint 2 Error](./Stage_2/Screenshots/Constraints/Con2.png)
3. **Prevent Duplicate Bot Names (`UNIQUE`):** Restricts the same engine from operating two distinct bots with identical display names.
   * ![Constraint 3 Error](./Stage_2/Screenshots/Constraints/Con3.png)

---

## 4. Indexes & Optimization
To optimize query execution times across our Big Data tables, we added 3 indexes (`Index.sql`). **Motivation & Performance Impact:**

1. **Telemetry Date Index:** The `HardwareTelemetry` table contains tens of thousands of rows. System monitoring relies heavily on timestamp filtering. Indexing the `time_stamp` column significantly reduced query execution time.
   * **Before:** ![Index 1 Before](./Stage_2/Screenshots/Index/In1before.png) | **After:** ![Index 1 After](./Stage_2/Screenshots/Index/In1after.png)
2. **Evaluation Score Index:** To quickly retrieve the best chess lines from the massive `EngineEvaluation` table, we applied an index on the `eval_score_cp` column, skipping full sequential scans.
   * **Before:** ![Index 2 Before](./Stage_2/Screenshots/Index/In2before.png) | **After:** ![Index 2 After](./Stage_2/Screenshots/Index/In2after.png)
3. **Foreign Key Index (Bot -> Engine):** PostgreSQL does not automatically index foreign keys. Creating a manual index on `engine_id` in the `Bot` table drastically accelerated `JOIN` operations between the two tables.
   * **Before:** ![Index 3 Before](./Stage_2/Screenshots/Index/In3before.png) | **After:** ![Index 3 After](./Stage_2/Screenshots/Index/In3after.png)

---

## 5. Transactions (Rollback & Commit)
Demonstration of database transaction management (`RollbackCommit.sql`) to ensure atomicity and error handling:
1. **Rollback (Server Memory Update Reversal):** We initiated an update to increase a server's RAM from 256GB to 1024GB, then executed a `ROLLBACK` to revert the table to its initial state.
   * **Initial State:** ![Rollback Before](./Stage_2/Screenshots/Rollback/R1before.png)
   * **Mid-Transaction:** ![Rollback Mid](./Stage_2/Screenshots/Rollback/R1.png)
   * **Reverted State:** ![Rollback After](./Stage_2/Screenshots/Rollback/R1after.png)
2. **Commit (Permanent Bot Update):** We upgraded a bot's difficulty to level 9 and executed a `COMMIT` to permanently save the changes to the database.
   * **Initial State:** ![Commit Before](./Stage_2/Screenshots/Rollback/R2before.png)
   * **Mid-Transaction:** ![Commit Mid](./Stage_2/Screenshots/Rollback/R2.png)
   * **Saved State:** ![Commit After](./Stage_2/Screenshots/Rollback/R2after.png)