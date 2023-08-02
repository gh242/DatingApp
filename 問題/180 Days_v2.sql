select 
	folder as rptfolder,rptname as rptname  ,max(lastexecutetime) as lastexecutetime,
	sum(data1.cnt ) as cnt ,
	STRING_AGG( UserName    , ',') WITHIN GROUP  (order BY UserName ) as username 
from 
(
	select distinct folder ,rptname as rptname ,convert(varchar,max(executetime),111) as lastexecutetime,
	count(*) as cnt ,username
	from 
	(
		select   SUBSTRING(t2.Path,1,LEN(t2.Path)-LEN(t2.Name)) AS Folder
		,t2.Name as rptname ,t1.TimeStart as executetime ,t1.UserName
		from ReportServer.dbo.ExecutionLog t1, ReportServer.dbo.Catalog t2
		where 1=1
		and t1.ReportID = t2.ItemID
		and rtrim(isnull(t2.path,''))<>''
		and upper( t2.name) like upper( @parmRptName)+'%'
		--and t2.name ='SRD Idle Time Instant'
		and t1.timestart>dateadd(day ,-180, getdate())
		and t1.status='rsSuccess'
	)data
	group by data.folder,data.rptname,data.username 
)data1
group by data1.folder,data1.rptname 
order by cnt desc 