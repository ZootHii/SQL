SELECT
    PersonType
    , Title
    , FirstName + COALESCE(' ' + MiddleName, '') + ' ' + LastName AS FullName
    , JobTitle
    , (CASE
          WHEN MaritalStatus = 'M' AND Gender = 'F' THEN 'Married Female'
          WHEN MaritalStatus = 'M' AND Gender = 'M' THEN 'Married Male'
          WHEN MaritalStatus = 'S' AND Gender = 'F' THEN 'Single Female'
          WHEN MaritalStatus = 'S' AND Gender = 'M' THEN 'Single Male'
          ELSE 'Unknown'
       END) AS SocialStatus
    , DATEDIFF(DAY, BirthDate, CURRENT_TIMESTAMP) / 365 AS Age
    , CAST(DATEPART(Month, HireDate) AS VARCHAR(8)) + '/'
        + CAST(DATEPART(Year, HireDate) AS VARCHAR(8)) AS HireMonthYear
FROM Emp
WHERE Title IS NOT NULL