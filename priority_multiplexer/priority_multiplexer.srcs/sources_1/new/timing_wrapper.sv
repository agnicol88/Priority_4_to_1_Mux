`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: timing_wrapper
// Description: Top-level wrapper file to test timing of PriorityMultiplexer.sv
//////////////////////////////////////////////////////////////////////////////////


module timing_wrapper(
    input logic clock,
    input logic [3:0][7:0] inData ,    
    input logic [3:0][7:0] inPriority,    
    input logic [3:0] inValid,    
    output logic [1:0] outDataIndex,    
    output logic [7:0] outData,    
    output logic [7:0] outPriority,    
    output logic outValid
    );
    reg [1:0] outDataIndexReg = 2'd0;   
    reg [7:0] outDataReg = 8'd0;    
    reg [7:0] outPriorityReg = 8'd0;    
    reg outValidReg = 1'b0;
      
    reg [3:0][7:0] inDataReg = 32'd0;    
    reg [3:0][7:0] inPriorityReg = 32'd0;    
    reg [3:0] inValidReg = 4'b0;
       
    wire [1:0] outDataIndexW;   
    wire [7:0] outDataW;    
    wire [7:0] outPriorityW;    
    wire outValidW;
    
    always_ff @ (posedge clock) begin
        // Register inputs and outputs so critical paths are within test module
        inDataReg <= inData;
        inPriorityReg <= inPriority;
        inValidReg <= inValid;
        
        outDataIndexReg <= outDataIndexW;
        outDataReg <= outDataW;
        outPriorityReg <= outPriorityW;
        outValidReg <= outValidW;
    end
    
    assign outDataIndex = outDataIndexReg;
    assign outData = outDataReg;
    assign outPriority = outPriorityReg;
    assign outValid = outValidReg;
    
    PriorityMultiplexer i_priority_mux (.clock(clock), .inData(inDataReg) , .inPriority(inPriorityReg), .inValid(inValidReg),    
                                        .outDataIndex(outDataIndexW), .outData(outDataW), .outPriority(outPriorityW), .outValid(outValidW)
        );                                                                                           
        
    
endmodule
