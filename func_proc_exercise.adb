with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

procedure func_proc_exercise is
   type Miles is digits 8 range 0.0 .. 25_000.0; -- Check
   type Kilometers is digits 8 range 0.0 .. 50_000.0; -- Check
   
   function M_To_K_Fun(M:in Miles) return Kilometers is
      Kilometers_per_Mile : constant := 1.609_344;
   begin
      return Kilometers(M*Kilometers_per_Mile); -- returns the conversion CASTED as a Kilometer
   end M_To_K_Fun;
   
   No_Miles : Miles;
   
begin
   Put("Miles  Kilometers"); 
   New_Line;
   No_Miles := 0.0;
   while No_Miles <= 10.0 loop
      Put(Float(No_Miles), Aft=>2, Exp=>0); -- Pass Mile, function runs
      Put("   ");
      Put(Float(M_To_K_Fun(No_Miles)), Aft=>2, Exp=>0);
      New_Line;
      No_Miles := No_Miles + 1.0; -- Increment
      end loop;
   
end func_proc_exercise;
