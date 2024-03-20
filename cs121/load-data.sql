-- Load user data
CALL sp_add_user('og wide', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('yishuc', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('party eel', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('acc kirby', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('not an eel', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('clamoodle', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('happy eel', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('crunchyeel', 'sdaquila@caltech.edu', 'password');
CALL sp_add_user('sus eel', 'yishuc@caltech.edu', '123');
CALL sp_add_user('pearlissus', 'bbyang@caltech.edu', 'ok');
CALL sp_add_user('syc', 'chen.family66@gmail.com', 'setworld');
CALL sp_add_user('pol', 'inthemistofoodles@gmail.com', '123');
CALL sp_add_user('kycoco', 'kycoco@yahoo.com', '941118Eel');
CALL sp_add_user('me', 'inthemistofoodles@gmail.com', '123');

-- Load avatar data from avatar_info.csv
LOAD DATA LOCAL INFILE 'data/avatar_info.csv'
INTO TABLE avatar
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(username, species, variant, color, image_path);

-- Load score data from scores.csv
LOAD DATA LOCAL INFILE 'data/scores.csv'
INTO TABLE score
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(username, score);

-- Load friend pairs data from friend_pairs.csv
LOAD DATA LOCAL INFILE 'data/friend_pairs.csv' 
INTO TABLE friend_request
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(from_user, to_user, @is_accepted)
SET is_accepted = 1;
