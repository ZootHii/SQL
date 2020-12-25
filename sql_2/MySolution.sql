WITH CitedPapers AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) AS RowNumber
		, CONCAT(FirstName, ' ', LastSurname) AS FullName
		, *
	FROM Papers AS PIN INNER JOIN Academician AS AIN
	ON PIN.AcademicianIdentityNumber = AIN.IdentityNumber
),
--START HIndex
HIndex AS
(
	SELECT
		AcademicianIdentityNumber AS HIID
		, MAX(RowNumber) AS HIndex
	FROM CitedPapers
	WHERE RowNumber <= CitationCount
	GROUP BY AcademicianIdentityNumber
),
--END HIndex
--START I10Index
IndexValue AS
(	
		SELECT
			AcademicianIdentityNumber
			, ( CASE
					WHEN CitationCount >= 10 THEN COUNT(PaperId) ELSE '0'
				END) AS PaperCount
		FROM CitedPapers
		GROUP BY CitationCount, AcademicianIdentityNumber
),
I10Index AS
(
	SELECT
		AcademicianIdentityNumber AS I10ID
		, SUM(PaperCount) AS I10Index
	FROM IndexValue
	GROUP BY AcademicianIdentityNumber
),
--END I10Index
HirschValues AS
(
	SELECT
		I10ID
		, HIndex
		, I10Index
	FROM I10Index INNER JOIN HIndex
	ON HIndex.HIID = I10Index.I10ID
),
AcademicianSummary AS
(
	SELECT
		FullName AS AcademicianName
		, HIndex
		, I10Index
		, SUM(CitationCount) AS TotalCitation
		, MAX(CitationCount) AS MaxCitation
		, COUNT(PaperId) - COUNT(CitationCount) AS PaperWithNoCitation
		, COUNT(PaperId) AS PublicationCount
		, CAST(SUM(CitationCount) / CAST(COUNT(PaperId) AS DECIMAL) AS DECIMAL(8,2)) AS CitationPerPaper
		, MIN(PublicationYear) AS FirstPublicationYear
		, MAX(PublicationYear) AS LastPublicationYear
		, Count(DISTINCT PublicationYear) AS PublishedYearCount
		, COUNT(ImpactFactor) AS SCIPaperCount
		, MIN(ImpactFactor) AS MinImpactFactor
		, MAX(ImpactFactor) AS MaxImpactFactor
	FROM CitedPapers INNER JOIN HirschValues
	ON CitedPapers.AcademicianIdentityNumber = HirschValues.I10ID
	GROUP BY FullName, HIndex, I10Index
)

SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC
