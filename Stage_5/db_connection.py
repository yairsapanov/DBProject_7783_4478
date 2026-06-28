import psycopg2
import pandas as pd
import streamlit as st

# Function to initialize database connection
@st.cache_resource
def init_connection():
    return psycopg2.connect(
        host="localhost",
        database="ChessDB",
        user="postgres",
        password="1234",
        port="5432"
    )

# Function to run queries and return pandas DataFrame
def run_query(query, params=None):
    conn = init_connection()
    try:
        if params:
            df = pd.read_sql_query(query, conn, params=params)
        else:
            df = pd.read_sql_query(query, conn)
        return df
    except Exception as e:
        st.error(f"Database Error: {e}")
        return None

# Function to run DML commands (INSERT, UPDATE, DELETE)
def execute_dml(query, params):
    conn = init_connection()
    with conn.cursor() as cur:
        try:
            cur.execute(query, params)
            conn.commit()
            return True, "Success"
        except Exception as e:
            conn.rollback()
            return False, str(e)