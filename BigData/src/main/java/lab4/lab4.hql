with joined as (

	select 
		substr(eurusd_date, 6, 2) as month
		, sum(eurusd_max) as max 
	from 
		market.forex
	group by 
		substr(eurusd_date, 6, 2)
		
	union all
	
	select 
		substr(eurgbp_date, 6, 2) as month
		, sum(eurgbp_max) as max 
	from 
		market.forex
	group by 
		substr(eurgbp_date, 6, 2) 
	
	union all
	
	select  
		substr(eurchf_date, 6, 2) as month
		, sum(eurchf_max) as max 
	from 
		market.forex
	group by 
		substr(eurchf_date, 6, 2)
)


select 
	month
	, sum(max)
from 
	joined
where 
	month in ('07', '08', '09')
group by 
	month;
