with overall; use overall;
package tests is

   procedure run_test(start_lon: in Float; start_lat: in Float; start_theta: in Float; 
                      dist_arr: in Dist_Store; theta_arr: in Theta_Store);
   procedure add_to_kml(File_Name: String; General_File: String; result: Coordinate_Store);

end tests;
