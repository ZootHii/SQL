WITH TESTDATA (TestID, Numerator, Denumerator) AS 
(
	SELECT
		*
	FROM (
		VALUES
		(1, 28, 49),			-->  4/7
		(2, -28, -49),			-->  4/7
		(3, 28, -49),			-->  -4/7
		(4, -28, 49),			-->  -4/7

		(5, 22, 6),				-->  11/3
		(6, -22, -6),			-->  11/3
		(7, 22, -6),			-->  -11/3
		(8, -22, 6),			-->  -11/3
		
		(9, 28, 14),			-->  2
		(10, -28, -14),			-->  2
		(11, 28, -14),			-->  -2
		(12, -28, 14),			-->  -2

		(13, 7919, 2687),		-->  7919/2687
		(14, -7, -2),			-->  7/2
		(15, 11, -17),			-->  -11/17
		(16, -19, 9),			-->  -19/9

		(17, 15, -3),			-->  -5
		(18, -20, 4),			-->  -5
		(19, -10, -2),			-->  5
		(20, 5, 1),				-->  5

		(21, 1, 1),				-->  1
		(22, -1, -1),			-->  1
		(23, 1, -1),			-->  -1
		(24, -1, 1),			-->  -1
		(25, -7, -7),			-->  1
		(26, 7, -7),			-->  -1

		(27, 0, 2),				-->  0
		(28, 0, -2),			-->  0
		(29, 0, 1),				-->  0
		(30, 0, -1),			-->  0

		(31, 2, 0),				-->  +Infinity
		(32, -100, 0),			-->  -Infinity
		(33, 0, 0),				-->  NaN

		(34, 10, NULL),			-->  NULL
		(35, -5, NULL),			-->  NULL
		(36, 0, NULL),			-->  NULL
		(37, NULL, 11),			-->  NULL
		(38, NULL, -8),			-->  NULL
		(39, NULL, 0),			-->  NULL
		(40, NULL, NULL)		-->  NULL
	) 
	TESTDATA (TestID, Numerator, Denumerator)
),
SET1 (...) AS
(
	-- student code
),
SET2 (...) AS
(
	-- student code
),
.
. 	-- student code
.
RESULT (...) AS 
(
	-- student code
)
SELECT
	TestID, 
	Numerator, 
	Denumerator, 
	Simplified
FROM RESULT
ORDER BY TestID
