USE [WarInfo]
GO

DECLARE @YYYYMMDD SMALLDATETIME;
SET @YYYYMMDD = '20230718';

-- DECLARE @MANU_REALDATE nvarchar(10);
-- SET @MANU_REALDATE = '20230718';

-- 宣告純量變數
declare @MANU_REALDATE varchar(50) = '20230718';
declare @WIP_DATE SMALLDATETIME = '2020-04-20 09:20:00.000';

DECLARE @MANU_ENDTIME nvarchar(10);
SET @MANU_ENDTIME = '080313';





-- select Convert(VarChar(10), DateAdd(minute, -440, @RealDate), 111) -- 2023/07/03

-- select DateAdd(n, 440, @YYYYMMDD) ; -- 2023-07-17 07:20:00
-- select DateAdd(n, 560, @YYYYMMDD)  ;-- 2023-07-17 09:20:00
-- select DateAdd(n, 1760, @YYYYMMDD);  -- 2023-07-18 05:20:00
-- select DateAdd(n, 1880, @YYYYMMDD) ; -- 2023-07-18 07:20:00

-- select DateAdd(n, 440, @RealDate-14); --2023-06-20 07:20:00
-- select DateAdd(n, 440, @RealDate+1)	  -- 2023-07-05 07:20:00

-----SELECT convert(varchar, getdate(), 108) - hh:mm:ss
select convert(char(8), @WIP_DATE, 108) -- 09:20:00


-------------Oracle wf3000
-----------FUN_DATEDIFFSECOND  函數功能：時間相減

-- WF3000.FUN_DATEDIFFSECOND(ENDTIME, STARTTIME)
/*
create or replace FUNCTION  FUN_DATEDIFFSECOND
( EndTime IN Date, StartTime in Date
) RETURN int AS
BEGIN
    RETURN 24*60*60*(EndTime-StartTime)+1;
END  FUN_DATEDIFFSECOND;
*/

--------RealDateToMfgDate----
-- 回傳 DateTime
--函數位置：資料表\可程式性\函數\純量值函數
--功能：減7小時20分，取年月日格式(yyyy/mm/dd)
-- [dbo].[RealDateToMfgDate]
-- dbo.RealDateToMfgDate(CollectionTime) -- 減440分，取年月日格式(yyyy/mm/dd)
/*
ALTER Function [dbo].[RealDateToMfgDate](@RealDate DateTime) Returns DateTime 
As  
Begin 
	 Return
		Case IsDate(@RealDate) 			----SELECT convert(varchar, getdate(), 111) - yyyy/mm/dd
	  		When 1 Then Cast(Convert(VarChar(10), DateAdd(minute, -440, @RealDate), 111) As DateTime)
			Else Null
		End
End
*/

--------RealDateToMfgDate10----
-- 回傳 Date
/*
ALTER Function [dbo].[RealDateToMfgDate10](@RealDate DateTime) Returns Date
As  
Begin 
	 Return
		Case IsDate(@RealDate) 
	  		When 1 Then Cast(Convert(VarChar(10), DateAdd(minute, -440, @RealDate), 111) As Date)
			Else Null
		End
End
GO
*/

--------RealDateToWeekNo----
/*
ALTER Function [dbo].[RealDateToWeekNo](@RealDate DateTime)  Returns Char(6) 
As  
Begin

	Declare @WeekNo As Char(6)

	If IsDate(@RealDate) = 1
		If DATENAME(wk, @RealDate)=53 
			--'If  Datepart(dw, @RealDate)=6
				Set @WeekNo = right(cast(Datepart(yy, @RealDate) as char(4)), 2)+'wk'+Replicate('0',2-Len(Convert(Varchar(2),DATENAME(wk, @RealDate))))+Convert(Varchar(2),DATENAME(wk, @RealDate))
			--Else
			--	Set @WeekNo = right(cast(Datepart(yy, @RealDate)+1 as char(4)), 2)+'wk01'
		Else
			Set @WeekNo =right(cast(Datepart(yy, @RealDate) as char(4)), 2)+'wk'+Replicate('0',2-Len(Convert(Varchar(2),DATENAME(wk, @RealDate))))+Convert(Varchar(2),DATENAME(wk, @RealDate))
	Else
		Set @WeekNo = Null

	Return @WeekNo

End



DECLARE @EndDate SMALLDATETIME;
SET @EndDate = '20230801';
--往前推 ? 日
DECLARE @DistanceDaily int;
SET @DistanceDaily = 14;
--往前推 ? 週
DECLARE @DistanceWeekly int;
SET @DistanceWeekly = 12;
--往前推 ? 月
DECLARE @DistanceMonthly int;
SET @DistanceMonthly = 13;


with
CTEWeek as (
select N=0
union all 
select N+7 from CTEWeek where N<DateDiff(day, @EndDate-7*@DistanceWeekly, @EndDate) 
)
select 'MFGDate'=dbo.RealDateToWeekNo(cast(DateAdd(day, -1*N, @EndDate)+' 00:00:00' as datetime))
          --,'TargetYield'=@TargetYield1
from CTEWeek
MFGDate
-------
23wk31
23wk30
23wk29
23wk28
23wk27
23wk26
23wk25
23wk24
23wk23
23wk22
23wk21
23wk20
23wk19
*/

--------RealDateToMonthFirstDate----
/*
ALTER Function [dbo].[RealDateToMonthFirstDate](@RealDate DateTime) Returns DateTime 
As  
Begin 
	 Return
		Case IsDate(@RealDate) 
	  		When 1 Then Cast(Convert(VarChar(10),  DateAdd(day, -Day(@RealDate)+1, @RealDate), 111) + '  00:00:00' As DateTime)
			Else Null
		End
End
*/
--------RealDateToMonthNo----
/*
ALTER Function [dbo].[RealDateToMonthNo](@RealDate DateTime) Returns Char(7) 
As  
Begin 
	  Return
		Case IsDate(@RealDate) 
	  		When 1 Then Convert(Varchar(4),Year(@RealDate))+'-'+Replicate('0',2-Len(Convert(Varchar(2),Datepart(mm,@RealDate))))+Convert(Varchar(2),Datepart(mm,@RealDate))
	  		Else Null
		End
End
*/
--------RealDateToWeekFirstDate----
/*
ALTER Function [dbo].[RealDateToWeekFirstDate](@RealDate DateTime) Returns DateTime 
As  
Begin 
	 Return
		Case IsDate(@RealDate) 
	  		When 1 Then Cast(Convert(VarChar(10), DateAdd(day, -Datepart(dw,@RealDate)+1, @RealDate), 111) + '  00:00:00' As DateTime)
			Else Null
		End
End
*/



--報表15
--where MFG_Date between convert(char(8), @YYYYMMDD-Day(@YYYYMMDD)+1, 112)  and convert(char(8), @YYYYMMDD, 112) 
-- select
-- left(convert(char(8), @YYYYMMDD, 112), 6)+'01'
-- --20230701

-- select
-- convert(char(8), @YYYYMMDD-Day(@YYYYMMDD)+1, 112)
-- --20230701

-- select 
-- convert(char(8), @YYYYMMDD, 112) 
-- --20230718

-- select 
-- DateAdd(n, 440, @YYYYMMDD-14) 
-- --2023-07-04 07:20:00
-- select 
-- DateAdd(n, 440, @YYYYMMDD+1) 
-- --2023-07-19 07:20:00

-- select
-- DateAdd(mi, 1880, @YYYYMMDD)   --加31小時20分
--2023-07-19 07:20:00

--報表28
-- cast
-- cast(Polisher as varchar)
-- 這些函式會將某種資料類型的運算式轉換成另一種資料類型。

--報表31
-- select 
-- cast(left(@MANU_REALDATE, 4)
--                            +'-'+substring(@MANU_REALDATE, 5, 2)
--                            +'-'+right(@MANU_REALDATE, 2)
--                            +' '+left(@MANU_ENDTIME, 2)
--                            +':'+substring(@MANU_ENDTIME, 3, 2)
--                            +':'+right(@MANU_ENDTIME, 2) as DateTime)
-- 2023-07-18 08:03:13.000  (cast ... as DateTime)


-- DECLARE @EndDate SMALLDATETIME;
-- SET @EndDate = '20230801';
-- --往前推 ? 日
-- DECLARE @P_Day int;
-- SET @P_Day = 14;

-- --往前算14天
-- select 
-- dateadd(d, -1*@P_Day+1, @EndDate)  --2023-07-19 00:00:00
-- select 
-- convert(char(8),dateadd(d, -1*@P_Day+1, @EndDate), 112) -- 20230719

--往前推 ? 週
-- DECLARE @P_week int;
-- SET @P_week = 10;
-- select
-- convert(char(8), [dbo].[RealDateToWeekFirstDate](DateAdd(d, -7*@P_week+7, @EndDate)), 112)
-- --20230528


-- DECLARE @P_month int;
-- SET @P_month = 10;
-- --往前推 ? 月
-- select
-- convert(char(8), [dbo].[RealDateToMonthFirstDate](DateAdd(m, -1*@P_month+1, @EndDate)), 112)
-- --20221101