with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; 
use Ada.Numerics.Elementary_Functions;
with overall; use overall;

package body vincenty is

   function vincenty_distance(d: in Float;
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
      DEBUG: Boolean := True;
      

      function calc_coord(theta_add: in Float; dist_add: in Float) return Coordinate is

         dir: Float := theta + theta_add; 
         dist_tmp: Float;
         
         flattening : Float;
         len_minor_axis : Float := 3432.505; -- Nautical Miles - radius at the poles
         sin_ber, cos_ber, tan_U, cos_U, sin_U, sin_a, cos_2_a, u_2, ang_dist, ang_dist_2, ang_dist_3, A, B: Float;
         cos_dist, change_dist, x, C, lamda, lon_diff: Float;
         tmp_lon, tmp_lat : Float;
         
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
         
         -- Constants
         -- a, b -> major and minor semi axes
         flattening := (R-len_minor_axis)/R;
         
         sin_ber := Sin(dir);
         cos_ber := Cos(dir);
         
         tan_U := (1.0 - flattening)*Tan(current_coor.lat);
         cos_U := 1.0/Sqrt((1.0+(tan_U*tan_U)));
         sin_U := tan_U * cos_U; 
         
         ang_dist := Arctan(tan_U, cos_ber);
         sin_a := cos_U * sin_ber;
         cos_2_a := 1.0 - (sin_a*sin_a); 
         u_2 := cos_2_a * ((R*R) - (len_minor_axis*len_minor_axis))/(len_minor_axis*len_minor_axis);
        
         A := 1.0 + ((u_2/16384.0) * (4096.0 +( u_2 * (-768.0 + u_2 * (320.0-175.0 * u_2)))));
         B := (u_2/1024.0) * (256.0 + (u_2 * (-128.0 + (u_2 * (74.0 - 47.0 * u_2)))));

         -- Calculations begin
         ang_dist_2 := dist_tmp/(len_minor_axis*A);
         ang_dist_3 := 0.0;
         
         while abs(ang_dist_2-ang_dist_3) > 0.000000000001 loop
            cos_dist := Cos(2.0*ang_dist+ ang_dist_2);
            change_dist := B * Sin(ang_dist_2) * (cos_dist + B/4.0 * (Cos(ang_dist_2)
                                                  *(-1.0 + 2.0 * cos_dist*cos_dist) - B/6.0 * cos_dist 
                                                  * (-3.0+4.0*Sin(ang_dist_2)*Sin(ang_dist_2))
                                                  * (-3.0+4.0*cos_dist*cos_dist)));
            ang_dist_3 := ang_dist_2;
            ang_dist_2 := (dist_tmp/len_minor_axis*A) + change_dist;
         end loop;
         
         x := sin_U * Sin(ang_dist_2) - cos_U * Cos(ang_dist_2) * cos_ber;
         
         -- New latitude
         tmp_lat := Arctan(sin_U*Cos(ang_dist_2) + cos_U * Sin(ang_dist_2) * cos_ber, (1.0-flattening) * Sqrt(sin_a*sin_a + x * x));
         future_coor.lat := tmp_lat;

         lamda := Arctan(Sin(ang_dist_2) * sin_ber, cos_U * Cos(ang_dist_2) - sin_U * Sin(ang_dist_2) * cos_ber);
         C := flattening/16.0 * cos_2_a * (4.0 + flattening * (4.0 -3.0 * cos_2_a));
         lon_diff := lamda - (1.0 - C) * flattening * sin_a * (ang_dist_2 + C * Sin(ang_dist_2)
                                                               *(cos_dist + C *Cos(ang_dist_2)
                                                                 *(-1.0 + 2.0 * cos_dist * cos_dist)));
         -- New Longitude
         tmp_lon := current_coor.lon + lon_diff;
         future_coor.lon := tmp_lon;
         
         -- transform back into degrees  
         future_coor.lat := handle_lat(rad_to_deg(future_coor.lat));
         future_coor.lon := handle_lon(rad_to_deg(future_coor.lon));
      
         if DEBUG then
            Put_Line("Flattening: " & Float'Image(flattening));
            Put_Line("Sin of bearing: " & Float'Image(sin_ber));
            Put_Line("Cos of bearing: " & Float'Image(cos_ber));
            Put_Line("Tan U: " & Float'Image(tan_U));
            Put_Line("Cos U: " & Float'Image(cos_U));
            Put_Line("Sin U: " & Float'Image(sin_U));
            Put_Line("Ang_dist: " & Float'Image(ang_dist));
            Put_Line("Sin_a: " & Float'Image(sin_a));
            Put_Line("Cos2a: " & Float'Image(cos_2_a));
            Put_Line("U2: " & Float'Image(u_2));
            Put_Line("A: " & Float'Image(A));
            Put_Line("B: " & Float'Image(B));
            Put_Line("Absolute: " & Float'Image(abs(ang_dist_2-ang_dist_3)));
            Put_Line("New Lat : " & Float'Image(tmp_lat));
            Put_Line("New Longitude " & Float'Image(tmp_lon));
         end if;
         
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
   end vincenty_distance;
     
      
    
end vincenty;
