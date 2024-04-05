-- Finds all friends of a given user, and returns a string with the usernames of
-- all friends separated by commas.
-- Gives a message if the user has no friends.
DELIMITER !
CREATE FUNCTION find_friends(user VARCHAR(20))
RETURNS VARCHAR(1000) DETERMINISTIC
BEGIN
    DECLARE friend_list VARCHAR(1000);

    SELECT GROUP_CONCAT(friend SEPARATOR ', ')
    INTO friend_list
    FROM (
        SELECT from_user AS friend FROM friend_request
        WHERE to_user = user
        AND is_accepted = 1
        UNION
        SELECT to_user FROM friend_request
        WHERE from_user = user
        AND is_accepted = 1
    ) AS friends;

    IF friend_list IS NULL THEN
        RETURN 'No friends yet';
    ELSE
        RETURN friend_list;
    END IF;
END !
DELIMITER ;

-- Returns whether two users are friends.
DELIMITER !
CREATE FUNCTION are_friends(user1 VARCHAR(20), user2 VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
    DECLARE friend_status TINYINT;

    SELECT COUNT(*)
    INTO friend_status
    FROM friend_request
    WHERE (from_user = user1 AND to_user = user2
    OR from_user = user2 AND to_user = user1)
    AND is_accepted = 1;

    RETURN friend_status;
END !
DELIMITER ;

-- Adds a new friend request to the friend_request table, using the specified
-- from_user and to_user. The is_accepted field is automatically set to 1 for now.
DELIMITER !
CREATE PROCEDURE add_friend(from_user VARCHAR(20), to_user VARCHAR(20))
BEGIN
    INSERT INTO friend_request (from_user, to_user, is_accepted)
    VALUES (from_user, to_user, 1);
END !
DELIMITER ;

-- Adds a new user to the avatar table, using the specified species, variant,
-- color, and image_path. The username is used to uniquely identify the user.
-- This is done alongside also adding the user to the user table with a salted
-- and hashed password.
DELIMITER !
CREATE PROCEDURE add_user_with_avatar(p_username VARCHAR(20), p_email VARCHAR(100),
    p_actual_password VARCHAR(20), p_species VARCHAR(50), p_variant VARCHAR(50),
    p_color VARCHAR(50), p_image_path VARCHAR(100))
BEGIN
    CALL sp_add_user(p_username, p_email, p_actual_password);
    INSERT INTO avatar (username, species, variant, color, image_path)
    VALUES (p_username, p_species, p_variant, p_color, p_image_path);
END !
DELIMITER ;

-- Adds a new score to the score table, using the specified username and score.
-- The time_played is automatically set to the current time.
DELIMITER !
CREATE PROCEDURE add_score(p_username VARCHAR(20), p_score INT)
BEGIN
    INSERT INTO score (username, score)
    VALUES (p_username, p_score);
END !
DELIMITER ;

-- A player becomes a wide green eel when they reach a score of 1000 or more.
-- This trigger updates the avatar table to reflect this change.
DELIMITER !
CREATE TRIGGER update_avatar
AFTER INSERT ON score
FOR EACH ROW
BEGIN
    IF NEW.score >= 1000 THEN
        UPDATE avatar
        SET p_species = 'eel',
            p_variant = 'wide',
            p_color = 'green',
            p_image_path = 'eel_wide_green.png'
        WHERE username = NEW.username;
    END IF;
END !
