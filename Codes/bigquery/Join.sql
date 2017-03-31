SELECT
*
FROM [datadive-142319:metrogis_parcels.2015_tax_parcel_data] AS tax
  JOIN [datadive-142319:sds_xref.parcel_to_water] AS intersection ON tax.centroid_long = intersection.parcel_centroid_long
                                                                  AND tax.centroid_lat = intersection.parcel_centroid_lat
  JOIN [datadive-142319:mces_lakes.1999_2014_monitoring_data] AS lake ON lake.DNR_ID_SITE_NUMBER = intersection.MCES_Map_Code1
