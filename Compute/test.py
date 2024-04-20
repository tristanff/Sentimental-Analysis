import json
from pysentimiento import create_analyzer

analyzer = create_analyzer(task="sentiment", lang="es")

json_file_path = "Data/NATO1.json"

def analyze_tweets_from_json(json_file_path):
    with open(json_file_path, "r", encoding="utf-8") as json_file:
        data = json.load(json_file)
        for tweet_data in data:
            tweet_text = tweet_data["text"]
            sentiment = analyzer.predict(tweet_text)
            print("Tweet:", tweet_text)
            print("Sentiment:", sentiment)
            print()

analyze_tweets_from_json(json_file_path)