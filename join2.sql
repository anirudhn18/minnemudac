 with lake as 
  (
  select DNR_ID_SITE_NUMBER, 
  avg(cast(TOTAL_PHOSPHORUS_RESULT as float64)) as avg_phos 
  from
  `datadive-142319.mces_lakes.1999_2014_monitoring_data`
  where TOTAL_PHOSPHORUS_RESULT is not null
  and substr(start_date,1,4) = "2014"
  group by 1
  ),
xref as
  (
  select parcel_centroid_lat, parcel_centroid_long, 
  MCES_Map_Code1,
  ceiling(cast(meters_to_lake_edge as float64)/1000) as dist_bucket
  from
  `datadive-142319.sds_xref.parcel_to_water`
  where meters_to_lake_edge <> '0'
  ),
tax as
  (
  select centroid_lat ,centroid_long,
  cast(ACRES_POLY as float64) as ACRES_POLY,
  cast(EMV_TOTAL as float64) as emv_total
  from
  `datadive-142319.metrogis_parcels.2015_tax_parcel_data`
  )
SELECT
  lake.DNR_ID_SITE_NUMBER, lake.avg_phos,
  xref.dist_bucket,
  count(*) as rowcnt,
  sum(tax.emv_total) as total_emv,
  sum(tax.acres_poly) as total_area
FROM tax
JOIN xref ON tax.centroid_long = xref.parcel_centroid_long
AND tax.centroid_lat = xref.parcel_centroid_lat
JOIN lake ON lake.DNR_ID_SITE_NUMBER = xref.MCES_Map_Code1
group by 1,2,3;