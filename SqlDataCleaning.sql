--Cleaning some Data using SQL Queries

Select Top(1000) * 
from [dbo].[NashvilleHousing]

-----------------------------------------------------------------------

--- 1) Change the date format from date time format

alter table [dbo].[NashvilleHousing]
add SaleDateConverted Date;

Update [dbo].[NashvilleHousing]
SET SaleDateConverted = convert(Date,SaleDate)

---------------------------------------------------------------------

--- 2) Some of the property address' are null. Observe that same Parcel IDs should have the same Property address'

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
From [dbo].[NashvilleHousing] a 
Join [dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.propertyaddress,b.PropertyAddress)
From [dbo].[NashvilleHousing] a 
Join [dbo].[NashvilleHousing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Check, none are null anymore
Select propertyaddress
from [dbo].[NashvilleHousing]
where PropertyAddress is null

---------------------------------------------------------------------------

--- 3) Break the address' into individual columns for address, city , state

Select propertyaddress, OwnerAddress
from [dbo].[NashvilleHousing]

--- For Property Address, We can see the format - address, city. So we need to separate the address and city.
--- Using Substring Function

Select SUBSTRING(propertyaddress, 1, charindex(',', Propertyaddress) - 1) as Address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, Len(propertyaddress)) as City
from [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing]
add PropAddress nvarchar(255), PropCity nvarchar(255);

update [dbo].[NashvilleHousing]
set PropAddress = SUBSTRING(propertyaddress,1, charindex(',', Propertyaddress) - 1),
PropCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, Len(propertyaddress))



-- For owner address it is address, city, state
-- Use Parsename to split delimiters, in this case we will turn commas into periods.

Select PARSENAME(replace(owneraddress, ',', '.'), 3) as Address,
PARSENAME(replace(owneraddress, ',', '.'), 2) as City,
PARSENAME(replace(owneraddress, ',', '.'), 1) as State
From [dbo].[NashvilleHousing]

alter table [dbo].[NashvilleHousing]
add OwnerSplitAddress nvarchar(255), OwnerSplitCity nvarchar(255), OwnerSplitState nvarchar(255);

update [dbo].[NashvilleHousing]
set OwnerSplitAddress = PARSENAME(replace(owneraddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(replace(owneraddress, ',', '.'), 2),
	OwnerSplitState = PARSENAME(replace(owneraddress, ',', '.'), 1)

-------------------------------------------------------------

--- 4) Look at SoldasVacant column it should only have "Yes" or "No" but has "Y" and "N" as well

Select Distinct(SoldasVacant)
From [dbo].[NashvilleHousing]

Select SoldasVacant,
Case When SoldasVacant = 'Y' Then 'Yes'
     When SoldasVacant = 'N' Then 'No'
	 Else SoldasVacant
	 End
From [dbo].[NashvilleHousing]

Update [dbo].[NashvilleHousing]
Set SoldAsVacant = Case When SoldasVacant = 'Y' Then 'Yes'
     When SoldasVacant = 'N' Then 'No'
	 Else SoldasVacant
	 End

--- Now we only have Yes and No for the column SoldasVacant
Select Distinct(SoldasVacant)
From [dbo].[NashvilleHousing]

--------------------------------------------------------------------

--- 5) Remove duplicates 

-- eliminate duplicate rows using row numbers 

Select *,
ROW_NUMBER() over (partition by ParcelID, Propertyaddress, Saleprice, Saledate, LegalReference order by uniqueid) row_num
From [dbo].[NashvilleHousing]

--use CTE

With RowNumCTE AS(
Select *,
ROW_NUMBER() over (partition by ParcelID, Propertyaddress, Saleprice, Saledate, LegalReference order by uniqueid) row_num
From [dbo].[NashvilleHousing]
)

Delete
From RowNumCTE
where row_num > 1

----------------------------------------------------------------------------

--- 6) Delete unused columns 

Alter table [dbo].[NashvilleHousing]
drop column PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

Select * 
From [dbo].[NashvilleHousing]

-----------------------------------------------------------------------------













































