# =================================================================
# Phase 1: Setup
# - Import libraries
# - Define database connection constants
# =================================================================

import pandas as pd
from sqlalchemy import create_engine
import logging

# Configure basic logging
# Python's logging module is a built-in framework for emitting log messages from Python programs.
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# --- Database Connection Details ---
# It's a best practice to use environment variables for this in a real project.
# For this project, we'll define them as constants for simplicity.
DB_USER = 'postgres'
DB_PASSWORD = 'toor'
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'postgres'

# --- Table and Schema Details ---
TABLE_NAME = 'raw_pokemon'
SCHEMA_NAME = 'public' # We will load raw data into the public schema


# =================================================================
# Main Execution Block
# =================================================================

def main():
    """Main function to run the ELT process"""
    logging.info("Starting Pokemon data loading script.")

    # Create a database engine
    try: 
        engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')
        logging.info("Database created successfully.")
    except Exception as e:
        logging.error(f"Error creating datavase engine: {e}")
        return


    # =================================================================
    # Phase 2: Extraction
    # - Read the CSV file into a pandas DataFrame
    # =================================================================
    try: 
        logging.info("Phase 2: Extracting data from CSV.")
        df = pd.read_csv('data/Pokemon.csv')
        logging.info(f"Successfully extracted {len(df)} rows from CSV.")
    except FileNotFoundError:
        logging.error("Error: 'data/Pokemon.csv' not found. Make sure the script is run from the project root.")
        return


    # =================================================================
    # Phase 3: Cleaning & Standardization
    # - Apply transformations to the DataFrame
    # =================================================================
    logging.info("Phase 3: Cleaning and standardizing data.")

    # Rename 'Classfication' column
    df.rename(columns={'classfication': 'classification'}, inplace=True)
    logging.info("Renamed column 'classfication' to 'classification'.")

    # Handle null in 'type2'
    df['type2'].fillna('None', inplace=True)
    logging.info("Filled null values in 'type2' with 'None'.")

    # Convert 'is_legendary' from int (0/1) to boolean
    df['is_legendary'] = df['is_legendary'].astype(bool)
    logging.info("Converted 'is_legendary' column to boolean type.")
    
    # Clean and convert 'capture_rate' to numeric.
    # The 'to_numeric' function with 'errors='coerce'' will turn any non-numeric
    # values into NaN (Not a Number), which we can then handle.
    df['capture_rate'] = pd.to_numeric(df['capture_rate'], errors='coerce')
    # For simplicity, we'll fill any resulting NaNs with a median or 0. Let's use 0.
    df['capture_rate'].fillna(0, inplace=True)
    df['capture_rate'] = df['capture_rate'].astype(int)
    logging.info("Cleaned and converted 'capture_rate' to integer type.")


    # =================================================================
    # Phase 4: Loading
    # - Write the cleaned DataFrame to the PostgreSQL database
    # =================================================================
    logging.info(f"Phase 4: Lading data into '{SCHEMA_NAME}.{TABLE_NAME}'.")
    
    try:
        # The 'to_sql' method will create the table and insert the data.
        # 'if_exists='replace'' will drop the table if it already exists before creating it again.
        # This makes our script idempotent (rerunnable).
        df.to_sql(
            name=TABLE_NAME, 
            con=engine, 
            schema=SCHEMA_NAME,
            if_exists='replace',
            index=False # Do not write the pandas DataFrame index as a column
        )
        logging.info(f"Successfully loaded {len(df)} rows into '{SCHEMA_NAME}.{TABLE_NAME}'.")
    except Exception as e:
        logging.error(f"Error loading data into the database: {e}")
        return
    
    logging.info("Script finished successfully")

if __name__ == '__main__':
    # This standard Python construct ensures that main() is called only when the script is executed directly. 
    main()
