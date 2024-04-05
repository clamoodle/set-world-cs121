-- CS 121 24wi: Password Management (Final Project)
DROP FUNCTION IF EXISTS make_salt;
DROP PROCEDURE IF EXISTS sp_add_user;
DROP FUNCTION IF EXISTS authenticate;
DROP PROCEDURE IF EXISTS sp_change_password;

-- (Provided) This function generates a specified number of characters for using as a
-- salt in passwords.
DELIMITER !
CREATE FUNCTION make_salt(num_chars INT)
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE salt VARCHAR(20) DEFAULT '';

    -- Don't want to generate more than 20 characters of salt.
    SET num_chars = LEAST(20, num_chars);

    -- Generate the salt!  Characters used are ASCII code 32 (space)
    -- through 126 ('z').
    WHILE num_chars > 0 DO
        SET salt = CONCAT(salt, CHAR(32 + FLOOR(RAND() * 95)));
        SET num_chars = num_chars - 1;
    END WHILE;

    RETURN salt;
END !
DELIMITER ;

-- Adds a new user to the user_info table, using the specified password (max
-- of 20 characters). Salts the password with a newly-generated salt value,
-- and then the salt and hash values are both stored in the table.
DELIMITER !
CREATE PROCEDURE sp_add_user(p_username VARCHAR(20), p_email VARCHAR(100),
 p_actual_password VARCHAR(20))
BEGIN
    DECLARE p_salt VARCHAR(20);
    DECLARE p_password_hash BINARY(64);

    -- Generate a new salt
    SET p_salt = make_salt(8);

    -- Calculate password hash
    SET p_password_hash = SHA2(CONCAT(p_salt, p_actual_password), 256);

    -- Insert user into the table
    INSERT INTO user (username, email, salt, password_hash)
    VALUES (p_username, p_email, p_salt, p_password_hash);
END !
DELIMITER ;

-- Authenticates the specified username and password against the data
-- in the user_info table.  Returns 1 if the user appears in the table, and the
-- specified password hashes to the value for the user. Otherwise returns 0.
DELIMITER !
CREATE FUNCTION authenticate(uname VARCHAR(20), pw VARCHAR(20))
RETURNS TINYINT DETERMINISTIC
BEGIN
  DECLARE p_stored_password_hash BINARY(64);
  DECLARE p_received_password_hash BINARY(64);
  DECLARE p_received_salt VARCHAR(20);

  -- Get the stored password hash and salt for the provided username
  SELECT password_hash, salt INTO p_stored_password_hash, p_received_salt
  FROM user
  WHERE username = uname;

  -- Invalid if username doesn't appear in user_info
  IF p_stored_password_hash IS NULL THEN
    RETURN 0;
  END IF;

  -- Calculate the hash of the received password with the stored salt
  SET p_received_password_hash = SHA2(CONCAT(p_received_salt, pw), 256);

  -- Invalid if password doesn't hash to the stored value
  IF p_received_password_hash = p_stored_password_hash THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;
END !
DELIMITER ;

