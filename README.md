# kodi-parental-controls
This can add parental controls to Kodi users with a MySQL setup.  For more information on this type of setup, please refer to [Kodi's documentation](https://kodi.wiki/view/Advancedsettings.xml).

This involves manually accessing your Kodi MySQL database to make modifications, and as such comes with **absolutely no warranty.**  This is not something that I expect most users to wish to undertake, but my hope is that this might be good enough for a team at Kodi to take my suggestion here as a potential way to model parental controls into future versions of Kodi.

I used [MySQL Workbench](https://www.mysql.com/products/workbench/) to make these changes, and recommend that you do so as well.

## Step 1

* Open the copy of **video permissions public.sql** provided within this repository.  
* Edit the default users as needed (lines 5-6).  The top area defines the users and logins which you will later use in the **advancedsettings.xml** file.  You may add as many names at this point as desired.  
* Edit the default users and their birthdates ('kodi' should remain an adult (hence the birthdate in 1970), and from now on will be used more like an admin that can edit records).
* Save the file.

## Step 2

* Open MySQL Workbench and connect to your database.  Your login will be the same as what you have already setup in your **advancedsettings.xml** file:
```    <advancedsettings>
      <videodatabase>
        <type>mysql</type>
        <host>hostname</host>
        <port>3306</port>
        <user>kodi</user>
        <pass>kodi</pass>
      </videodatabase> 
```

* Here you may see multiple schemas in the database.  For example, in mine, I had *myvideos119* and *myvideos121*.  This refers to database versions used by Kodi.  I have worked with version 121, **but I have not tested this technique with any other version**.  If you have a different version (and are not afraid of changing your database), then I recommend you copy an existing view and add the last parts of my code to each view within your personal copy of my sql code.  For reference, the relevant bits are as follows:

      * movie_view
```CREATE or replace
    ALGORITHM = UNDEFINED 
    DEFINER = `kodi`@`%` 
    SQL SECURITY DEFINER
VIEW `movie_view` AS
...
-- newly added permissions check
        JOIN age_permissions ap ON `movie`.c12 = ap.rated
		JOIN user_age ua ON ua.user = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
	WHERE 
    (
		ua.age >= ap.age
        or
        ua.age is null
    )
    ;
```
