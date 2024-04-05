-- CS 121 24wi: final project setup.sql

-- DROP TABLE commands:
DROP TABLE IF EXISTS friend_request;
DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS avatar;
DROP TABLE IF EXISTS user;

-- CREATE TABLE commands:
-- Represents a user, uniquely identified by username, and having an associated
-- password_hash, salt, and email.
CREATE TABLE user (
    username VARCHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL,

    -- Salt will be 8 characters all the time, so we can make this 8.
    salt CHAR(8) NOT NULL,

    -- We use SHA-2 with 256-bit hashes.  MySQL returns the hash
    -- value as a hexadecimal string, which means that each byte is
    -- represented as 2 characters.  Thus, 256 / 8 * 2 = 64.
    -- We can use BINARY or CHAR here; BINARY simply has a different
    -- definition for comparison/sorting than CHAR.
    password_hash BINARY(64) NOT NULL
);

-- Represents an avatar, uniquely identified by username, and having an associated
-- species, variant, color, and img_path.
CREATE TABLE avatar (
    username VARCHAR(20) PRIMARY KEY,
    species VARCHAR(50) NOT NULL,
    variant VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    image_path VARCHAR(100) NOT NULL,
    FOREIGN KEY (username) REFERENCES user(username)
    ON DELETE CASCADE
);

-- Represents a score, uniquely identified by username and time_played, and having an
-- associated score.
CREATE TABLE score (
    username VARCHAR(20) NOT NULL,
    time_played TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score INT NOT NULL,

    PRIMARY KEY (username, time_played),
    FOREIGN KEY (username) REFERENCES user(username)
    ON DELETE CASCADE
);

-- Represents a friend request, uniquely identified by from_user and to_user,
-- and having an associated boolean for is_accepted, time_sent, and time_accepted
-- if the request was accepted.
CREATE TABLE friend_request (
    from_user VARCHAR(20) NOT NULL,
    to_user VARCHAR(20) NOT NULL,
    is_accepted TINYINT NOT NULL,
    time_sent TIMESTAMP,
    time_accepted TIMESTAMP,

    PRIMARY KEY (from_user, to_user),
    FOREIGN KEY (from_user) REFERENCES user(username)
    ON DELETE CASCADE,
    FOREIGN KEY (to_user) REFERENCES user(username)
    ON DELETE CASCADE
);


-- Indexes:
-- For retriving scores for leaderboard
CREATE INDEX idx_username_time_played ON score (username, time_played);

-- For retriving friend relationships
CREATE INDEX idx_from_user ON friend_request (from_user);
CREATE INDEX idx_to_user ON friend_request (to_user);
