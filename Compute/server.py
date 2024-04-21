from flask import Flask, request, jsonify
from pysentimiento import create_analyzer

# Créez l'analyseur de sentiment
analyzer = create_analyzer(task="sentiment", lang="es")

# Créez l'application Flask
app = Flask(__name__)


@app.route('/analyze_tweets', methods=['POST'])
def analyze_tweets():
    # Recevoir les données JSON depuis la requête
    data = request.json

    # Liste des résultats
    results = []

    # Traiter chaque tweet dans les données
    for tweet_data in data:
        tweet_text = tweet_data.get("text", "")

        if tweet_text:
            # Analyser le sentiment du texte
            sentiment_result = analyzer.predict(tweet_text)

            # Obtenir la catégorie de sentiment et les probabilités
            output = sentiment_result.output
            probas = sentiment_result.probas

            # Stocker les résultats dans un dictionnaire
            result = {
                "text": tweet_text,
                "sentiment": output,
                "probabilities": {
                    "NEG": probas.get("NEG", 0.0),
                    "POS": probas.get("POS", 0.0),
                    "NEU": probas.get("NEU", 0.0),
                },
            }
            results.append(result)

    # Renvoyer les résultats sous forme de JSON
    return jsonify(results)


# Lancer le serveur Flask sur le port 5000
if __name__ == '__main__':
    app.run(port=5000, debug=True)