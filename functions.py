import sqlite3


def query_to_animal_db(query):
    with sqlite3.connect("animal.db") as connection:
        cursor = connection.cursor()
        cursor.execute(query)
        result = cursor.fetchall()
    if len(result) == 1:
        line = result[0]
        result_dict = {
            "id": line[0],
            "animal_id": line[1],
            "type_id": line[2],
            "name": line[3],
            "breed_id": line[4],
            "date_of_birth": line[5],
            "outcome_id": line[6],
            "age_upon_outcome": line[7],
            "outcome_subtype": line[8],
            "outcome_type": line[9],
            "outcome_month": line[10],
            "outcome_year": line[11]
        }
    else:
        result_dict = {}
    return result_dict
