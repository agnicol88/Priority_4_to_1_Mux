`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: two_to_one_priority_mux
// Description: Module performs a combinatorial 2-to-1 priority mux. If only one input
//              is valid, that input is passed. If both inputs are valid, the input 
//              with the higher priority is passed. If both inputs are valid with the
//              same priority, the A input is passed.
//              The dataIndex output is set to 0 to indicate that A has been passed,
//              and 1 to indicate that B has been passed.
//////////////////////////////////////////////////////////////////////////////////


module two_to_one_priority_mux(
    input [7:0] aData,
    input [7:0] aPriority,
    input aValid,
    input [7:0] bData,
    input [7:0] bPriority,
    input bValid,
    output [7:0] dataOut,
    output [7:0] dataPriority,
    output dataValid,
    output dataIndex
    );
    reg [7:0] dataOutReg = 8'd0;
    reg [7:0] dataPriorityReg = 8'd0;
    reg dataIndexReg = 1'b0;
    
    assign dataOut = dataOutReg;
    assign dataPriority = dataPriorityReg;
    assign dataIndex = dataIndexReg;
    assign dataValid = aValid | bValid;
    
    always_comb begin
       if (aValid & bValid) begin
       // Both input branches valid - need to arbitrate
         if (bPriority > aPriority) begin
           // B higher priority - pass B
           dataOutReg = bData;
           dataPriorityReg = bPriority;
           dataIndexReg = 1'b1;
         end
         else begin
           // Otherwise, pass A
           dataOutReg = aData;
           dataPriorityReg = aPriority;
           dataIndexReg = 1'b0;
         end
       end
       else if (aValid) begin
       // Only A valid - pass A
         dataOutReg = aData;
         dataPriorityReg = aPriority;
         dataIndexReg = 1'b0;
       end 
       else if (bValid) begin
       // Only B valid - pass B
         dataOutReg = bData;
         dataPriorityReg = bPriority;
         dataIndexReg = 1'b1;
       end      
       else begin
         dataOutReg = 8'd0;
         dataPriorityReg = 8'd0;
         dataIndexReg = 1'b0;
       end
    end
    
endmodule
