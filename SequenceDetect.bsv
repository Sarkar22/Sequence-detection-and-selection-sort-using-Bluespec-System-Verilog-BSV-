package SequenceDetect;

// ---------------------------------------------------------------
// Library imports 
import GetPut :: *;
// ---------------------------------------------------------------

// ---------------------------------------------------------------
// Interface type definition
// The system will "put" input data values into the detector, and
// "get" responses from the detector as results. Observe that no
// low-level control signals have been declared with respect to
// the interface.

interface SequenceDetect;
   interface Put# (Bit #(32)) iData;
   interface Get# (Bit #(32)) oResult;
endinterface : SequenceDetect

// ---------------------------------------------------------------
// Module definition

module mkSeqDet (SequenceDetect);
   // ------------------------------------------------------------
   // Submodules
   // The only submodules you require in this model are registers.
   

   // rg_busy is a register which holds a Bool value and is reset
   // to False
   Reg #(Bool) rg_busy <- mkReg (False);          
   Reg #(Bool) rg_ready <- mkReg (False);
   Reg #(Bit#(4)) rg_seq <- mkReg(10) ;           //4 bit sequence
   Reg #(Bit#(32)) p <- mkReg(0) ;                // input register
   Reg #(Bit#(32)) rg_number_of_seq <- mkReg(0);      // output 
   Reg #(Bit#(5)) index_of_bitstream <- mkReg(31);                 // position/index in the input array


   // ------------------------------------------------------------
   // Rules -- rule needs to be defined.
   
    rule detectSequence  (rg_busy == True);
		if (p[index_of_bitstream : index_of_bitstream-3] == rg_seq)
		rg_number_of_seq <= rg_number_of_seq +1 ;
		index_of_bitstream <= index_of_bitstream-1;
		if(index_of_bitstream == 3) begin
			rg_ready <= True;
			rg_busy <= False;
		end
    endrule : detectSequence
 
   // ------------------------------------------------------------
   // Interface definition
   // The last bit of code relates to defining what each method in
   // your interface does. If a method is of type Action or
   // ActionValue, writing the internals of a method is like
   // writing a rule. You need to answer the same questions. Only
   // for ActionValue methods, in addition, there will be a value
   // returned like you would do in a function. There is a third
   // type of method called value methods. These just return value
   // and do not have any side-effects.
   // ------------------------------------------------------------
    interface Put iData;
      method Action put (Bit #(32) d) if (rg_busy == False);
		 begin
		 p <= d ;
		 rg_busy<= True;
		 rg_ready<=False;
		 end
      endmethod : put
    endinterface

    interface Get oResult;
      method ActionValue #(Bit #(32)) get () if (rg_ready == True);
		 return rg_number_of_seq;
      endmethod : get
    endinterface

endmodule : mkSeqDet
// ------------------------------------------------------------


module mkTestbench (Empty);

 SequenceDetect detect <- mkSeqDet;
 
 Reg #(Bool) start <- mkReg(False);

 rule putvalue (!start);
  detect.iData.put(32'b10101000111100001111010010110000);
  start <= True;
 endrule

 rule getresult;
  let z <- detect.oResult.get;
  $display ("answer is %0d",z);
  $finish;
 endrule

endmodule: mkTestbench


//--------------------------------------------------------------

endpackage : SequenceDetect
