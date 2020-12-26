WITH CitedPapers AS
(
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) as RowNumber, *
	FROM Papers																						-- 6 pts
	WHERE CitationCount IS NOT NULL		-- it is optional to write this condition
),
HirschIndex AS								
(
	SELECT
		AcademicianIdentityNumber
		, MAX(RowNumber) AS HIndex																	-- 5 pts
	FROM CitedPapers
	WHERE RowNumber <= CitationCount																-- 5 pts
	GROUP BY AcademicianIdentityNumber																-- 5 pts
),
AcademicianSummary AS
(
	SELECT
		  (SELECT 
			  FirstName + ' ' + LastSurname 
		   FROM Academician AS IA 
		   WHERE A.IdentityNumber = IA.IdentityNumber) AS AcademicianName							-- 6 pts
		, (SELECT 
			  HIndex 
		   FROM HirschIndex AS H 
		   WHERE A.IdentityNumber = H.AcademicianIdentityNumber) AS HIndex							-- 10 pts
		, SUM(CASE WHEN CitationCount >= 10 THEN 1 ELSE 0 END) AS I10Index							-- 8 pts
		, SUM(CitationCount) AS TotalCitation														-- 3 pts
		, MAX(CitationCount) AS MaxCitation															-- 3 pts
		, SUM(CASE WHEN CitationCount IS NULL THEN 1 ELSE 0 END) AS PaperWithNoCitation				-- 7 pts
		, COUNT(*) AS PublicationCount																-- 4 pts
		, CAST(CAST(SUM(CitationCount) AS FLOAT) / COUNT(*) AS DECIMAL(18,2)) AS CitationPerPaper	-- 5 pts
		, MIN(PublicationYear) AS FirstPublicationYear												-- 3 pts
		, MAX(PublicationYear) AS LastPublicationYear												-- 3 pts
		, (SELECT 
			  COUNT(DISTINCT(PublicationYear)) 
		   FROM Academician AS IA 
		   WHERE A.IdentityNumber = IA.IdentityNumber) AS PublishedYearCount						-- 6 pts
		, SUM(CASE WHEN ImpactFactor IS NOT NULL THEN 1 ELSE 0 END) AS SCIPaperCount				-- 6 pts
		, MIN(ImpactFactor) AS MinImpactFactor														-- 3 pts
		, MAX(ImpactFactor) AS MaxImpactFactor														-- 3 pts
	FROM Academician AS A INNER JOIN Papers AS P
	ON A.IdentityNumber = P.AcademicianIdentityNumber												-- 4 pts
	GROUP BY A.IdentityNumber
)
SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC
-- 10 pts, code quality
