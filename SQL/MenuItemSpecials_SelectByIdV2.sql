USE [Carte]
GO
/****** Object:  StoredProcedure [dbo].[MenuItemSpecials_Select_ByIdV2]    Script Date: 11/23/2022 4:12:02 PM ******/
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

ALTER proc [dbo].[MenuItemSpecials_Select_ByIdV2]
				@Id int
as
/*
Declare
			@Id int = 2
Execute dbo.MenuItemSpecials_Select_ByIdV2 @Id 

select * 
from dbo.MenuItemSpecials 

*/
begin 
SELECT msu.[Id]
	  ,mi.Id as MenuItemId
      ,msu.[Name]
      ,msu.[Details]
      ,msu.[MenuItemId] as MenuItemSpecialId
      ,msu.[MaxQuantity]
      ,msu.[SpecialCost]
      ,msu.[IsPublished]
      ,msu.[IsDeleted]
      ,msu.[StartDate]
      ,msu.[EndDate]
      ,msu.[CreatedBy]
      ,msu.[ModifiedBy]
      ,msu.[DateCreated]
      ,msu.[DateModified]
	  ,FoodWarningTypes = (Select fst.Id
								 ,fst.Name
							From dbo.FoodSafeTypes as fst inner join dbo.DietaryRestrictions as dr
									on  fst.Id = dr.FoodSafeTypeId
								inner join dbo.MenuItems as mi
									on mi.Id = dr.MenuItemId
							Where mi.Id = @Id
						For JSON AUTO)

FROM [dbo].[MenuItemSpecials] as msu
inner join MenuItems as mi
on mi.Id = msu.MenuItemId
inner join Organizations as o
on msu.MenuItemId = o.Id
where msu.Id = @Id
end



