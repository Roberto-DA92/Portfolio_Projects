/*

Cleaning Data 


*/


SELECT *
FROM portfolio_project.dbo.Nashville_TN_housing_data

-- Standardize Data Format

SELECT SaleDate_2, CONVERT (Date, SaleDate)
FROM portfolio_project.dbo.Nashville_TN_housing_data


Update Nashville_TN_housing_data
SET SaleDate = CONVERT (Date, SaleDate)

ALTER TABLE Nashville_TN_housing_data
Add SaleDate_2 Date;

Update Nashville_TN_housing_data
SET SaleDate_2 = CONVERT (Date, SaleDate)



-- Populate Property Address data

SELECT *
FROM portfolio_project.dbo.Nashville_TN_housing_data
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

/* Self JOIN the table, use ISNULL to compare both results */ 
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.dbo.Nashville_TN_housing_data AS a 
JOIN portfolio_project.dbo.Nashville_TN_housing_data AS b
ON a.ParcelID = b.ParcelID 
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

/* Update the table to eliminate the nulls */

UPDATE a
SET a.PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM portfolio_project.dbo.Nashville_TN_housing_data AS a 
JOIN portfolio_project.dbo.Nashville_TN_housing_data AS b
ON a.ParcelID = b.ParcelID 
AND a.UniqueID <> b.UniqueID




-- Breaking out Address into individual columns (Address, City, State)

SELECT PropertyAddress
FROM portfolio_project.dbo.Nashville_TN_housing_data
--WHERE PropertyAddress IS NULL


SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
FROM portfolio_project.dbo.Nashville_TN_housing_data


SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress)) AS City
FROM portfolio_project.dbo.Nashville_TN_housing_data


ALTER TABLE Nashville_TN_housing_data
Add PropertySplitAddress Nvarchar(255);

Update dbo.Nashville_TN_housing_data
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE Nashville_TN_housing_data
Add PropertySplitCity Nvarchar(255);

Update Nashville_TN_housing_data
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , LEN(PropertyAddress))


-- Let's do the same, but with PARSENAME for the Owner Address comlumn

SELECT *
FROM portfolio_project.dbo.Nashville_TN_housing_data


 SELECT
 PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3), 
  PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2), 
   PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1) 
 FROM portfolio_project.dbo.Nashville_TN_housing_data

 ALTER TABLE Nashville_TN_housing_data
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_TN_housing_data
SET OwnerSplitAddress =  PARSENAME (REPLACE (OwnerAddress, ',', '.'), 3)

ALTER TABLE Nashville_TN_housing_data
Add OwnerSplitCity Nvarchar(255);

Update Nashville_TN_housing_data
SET OwnerSplitCity = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 2)

ALTER TABLE Nashville_TN_housing_data
Add OwnerSplitState Nvarchar(255);

Update Nashville_TN_housing_data
SET OwnerSplitState = PARSENAME (REPLACE (OwnerAddress, ',', '.'), 1)



 /* I created a wrong column, so I had to drop the column*/

 ALTER TABLE portfolio_project.dbo.Nashville_TN_housing_data 
 DROP COLUMN OwnerSplitCityy




 
 -- Change Y and N to Yes and No in "Sold as Vacant" field


 SELECT DISTINCT (SoldAsVacant), COUNT (SoldAsVacant)
 FROM portfolio_project.dbo.Nashville_TN_housing_data
 GROUP BY SoldAsVacant
 ORDER BY 2
 
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
            WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SOldAsVacant
			END           
FROM portfolio_project.dbo.Nashville_TN_housing_data

UPDATE Nashville_TN_housing_data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
            WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SOldAsVacant
			END           



-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_num

FROM portfolio_project.dbo.Nashville_TN_housing_data
--ORDER BY ParcelID
)

DELETE
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress




-- DELETE Unused Columns

SELECT * 
FROM portfolio_project.dbo.Nashville_TN_housing_data

ALTER TABLE portfolio_project.dbo.Nashville_TN_housing_data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE portfolio_project.dbo.Nashville_TN_housing_data
DROP COLUMN SaleDate