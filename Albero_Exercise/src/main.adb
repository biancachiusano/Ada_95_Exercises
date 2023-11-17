with Ada.Text_IO; use Ada.Text_IO;
with Ada.Direct_IO;
with Ada.Numerics.Elementary_Functions;
use Ada.Numerics.Elementary_Functions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with terrapiatta;
with haversine;
with vincenty;
with tests;
with overall;

procedure Main is

   distance: Float := 0.0;
   theta: Float := -1.0;
   origin_lon: Float := -200.0; -- Longitude (X)
   origin_lat: Float := -200.0; -- Latitude (Y)

   mode: Integer := 0;

   dist_arr: overall.Dist_Store := (0.0, 0.0, 0.0, Sqrt(2.0), 0.0, ((3.0/2.0)*Sqrt(2.0)), ((3.0/2.0)*Sqrt(2.0)),
                                    0.0, Sqrt(2.0), 0.0, 0.0);

   theta_arr: overall.Theta_Store := (90.0, 0.0, 90.0, -45.0, 90.0, -45.0, -135.0, 90.0, -135.0, 90.0, 180.0);

   result : overall.Coordinate_Store;

   -- Vars for Printing on KML
   F : File_Type;
   Fg : File_Type;
   File_Name: Unbounded_String := Null_Unbounded_String;
   piatta_file : String:= "terrapiatta.kml";
   sferica_file: String:= "sferica.kml";
   vinc_file : String := "vincenty.kml";
   General_File: constant String:= "general.kml";

   wanted_len : Integer;
   wanted_str : String := "<coordinates>";
   str_bed : String (1..13);
   trial_bed : String(1..18);
   tmp_unbounded_str : Unbounded_String := Null_Unbounded_String;
   tmp_char: String := "A";
   spaced_str : Unbounded_String := Null_Unbounded_String;
   all_info : Unbounded_String := Null_Unbounded_String;


   -- For tests
   testing_Flag : Boolean := False;

   -- For symmetry
   symm : Boolean := False;
   symm_mode : Integer := 0;

begin

   if testing_Flag then
      -- This function allows to run the same test for all three modes
      -- And generates kml files ready to compare the three modes on Google Earth
      tests.run_test(start_lon   => -89.0,
                     start_lat   => 0.0,
                     start_theta => 0.0,
                     dist_arr    => dist_arr,
                     theta_arr   => theta_arr);
   else

      --  User Input
      Put_Line("Esercizio Albero!");
      Put("Enter Distance: (in Nautical Miles): "); distance := Float'Value(Get_Line);

      while theta not in 0.0..360.0 loop
         Put("Enter Theta: (0..360): ");
         theta := Float'Value(Get_Line);
      end loop;

      while origin_lat not in -90.0..90.0 loop
         Put("Enter Longitude (-90..90): ");
         origin_lat := Float'Value(Get_Line);
      end loop;

      while origin_lon not in -180.0..180.0 loop
         Put("Enter Longitude (-180..180): ");
         origin_lon := Float'Value(Get_Line);
      end loop;

      Put_Line("Choose how you want to compute the coordinates: ");
      Put_Line("1 - Normally");
      Put_Line("2 - With Symmetry");

      while symm_mode not in 1..2 loop
         Put("Choose how to compute coordinates: ");
         symm_mode:= Integer'Value(Get_Line);
         case symm_mode is
            when 1 =>
               Put_Line("We are going to calculate the coordinates normally");
            when 2 =>
               Put_Line("We are going to use symmetry");
               symm := True;
            when others =>
               Put_Line("Choose a valid mode");
         end case;
      end loop;


      Put_Line("Available modes: ");
      Put_Line("1 - Terra Piatta");
      Put_Line("2 - Terra Spherica");
      Put_Line("3 - Terra WGS84");

      while mode not in 1..3 loop
         Put("Choose your mode: "); mode := Integer'Value(Get_Line);
         case mode is
         when 1 =>
            Put_Line("Chosen Mode: Terra Piatta");
            result:= terrapiatta.terra_piatta(distance, theta, origin_lon, origin_lat, dist_arr, theta_arr, symm);
            File_Name := To_Unbounded_String(piatta_file);
         when 2 =>
            Put_Line("Chosen Mode: Terra Spherica");
            result := haversine.haversine_distance(distance, theta, origin_lon, origin_lat, dist_arr, theta_arr, symm);
            File_Name := To_Unbounded_String(sferica_file);
         when 3 =>
            Put_Line("Chosen Mode: Terra WGS84");
            result := vincenty.vincenty_distance(distance, theta, origin_lon, origin_lat, dist_arr, theta_arr, symm);
            File_Name := To_Unbounded_String(vinc_file);
         when others =>
            Put_Line("Please choose one of the three modes");
         end case;
      end loop;


      -- Code for KML File
      Open(F, Out_File, To_String(File_Name));
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
   end if;

end Main;
