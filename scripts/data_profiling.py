
import pandas as pd

try:
    # The 'r' prefix creates a raw string. 
    # All backslashes are treated as literal characters.
    df = pd.read_csv(r'C:\Users\User\GitHub\analytics-pokedb\data\Pokemon.csv')

    print("---Column Names & dtypes---")
    print(df.info())

    print("\n---Data Preview (First 5 rows)---")
    print(df.head())

except FileNotFoundError:
    print("Error: Pokemon.csv not found in the project directory")