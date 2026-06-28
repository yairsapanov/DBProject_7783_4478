## 🎨 Phase E: Graphical User Interface (GUI) 

In the final phase of the project, we developed a modern, interactive Web Application to interface with our PostgreSQL database. We bypassed traditional, clunky desktop frameworks in favor of a sleek, browser-based dashboard.

The application features **Role-Based Access Control (RBAC)**, routing users to specific dashboards based on their administrative clearance, ensuring a clean and secure user experience.

### 🛠️ Technology Stack
* **Language:** Python 3
* **GUI Framework:** `Streamlit` (for rapid web-app development and modern UI components)
* **Database Adapter:** `psycopg2` (for executing SQL queries and DML operations)
* **Data Handling:** `Pandas` (for converting SQL outputs into formatted, borderless dataframes)

### 🚀 How to Run the Application
1. Ensure Python is installed on your local machine.
2. Open your terminal and install the required dependencies:
   ```bash
   pip install streamlit psycopg2 pandas
   ```
3. Navigate to the project directory containing `app.py` and `db_connection.py`.
4. Run the application using the following command:
   ```bash
   streamlit run app.py
   ```
5. The application will automatically open in your default web browser (typically at `http://localhost:8501`).

---

### 1. System Admin Dashboard (`Role: System Admin`)
This dashboard is dedicated to high-level analytics and executing core database routines. It demonstrates the integration of Phase B (Queries) and Phase D (PL/pgSQL) directly into the UI.

* **Advanced Analytics (Phase B Integration):**
  * **Top Players Query:** Filters and orders the highest ELO players.
    ![Top Players](screenshots/screen1/F1.png)
  * **Tournament Stats Query:** Uses `GROUP BY` and `JOIN` to display registration counts per tournament.
    ![Tourney Stats](screenshots/screen1/F2.png)
    *(Main Analytics View: ![Analytics UI](screenshots/screen1/S1.png))*

* **System Operations (Phase D Integration):**
  * **Calculate Score (Function):** Executes `fn_calculate_player_score`. Features a UI pre-check to prevent DB crashes if a player isn't registered.
    * *Validation Failure (Player not registered):* ![Validation](screenshots/screen1/PR1A.png)
    * *Execution Success:* ![Success](screenshots/screen1/PR1B.png)
  * **Promote Active Players (Procedure):** Executes `pr_promote_active_players` via UI input.
    * *Execution:* ![Proc 2](screenshots/screen1/PR2.png)
    * *Proof of DB Change:* ![Proc 2 Proof](screenshots/screen1/PR2P.png)
    *(Main Operations View: ![Operations UI](screenshots/screen1/S2.png))*

---

### 2. Tournament Organizer Dashboard (`Role: Tournament Organizer`)
This dashboard handles the core CRUD operations for the human/bot players and tournament entities, strictly adhering to UX/UI database requirements.

* **Foreign Key Value Resolution (JOINs):** Instead of displaying raw `bot_id` or `club_id`, the UI performs SQL `JOIN`s to display the actual Bot Names and Club Names.
  * **View Players:** ![View Players](screenshots/screen2/S1.png)
  * **View Tournaments:** ![View Tournaments](screenshots/screen2/S5.png)

* **Fetch-Before-Update Logic:** When updating a record, the user inputs the ID, clicks "Fetch", and the system retrieves the existing row data to pre-fill the update form.
  * **Update Player (Fetch & Form):** ![Update Fetch](screenshots/screen2/S3.png) | ![Update Form](screenshots/screen2/S3-2.png)
  * **Update Proof:** ![Update Proof](screenshots/screen2/S3P.png)

* **Insert & Delete Operations:**
  * **Add Player:** ![Add Player](screenshots/screen2/S2.png) | *Proof:* ![Add Proof](screenshots/screen2/S2P.png)
  * **Delete Player:** ![Delete Player](screenshots/screen2/S4.png) | *Proof:* ![Delete Proof](screenshots/screen2/S4P.png)

---

### 3. Hardware Technician Dashboard (`Role: Hardware Technician`)
An advanced feature set allowing IT technicians to monitor the physical infrastructure that powers the chess engines and bots.

* **Live Telemetry Monitoring:** Fetches the latest system loads (CPU, RAM, Temps) joining the `hardwaretelemetry` and `hardwarenode` tables.
  * ![Telemetry View](screenshots/screen3/S1.png)
* **Node Infrastructure Management (CRUD):** * **View Active Nodes:** ![View Nodes](screenshots/screen3/S2.png)
  * **Register New Server Node:** ![Add Node](screenshots/screen3/S3.png) | *Proof:* ![Add Proof](screenshots/screen3/S3P.png)
  * **Update Server Specs:** ![Update Node](screenshots/screen3/S4.png) | *Proof:* ![Update Proof](screenshots/screen3/S4P.png)
  * **Decommission/Delete Node:** ![Delete Node](screenshots/screen3/S5.png) | *Proof:* ![Delete Proof](screenshots/screen3/S5P.png)

---
*End of Project Documentation.*