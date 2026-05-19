import random
from datetime import datetime, timedelta

def generate_telemetry_data(num_servers=20, days=1095):
    # Generate 3 years of daily telemetry for hardware nodes
    inserts = []
    start_date = datetime(2023, 1, 1)
    telemetry_id = 1
    
    for day in range(days):
        current_date = start_date + timedelta(days=day)
        date_str = current_date.strftime('%Y-%m-%d %H:%M:%S')
        
        for node_id in range(1, num_servers + 1):
            temp = round(random.uniform(35.0, 85.0), 2)
            cpu = round(random.uniform(10.0, 95.0), 2)
            ram = round(random.uniform(20.0, 90.0), 2)
            disk = random.randint(500, 5000)
            
            sql = f"INSERT INTO HardwareTelemetry (telemetry_id, node_id, time_stamp, temp_celsius, cpu_usage_pct, ram_usage_pct, disk_io_ops) VALUES ({telemetry_id}, {node_id}, '{date_str}', {temp}, {cpu}, {ram}, {disk});"
            inserts.append(sql)
            telemetry_id += 1
            
    return inserts

def generate_evaluations(num_evals=25000):
    # Generate 25000 engine evaluations
    inserts = []
    eval_id = 1
    
    moves = ['e2e4', 'd2d4', 'g1f3', 'c2c4', 'e7e5', 'c7c5', 'g8f6']
    
    for i in range(num_evals):
        # Assume we have 10 engines and 50 opening positions created manually later
        engine_id = random.randint(1, 10) 
        fen_id = random.randint(1, 50) 
        depth = random.randint(15, 30)
        move = random.choice(moves)
        score = random.randint(-150, 150)
        
        day_offset = random.randint(0, 360)
        comp_date = (datetime(2023, 1, 1) + timedelta(days=day_offset)).strftime('%Y-%m-%d')
        
        sql = f"INSERT INTO EngineEvaluation (eval_id, engine_id, fen_id, search_depth, best_move_pgn, eval_score_cp, computed_date) VALUES ({eval_id}, {engine_id}, {fen_id}, {depth}, '{move}', {score}, '{comp_date}');"
        inserts.append(sql)
        eval_id += 1
        
    return inserts

# Execute generation and write to file
print("Generating big data...")
telemetry_sql = generate_telemetry_data()
evaluation_sql = generate_evaluations()

with open('insert_large.sql', 'w') as f:
    f.write("-- HardwareTelemetry Big Data\n")
    for line in telemetry_sql:
        f.write(line + "\n")
        
    f.write("\n-- EngineEvaluation Big Data\n")
    for line in evaluation_sql:
        f.write(line + "\n")

total_rows = len(telemetry_sql) + len(evaluation_sql)
print(f"Success! File 'insert_large.sql' generated with {total_rows} rows.")