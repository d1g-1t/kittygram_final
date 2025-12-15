import os
import sys
import time
import psycopg2
from psycopg2 import OperationalError

def wait_for_db():
    max_retries = 30
    retry_interval = 2
    
    db_config = {
        'dbname': os.getenv('POSTGRES_DB', 'furrymetrics'),
        'user': os.getenv('POSTGRES_USER', 'furrymetrics_user'),
        'password': os.getenv('POSTGRES_PASSWORD', ''),
        'host': os.getenv('DB_HOST', 'db'),
        'port': os.getenv('DB_PORT', '5432')
    }
    
    for attempt in range(1, max_retries + 1):
        try:
            conn = psycopg2.connect(**db_config)
            conn.close()
            print("Database is ready!")
            return True
        except OperationalError as e:
            if attempt == max_retries:
                print(f"Failed to connect to database after {max_retries} attempts")
                sys.exit(1)
            print(f"Attempt {attempt}/{max_retries}: Database not ready, waiting {retry_interval}s...")
            time.sleep(retry_interval)
    
    return False

if __name__ == '__main__':
    wait_for_db()
