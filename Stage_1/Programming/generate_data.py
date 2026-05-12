import random
from datetime import datetime, timedelta

def generate_mock_data():
    filename = "insert_large.sql"
    print("⏳ Generating mock data...")

    with open(filename, "w", encoding="utf-8") as f:
        f.write("-- Automated script for generating massive mock data - 40,000 rows\n\n")

        # --- 1. OpeningPosition Table (20,000 rows) ---
        f.write("-- Generating 20,000 opening positions (OpeningPosition)\n")
        # FIXED: Added double single-quotes ('') to escape the apostrophe in SQL!
        openings = [
            ("C20", "King''s Pawn Game"), ("B20", "Sicilian Defense"),
            ("C60", "Ruy Lopez"), ("D06", "Queen''s Gambit"),
            ("A04", "Reti Opening"), ("E90", "King''s Indian Defense"),
            ("D80", "Grunfeld Defense"), ("B10", "Caro-Kann Defense"),
            ("C00", "French Defense"), ("B01", "Scandinavian Defense")
        ]

        fen_id = 1
        # Writing in 20 batches of 1000 rows to ensure smooth SQL execution
        for batch in range(20):
            values = []
            for _ in range(1000):
                eco, base_name = random.choice(openings)
                # Generating a unique FEN by altering move numbers
                fen = f"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - {random.randint(0, 15)} {fen_id}"
                opening_name = f"{base_name} - Line {fen_id}"
                values.append(f"({fen_id}, '{fen}', '{eco}', '{opening_name}')")
                fen_id += 1

            f.write("INSERT INTO OpeningPosition (fen_id, fen_string, eco_code, opening_name) VALUES\n")
            f.write(",\n".join(values) + ";\n\n")

        # --- 2. HardwareTelemetry Table (20,000 rows) ---
        f.write("-- Generating 20,000 server telemetry logs (HardwareTelemetry)\n")
        # Starting telemetry logs from January 1st, 2026
        current_time = datetime(2026, 1, 1, 0, 0, 0)

        for batch in range(20):
            values = []
            for _ in range(1000):
                # Assuming HardwareNode IDs 1 and 2 exist in the database
                node_id = random.choice([1, 2])
                timestamp_str = current_time.strftime('%Y-%m-%d %H:%M:%S')
                cpu = random.randint(15, 95)  # Realistic CPU usage
                temp = random.randint(40, 85)  # Realistic temperature

                values.append(f"({node_id}, '{timestamp_str}', {cpu}, {temp})")

                # Advancing time by 1 minute for the next log entry
                current_time += timedelta(minutes=1)

            f.write("INSERT INTO HardwareTelemetry (node_id, time_stamp, cpu_usage_pct, temp_celsius) VALUES\n")
            f.write(",\n".join(values) + ";\n\n")

    print(f"✅ Success! File '{filename}' generated with 40,000 rows.")
    print("Ready for submission. Don't forget to take a screenshot of the terminal!")

if __name__ == '__main__':
    generate_mock_data()