with overall; use overall;

package terrapiatta is
   
   function terra_piatta(d: in Float;
                         t: in Float;
                         o_x: in Float; 
                         o_y: in Float;
                         dist_arr: in Dist_Store;
                         theta_arr: in Theta_Store;
                         symm: in Boolean) return Coordinate_Store;
    

end terrapiatta;
