CREATE OR REPLACE FUNCTION Shadow(sun decimal[], geom geometry, height decimal) RETURNS geometry AS $$
-- made by OSM Buildings
DECLARE
  azimuth decimal = -sun[1]*PI()/180 - PI()/2;
  altitude decimal = sun[2]*PI()/180;
  length decimal = 1 / TAN(altitude);
  XOff decimal = COS(azimuth) * length;
  YOff decimal = SIN(azimuth) * length;
  i integer;
  footprint geometry;
  shadow geometry;
  x1 decimal;
  y1 decimal;
  _x1 decimal;
  _y1 decimal;
  x2 decimal;
  y2 decimal;
  _x2 decimal;
  _y2 decimal;
BEGIN
  footprint = ST_ExteriorRing(geom);
  shadow = ST_Translate(geom, XOff, YOff);
  FOR i IN 0..ST_NPoints(footprint)-2 LOOP
    x1 = ST_X(ST_PointN(footprint, i+1));
    y1 = ST_Y(ST_PointN(footprint, i+1));
    _x1 = x1 + XOff*height;
    _y1 = y1 + YOff*height;
    --
    x2 = ST_X(ST_PointN(footprint, i+2));
    y2 = ST_Y(ST_PointN(footprint, i+2));
    _x2 = x2 + XOff*height;
    _y2 = y2 + YOff*height;
    --
    shadow = ST_Union(
        shadow,
        ST_MakePolygon(
          ST_SetSRID(
            ST_MakeLine(ARRAY[
              ST_MakePoint(x1, y1),
              ST_MakePoint(x2, y2),
              ST_MakePoint(_x2, _y2),
              ST_MakePoint(_x1, _y1),
              ST_MakePoint(x1, y1)
            ]),
            ST_SRID(shadow)
          )
        )
      );
  END LOOP;
  shadow = ST_Simplify(shadow, 0.01);
  RETURN shadow;
END; 
$$ LANGUAGE plpgsql;
