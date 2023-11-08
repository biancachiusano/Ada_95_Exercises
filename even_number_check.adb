with Ada.Text_IO;
use Ada.Text_IO;

procedure even_number_check is
   number_to_check : Integer := 3;
   checker : constant Integer := 2;
   
begin
   if number_to_check mod checker = 0 then
      Put("Even Number");
      New_Line;
   else
      Put("Not an Even Number");
      New_Line;
   end if;
  
end even_number_check;
