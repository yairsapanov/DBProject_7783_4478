# Phase B: Advanced Database Queries & Optimization

This phase includes complex data querying, DML operations, integrity constraints, and performance tuning using indexes.

## 1. Select Queries

**Query 1: Active engines in 2023**
* Execution with JOIN: ![Query 1A](./Screenshots/Queries/1.A.png)
* Execution with EXISTS (More efficient): ![Query 1B](./Screenshots/Queries/1.B.png)

**Query 2: High difficulty bots on local engines**
* Execution with JOIN: ![Query 2A](./Screenshots/Queries/2.A.png)
* Execution with IN (Faster for single-table reads): ![Query 2B](./Screenshots/Queries/2.B.png)

**Query 3: UIs supporting Stockfish/Komodo**
* Execution with JOIN: ![Query 3A](./Screenshots/Queries/3.A.png)
* Execution with EXISTS (Prevents duplicates): ![Query 3B](./Screenshots/Queries/3.B.png)

**Query 4: Hardware nodes with high threads**
* Execution with JOIN: ![Query 4A](./Screenshots/Queries/4.A.png)
* Execution with Nested IN: ![Query 4B](./Screenshots/Queries/4.B.png)

**Query 5: Monthly telemetry averages**
* Grouped averages using EXTRACT: ![Query 5](./Screenshots/Queries/5.png)

**Query 6: Engine evaluation statistics**
* Aggregation filtered with HAVING: ![Query 6](./Screenshots/Queries/6.png)

**Query 7: Top evaluated opening positions**
* High centipawn advantage openings: ![Query 7](./Screenshots/Queries/7.png)

**Query 8: Bot creation timeline**
* Chronological grouping of new bots: ![Query 8](./Screenshots/Queries/8.png)

---

## 2. DML Queries (Update & Delete)

**Update 1: Upgrade Stockfish bots difficulty**
* State before update: ![Up1 Before](./Screenshots/Queries/Up1B.png)
* Executing the update: ![Up1 Execute](./Screenshots/Queries/Up1.png)
* State after update: ![Up1 After](./Screenshots/Queries/Up1A.png)

**Update 2: Upgrade RAM for US-East servers**
* State before update: ![Up2 Before](./Screenshots/Queries/Up2B.png)
* Executing the update: ![Up2 Execute](./Screenshots/Queries/Up2.png)
* State after update: ![Up2 After](./Screenshots/Queries/Up2A.png)

**Update 3: Add bonus to 2023 deep searches**
* State before update: ![Up3 Before](./Screenshots/Queries/Up3B.png)
* Executing the update: ![Up3 Execute](./Screenshots/Queries/Up3.png)
* State after update: ![Up3 After](./Screenshots/Queries/Up3A.png)

**Delete 1: Remove weak legacy bots**
* State before deletion: ![Del1 Before](./Screenshots/Queries/Del1B.png)
* Executing the deletion: ![Del1 Execute](./Screenshots/Queries/Del1.png)
* State after deletion: ![Del1 After](./Screenshots/Queries/Del1A.png)

**Delete 2: Clear extreme thermal anomalies**
* State before deletion: ![Del2 Before](./Screenshots/Queries/Del2B.png)
* Executing the deletion: ![Del2 Execute](./Screenshots/Queries/Del2.png)
* State after deletion: ![Del2 After](./Screenshots/Queries/Del2A.png)

**Delete 3: Deprecate legacy Web UI support**
* State before deletion: ![Del3 Before](./Screenshots/Queries/Del3B.png)
* Executing the deletion: ![Del3 Execute](./Screenshots/Queries/Del3.png)
* State after deletion: ![Del3 After](./Screenshots/Queries/Del3A.png)

---

## 3. Database Constraints

**Constraint 1: Prevent future evaluation dates**
* Error thrown on invalid date: ![Constraint 1](./Screenshots/Constraints/Con1.png)

**Constraint 2: Minimum hardware RAM**
* Error thrown on low RAM insertion: ![Constraint 2](./Screenshots/Constraints/Con2.png)

**Constraint 3: Unique bot names per engine**
* Error thrown on duplicate bot name: ![Constraint 3](./Screenshots/Constraints/Con3.png)

---

## 4. Performance Optimization (Indexes)

**Index 1: Telemetry Time Stamp**
* Speed before indexing: ![In1 Before](./Screenshots/Index/In1B.png)
* Speed after indexing: ![In1 After](./Screenshots/Index/In1A.png)

**Index 2: Evaluation Score**
* Speed before indexing: ![In2 Before](./Screenshots/Index/In2B.png)
* Speed after indexing: ![In2 After](./Screenshots/Index/In2A.png)

**Index 3: Foreign Key (engine_id)**
* Speed before indexing: ![In3 Before](./Screenshots/Index/In3B.png)
* Speed after indexing: ![In3 After](./Screenshots/Index/In3A.png)

---

## 5. Transactions

**Transaction 1: Rollback**
* Initial server state: ![Rollback Before](./Screenshots/Rollback/R1B.png)
* Unsaved memory upgrade: ![Rollback Execution](./Screenshots/Rollback/R1.png)
* State reverted to original: ![Rollback After](./Screenshots/Rollback/R1A.png)

**Transaction 2: Commit**
* Initial bot state: ![Commit Before](./Screenshots/Rollback/C1B.png)
* Unsaved difficulty upgrade: ![Commit Execution](./Screenshots/Rollback/C1.png)
* State saved permanently: ![Commit After](./Screenshots/Rollback/C1A.png)