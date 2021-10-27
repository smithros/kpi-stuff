forex_history = LOAD 'hdfs://hadoop-master:54310/user/hduser/market/EURUSD_GBP_CHF.csv' USING PigStorage(',') as
                      (eurusd_date:chararray, eurusd_time:chararray, eurusd_open:float, eurusd_max:float, eurusd_min:float, eurusd_close:float, eurusd_volume:float,
                       eurgbp_date:chararray, eurgbp_time:chararray, eurgbp_open:float, eurgbp_max:float, eurgbp_min:float, eurgbp_close:float, eurgbp_volume:float,
					   eurchf_date:chararray, eurchf_time:chararray, eurchf_open:float, eurchf_max:float, eurchf_min:float, eurchf_close:float, eurchf_volume:float);

jul_usd = FOREACH (FILTER forex_history BY SUBSTRING(eurusd_date, 5, 7) == '07') GENERATE eurusd_date as date, eurusd_max as max;
aug_usd = FOREACH (FILTER forex_history BY SUBSTRING(eurusd_date, 5, 7) == '08') GENERATE eurusd_date as date, eurusd_max as max;
sep_usd = FOREACH (FILTER forex_history BY SUBSTRING(eurusd_date, 5, 7) == '09') GENERATE eurusd_date as date, eurusd_max as max;

jul_gdp = FOREACH (FILTER forex_history BY SUBSTRING(eurgbp_date, 5, 7) == '07') GENERATE eurgbp_date as date, eurgbp_max as max;
aug_gdp = FOREACH (FILTER forex_history BY SUBSTRING(eurgbp_date, 5, 7) == '08') GENERATE eurgbp_date as date, eurgbp_max as max;
sep_gdp = FOREACH (FILTER forex_history BY SUBSTRING(eurgbp_date, 5, 7) == '09') GENERATE eurgbp_date as date, eurgbp_max as max;

jul_chf = FOREACH (FILTER forex_history BY SUBSTRING(eurchf_date, 5, 7) == '07') GENERATE eurchf_date as date, eurchf_max as max;
aug_chf = FOREACH (FILTER forex_history BY SUBSTRING(eurchf_date, 5, 7) == '08') GENERATE eurchf_date as date, eurchf_max as max;
sep_chf = FOREACH (FILTER forex_history BY SUBSTRING(eurchf_date, 5, 7) == '09') GENERATE eurchf_date as date, eurchf_max as max;

jul_all = UNION jul_usd, jul_gdp, jul_chf;
aug_all = UNION aug_usd, aug_gdp, aug_chf;
sep_all = UNION sep_usd, sep_gdp, sep_chf;

jul_group = GROUP jul_all ALL;
aug_group = GROUP aug_all ALL;
sep_group = GROUP sep_all ALL;

jul_sum = FOREACH jul_group GENERATE '07', SUM(jul_all.$1); 
aug_sum = FOREACH aug_group GENERATE '08', SUM(aug_all.$1); 
sep_sum = FOREACH sep_group GENERATE '09', SUM(sep_all.$1); 

result = UNION jul_sum, aug_sum, sep_sum;

STORE result INTO 'hdfs://hadoop-master:54310/user/hduser/results/rostyslav_koval_lab3' USING PigStorage (',');
