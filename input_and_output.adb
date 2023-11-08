with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;
  
procedure input_and_output is
   Fd : File_Type;
   Ch : Character;
begin
   if Argument_Count >=1 then
      for I in 1 .. Argument_Count loop
         Open(File => Fd, Mode => In_File,
              Name => Argument(I));
         while not End_Of_File(Fd) loop
            while not End_Of_Line(Fd) loop
               Get(Fd,Ch);
               Put(Fd,Ch);
            end loop;
            Skip_Line(Fd);
            New_Line;
         end loop;
         Close(Fd);
      end loop;
   else
      Put("Usage: cat file1 ...");
      New_Line;
   end if;
    
end input_and_output;
