with overall; use overall;
package simmetria is

   function calculate_symmetry(current_coor : Coordinate; current_dist : Float; dist : Float; theta: Float) return Coordinate;
   function calculate_symmetry_two (dist : Float; theta: Float; current_dist: Float; current_coor: Coordinate) return Coordinate;
end simmetria;
