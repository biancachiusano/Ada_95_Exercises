with Ada.Text_IO;
use Ada.Text_IO;

procedure countdown is
   type Count_Range is range 0 .. 10;
   Count : Count_Range := 10; -- Making Count of type Count_Range
     
   begin
      for Count in reverse Count_Range loop
         if Count = 3 then
            Put("Ignition");
            New_Line;
         end if;
         Put(Count_Range'Image(Count)); --Count is of type Count_Range
         New_Line;
         delay 1.0;
      end loop;
      Put("Blast off!");
      New_Line;
end countdown;
