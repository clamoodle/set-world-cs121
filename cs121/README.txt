CS121 wi2024 Final Project

- The data comes from actual users on Set World (CS132 sp23 Final Project)
- Create database "setdb"
- Data can be loaded by running in order (in the final directory):
    - setup.sql
    - setup-passwords.sql (since load-data.sql uses sp_add_user)
    - load-data.sql (requires csv files)
        - The .csv files required can all be obtained by running python users_to_csv.py in the same directory level as users.json
        - They are submitted in the data folder (unzipped)
    - The rest of the .sql files should be able to be loaded in order specified in specs

- To run this app
    - head to https://github.com/clamoodle/set-world-cs121.git and clone this repository
    - In the terminal, run "npm install" to install all node dependencies
    - run "node app.js"
    - open up browser (preferably Chrome) and head to "localhost:3000"
        - note default port for mySQL is 3307, this can be changed in app.js
    - Have fun!

- Future work
    - all friend requests rn are automatically approved
