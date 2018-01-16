# pg-shadows

This custom function adds shadow calculation to PostGIS.

<img src="https://github.com/OSMBuildings/pg-shadows/blob/master/Screenshot%202018-01-16%2010.39.34.png" height="400">

## Usage

`Shadow(ARRAY[azimuth decimal, altitude decimal], geometry, height)`

- ARRAY[azimuth, altitude] should be calculated on your side i.e. by Mourner's suncalc.
  We might add an appropriate SQL function later on.
- azimuth is horizontal angle in decimal degrees, orign north.
- altitude is vertical angle in decimal degrees.
- geometry is your geometry, i.e. building footprint
- height is your object's height in meters

Returns polygon geometry which you can use for shadow visualization or for intersection tests.

## Example

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
