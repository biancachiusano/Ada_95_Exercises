with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; 
use Ada.Numerics.Elementary_Functions;
with overall; use overall;

package body haversine is

   function haversine_distance(d: in Float;
                               t: in Float;
                               o_x: in Float;
                               o_y: in Float;
                               dist_arr: in Dist_Store;
                               theta_arr: in Theta_Store;
                               symm: in Boolean) return Coordinate_Store is
   
      -- Store the 12 coordinates
      coor_store : Coordinate_Store;
      
      -- Initialising the input paramenters
      dist: constant Float := d; 
      theta: constant Float := t; 
      origin: constant Coordinate := (o_x,o_y, 5000.0);
      
      -- Radial distance earth
      R: constant Float := 3440.065; 
      
      -- Keeping track of where we are
      current_coor: Coordinate := origin; 
      future_coor: Coordinate;
      
      -- Debug
      DEBUG: Boolean := False;
      
         
      function calc_coord(theta_add: in Float; dist_add: in Float) return Coordinate is

         dir: Float := theta + theta_add; 
         dist_tmp: Float;
         
      begin
         
         if dist_add = 0.0 then
            dist_tmp := dist;
         else
            dist_tmp := dist * dist_add;
         end if;
         
         -- Transforming into radians
         current_coor.lat := deg_to_rad(current_coor.lat);
         current_coor.lon := deg_to_rad(current_coor.lon);
         
         dir := deg_to_rad(dir); 
 
         -- calculate latitude (Radians)
         future_coor.lat := Arcsin(Sin(current_coor.lat)
                                   *Cos(dist_tmp/R) 
                                   +Cos(current_coor.lat)
                                   *Sin(dist_tmp/R)
                                   *Cos(dir));
         
         -- calculate longitude (Radians)
         future_coor.lon := current_coor.lon + Arctan(Sin(dir)
                                                      *Sin(dist_tmp/R)
                                                      *Cos(current_coor.lat),
                                                      Cos(dist_tmp/R)
                                                      -Sin(current_coor.lat)
                                                      *Sin(future_coor.lat));
         -- transform back into degrees  
         future_coor.lat := handle_lat(rad_to_deg(future_coor.lat));
         future_coor.lon := handle_lon(rad_to_deg(future_coor.lon));
      
      
         -- Here the coordinates we just calculated become the current
         update_vars(current_coor, future_coor); 
         
         -- Return where we are now
         return current_coor;
         
      end calc_coord;
      
      
   begin
      
      -- KML coordinates: longitude, latitude, altitude
      coor_store(1) := origin;
      for I in 2..12 loop
         coor_store(I):= calc_coord(theta_add => theta_arr(I),
                                    dist_add  => dist_arr(I)); 
      end loop;
      
      -- Printing
      print_coors(coor_store);
      
      return coor_store;  
      
   end haversine_distance;

end haversine;
