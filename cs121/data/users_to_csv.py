import json
import csv

# Load JSON data from file
with open('users.json', 'r') as json_file:
    data = json.load(json_file)

# Write user data to user_data.csv
user_csv_file = 'user_data.csv'
user_csv_headers = ['username', 'email', 'password']

with open(user_csv_file, 'w', newline='') as user_file:
    user_writer = csv.DictWriter(user_file, fieldnames=user_csv_headers)
    user_writer.writeheader()
    for item in data:
        user_writer.writerow({
            'username': item['username'],
            'email': item['email'],
            'password': item['password']
        })

print(f'User data CSV file "{user_csv_file}" has been created successfully.')


# Write avatar info to avatar_info.csv
avatar_csv_file = 'avatar_info.csv'
avatar_csv_headers = ['username', 'species', 'variant', 'color', 'image_path']

with open(avatar_csv_file, 'w', newline='') as avatar_file:
    avatar_writer = csv.DictWriter(avatar_file, fieldnames=avatar_csv_headers)
    avatar_writer.writeheader()
    for item in data:
        color, variant = item['image_path'].split('/')[-1][:-len('.png')].split('-')
        avatar_writer.writerow({
            'username': item['username'],
            'species': item['species'],
            'variant': variant,
            'color': color,
            'image_path': item['image_path']
        })
        
print(f'Avatar info CSV file "{avatar_csv_file}" has been created successfully.')


# Write top scores into scores.csv
scores_csv_file = 'scores.csv'
scores_csv_headers = ['username', 'high_score']

with open(scores_csv_file, 'w', newline='') as scores_file:
    scores_writer = csv.DictWriter(scores_file, fieldnames=scores_csv_headers)
    scores_writer.writeheader()
    for item in data:
        scores_writer.writerow({
            'username': item['username'],
            'high_score': item['high_score']
        })
            
print(f'Scores CSV file "{scores_csv_file}" has been created successfully.')


# Write friend pairs to friend_pairs.csv
friend_pairs = set()
for item in data:
    username = item['username']
    friends = item['friends']
    for friend in friends:
        # Ensure unique pairs by sorting usernames alphabetically
        pair = tuple(sorted([username, friend]))
        friend_pairs.add(pair)

friend_csv_file = 'friend_pairs.csv'
friend_csv_headers = ['user1', 'user2', 'are_friends']

with open(friend_csv_file, 'w', newline='') as friend_file:
    friend_writer = csv.DictWriter(friend_file, fieldnames=friend_csv_headers)
    friend_writer.writeheader()
    for pair in friend_pairs:
        user1, user2 = pair
        friend_writer.writerow({'user1': user1, 'user2': user2, 'are_friends': True})

print(f'Friend pairs CSV file "{friend_csv_file}" has been created successfully.')
