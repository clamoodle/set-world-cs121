-- Select all emails with more than 1 user and show the number of accounts with that email
SELECT email, COUNT(email) AS num_users
FROM user
GROUP BY email
HAVING num_users > 1;

-- Select all users with score greater than 2000
SELECT username, score
FROM score
WHERE score > 2000;

-- Select the friends list from "clamoodle" and "kycoco"
SELECT username, find_friends(username) AS friends
FROM user
WHERE username IN ('clamoodle', 'kycoco');

-- Select all users who are friends with "clamoodle"
SELECT from_user AS friend FROM friend_request
WHERE to_user = 'clamoodle'
AND is_accepted = 1
UNION
SELECT to_user FROM friend_request
WHERE from_user = 'clamoodle'
AND is_accepted = 1;

-- Finds the username, highest score, avatar image path, and friends of all users.
-- This function is used upon every login in game.
-- Friends are stored in a comma-separated string as in the return of find_friends.
CREATE VIEW user_info AS
SELECT u.username,
       CASE WHEN s.score is NULL THEN 0 ELSE s.score END AS high_score,
       a.image_path,
       find_friends(u.username) AS friends
FROM user u
LEFT OUTER JOIN (
    SELECT username, MAX(score) AS score
    FROM score
    GROUP BY username
    ) s ON u.username = s.username
JOIN avatar a ON u.username = a.username;

-- Create a view to store the top 10 scores with unique users
CREATE VIEW top_scores AS
SELECT COUNT(r.tops) as rank, r.username, r.high_score
FROM (
    SELECT u1.username, u1.high_score, u2.high_score AS tops FROM user_info u1 JOIN user_info u2
    WHERE u1.high_score <= u2.high_score
    -- We don't want to include users with no score records
    AND u1.high_score > 0
    AND u2.high_score > 0
    ) r
GROUP BY r.username, r.high_score
ORDER BY rank
LIMIT 10;

-- Select from user_info all users who are friends with "crunchyeel", are not
-- eels, and have a high score greater than 2000.
-- Exclude "crunchyeel" from the results.
-- SELECT ui.username, ui.high_score, ui.image_path, ui.friends
SELECT ui.username, ui.high_score, ui.image_path, ui.friends
FROM user_info ui JOIN avatar a
    ON ui.username = a.username
WHERE ui.username IN (
    -- This SELECT statement is written so that in JS query we can parameterize
    -- the friendship status to 0 or 1 or both.
    SELECT t.u2 FROM (SELECT u1.username u1, u2.username u2,
        CASE WHEN (f1.is_accepted IS NULL AND f2.is_accepted IS NULL) THEN 0
        ELSE 1 END AS is_accepted
    FROM (user u1 JOIN user u2)
    LEFT JOIN friend_request f1 ON
        u1.username = f1.from_user AND u2.username = f1.to_user
    LEFT JOIN friend_request f2 ON
        u1.username = f2.to_user AND u2.username = f2.from_user
    WHERE u1.username != u2.username
    AND u1.username = 'crunchyeel') AS t
    WHERE (is_accepted = 1)
) AND (a.species = 'not eel')
AND (high_score >= 2000);

