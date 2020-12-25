WITH CitedPapers AS
(
	SELECT 
		ROW_NUMBER() OVER (PARTITION BY AcademicianIdentityNumber ORDER BY CitationCount DESC) as RowNumber, *
	FROM ...
	WHERE ...
),
HirschValues AS
(
	...
),
HirschIndex AS
(
	...
),
AcademicianSummary AS
(
	SELECT
		... AS AcademicianName,
		... AS HIndex,
		... AS I10Index,
		... AS TotalCitation,
		... AS MaxCitation,
		... AS PaperWithNoCitation,
		... AS PublicationCount,
		... AS CitationPerPaper,
		... AS FirstPublicationYear,
		... AS LastPublicationYear,
		... AS PublishedYearCount,
		... AS SCIPaperCount,
		... AS MinImpactFactor,
		... AS MaxImpactFactor
	FROM ...
	ON ...
	GROUP BY ...
)
SELECT
	*
FROM AcademicianSummary
ORDER BY HIndex DESC

-- See  https://en.wikipedia.org/wiki/H-index
-- See  https://guides.erau.edu/bibliometrics/author-level/i10-index
-- See  https://scholar.google.com.tr/citations?user=LQg7qAEAAAAJ&hl=en
