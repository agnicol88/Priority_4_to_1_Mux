`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: PriorityMultiplexer
// Description: Module performs a 4-to-1 priority mux by instantiating three 2-to-1
//              combinatorial muxs (arbitrate between first and second inputs, between
//              third and fourth, and between the outputs of the first-level muxs). 
//
//              If only one input is valid, that input is passed. If more than one inputs
//              are valid, the input with the highest priority is passed. 
//              If more than one inputs are valid with the highest priority, the lower
//              index input is passed. The dataIndex output is set to the active output 
//              channel index.
//
//              Latency = 1 clock tick
//              FMax = 281.7 MHz (Virtex 7-class)
//////////////////////////////////////////////////////////////////////////////////


module PriorityMultiplexer(
    input logic clock,
    input logic [3:0][7:0] inData ,    
    input logic [3:0][7:0] inPriority,    
    input logic [3:0] inValid,    
    output logic [1:0] outDataIndex = 2'd0,    
    output logic [7:0] outData = 8'd0,    
    output logic [7:0] outPriority = 8'd0,    
    output logic outValid = 1'b0
    );    
    wire [1:0] outDataIndexW;   
    wire [7:0] outDataW;    
    wire [7:0] outPriorityW;    
    wire outValidW;
    
    wire [7:0] ab_Data;
    wire [7:0] ab_Priority;
    wire ab_Valid;
    wire ab_Index;
    
    wire [7:0] cd_Data;
    wire [7:0] cd_Priority;
    wire cd_Valid;
    wire cd_Index;
        
    wire abcd_Index;       
    
    // First-stage mux selects between the first (A) and second (B) inputs   
    two_to_one_priority_mux abMux (.aData(inData[0]), .aPriority(inPriority[0]), .aValid(inValid[0]),
                                   .bData(inData[1]), .bPriority(inPriority[1]), .bValid(inValid[1]),
                                   .dataOut(ab_Data), .dataPriority(ab_Priority), .dataValid(ab_Valid),.dataIndex(ab_Index));
    
    // First-stage mux selects between the third (C) and fourth (D) inputs
    two_to_one_priority_mux cdMux (.aData(inData[2]), .aPriority(inPriority[2]), .aValid(inValid[2]),
                                   .bData(inData[3]), .bPriority(inPriority[3]), .bValid(inValid[3]),
                                   .dataOut(cd_Data), .dataPriority(cd_Priority), .dataValid(cd_Valid),.dataIndex(cd_Index));
       
    // Second-stage mux selects between the outputs of the first-stage muxs  
    two_to_one_priority_mux outMux (.aData(ab_Data), .aPriority(ab_Priority), .aValid(ab_Valid),
                                  .bData(cd_Data), .bPriority(cd_Priority), .bValid(cd_Valid),
                                  .dataOut(outDataW), .dataPriority(outPriorityW), .dataValid(outValidW),.dataIndex(abcd_Index));
     
     // If the second-stage mux index is 1, input C or D is being used, otherwise it's A or B.
     // Check index output of first-stage muxs to determine which has been passed.
     assign outDataIndexW = abcd_Index ? (cd_Index ? 4'd3 : 4'd2) 
                                       : (ab_Index ? 4'd1 : 4'd0);                                                                                             
    
     // Register outputs for passing to downstream modules
     always_ff @(posedge clock) begin
        outDataIndex <= outDataIndexW;
        outData <= outDataW;
        outPriority <= outPriorityW;
        outValid <= outValidW;
     end
     
endmodule
