interface SelectionSort_IFC ;
   method Action  put ( Int#(32) x );
   method ActionValue #( Int#(32) )  get;
endinterface

module mkSelectionSort (SelectionSort_IFC);

   Reg #(Bool) rg_busy <- mkReg( False ) ;
   Reg #(UInt #(4) ) inp_count <- mkReg(0) ;
   Reg #(UInt #(4) ) outp_count <- mkReg(0)  ;
   Reg #(UInt #(3) ) count <- mkReg(0)  ;
   Reg #(Int #(32)) inp_arr [8] ;

   // instantiate 8 Reg's inside the array "inp_arr" of 8 Reg's
   for (Integer i = 0 ; i < 8 ; i = i+1) begin
     inp_arr[i] <- mkReg(0);
   end

   // returns location of smallest among inp_arr[ count1 : .... ]
   // UInt#(3) means type of 3-bit unsigned integers
   // ...... 
   function UInt#(3) findMinLoc ( UInt#(3) count1 ) ;
      UInt#(3) minloc ;
      minloc = count1 ;
      Int#(32) minval ;
      minval = inp_arr[ count1 ] ;
      for (Integer i = 0 ; i < 8 ; i = i+1)
         if ( fromInteger(i) > count1 ) begin
	   if ( inp_arr [ i ] <  minval )  begin
             minval = inp_arr [ i ] ;
             minloc = fromInteger(i) ;
           end 
         end 
      return minloc;
   endfunction

   rule rl_position ( rg_busy && count < 7 ) ;
     Int#(32) inp_arr_local[8] ;
     // use this array of int32 variables to read and modify the contents of 
     // array "inp_arr" of 8 int32.
     Int#(32) temp1;
     // read inp_arr contents into inp_arr_local
     for ( Integer i = 0 ; i < 8 ; i = i+1 ) inp_arr_local[i] = inp_arr[i] ;  
     // note "=" that is "assignment to variable" 
     //  and not an "assignment to a storage element" , i.e. not "<="
     temp1 = inp_arr_local[count];
     // modify array of variables ( combinational ) in order to perform swap
     inp_arr_local[ count ]  = inp_arr_local[findMinLoc(count)];
     inp_arr_local[ findMinLoc(count)]  = temp1 ;

     // update array "inp_arr" of 8 int32 registers 
     for ( Integer i = 0 ; i < 8 ; i = i+1) inp_arr[i] <=inp_arr_local[i] ;  

     // do not forget to update the storage count
     count <= count + 1 ;
   endrule 

   method Action put ( Int#(32) x ) if ( !rg_busy ) ;
      inp_count <= inp_count+1;
      inp_arr[ inp_count ] <= x ;
      if ( inp_count == 7 ) rg_busy <= True ;
   endmethod

   method ActionValue#(Int#(32)) get () if ( count==7  && outp_count < 8 ) ;
      outp_count<=outp_count+1;
      if ( outp_count<7 ) rg_busy <= False ;
      if ( outp_count==7) begin
        for ( Integer i = 0 ; i < 8 ; i=i+1 ) 
          $display( "Result of SelectionSort : inp_arr[ %d ] = %d ", i , inp_arr[ i ] ) ;
      end 
      return inp_arr[ outp_count ] ;
   endmethod

endmodule: mkSelectionSort



// Testbench starts here


(* synthesize *)
module mkTestbench (Empty);
   Reg #(UInt #(4) ) idx_in <- mkReg (0);
   Reg #(UInt #(4) ) idx_out <- mkReg (0);

   // Instantiate the parallel sorter
   SelectionSort_IFC sorter <- mkSelectionSort ;

   rule rl_feed_inputs (idx_in < 8);
     int x_arr[8] = {1,104,33,431,401, 301,200,50} ;
     sorter.put( x_arr[ idx_in ] ) ;
     idx_in <= idx_in+1 ; 
     $display( "SelectionSort : inp_arr[ %d ] = %d ", idx_in , x_arr[ idx_in ] ) ;
   endrule

   rule rl_drain_outputs (idx_out < 8);
      let y <- sorter.get ();
      idx_out <= idx_out + 1;
      $display ("SelectionSort          : y_%0d = %0d", idx_out, y);
      if (idx_out == 8-1) $finish;
   endrule
endmodule
