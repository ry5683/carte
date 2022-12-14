USE [Carte]
GO
/****** Object:  StoredProcedure [dbo].[MenuItemSpecials_Select_ById_PagedV2]    Script Date: 11/23/2022 4:10:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: <Ryan Murillo>
-- Create date: <11/1/2022>
-- Description: <Getting MenuItemId for mobileMenu>
-- Code Reviewer: Christian Tannahill 

-- MODIFIED BY: Ryan Murillo
-- MODIFIED DATE: 11/1/2022
-- Code Reviewer: Christian Tannahill
-- Note: Joining o.Id on mi.Id


ALTER proc [dbo].[MenuItemSpecials_Select_ById_PagedV2]
							@Id int
							,@PageIndex int 
							,@PageSize int
							
as
/*
Declare		@Id int = 2
			,@PageIndex int = 0
			,@PageSize int = 8
			
Execute dbo.MenuItemSpecials_Select_ById_PagedV2
		    @Id
			,@PageIndex
			,@PageSize 
		
select * 
from dbo.MenuItemSpecials			
*/
begin
declare @offset int = @PageIndex * @PageSize

SELECT mis.Id 
	  ,mi.Id 
      ,mi.Name
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
	  ,FoodWarningTypes = (Select fst.Id
								 ,fst.Name
							From dbo.FoodSafeTypes as fst inner join dbo.DietaryRestrictions as dr
									on  fst.Id = dr.FoodSafeTypeId
								inner join dbo.MenuItems as mi
									on mi.Id = dr.MenuItemId
						For JSON AUTO)

	  ,TotalCount = count(1) over()
FROM [dbo].[MenuItemSpecials] as mis
inner join MenuItems as mi
on mi.Id = mis.MenuItemId
inner join Organizations as o
on mis.MenuItemId = o.Id
WHERE mis.Id = @Id

order by mis.Id
OFFSET @offset rows 
fetch next @PageSize rows only 
end