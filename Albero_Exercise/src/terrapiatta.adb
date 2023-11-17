with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with overall; use overall;
with simmetria; 

package body terrapiatta is

   function terra_piatta(d: in Float;
                         t: in Float;
                         o_x: in Float;
                         o_y: in Float;
                         dist_arr: in Dist_Store;
                         theta_arr: in Theta_Store;
                         symm: in Boolean) return Coordinate_Store is
      
      -- Store the 12 coordinates
      coor_store : Coordinate_Store;
      
      -- Initialising the input paramenters
      dist: constant Float := d; -- Distance is a constant
      theta: constant Float := t; -- Theta is a constant
      origin: constant Coordinate := (o_x,o_y, 5000.0);
      
      -- Keeping track of where we are
      current_coor: Coordinate := origin; 
      future_coor: Coordinate;
      
      -- for symmetry
      dec: Integer := 2;
      
         
      function calc_coord(theta_add: in Float; dist_add: in Float) return Coordinate is

         dir: Float := theta + theta_add; 
         dist_tmp: Float;
         
      begin
         
         if dist_add = 0.0 then
            dist_tmp := dist;
         else
            dist_tmp := dist * dist_add;
         end if;
         dist_tmp := dist_tmp/60.0;
         
         -- Theta (RADIANS)
         dir := deg_to_rad(dir); 
 
         -- calculate latitude (DEGREES)
         future_coor.lat := handle_lat(current_coor.lat + dist_tmp*Cos(dir));
         
         -- calculate longitude (DEGREES)
         future_coor.lon := handle_lon(current_coor.lon + dist_tmp*Sin(dir));
         
         update_vars(current_coor, future_coor);
     
         return current_coor;
         
      end calc_coord;
      
      
   begin
      -- KML coordinates: longitude, latitude, altitude
      if symm then
         coor_store(1) := origin;
         for I in 2..7 loop
            coor_store(I):= calc_coord(theta_add => theta_arr(I),
                                       dist_add  => dist_arr(I)); 
         end loop;
         
         for I in 8..10 loop
            --coor_store(I) := simmetria.calculate_symmetry(current_coor => coor_store(I-dec), current_dist => dist_arr(I-dec),dist         => d,theta        => t);
            Put_Line("DIST_ARR at " & Integer'Image(I) & " is: " & Float'Image(dist_arr(I-dec)));
            coor_store(I) := simmetria.calculate_symmetry_two(dist         => d,
                                                              theta        => t,
                                                              current_dist => dist_arr(I-dec),
                                                              current_coor => coor_store(I-dec));
            dec := dec + 2;
         end loop;
         coor_store(11) := simmetria.calculate_symmetry_two(dist         => d,
                                                            theta        => t,
                                                            current_dist => 90.0,
                                                            current_coor => coor_store(3));
         coor_store(12) := coor_store(1);
               
      else
         coor_store(1) := origin;
         for I in 2..12 loop
            coor_store(I):= calc_coord(theta_add => theta_arr(I),
                                       dist_add  => dist_arr(I)); 
         end loop;
      end if;
      
      
      -- Printing
      print_coors(coor_store);
      
      return coor_store;
   end terra_piatta;
   
end terrapiatta;
