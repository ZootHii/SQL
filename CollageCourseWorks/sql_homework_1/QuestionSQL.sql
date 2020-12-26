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
	*
FROM Emp
