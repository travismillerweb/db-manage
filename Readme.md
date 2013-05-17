DBManage Scripts

==

This repo keeps track of [dbname] database.

So what's different about this repo and the old hooks?

- **Importing and exporting the db are separate steps from committing and pulling**. As a result, pulling and pushing doesn't automatically modify your database. Life is safer.
- Whenever you run the import script, **your previous database is automatically saved to the "stashed_avi_ux.sql"** file. Life is safer.

- The **database changes are tracked in a completely separate repo**, now updating the files doesn't require also force you to update the DB and put everybody else's db out of date. Life is safer.
- The **override feature** should be used with caution! it primarily exists for easy updating and syncing with our content database.


Environment Setup FIRST!
--
Remember to setup the "mysql_config" options file! Specify an alternate MySQL host if it differs from "localhost" along with User and DB Credentials.


How To
--

To export the database, run `./export`. To import the database, run `./import`.

Or, more verbose:

To share your database changes, run:

    ./export
    git add -A
    git commit -m "Description"
    git push


To get the latest database, run:

    git pull
    ./import


Tagging A DB Version
--
    git tag UAT-v1.0
    git push origin UAT-v1.0

