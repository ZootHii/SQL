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
		, IndexNumber+1
		, (CASE WHEN Number%(IndexNumber) = 0 THEN IndexNumber ELSE NULL END)
		, CAST(CAST(Summation AS varchar(1000)) + COALESCE('+' + CAST(DivisorSum AS VARCHAR(1000)), '')  AS VARCHAR(1000)) 
	FROM PerfectNumberCandidates
	WHERE IndexNumber < 10000 AND IndexNumber < Number
),
PerfectNumbers AS
(
	SELECT
		Number
		, MAX(Summation) + ' = ' + CAST(Number AS VARCHAR(1000)) AS Summation
	FROM PerfectNumberCandidates
	GROUP BY Number
	HAVING SUM(DivisorSum) = Number
)
SELECT DISTINCT
	*
FROM PerfectNumbers
OPTION (MAXRECURSION 10000)
