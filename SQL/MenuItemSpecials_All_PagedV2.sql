USE [Carte]
GO
/****** Object:  StoredProcedure [dbo].[MenuItemSpecials_All_PagedV2]    Script Date: 11/23/2022 4:11:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: <Ryan Murillo>
-- Create date: <11/1/2022>
-- Description: <Getting MenuId for mobileMenu>
-- Code Reviewer: Christian Tannahill 

-- MODIFIED BY: Ryan Murillo
-- MODIFIED DATE: 11/1/2022
-- Code Reviewer: Christian Tannahill
-- Note: I'm joining o.Id on mi.Id 

ALTER proc [dbo].[MenuItemSpecials_All_PagedV2]
							@PageIndex int
							,@PageSize int
							,@orgId int
							
as
/*
Declare		@PageIndex int = 0
			,@PageSize int = 8
			,@orgId int = 1
			
Execute dbo.MenuItemSpecials_All_PagedV2
			@PageIndex
			,@PageSize 
			,@orgId
		
select * 
from dbo.MenuItemSpecials

select * 
from dbo.MenuItems

*/
begin
declare @offset int = @PageIndex * @PageSize

SELECT mis.Id
	  ,mi.Id as MenuItemId
	  ,o.Id
	  ,mis.Name
      ,mis.Details
      ,mis.MenuItemId as MenuItemSpecialId
      ,mis.MaxQuantity
      ,mis.SpecialCost
      ,mis.IsPublished
      ,mis.IsDeleted
      ,mis.StartDate
      ,mis.EndDate
      ,mis.CreatedBy
      ,mis.ModifiedBy
      ,mis.DateCreated
      ,mis.DateModified
	  ,FoodSafeTypes = (Select fst.Id
								 ,fst.Name
							From dbo.FoodSafeTypes as fst inner join dbo.DietaryRestrictions as dr
									on  fst.Id = dr.FoodSafeTypeId and dr.MenuItemId = mi.Id
						For JSON AUTO)

	  ,TotalCount = count(1) over()
FROM [dbo].[MenuItemSpecials] as mis
inner join MenuItems as mi
on mi.Id = mis.MenuItemId
inner join Organizations as o
on o.Id = @orgId

--WHERE o.Id = @orgId

order by mis.Id
OFFSET @offset rows 
fetch next @PageSize rows only 
end
