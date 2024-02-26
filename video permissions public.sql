


--                         user                      password
create user if not exists 'adult'@'%' identified by 'login';
create user if not exists 'child'@'%' identified by 'login';


-- The following section will need to be done via MySQL command line because of permissions.
-- grant select, update on *.* to 'child';
-- GRANT SELECT, update ON *.* TO 'adult';
flush privileges;




drop table if exists users;
create table users(user varchar(50), birthdate date);

insert into users(user, birthdate)
values
('child','2016-05-04'),
('adult','2002-09-07'),
('kodi','1970-01-01');




drop view if exists `user_age`;
create 
    ALGORITHM = UNDEFINED 
    DEFINER = `kodi`@`%` 
    SQL SECURITY DEFINER
view `user_age`
AS
	select 
		u.user,
		TIMESTAMPDIFF(YEAR, u.birthdate, CURDATE()) as age
	from users u;


drop table if exists age_permissions;

create table age_permissions (rated varchar(20), age smallint);

INSERT INTO age_permissions (rated, age) VALUES
('G', 1),
('Rated G', 1),
('U', 1),
('PG', 8),
('Rated PG', 8),
('PG-13', 13),
('Rated PG-13', 13),
('R', 17),
('Rated R', 17),
('NC-17', 18),
('NR', 18),
('Rated NR', 18),
('', 18),
-- TV ratings
('TV-Y', 1),
('TV-Y7', 7),
('TV-G', 1),
('TV-PG', 8),
('TV-14', 14),
('TV-MA', 17);










CREATE or replace
    ALGORITHM = UNDEFINED 
    DEFINER = `kodi`@`%` 
    SQL SECURITY DEFINER
VIEW `movie_view` AS
    SELECT 
        `movie`.`idMovie` AS `idMovie`,
        `movie`.`idFile` AS `idFile`,
        `movie`.`c00` AS `c00`, -- Title
        `movie`.`c01` AS `c01`,
        `movie`.`c02` AS `c02`,
        `movie`.`c03` AS `c03`,
        `movie`.`c04` AS `c04`,
        `movie`.`c05` AS `c05`,
        `movie`.`c06` AS `c06`,
        `movie`.`c07` AS `c07`,
        `movie`.`c08` AS `c08`,
        `movie`.`c09` AS `c09`,
        `movie`.`c10` AS `c10`,
        `movie`.`c11` AS `c11`,
        `movie`.`c12` AS `c12`, -- Rated
        `movie`.`c13` AS `c13`,
        `movie`.`c14` AS `c14`,
        `movie`.`c15` AS `c15`, -- Director
        `movie`.`c16` AS `c16`,
        `movie`.`c17` AS `c17`,
        `movie`.`c18` AS `c18`, -- Studio
        `movie`.`c19` AS `c19`,
        `movie`.`c20` AS `c20`,
        `movie`.`c21` AS `c21`,
        `movie`.`c22` AS `c22`,
        `movie`.`c23` AS `c23`,
        `movie`.`idSet` AS `idSet`,
        `movie`.`userrating` AS `userrating`,
        `movie`.`premiered` AS `premiered`,
        `sets`.`strSet` AS `strSet`,
        `sets`.`strOverview` AS `strSetOverview`,
        `files`.`strFilename` AS `strFileName`,
        `path`.`strPath` AS `strPath`,
        `files`.`playCount` AS `playCount`,
        `files`.`lastPlayed` AS `lastPlayed`,
        `files`.`dateAdded` AS `dateAdded`,
        `bookmark`.`timeInSeconds` AS `resumeTimeInSeconds`,
        `bookmark`.`totalTimeInSeconds` AS `totalTimeInSeconds`,
        `bookmark`.`playerState` AS `playerState`,
        `rating`.`rating` AS `rating`,
        `rating`.`votes` AS `votes`,
        `rating`.`rating_type` AS `rating_type`,
        `uniqueid`.`value` AS `uniqueid_value`,
        `uniqueid`.`type` AS `uniqueid_type`
    FROM
        ((((((`movie` 
        LEFT JOIN `sets` ON ((`sets`.`idSet` = `movie`.`idSet`)))
        JOIN `files` ON ((`files`.`idFile` = `movie`.`idFile`)))
        JOIN `path` ON ((`path`.`idPath` = `files`.`idPath`)))
        LEFT JOIN `bookmark` ON (((`bookmark`.`idFile` = `movie`.`idFile`)
            AND (`bookmark`.`type` = 1))))
        LEFT JOIN `rating` ON ((`rating`.`rating_id` = `movie`.`c05`)))
        LEFT JOIN `uniqueid` ON ((`uniqueid`.`uniqueid_id` = `movie`.`c09`)))
        JOIN age_permissions ap ON `movie`.c12 = ap.rated
		JOIN user_age ua ON ua.user = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
	WHERE 
    (
		ua.age >= ap.age
        or
        ua.age is null
    )
    ;
	




	
CREATE or replace
    ALGORITHM = UNDEFINED 
    DEFINER = `kodi`@`%` 
    SQL SECURITY DEFINER
VIEW `tvshow_view` AS
    SELECT 
        `tvshow`.`idShow` AS `idShow`,
        `tvshow`.`c00` AS `c00`,
        `tvshow`.`c01` AS `c01`,
        `tvshow`.`c02` AS `c02`,
        `tvshow`.`c03` AS `c03`,
        `tvshow`.`c04` AS `c04`,
        `tvshow`.`c05` AS `c05`,
        `tvshow`.`c06` AS `c06`,
        `tvshow`.`c07` AS `c07`,
        `tvshow`.`c08` AS `c08`,
        `tvshow`.`c09` AS `c09`,
        `tvshow`.`c10` AS `c10`,
        `tvshow`.`c11` AS `c11`,
        `tvshow`.`c12` AS `c12`, 
        `tvshow`.`c13` AS `c13`,  -- Rated
        `tvshow`.`c14` AS `c14`,
        `tvshow`.`c15` AS `c15`,
        `tvshow`.`c16` AS `c16`,
        `tvshow`.`c17` AS `c17`,
        `tvshow`.`c18` AS `c18`,
        `tvshow`.`c19` AS `c19`,
        `tvshow`.`c20` AS `c20`,
        `tvshow`.`c21` AS `c21`,
        `tvshow`.`c22` AS `c22`,
        `tvshow`.`c23` AS `c23`,
        `tvshow`.`userrating` AS `userrating`,
        `tvshow`.`duration` AS `duration`,
        `path`.`idParentPath` AS `idParentPath`,
        `path`.`strPath` AS `strPath`,
        `tvshowcounts`.`dateAdded` AS `dateAdded`,
        `tvshowcounts`.`lastPlayed` AS `lastPlayed`,
        `tvshowcounts`.`totalCount` AS `totalCount`,
        `tvshowcounts`.`watchedcount` AS `watchedcount`,
        `tvshowcounts`.`totalSeasons` AS `totalSeasons`,
        `rating`.`rating` AS `rating`,
        `rating`.`votes` AS `votes`,
        `rating`.`rating_type` AS `rating_type`,
        `uniqueid`.`value` AS `uniqueid_value`,
        `uniqueid`.`type` AS `uniqueid_type`
    FROM
        (((((`tvshow`
        LEFT JOIN `tvshowlinkpath_minview` ON ((`tvshowlinkpath_minview`.`idShow` = `tvshow`.`idShow`)))
        LEFT JOIN `path` ON ((`path`.`idPath` = `tvshowlinkpath_minview`.`idPath`)))
        JOIN `tvshowcounts` ON ((`tvshow`.`idShow` = `tvshowcounts`.`idShow`)))
        LEFT JOIN `rating` ON ((`rating`.`rating_id` = `tvshow`.`c04`)))
        LEFT JOIN `uniqueid` ON ((`uniqueid`.`uniqueid_id` = `tvshow`.`c12`)))
		JOIN age_permissions ap ON `tvshow`.`c13` = ap.rated
		JOIN user_age ua ON ua.user = SUBSTRING_INDEX(CURRENT_USER(), '@', 1)
	WHERE 
    (
		ua.age >= ap.age
        or
        ua.age is null
    )
    ;
