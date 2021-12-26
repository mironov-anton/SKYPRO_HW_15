from flask import Flask, jsonify
from functions import query_to_animal_db

app = Flask(__name__)


@app.route("/animals/<idx>")
def animals(idx):
    query = (f"""
            SELECT * FROM animals_final
            LEFT JOIN outcomes ON outcomes.animal_id=animals_final.animal_id
            WHERE animals_final.id = {idx}
            """)
    result_dict = query_to_animal_db(query)
    return jsonify(result_dict)


if __name__ == "__main__":
    app.run(debug=True)
