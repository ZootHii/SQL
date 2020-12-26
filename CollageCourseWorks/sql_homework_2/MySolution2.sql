WITH CitedPapers AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) AS RowNumber
		, CONCAT(FirstName, ' ', LastSurname) AS FullName
		, *
	FROM Papers AS PIN INNER JOIN Academician AS AIN
	ON PIN.AcademicianIdentityNumber = AIN.IdentityNumber
),
HIndex AS
(
	SELECT
		AcademicianIdentityNumber AS HIID
		, MAX(RowNumber) AS HIndex
	FROM CitedPapers
	WHERE RowNumber <= CitationCount
	GROUP BY AcademicianIdentityNumber
),
AcademicianSummary AS
(
	SELECT
		FullName AS AcademicianName
		, HIndex
		, SUM(CASE WHEN CitationCount >= 10 THEN 1 ELSE 0 END) AS I10Index --VAY AQ	BU KADAR KOLAYMIÞ
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
	FROM CitedPapers INNER JOIN HIndex
	ON CitedPapers.AcademicianIdentityNumber = HIndex.HIID
	GROUP BY FullName, HIndex
)

SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC
