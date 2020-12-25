-- https://en.wikipedia.org/wiki/Perfect_number
WITH Numbers (Number) AS
(
	SELECT
		*
	FROM (
		VALUES
		(NULL),
		(1),
		(2),
		(3),
		(4),
		(5),
		(6),
		(7),
		(8),
		(9),
		(10),
		(20),
		(28),
		(30),
		(40),
		(50),
		(100),
		(496),
		(500),
		(1000),
		(8128),
		(10000)
	) Numbers (Number)
),
PerfectNumberCandidates AS
(
	SELECT 
		Number
		, 1 AS IndexNumber
		, 0 AS DivisorSum
		, CAST('' AS VARCHAR(1000)) AS Summation
	FROM Numbers

	UNION ALL

	SELECT 
		Number
		, IndexNumber + 1 AS IndexNumber
		, (CASE WHEN Number % IndexNumber = 0 THEN DivisorSum + IndexNumber ELSE DivisorSum END) AS DivisorSum
		, CAST(Summation + (CASE WHEN Number % IndexNumber = 0 THEN '+' + CAST(IndexNumber AS VARCHAR(100)) ELSE '' END) AS VARCHAR(1000)) AS Summation
	FROM PerfectNumberCandidates
	WHERE IndexNumber <= Number / 2
),
PerfectNumbers AS
(
	SELECT
		Number,
		RIGHT(Summation, LEN(Summation)-1) + ' = ' + CAST(Number AS VARCHAR(100)) AS Summation
	FROM PerfectNumberCandidates
	WHERE Number = DivisorSum
)
SELECT
	*
FROM PerfectNumbers
ORDER BY Number
OPTION (MAXRECURSION 10000)
