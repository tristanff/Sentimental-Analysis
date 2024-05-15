import csv
import uuid

def add_unique_id(input_file, output_file):
    with open(input_file, 'r') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames + ['id']
        rows = list(reader)

    for row in rows:
        row['id'] = str(uuid.uuid4())

    with open(output_file, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

# Usage example
input_file = 'merged_data.csv'
output_file = 'merged_data.csv'
add_unique_id(input_file, output_file)
