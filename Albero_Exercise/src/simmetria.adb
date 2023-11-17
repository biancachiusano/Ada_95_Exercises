with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with overall; use overall;

package body simmetria is

   
   function calculate_symmetry(current_coor : Coordinate; current_dist : Float; dist : Float; theta: Float) return Coordinate is
      
      future_coor : Coordinate;
  
      new_dist : Float;
      dir: Float := theta - 90.0; 
      dist_tmp: Float;
     
   begin
      
      if current_dist = 0.0 then
            dist_tmp := dist;
         else
            dist_tmp := dist * current_dist;
      end if;
      
      new_dist := dist + dist_tmp*2.0;
      new_dist := new_dist/60.0;
         
      -- Theta (RADIANS)
      dir := deg_to_rad(dir); 
 
      -- calculate latitude (DEGREES)
      future_coor.lat := handle_lat(current_coor.lat + new_dist*Cos(dir));
         
      -- calculate longitude (DEGREES)
      future_coor.lon := handle_lon(current_coor.lon + new_dist*Sin(dir));
         
      return future_coor;
            
   end calculate_symmetry;
   
    function calculate_symmetry_two (dist : Float; theta: Float; current_dist: Float; current_coor:Coordinate) return Coordinate is
      
      future_coor : Coordinate;
      dir: Float := theta - 90.0; 
      dist_tmp: Float;
     
   begin
      
      if current_dist = 0.0 then
            dist_tmp := dist*2.0+dist;
         else
            dist_tmp := dist;
      end if;
      
      dist_tmp := dist_tmp/60.0;
         
      -- Theta (RADIANS)
      dir := deg_to_rad(dir); 
 
      -- calculate latitude (DEGREES)
      future_coor.lat := handle_lat(current_coor.lat + dist_tmp*Cos(dir));
         
      -- calculate longitude (DEGREES)
      future_coor.lon := handle_lon(current_coor.lon + dist_tmp*Sin(dir));
         
      return future_coor;
            
   end calculate_symmetry_two;
   

end simmetria;
