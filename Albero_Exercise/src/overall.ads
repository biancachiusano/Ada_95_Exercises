package overall is

   type Coordinate is record
      lon : Float range -180.0..180.0;
      lat : Float range -90.0..90.0;
      alt : Float := 5000.0;
   end record;

   type Coordinate_Store is array(1..12) of Coordinate;
   type Dist_Store is array(2..12) of Float;
   type Theta_Store is array(2..12) of Float;

   function deg_to_rad(deg: Float) return Float;
   function rad_to_deg(rad: Float) return Float;
   function handle_lat(lat: Float) return Float;
   function handle_lon(lon: Float) return Float;
   procedure update_vars(current: out Coordinate;
                         future: in out Coordinate);

   function remove_spaces(actual: String) return String;
   procedure print_coors(coor_store: in Coordinate_Store);

end overall;
