import requests
from bs4 import BeautifulSoup
import json

f_jokes=list()

for p in range(1,5):
    url = "http://bash.org.pl/latest/?page={p}"
    jokes = requests.get(url)
    soup = BeautifulSoup(jokes.text, 'html.parser')
    content = soup.find('div', {'id': 'content'})
    posts = content.find_all('div', {'class': 'q post'})

    for post in posts:
        messageID = post['id'].replace('d','#')
        message = post.find('div', {'class': 'quote post-content post-body'})

        f_message = message.text.replace('\t', '').replace('\n', '').replace('\r', '')
        f_jokes.append({'id': messageID, 'joke': f_message})

#    print(f_jokes) 

    with open('jokes.json', 'w') as f:  # Write in JSON file
        json.dump(f_jokes, f)
