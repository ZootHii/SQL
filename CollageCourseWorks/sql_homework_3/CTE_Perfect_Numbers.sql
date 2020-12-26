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
		-- Student Code
	FROM PerfectNumberCandidates
	-- Student Code
),
PerfectNumbers AS
(
	SELECT
		-- Student Code
	FROM PerfectNumberCandidates
	-- Student Code
)
SELECT
	*
FROM PerfectNumbers
ORDER BY Number
OPTION (MAXRECURSION 10000)
