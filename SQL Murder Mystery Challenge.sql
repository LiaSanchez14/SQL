--A crime has taken place and the detective needs your help. The detective gave you the crime scene report, but you somehow lost it. 
--You vaguely remember that the crime was a murder that occurred sometime on Jan.15, 2018 and that it took place in SQL City.
--Start by retrieving the corresponding crime scene report from the police department’s database.--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Run this query to find the names of the tables in this database.--

SELECT name 
FROM sqlite_master
WHERE type = 'table'

--Table Names are the following:
--crime_scene_report
--drivers_license
--person
--facebook_event_checkin
--interview
--get_fit_now_member
--get_fit_now_check_in
--income
--solution--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Run a query to find the structure of the `crime_scene_report` table--

SELECT sql 
FROM sqlite_master
WHERE name = 'crime_scene_report'
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Retrive the corresponding crime scene report from the police department's database--

SELECT *
FROM crime_scene_report
WHERE city='SQL City' AND date=20180115 AND type= 'murder';

-- the murder report states "Security footage shows that there were 2 witnesses. 
--The first witness lives at the last house on "Northwestern Dr". 
--The second witness, named Annabel, lives somewhere on "Franklin Ave".
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Identify the second witness and find more information about them--

SELECT *
FROM person
WHERE name like '%Annabel%' AND address_street_name = 'Franklin Ave';

--id --> 16371
--name --> Annabel Miller
--license_id	--> 490173
--address_number	--> 103
--address_street_name	--> Franklin Ave
--ssn --> 318771143 --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Identify the first witness and find more information about them--

SELECT *
FROM person
WHERE address_street_name='Northwestern Dr'
ORDER BY address_number desc;

--id --> 14887
--name --> Morty Schapiro
--license_id	--> 118009
--address_number	--> 4919
--address_street_name	--> Northwestern Dr
--ssn --> 111564949 --
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--What did the witnesses say during their interviews?--

SELECT id,name,interview.transcript
FROM person
Inner JOIN interview
ON person.id = interview.person_id
WHERE id = 16371 OR id = 14887;

--id --> 14887
--name --> Morty Schapiro
--transcript --> I heard a gunshot and then saw a man run out. 
--He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W".--

--id --> 16371
--name --> Annabel Miller
--transcript --> I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Find more information on person who is a gold member and who's membership starts with "48Z" and was working out on January 9th--

SELECT id,person_id,name,membership_status,check_in_date
FROM get_fit_now_member
INNER JOIN get_fit_now_check_in
ON get_fit_now_member.id = get_fit_now_check_in.membership_id
WHERE id LIKE '48Z%' AND membership_status ='gold' AND check_in_date = 20180109;

--Two people fit this description--

--id --> 48Z7A
--person_id	--> 28819
--name --> Joe Germuska
--membership_status	--> gold
--check_in_date --> 20180109

--id --> 48Z55
--person_id	--> 67318
--name --> Jeremy Bowers
--membership_status	--> gold
--check_in_date --> 20180109
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--How many people own a car with a drivers license that includes "H42W" in the numeration?--

SELECT COUNT(*)
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

--3--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--What information is there about the drivers?--

SELECT *
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

-- id	    age height	eye_color	 hair_color	 gender	  plate_number	 car_make	    car_model
--183779	21	 65	    blue	     blonde	     female  	H42W0X	       Toyota	      Prius
--423327	30	 70   	brown	     brown	      male	  0H42W2	       Chevrolet	  Spark LS
--664760	21	 71	    black	     black	      male	  4H42WR	       Nissan	      Altima--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--What are the names of the drivers?--

SELECT license_id,person.name
FROM person
INNER JOIN drivers_license
ON person.license_id = drivers_license.id
WHERE drivers_license.id = 183779 OR drivers_license.id = 423327 OR drivers_license.id = 664760

--license_id	 name
--183779	     Maxine Whitely
--423327	     Jeremy Bowers
--664760	     Tushar Chandra--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Who is the killer?--

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
        
        SELECT value FROM solution;

--Congrats, you found the murderer! But wait, there's more... 
--If you think you're up for a challenge, try querying the interview transcript of the murderer to find the real villain behind this crime.--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--What did the Jeremy Bowers say during his interview?--

SELECT get_fit_now_member.id AS get_fit_now_member_id,person.id AS person_id,person.name,transcript
FROM person
Inner JOIN interview
ON person.id = interview.person_id
INNER JOIN get_fit_now_member
ON person.id= get_fit_now_member.person_id
WHERE get_fit_now_member.id= '48Z7A' OR get_fit_now_member.id= '48Z55';

--get_fit_now_member_id	--> 48Z55
--person_id	--> 67318
--name --> Jeremy Bowers
--transcript --> I was hired by a woman with a lot of money. 
--I don't know her name but I know she's around 5'5" (65") or 5'7" (67"). 
--She has red hair and she drives a Tesla Model S. I know that she attended the SQL Symphony Concert 3 times in December 2017.--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--Find who is the woman that allegedly hired Jeremy Bowers--

SELECT person_id,name,event_name,COUNT(event_name) AS attendance_count
FROM facebook_event_checkin
INNER JOIN person
ON facebook_event_checkin.person_id = person.id
WHERE date LIKE '201712%' AND event_name= 'SQL Symphony Concert'
GROUP BY name
ORDER BY attendance_count desc;

--person_id	--> 99716
--name --> Miranda Priestly
--event_name --> SQL Symphony Concert
--attendance_count --> 3
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--What information is there about Miranda Priestly?--

SELECT person.*,income.annual_income
FROM person
INNER JOIN income
ON person.ssn = income.ssn
WHERE person.name = 'Miranda Priestly'

--id	   name	             license_id	 address_number	 address_street_name   	 ssn	        annual_income
--99716	 Miranda Priestly	 202298	     1883	           Golden Ave	             987756388	  310000--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                          ALL DONE!!
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
