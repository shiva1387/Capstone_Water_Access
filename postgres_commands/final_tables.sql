--Code to create the final tables in postgres

-- Sierra Leone

drop table if exists sierraleone_preds;

create table sierraleone_preds(row_id TEXT,country_name TEXT,water_source TEXT, water_tech TEXT,
	status_id TEXT,status_0_yes TEXT,management TEXT,pay TEXT,installer TEXT,
	install_year TEXT,status TEXT,source TEXT,adm1 TEXT,adm2 TEXT,wpdx_id TEXT,
	report_date TEXT,country_id TEXT,activity_id TEXT,data_lnk TEXT,orig_lnk TEXT,
	photo_lnk TEXT,converted TEXT,created TEXT,updated TEXT,lat_deg TEXT,lon_deg TEXT,Location TEXT,
	Count TEXT,fecal_coliform_presence TEXT,fecal_coliform_value TEXT,subjective_quality TEXT,
	new_report_date TEXT,new_install_year TEXT,age_well TEXT,age_well_days TEXT, 
	status_binary TEXT,time_since_measurement TEXT,time_since_meas_years TEXT,
	age_well_years TEXT,fuzzy_water_source TEXT,fuzzy_water_tech TEXT,today_preds TEXT,
	today_predprob TEXT,one_year_preds TEXT,one_year_predprob TEXT,three_year_preds TEXT,
	three_year_predprob TEXT,five_year_preds TEXT,five_year_predprob TEXT);

-- Load data from local csv
\copy sierraleone_preds FROM '/Users/Dan/Desktop/prediction_files/Sierra_Leone_w_outyear_predictions.csv'  DELIMITER ',' CSV HEADER;

-- Merge Swazi_preds with population data
ALTER TABLE sierraleone_preds ALTER today_predprob TYPE double precision USING today_predprob::double precision;
ALTER TABLE sierraleone_preds ALTER age_well_years TYPE double precision USING age_well_years::double precision;

drop table if exists sierraleone_final;

SELECT a.country_name, a.water_source, a.water_tech, a.status_id, a.install_year, 
a.lat_deg, a.lon_deg, a.time_since_meas_years, a.management, a.fuzzy_water_source, a.fuzzy_water_tech,
a.today_preds, a.today_predprob, a.wpdx_id, b.one_km_population, b.one_km_total_water_points,
b.one_km_functioning_water_points, b.key, b.district, b.sub_district, ((a.today_predprob * b.one_km_population) /(1+b.one_km_functioning_water_points)) as impact_score,
a.age_well_years, a.one_year_preds, a.one_year_predprob, a.three_year_preds,
a.three_year_predprob, a.five_year_preds, a.five_year_predprob
INTO sierraleone_final
FROM sierraleone_preds a
INNER JOIN sierra_leone_water_and_population b
ON cast(substring(a."wpdx_id" from 6 for 12) as int) = b.key
WHERE b.one_km_functioning_water_points >=0
;

ALTER TABLE sierraleone_final ALTER lat_deg  TYPE double precision USING lat_deg::double precision;
ALTER TABLE sierraleone_final ALTER lon_deg  TYPE double precision USING lon_deg:: double precision;
ALTER TABLE sierraleone_final ALTER today_preds type integer USING today_preds::integer;
ALTER TABLE sierraleone_final ALTER today_predprob TYPE double precision USING today_predprob::double precision;
-- ALTER TABLE sierraleone_final ALTER install_year TYPE float(1) USING install_year::float(1); Doesn't work because '__missing__'
ALTER TABLE sierraleone_final ALTER time_since_meas_years TYPE double precision using time_since_meas_years::double precision;
ALTER TABLE sierraleone_final ALTER one_year_preds TYPE float(1) USING one_year_preds::float(1);
ALTER TABLE sierraleone_final ALTER one_year_predprob TYPE double precision USING one_year_predprob::double precision;
ALTER TABLE sierraleone_final ALTER three_year_preds TYPE float(1) USING three_year_preds::float(1);
ALTER TABLE sierraleone_final ALTER three_year_predprob TYPE double precision USING three_year_predprob::double precision;
ALTER TABLE sierraleone_final ALTER five_year_preds TYPE float(1) USING five_year_preds::float(1);
ALTER TABLE sierraleone_final ALTER five_year_predprob TYPE double precision USING five_year_predprob::double precision;

-- Create Swazi_preds
drop table if exists swazi_preds;

create table swazi_preds(row_id TEXT,country_name TEXT,water_source TEXT, water_tech TEXT,
	status_id TEXT,status_0_yes TEXT,management TEXT,pay TEXT,installer TEXT,
	install_year TEXT,status TEXT,source TEXT,adm1 TEXT,adm2 TEXT,wpdx_id TEXT,
	report_date TEXT,country_id TEXT,activity_id TEXT,data_lnk TEXT,orig_lnk TEXT,
	photo_lnk TEXT,converted TEXT,created TEXT,updated TEXT,lat_deg TEXT,lon_deg TEXT,Location TEXT,
	Count TEXT,fecal_coliform_presence TEXT,fecal_coliform_value TEXT,subjective_quality TEXT,
	new_report_date TEXT,new_install_year TEXT,age_well TEXT,age_well_days TEXT, 
	status_binary TEXT,time_since_measurement TEXT,time_since_meas_years TEXT,
	age_well_years TEXT,fuzzy_water_source TEXT,fuzzy_water_tech TEXT,today_preds TEXT,
	today_predprob TEXT,one_year_preds TEXT,one_year_predprob TEXT,three_year_preds TEXT,
	three_year_predprob TEXT,five_year_preds TEXT,five_year_predprob TEXT);

-- Load data from local csv
\copy swazi_preds FROM '/Users/Dan/Desktop/prediction_files/Swaziland_w_outyear_predictions.csv'  DELIMITER ',' CSV HEADER;

-- Merge Swazi_preds with population data
ALTER TABLE swazi_preds ALTER today_predprob TYPE double precision USING today_predprob::double precision;
ALTER TABLE swazi_preds ALTER age_well_years TYPE double precision USING age_well_years::double precision;

drop table if exists swazi_final;

SELECT a.country_name, a.water_source, a.water_tech, a.status_id, a.install_year, 
a.lat_deg, a.lon_deg, a.time_since_meas_years, a.management, a.fuzzy_water_source, a.fuzzy_water_tech,
a.today_preds, a.today_predprob, a.wpdx_id, b.one_km_population, b.one_km_total_water_points,
b.one_km_functioning_water_points, b.key, b.district, b.sub_district, ((a.today_predprob * b.one_km_population) /(1+b.one_km_functioning_water_points)) as impact_score,
a.age_well_years, a.one_year_preds, a.one_year_predprob, a.three_year_preds,
a.three_year_predprob, a.five_year_preds, a.five_year_predprob
INTO swazi_final
FROM swazi_preds a
INNER JOIN swaziland_water_and_population b
ON cast(substring(a."wpdx_id" from 6 for 12) as int) = b.key
WHERE b.one_km_functioning_water_points >=0
;

ALTER TABLE swazi_final ALTER lat_deg  TYPE double precision USING lat_deg::double precision;
ALTER TABLE swazi_final ALTER lon_deg  TYPE double precision USING lon_deg:: double precision;
ALTER TABLE swazi_final ALTER today_preds type integer USING today_preds::integer;
ALTER TABLE swazi_final ALTER today_predprob TYPE double precision USING today_predprob::double precision;
-- ALTER TABLE swazi_final ALTER install_year TYPE float(1) USING install_year::float(1);
ALTER TABLE swazi_final ALTER time_since_meas_years TYPE double precision using time_since_meas_years::double precision;
ALTER TABLE swazi_final ALTER one_year_preds TYPE float(1) USING one_year_preds::float(1);
ALTER TABLE swazi_final ALTER one_year_predprob TYPE double precision USING one_year_predprob::double precision;
ALTER TABLE swazi_final ALTER three_year_preds TYPE float(1) USING three_year_preds::float(1);
ALTER TABLE swazi_final ALTER three_year_predprob TYPE double precision USING three_year_predprob::double precision;
ALTER TABLE swazi_final ALTER five_year_preds TYPE float(1) USING five_year_preds::float(1);
ALTER TABLE swazi_final ALTER five_year_predprob TYPE double precision USING five_year_predprob::double precision;








------------------------------------------------------------------------------------------------------------
-------------UNION- RUN AFTER TABLES MADE
------------------------------------------------------------------------------------------------------------
drop table if exists final_all;

create table final_all
AS
SELECT * FROM sierraleone_final
    UNION
SELECT * FROM swazi_final;




