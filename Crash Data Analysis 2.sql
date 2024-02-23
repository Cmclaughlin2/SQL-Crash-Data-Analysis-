-- 1.) How many crashes occured in 2019 in districts 1-5.
SELECT COUNT(*) AS crashes_occured
FROM crashes as c
INNER JOIN beats as b
ON c.BEAT_OF_OCCURRENCE = b.BEAT_NUM
INNER JOIN districts as d 
ON b.DISTRICT_NUM = d.DISTRICT_NUM
WHERE YEAR(c.CRASH_DATE) = 2019
AND d.DISTRICT_NUM BETWEEN 1 AND 5


-- 2.) How many Toyota Camrys were involved in crashes with clear conditions and in beats 111-935?
SELECT COUNT(*) AS toyota_camry_crashes
FROM vehicles AS v, crashes as c, beats as b
WHERE c.crash_record_id = v.crash_record_id
AND b.BEAT_NUM = c.BEAT_OF_OCCURRENCE
AND v.MAKE LIKE '%TOYOTA%'
AND v.MODEL LIKE '%CAMRY%'
AND c.WEATHER_CONDITION LIKE '%CLEAR%'
AND b.BEAT_NUM BETWEEN 111 AND 935


-- 3.) How many Oregonians were involved in crashes with a below average speed limit?
SELECT COUNT(*) AS oregonian_below_avg_speed_limit
FROM people as p
INNER JOIN crashes as c
ON p.CRASH_RECORD_ID = c.CRASH_RECORD_ID
INNER JOIN zipcodes AS z
ON z.ZIP_CODE = p.ZIP_CODE
WHERE z.STATE_NAME = 'Oregon'
AND c.POSTED_SPEED_LIMIT < (SELECT AVG(POSTED_SPEED_LIMIT) FROM crashes)


-- 4.)Look at the ERD How many crashes occurred in each district in 2021? Include the district number and name in your result. Order by district number.
SELECT d.DISTRICT_NUM , DISTRICT_NAME, COUNT(c.CRASH_RECORD_ID) AS crashes_in_each_district
FROM crashes as c, districts as d, beats as b
WHERE c.BEAT_OF_OCCURRENCE = b.BEAT_NUM
AND d.DISTRICT_NUM = b.DISTRICT_NUM
AND YEAR(c.CRASH_DATE) = '2021'
GROUP BY d.DISTRICT_NUM, d.DISTRICT_NAME
ORDER BY d.DISTRICT_NUM


-- 5.) The type of ejection a person endured and the count of records for that type - in situations in which a person was trapped, extricated, partially ejected, or totally ejected and the speed limit was 30 miles or less per hour.
SELECT DISTINCT EJECTION AS ejection_type, COUNT(*) AS count_of_each_ejection_type
FROM people as p
INNER JOIN crashes as c
ON p.CRASH_RECORD_ID = c.CRASH_RECORD_ID
WHERE POSTED_SPEED_LIMIT <= 30
AND EJECTION IN ('TRAPPED/EXTRICATED', 'PARTIALLY EJECTED', 'TOTALLY EJECTED')
GROUP BY EJECTION