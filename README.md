# pg-shadows

Shadow calculation in PostGIS

~~~ sql
SELECT
  ST_AsGeoJSON(ST_Transform(way, 4326))::json AS geometry,
  ST_AsGeoJSON(
    ST_Transform(
  	  Shadow(ARRAY[90, 5], way, 25),
	  4326)
 )::json AS shadow
FROM
  planet_osm_polygon
WHERE
  osm_id = 313670734
~~~
