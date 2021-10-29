rmf hdfs://hadoop-master:54310/user/hduser/results/rostyslav_koval_lab3

forex_history = LOAD 'hdfs://hadoop-master:54310/user/hduser/market/EURUSD_GBP_CHF.csv' USING PigStorage(',') as
                      (eurusd_date:chararray, eurusd_time:chararray, eurusd_open:float, eurusd_max:float, eurusd_min:float, eurusd_close:float, eurusd_volume:float,
                       eurgbp_date:chararray, eurgbp_time:chararray, eurgbp_open:float, eurgbp_max:float, eurgbp_min:float, eurgbp_close:float, eurgbp_volume:float,
					   eurchf_date:chararray, eurchf_time:chararray, eurchf_open:float, eurchf_max:float, eurchf_min:float, eurchf_close:float, eurchf_volume:float);

usd_dt = FOREACH forex_history GENERATE eurusd_date as date, eurusd_max as max;
gdp_dt = FOREACH forex_history GENERATE eurgbp_date as date, eurgbp_max as max;
chf_dt = FOREACH forex_history GENERATE eurchf_date as date, eurchf_max as max;

all_dt = UNION usd_dt, gdp_dt, chf_dt;

jul_fltr = FILTER all_dt BY SUBSTRING(date, 5, 7) == '07';
aug_fltr = FILTER all_dt BY SUBSTRING(date, 5, 7) == '08';
sep_fltr = FILTER all_dt BY SUBSTRING(date, 5, 7) == '09';

jul_all = GROUP jul_fltr ALL;
aug_all = GROUP aug_fltr ALL;
sep_all = GROUP sep_fltr ALL;

jul_sum = FOREACH jul_all GENERATE '07', SUM(jul_fltr.max);
aug_sum = FOREACH aug_all GENERATE '08', SUM(aug_fltr.max);
sep_sum = FOREACH sep_all GENERATE '09', SUM(sep_fltr.max);

result = UNION jul_sum, aug_sum, sep_sum;

STORE result INTO 'hdfs://hadoop-master:54310/user/hduser/results/rostyslav_koval_lab3' USING PigStorage (',');
