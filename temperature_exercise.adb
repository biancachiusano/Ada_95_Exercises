with Ada.Text_IO;
use Ada.Text_IO;

procedure temperature_exercise is
   fahrenheit_temp : Float := 72.2;
   centigrade_temp: Float := 0.0;
   const_1: constant Float := 32.0;
   const_2: constant Float := 1.8;
   
begin
   centigrade_temp := (fahrenheit_temp - const_1)/const_2;
   Put("Fahrenheit: "); Put(Float'Image(fahrenheit_temp));
   New_Line;
   Put("Degrees Centigrade: "); Put(Float'Image(centigrade_temp));
   New_Line;
end temperature_exercise;
