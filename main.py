import sqlite3


def query_to_netflix_db(query):
    with sqlite3.connect("netflix.db") as connection:
        cursor = connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
    return results
