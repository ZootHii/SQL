WITH CitedPapers AS
(
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) as RowNumber, *
	FROM Papers																	
	WHERE CitationCount IS NOT NULL		-- it is optional to write this condition
),
HirschValues AS
(
	SELECT
		AcademicianIdentityNumber
		, RowNumber AS HirschValue
	FROM CitedPapers
	WHERE RowNumber <= CitationCount																
),
HirschIndex AS
(
	SELECT
		AcademicianIdentityNumber
		, MAX(HirschValue) AS HIndex																
	FROM HirschValues
	GROUP BY AcademicianIdentityNumber																
),
AcademicianSummary AS
(
	SELECT
		  (SELECT 
			  FirstName + ' ' + LastSurname 
		   FROM Academician AS IA 
		   WHERE A.IdentityNumber = IA.IdentityNumber) AS AcademicianName							
		, (SELECT 
			  HIndex 
		   FROM HirschIndex AS H 
		   WHERE A.IdentityNumber = H.AcademicianIdentityNumber) AS HIndex							
		, SUM(CASE WHEN CitationCount >= 10 THEN 1 ELSE 0 END) AS I10Index							
		, SUM(CitationCount) AS TotalCitation														
		, MAX(CitationCount) AS MaxCitation															
		, SUM(CASE WHEN CitationCount IS NULL THEN 1 ELSE 0 END) AS PaperWithNoCitation				
		, COUNT(*) AS PublicationCount																
		, CAST(CAST(SUM(CitationCount) AS FLOAT) / COUNT(*) AS DECIMAL(18,2)) AS CitationPerPaper	
		, MIN(PublicationYear) AS FirstPublicationYear												
		, MAX(PublicationYear) AS LastPublicationYear												
		, (SELECT 
			  COUNT(DISTINCT(PublicationYear)) 
		   FROM Academician AS IA 
		   WHERE A.IdentityNumber = IA.IdentityNumber) AS PublishedYearCount						
		, SUM(CASE WHEN ImpactFactor IS NOT NULL THEN 1 ELSE 0 END) AS SCIPaperCount				
		, MIN(ImpactFactor) AS MinImpactFactor														
		, MAX(ImpactFactor) AS MaxImpactFactor														
	FROM Academician AS A INNER JOIN Papers AS P
	ON A.IdentityNumber = P.AcademicianIdentityNumber												
	GROUP BY A.IdentityNumber
)
SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC
