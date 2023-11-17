with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body overall is

   -- Function to transform degrees to radians 
   function deg_to_rad(deg: Float) return Float is    
   begin
      return deg * Pi/ 180.0;
   end deg_to_rad;
   
   -- Function to convert radians to degrees 
   function rad_to_deg(rad: Float) return Float is
   begin
      return rad*180.0/Pi;
   end rad_to_deg;
   
   
   -- Handle Latitude (RECURSVE)
   function handle_lat(lat: Float) return Float is
      diff : Float := 0.0;
      control : constant Float := 90.0;
   begin
      if lat >= -90.0 and lat <= 90.0 then
         return lat;
      else  
         if lat > control then
            diff := lat - control;
            return handle_lat(control - diff); -- recursive
         end if;
      
         if lat < (control*(-1.0)) then
            diff := lat + control;
            return handle_lat(diff*(-1.0) - control); -- recursive
         end if;
      end if;
      
      return lat;

   end handle_lat;
   
   -- Handle Longitude (RECURSIVE)
   function handle_lon(lon: Float) return Float is
      diff : Float := 0.0;
      control : constant Float := 180.0;
   begin
      if lon >= -180.0 and lon <=180.0 then
         return lon;
      else 
         if lon > control then
            diff := lon - control;
            return handle_lon(diff - control); -- Recursive
         end if;
      
         if lon < (control*(-1.0)) then
            diff := lon + control;
            return handle_lon(diff + control); -- Recursive
         end if;
      end if;
      
      return lon;
     
   end handle_lon;
      
   
   -- Update current and future coordinates
   procedure update_vars(current: out Coordinate;
                         future: in out Coordinate) is
      tmp_coor : Coordinate := (0.0, 0.0, 5000.0);
   begin
      current := future;
      future := tmp_coor;
   end update_vars;
   
   
   -- Remove spaces in the printing
   function remove_spaces(actual: String) return String is
      no_space_str : Unbounded_String :=Null_Unbounded_String;
   begin
      
      for I in actual'range loop
         if actual(I) /= ' ' then
            Append(no_space_str, actual(I));
         end if;
      end loop;
      
      return To_String(no_space_str);
   end remove_spaces;
   
   procedure print_coors(coor_store: in Coordinate_Store) is
   begin
      for I in 1..12 loop
         Put_Line(Float'Image(coor_store(I).lon) & "," & 
                    Float'Image(coor_store(I).lat) & "," & 
                    Float'Image(coor_store(I).alt));
      end loop;
   end print_coors;
   
end overall;
