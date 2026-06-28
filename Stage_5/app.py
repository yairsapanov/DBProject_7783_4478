import streamlit as st
import db_connection as db

# Configure page settings
st.set_page_config(page_title="Chess DB Manager", page_icon="♟️", layout="wide")

def main():
    st.sidebar.title("♟️ Main Navigation")
    st.sidebar.write("Select your role:")
    
    # User role selection
    role = st.sidebar.radio("Role", ["System Admin", "Tournament Organizer", "Hardware Technician"])
    
    st.sidebar.divider()

    if role == "System Admin":
        show_system_admin_page()
    elif role == "Tournament Organizer":
        show_tournament_organizer_page()
    elif role == "Hardware Technician":
        show_technician_page()

def show_system_admin_page():
    st.title("🛡️ System Admin Dashboard")
    st.write("Welcome Admin. Run advanced analytical queries and execute core system procedures.")

    # חלוקה ל-2 לשוניות: שאילתות (שלב ב') ופרוצדורות (שלב ד')
    tab_queries, tab_procs = st.tabs(["📈 Advanced Analytics (Phase B)", "⚙️ System Operations (Phase D)"])

    # ==========================================
    # לשונית 1: שאילתות מתקדמות משלב ב'
    # ==========================================
    with tab_queries:
        st.subheader("Run Analytical Queries")
        col1, col2 = st.columns(2)
        
        with col1:
            st.info("Query 1: Top Players & Activity")
            if st.button("📊 Show Top 10 Players (By ELO)"):
                # שאילתה שמביאה את השחקנים המובילים, משלבת נתונים וסטטיסטיקה
                q1 = """
                    SELECT player_id, username, elo_rating, total_games_played
                    FROM player
                    ORDER BY elo_rating DESC
                    LIMIT 10;
                """
                df1 = db.run_query(q1)
                if df1 is not None:
                    st.dataframe(df1, use_container_width=True, hide_index=True)

        with col2:
            st.info("Query 2: Tournament Registrations Overview")
            if st.button("🏆 Show Tournaments Stats"):
                # שאילתת GROUP BY ו-JOIN לספירת משתתפים בכל טורניר
                q2 = """
                    SELECT t.tournament_id, t.name, t.status, COUNT(r.player_id) AS total_participants
                    FROM tournament t
                    LEFT JOIN registration r ON t.tournament_id = r.tournament_id
                    GROUP BY t.tournament_id, t.name, t.status
                    ORDER BY t.tournament_id;
                """
                df2 = db.run_query(q2)
                if df2 is not None:
                    st.dataframe(df2, use_container_width=True, hide_index=True)


    # ==========================================
    # לשונית 2: פונקציות ופרוצדורות משלב ד'
    # ==========================================
    with tab_procs:
        st.subheader("Execute PL/pgSQL Routines")
        
        col3, col4 = st.columns(2)

        # 1. הפעלת הפונקציה (Function) - חישוב ניקוד
        # 1. Function execution - Calculate Score
        with col3:
            with st.container(border=True):
                st.markdown("#### 🧮 Calculate Player Score")
                st.caption("Executes: fn_calculate_player_score(player_id, tourney_id)")
                
                calc_player_id = st.number_input("Player ID", min_value=1, step=1, key="calc_pid")
                calc_tourney_id = st.number_input("Tournament ID", min_value=1, step=1, key="calc_tid")
                
                if st.button("Calculate Score", type="primary"):
                    
                    # Pre-check: Verify if player is registered to avoid DB exceptions
                    check_q = "SELECT 1 FROM registration WHERE player_id = %s AND tournament_id = %s;"
                    check_res = db.run_query(check_q, (calc_player_id, calc_tourney_id))
                    
                    if check_res is None or check_res.empty:
                        st.warning(f"⚠️ Player {calc_player_id} is NOT registered for Tournament {calc_tourney_id}!")
                    else:
                        # Proceed with calling the DB function
                        q_func = "SELECT fn_calculate_player_score(%s, %s) AS score;"
                        try:
                            df_res = db.run_query(q_func, (calc_player_id, calc_tourney_id))
                            if df_res is not None and not df_res.empty:
                                score = df_res.iloc[0]['score']
                                st.success(f"**Success!** The total score for Player {calc_player_id} in Tournament {calc_tourney_id} is: **{score}**")
                                st.balloons() 
                        except Exception as e:
                            st.error(f"Execution Failed: {e}")

        # 2. הפעלת הפרוצדורה (Procedure) - קידום שחקנים
        with col4:
            with st.container(border=True):
                st.markdown("#### 🚀 Promote Active Players")
                st.caption("Executes: pr_promote_active_players(min_games)")
                st.write("Boost ELO for humans & difficulty for bots who played enough games.")
                
                min_games_input = st.number_input("Minimum Games Played to qualify", min_value=1, step=1, value=1)
                
                if st.button("Run Promotion Routine", type="primary"):
                    # בפרוצדורות משתמשים ב-CALL ולא ב-SELECT
                    q_proc = "CALL pr_promote_active_players(%s);"
                    success, msg = db.execute_dml(q_proc, (min_games_input,))
                    
                    if success:
                        st.success(f"**Routine Executed!** All entities with >= {min_games_input} games were promoted.")
                    else:
                        st.error(f"Execution Failed: {msg}")

def show_tournament_organizer_page():
    st.title("🏆 Tournament Organizer Dashboard")
    st.write("Manage Players, Tournaments, and Club affiliations.")

    # חלוקה ל-5 לשוניות (CRUD על שחקנים וצפייה בטורנירים)
    tab1, tab2, tab3, tab4, tab5 = st.tabs(["📋 View Players", "➕ Add Player", "✏️ Update Player", "❌ Delete Player", "🏟️ View Tournaments"])

    # ==========================================
    # READ: רשימת שחקנים (עם JOIN שמחליף ID בשם הבוט, אם קיים)
    # ==========================================
    with tab1:
        st.subheader("Registered Players Directory")
        # דרישת מרצה: לא להציג מפתחות זרים "יבשים" אלא ערכים
        query_players = """
            SELECT 
                p.player_id, 
                p.username, 
                p.elo_rating, 
                p.total_games_played,
                COALESCE(b.display_name, 'Human Player') AS player_type
            FROM player p
            LEFT JOIN bot b ON p.bot_id = b.bot_id
            ORDER BY p.player_id DESC;
        """
        df_players = db.run_query(query_players)
        if df_players is not None and not df_players.empty:
            st.dataframe(df_players, use_container_width=True, hide_index=True)
        else:
            st.info("No players found in the database.")

    # ==========================================
    # CREATE: הוספת שחקן חדש
    # ==========================================
    with tab2:
        st.subheader("Register New Human Player")
        with st.form("add_player_form", clear_on_submit=True):
            new_username = st.text_input("Username", max_chars=50)
            new_elo = st.number_input("Starting ELO Rating", min_value=0, max_value=3500, value=1200, step=10)
            submit_add = st.form_submit_button("Add Player")

            if submit_add:
                if not new_username:
                    st.error("Username cannot be empty!")
                else:
                    # מציאת ה-ID הבא
                    q_max = "SELECT COALESCE(MAX(player_id), 0) + 1 AS next_id FROM player"
                    next_id = db.run_query(q_max).iloc[0]['next_id']

                    insert_q = """
                        INSERT INTO player (player_id, username, elo_rating, total_games_played)
                        VALUES (%s, %s, %s, 0)
                    """
                    success, msg = db.execute_dml(insert_q, (int(next_id), new_username, new_elo))
                    if success:
                        st.success(f"Player '{new_username}' added successfully with ID {next_id}!")
                    else:
                        st.error(f"Database Error: {msg}")

    # ==========================================
    # UPDATE: עדכון שחקן (דרישת מרצה - משיכת הנתונים קודם)
    # ==========================================
    with tab3:
        st.subheader("Update Player Information")
        
        player_id_to_update = st.number_input("Enter Player ID to fetch", min_value=1, step=1, key="upd_pid")
        
        # שלב א': משיכת הנתונים (Fetch)
        if st.button("Fetch Player Details"):
            player_data = db.run_query("SELECT * FROM player WHERE player_id = %s", (player_id_to_update,))
            if player_data is not None and not player_data.empty:
                st.session_state['update_player_data'] = player_data.iloc[0]
            else:
                st.warning(f"Player ID {player_id_to_update} not found.")

        # שלב ב': הצגת הנתונים בטופס לעדכון
        if 'update_player_data' in st.session_state:
            curr_p = st.session_state['update_player_data']
            with st.form("update_player_form"):
                st.info(f"Editing Player: {curr_p['username']}")
                
                upd_username = st.text_input("Username", value=curr_p['username'])
                upd_elo = st.number_input("ELO Rating", min_value=0, value=int(curr_p['elo_rating']))
                upd_games = st.number_input("Total Games Played", min_value=0, value=int(curr_p['total_games_played']))
                
                submit_upd = st.form_submit_button("Save Changes")

                if submit_upd:
                    update_q = """
                        UPDATE player
                        SET username=%s, elo_rating=%s, total_games_played=%s
                        WHERE player_id=%s
                    """
                    success, msg = db.execute_dml(update_q, (upd_username, upd_elo, upd_games, player_id_to_update))
                    if success:
                        st.success("Player updated successfully!")
                        del st.session_state['update_player_data'] # ניקוי
                    else:
                        st.error(f"Update Failed: {msg}")

    # ==========================================
    # DELETE: מחיקת שחקן
    # ==========================================
    with tab4:
        st.subheader("Remove Player")
        player_id_to_delete = st.number_input("Enter Player ID to delete", min_value=1, step=1, key="del_pid")
        
        st.warning("Note: Deleting a player might fail if they are linked to existing game history.")
        if st.button("Delete Player", type="primary"):
            success, msg = db.execute_dml("DELETE FROM player WHERE player_id = %s", (player_id_to_delete,))
            if success:
                st.success("Player deleted successfully!")
            else:
                st.error(f"Cannot delete player. Error: {msg}")

    # ==========================================
    # READ: טורנירים (JOIN למועדונים)
    # ==========================================
    with tab5:
        st.subheader("Tournaments & Clubs Directory")
        # דרישת מרצה: לא להציג club_id, אלא את שם המועדון מתוך טבלת Club
        query_tourneys = """
            SELECT 
                t.tournament_id, 
                t.name AS tournament_name, 
                c.name AS club_name, 
                t.status,
                t.registration_open_date, 
                t.start_date
            FROM tournament t
            LEFT JOIN club c ON t.club_id = c.club_id
            ORDER BY t.start_date DESC;
        """
        df_tourneys = db.run_query(query_tourneys)
        if df_tourneys is not None and not df_tourneys.empty:
            st.dataframe(df_tourneys, use_container_width=True, hide_index=True)
        else:
            st.info("No tournaments found.")

def show_technician_page():
    st.title("🖥️ Hardware Technician Dashboard")
    st.write("Manage Bare-Metal Nodes and Monitor Live Telemetry.")

    # יצירת לשוניות עבור כל פעולות ה-CRUD
    tab1, tab2, tab3, tab4, tab5 = st.tabs(["📊 Live Telemetry", "📋 View Nodes", "➕ Add Node", "✏️ Update Node", "❌ Delete Node"])

    # --- READ (טלמטריה) ---
    with tab1:
        st.subheader("Latest Hardware Telemetry")
        query = """
            SELECT telemetry_id, h.node_id, cpu_usage_pct, time_stamp, temp_celsius, disk_io_ops, ram_usage_pct
            FROM "hardwaretelemetry" h
            JOIN "hardwarenode" n ON h.node_id = n.node_id
            ORDER BY time_stamp DESC;
        """
        df = db.run_query(query)
        if df is not None and not df.empty:
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No telemetry data found.")

    # --- READ (צפייה בשרתים) ---
    with tab2:
        st.subheader("Registered Nodes")
        df_nodes = db.run_query('SELECT * FROM "hardwarenode" ORDER BY node_id')
        if df_nodes is not None:
            st.dataframe(df_nodes, use_container_width=True, hide_index=True)

    # --- CREATE (הוספת שרת - מותאם בדיוק לתמונה) ---
    with tab3:
        st.subheader("Register New Node")
        with st.form("add_node_form", clear_on_submit=True):
            new_ip = st.text_input("IP Address")
            new_hostname = st.text_input("Hostname")
            new_cpu_cores = st.number_input("CPU Cores Number", min_value=1, step=1, value=8) # שונה למספר
            new_ram = st.number_input("RAM (GB)", min_value=1, max_value=512, value=16)
            new_zone = st.text_input("Datacenter Zone (e.g., us-east-1)") # הוסף השדה החסר
            new_os = st.text_input("OS Version")
            submit_add = st.form_submit_button("Add Node")

            if submit_add:
                # מציאת ה-ID הבא הפנוי
                q_max = 'SELECT COALESCE(MAX(node_id), 0) + 1 AS next_id FROM "hardwarenode"'
                next_id = db.run_query(q_max).iloc[0]['next_id']

                insert_q = """
                    INSERT INTO "hardwarenode" (node_id, ip_address, host_name, cpu_cores, ram_gb, datacenter_zone, os_version)
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                """
                success, msg = db.execute_dml(insert_q, (int(next_id), new_ip, new_hostname, int(new_cpu_cores), new_ram, new_zone, new_os))
                if success:
                    st.success(f"Node {new_ip} added successfully! Refresh to see changes.")
                else:
                    st.error(f"Error: {msg}")

    # --- UPDATE (עדכון שרת - מותאם בדיוק לתמונה) ---
    with tab4:
        st.subheader("Update Node Configuration")
        
        node_id_to_update = st.number_input("Enter Node ID to fetch", min_value=1, step=1)
        if st.button("Fetch Node Details"):
            node_data = db.run_query('SELECT * FROM "hardwarenode" WHERE node_id = %s', (node_id_to_update,))
            if node_data is not None and not node_data.empty:
                st.session_state['update_node_data'] = node_data.iloc[0]
            else:
                st.warning("Node not found in the database.")

        if 'update_node_data' in st.session_state:
            curr_data = st.session_state['update_node_data']
            with st.form("update_node_form"):
                # שאיבת הנתונים לעמודות האמיתיות שקיימות בטבלה
                upd_ip = st.text_input("IP Address", value=curr_data['ip_address'])
                upd_hostname = st.text_input("Hostname", value=curr_data['host_name'])
                upd_cpu = st.number_input("CPU Cores Number", min_value=1, step=1, value=int(curr_data['cpu_cores']))
                upd_ram = st.number_input("RAM (GB)", min_value=1, max_value=512, value=int(curr_data['ram_gb']))
                upd_zone = st.text_input("Datacenter Zone", value=curr_data['datacenter_zone'])
                upd_os = st.text_input("OS Version", value=curr_data['os_version'])
                submit_upd = st.form_submit_button("Save Changes")

                if submit_upd:
                    update_q = """
                        UPDATE "hardwarenode"
                        SET ip_address=%s, host_name=%s, cpu_cores=%s, ram_gb=%s, datacenter_zone=%s, os_version=%s
                        WHERE node_id=%s
                    """
                    success, msg = db.execute_dml(update_q, (upd_ip, upd_hostname, upd_cpu, upd_ram, upd_zone, upd_os, node_id_to_update))
                    if success:
                        st.success("Node updated successfully!")
                        del st.session_state['update_node_data']
                    else:
                        st.error(f"Error: {msg}")

    # --- DELETE (ללא שינוי, עבד לך מעולה) ---
    with tab5:
        st.subheader("Remove Node")
        node_id_to_delete = st.number_input("Enter Node ID to delete", min_value=1, step=1, key="del_node")
        if st.button("Delete Node", type="primary"):
            success, msg = db.execute_dml('DELETE FROM "hardwarenode" WHERE node_id = %s', (node_id_to_delete,))
            if success:
                st.success("Node deleted successfully!")
            else:
                st.error(f"Cannot delete node. It might be linked to existing telemetry data. Error: {msg}")

if __name__ == "__main__":
    main()