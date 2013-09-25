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


Adding the Database to the Git Workflow
--

Some notes (Unix):

* if you need to commit a db update, but don't want to change files, run .git/hooks/pre-commit directly
* remember, pre-merge not post-commit

In your .git/hooks folder add these file:

* pre-commit
* post-merge
* mysql_config

In mysql_config write:

{{{
#!bash

#!/bin/sh

path_to_binary='/Applications/MAMP/Library/bin/'
mysql_user='root'
mysql_pass='root'
dbname='avi_ux' # also used as the file name
path_to_file='' # the path relative to the root git directory

rootdir=$(git rev-parse --show-toplevel)
}}}

In pre_commit file write:

{{{
#!bash

#!/bin/sh
# 
# Dumps the database and adds it the current commit
# You may need to chmod +x .git/hooks/mysql_config

. .git/hooks/mysql_config

$path_to_binary"/mysqldump" --user=$mysql_user --password=$mysql_pass --skip-extended-insert $dbname > $rootdir/$path_to_file/$dbname.sql
git add $rootdir/$path_to_file/$dbname.sql

echo "Dumped and added $dbname.sql to commit"

}}}


In the post-merge file write:

{{{
#!bash

#!/bin/sh
# 
# Updates the existing database by 
# restoring from the mysqldump file in the commit that just happened
# 
# You may need to chmod +x .git/hooks/mysql_config

. .git/hooks/mysql_config

$path_to_binary"/mysql" --user=$mysql_user --password=$mysql_pass $dbname  < $rootdir/$path_to_file/$dbname.sql

echo "Restored database from $dbname.sql to MySql"
}}}


== The original article ==

C:\wamp\www\avi-spl-scratches\.git\hooks:
- pre-commit
- post-merge (post-commit on windows) (NO NO NO USE post-merge, see http://www.manpagez.com/man/5/githooks/)

Notes from initial source site:

Let’s start with pre-commit. The pre-commit hook will run a script directly before a commit is executed. To edit your pre-commit hook:

<code>
[your editor] /path/to/your/repo/.git/hooks/pre-commit
</code>

Now, lets write the pre-commit script. We are going to tell the system to dump our MySQL database to our git repository and add it to be committed.
(make sure add to the top of the page, wont work at the bottom!)

<code>
#!/bin/sh
mysqldump -u [mysql user] -p[mysql password] --skip-extended-insert [database] > /path/to/your/repo/[database].sql
cd /path/to/your/repo
git add [database].sql
</code>

Now, lets write the post-merge script. We are going to tell the system to restore the MySQL dump to the local database for the latest changes. Edit the post-merge hook with:
<code>
[your editor] /path/to/your/repo/.git/hooks/post-merge
</code>

And write:
<code>
#!/bin/sh
mysql -u [mysql user] -p[mysql password] [database] < /path/to/your/repo/[database].sql
</code>

If you are experiencing issues with error messages saying files don't exist, trying going to phpMyAdmin and export a working copy of the MySQL database to get you started.


They are initially stored as .sample files, after adding the hooks to these files, remove the .sample and change these files to regular files

Do some testing to make sure it works and we should be good to go!


**NOTE:**

- When exporting the initial database, be sure to include Drop Statements in the Initial Export, because you might get conflicts with Primary Keys Initially Existing.

- Individual MySQL configurations should not affect how the hooks interact with git commands and the project Database


Main Source: http://ben.kulbertis.org/2011/10/synchronizing-a-mysql-database-with-git-and-git-hooks/

