with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with terrapiatta;
with haversine;
with vincenty;
with tests;
with overall;

package body tests is

   procedure run_test(start_lon: in Float; start_lat: in Float; start_theta: in Float; 
                      dist_arr: in Dist_Store; theta_arr: in Theta_Store) is
      
      result : overall.Coordinate_Store;
   begin
      Put_Line("Test for: Terrapiatta");
      result := terrapiatta.terra_piatta(d         => 10.0,
                                         t         => start_theta,
                                         o_x       => start_lon,
                                         o_y       => start_lat,
                                         dist_arr  => dist_arr,
                                         theta_arr => theta_arr,
                                         symm => False);
      
      add_to_kml("terrapiatta.kml", "general.kml", result);
      
      Put_Line("Test for: Sferica");
      result := haversine.haversine_distance(d         => 10.0,
                                             t         => start_theta,
                                             o_x       => start_lon,
                                             o_y       => start_lat,
                                             dist_arr  => dist_arr,
                                             theta_arr => theta_arr,
                                             symm => False);
      
      add_to_kml("sferica.kml", "general.kml", result);
      
      Put_Line("Test for: WGS84");
      result := vincenty.vincenty_distance(d         => 10.0,
                                           t         => start_theta,
                                           o_x       => start_lon,
                                           o_y       => start_lat,
                                           dist_arr  => dist_arr,
                                           theta_arr => theta_arr,
                                           symm => False);
      
      add_to_kml("vincenty.kml", "general.kml", result);
         
   end run_test;
   
   procedure add_to_kml(File_Name: String; General_File: String; result: Coordinate_Store) is
      F : File_Type;
      Fg : File_Type;
      wanted_len : Integer;
      wanted_str : String := "<coordinates>";
      str_bed : String (1..13);
      trial_bed : String(1..18);
      tmp_unbounded_str : Unbounded_String := Null_Unbounded_String;
      tmp_char: String := "A";
      spaced_str : Unbounded_String := Null_Unbounded_String;
      all_info : Unbounded_String := Null_Unbounded_String;
      
   begin
      -- Code for KML File
      Open(F, Out_File, File_Name);
      Reset(F);   -- Reset file you are going to write in
      Open(Fg, In_File, General_File); -- Read from general file
      while not End_Of_File(Fg) loop

         tmp_unbounded_str := To_Unbounded_String(Get_Line(Fg));
         Put_Line(F, To_String(tmp_unbounded_str));
         wanted_len := Length(tmp_unbounded_str);

         if wanted_len = 18 then

            trial_bed := To_String(tmp_unbounded_str);

            for I in 1..13 loop
               str_bed(I) := trial_bed(I+5);
            end loop;

            if str_bed = wanted_str then
               for I in 1..12 loop
                  Put_line(F, overall.remove_spaces(Float'Image(result(I).lon) & ","
                           & Float'Image(result(I).lat) & ","
                           & Float'Image(result(I).alt)));
               end loop;
            end if;
         end if;
      end loop;

      Close(Fg);
      Close(F);
   end add_to_kml;

end tests;
