import os
import requests
from pysentimiento import create_analyzer

# Create sentiment analyzer
analyzer = create_analyzer(task="sentiment", lang="en")

api_url = os.getenv("API_URL")


def analyze_tweets():
    try:
        # Make a request to the /raw_tweets API to get a list of tweets
        raw_tweets_response = requests.get(api_url + "/tweets_raw")
        raw_tweets_data = raw_tweets_response.json()

        # List to store the results
        results = []

        # Process each tweet in the data
        for tweet_data in raw_tweets_data:
            tweet_text = tweet_data.get("text", "")
            tweet_subject = tweet_data.get("subject", "")
            tweet_user = tweet_data.get("user", "")
            tweet_id = tweet_data.get("id", "")

            if tweet_text:
                # Analyze the sentiment of the text
                sentiment_result = analyzer.predict(tweet_text)

                # Get the sentiment category and probabilities
                output = sentiment_result.output

                # Store the results in a dictionary
                result = {
                    "text": tweet_text,
                    "subject": tweet_subject,
                    "user": tweet_user,
                    "sentiment": output,
                    "id": tweet_id,
                }
                results.append(result)

        # Return the results as a list
        return results

    except Exception as e:
        # In case of error, return an empty list
        print("An error occurred:", str(e))
        return []


# Execute the function to analyze the tweets
analyzed_tweets = analyze_tweets()
print(analyzed_tweets)

# Send the results to the /update_dbs API
update_dbs_response = requests.post(api_url + "/update_db", json=analyzed_tweets)

# Display the response from the /update_dbs API
print("Update DBs response:", update_dbs_response.text)
