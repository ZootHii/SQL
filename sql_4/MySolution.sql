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
		(40, NULL, NULL),		-->  NULL
		
		--other test cases
		(41, 78, 84),			-->  13/14 
		(42, 333, 3333),
		(43, -3123, 0),
		(44, 17, 0),
		(45, 87, 97),
		(46, 17, 13),
		(47, -17, -1)
	)
	TESTDATA (TestID, Numerator, Denumerator)
),
SET1 AS
(
	SELECT
		TestID
		, Numerator
		, Denumerator
		, 1 AS IndexNumber
		, 1 AS NumeratorDivisor
		, 1 AS DenumeratorDivisor
		, 0 AS CommonDivisor
	FROM TESTDATA

	UNION ALL

	SELECT
		 TestID
		 , Numerator
		 , Denumerator
		 , IndexNumber + 1 AS IndexNumber
		 , (CASE WHEN ABS(Numerator)%(IndexNumber + 1) = 0 THEN (IndexNumber + 1) ELSE NULL END) AS NumeratorDivisor
		 , (CASE WHEN ABS(Denumerator)%(IndexNumber + 1) = 0 THEN (IndexNumber + 1) ELSE NULL END) AS DenumeratorDivisor
		 , (CASE WHEN DenumeratorDivisor = NumeratorDivisor THEN NumeratorDivisor END) AS CommonDivisor
	FROM SET1
	WHERE IndexNumber <= ABS(Numerator) OR IndexNumber <= ABS(Denumerator)
),
SET2 AS
(
	SELECT
		TestID
		, Numerator
		, Denumerator
		, MAX(CommonDivisor) AS MAXCommonDivisor
		, (CASE WHEN MAX(CommonDivisor) != 0 THEN Numerator/MAX(CommonDivisor) ELSE NULL END) AS DividedNumerator
		, (CASE WHEN MAX(CommonDivisor) != 0 THEN Denumerator/MAX(CommonDivisor) ELSE NULL END) AS DividedDenumerator
	FROM SET1
	GROUP BY TestID, Numerator, Denumerator
),
RESULT AS
(
	SELECT
	*
	, (CASE 
		WHEN MAXCommonDivisor = 0 AND Numerator = 0 AND Denumerator = 0 THEN 'NaN'
		WHEN ABS(DividedDenumerator) = 1 AND DividedNumerator/DividedDenumerator < 0 
			THEN CAST(-ABS(DividedNumerator) AS VARCHAR)
		WHEN ABS(DividedDenumerator) = 1 AND DividedNumerator/DividedDenumerator > 0 
			THEN CAST(ABS(DividedNumerator) AS VARCHAR)
		WHEN DividedDenumerator = 0 AND DividedNumerator < 0 THEN '-Infinity'
		WHEN DividedDenumerator = 0 AND DividedNumerator > 0 THEN '+Infinity'
		WHEN DividedNumerator/CAST(DividedDenumerator AS FLOAT) < 0 
			THEN CAST(-ABS(DividedNumerator) AS VARCHAR)+'/'+CAST(ABS(DividedDenumerator) AS VARCHAR)
		WHEN DividedNumerator/CAST(DividedDenumerator AS FLOAT) > 0 
			THEN CAST(ABS(DividedNumerator) AS VARCHAR)+'/'+CAST(ABS(DividedDenumerator) AS VARCHAR)
		WHEN DividedNumerator = 0 THEN '0'
		ELSE 'Undefined'
	   END) AS Simplified
	FROM SET2
)

SELECT
	TestID
	, Numerator
	, Denumerator
	, Simplified
	--*
FROM RESULT
ORDER BY TestID
OPTION (MAXRECURSION 10000)