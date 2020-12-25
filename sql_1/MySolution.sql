WITH Emp AS
(
	SELECT
		PersonType
		, Title
		, FirstName
		, MiddleName
		, LastName
		, JobTitle
		, BirthDate
		, MaritalStatus
		, Gender
		, HireDate
	FROM HumanResources.Employee AS E INNER JOIN Person.Person AS P
	ON E.BusinessEntityID = P.BusinessEntityID
	
)
SELECT 
	PersonType
	, Title
	, CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS FullName
	, JobTitle
	, CONCAT(REPLACE(REPLACE(MaritalStatus, 'M', 'Married'), 'S', 'Single'),
	' ',REPLACE(REPLACE(Gender, 'M', 'Male'), 'F', 'Female')) AS SocialStatus
	, DATEDIFF(YEAR, BirthDate, CURRENT_TIMESTAMP) AS Age
	, CAST(MONTH(HireDate) AS VARCHAR)+'/'+CAST(YEAR(HireDate) AS VARCHAR) AS HireMonthYear
	--this looks better I think
	, SUBSTRING(CAST(HireDate AS VARCHAR(10)), 6, 2)+'/'+LEFT(HireDate, 4) AS HireMonthYear 
FROM Emp
WHERE Title IS NOT NULL;
