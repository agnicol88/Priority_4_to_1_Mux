`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: priority_mux_tb
// Description: Basic directed testbench to test PriorityMultiplexer.sv
//////////////////////////////////////////////////////////////////////////////////


module priority_mux_tb;
    reg clock = 1'b0;
    reg test_pass = 1'b1;
    wire [1:0] outIndex;
    wire [7:0] outData;
    wire [7:0] outPriority;
    wire outValid;
    reg [3:0][7:0] inData = 32'hdeadface;
    reg [3:0][7:0] inPriority = 32'd0;
    reg [3:0] inValid = 4'd0;
    
    PriorityMultiplexer i_priorityMux(.clock(clock),.inData(inData),.inPriority(inPriority), .inValid(inValid), 
                                      .outDataIndex(outIndex), .outData(outData), .outPriority(outPriority), .outValid(outValid));


    always
       #10 clock <= ~clock;
    
    always begin
        $display("Enabling each channel sequentially");
        @ (posedge clock)
        inValid = 4'b1000;
        @ (posedge clock)
        #1 if ((outData == inData[3]) & (outIndex == 2'd3) & (outValid == 1'b1))
            $display("Channel 3 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 3 Fail***");
           end       
        
        @ (posedge clock)
        inValid = 4'b0100;
        @ (posedge clock)
        #1 if ((outData == inData[2]) & (outIndex == 2'd2) & (outValid == 1'b1))
            $display("Channel 2 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 2 Fail***");
           end
           
        @ (posedge clock)
        inValid = 4'b0010;
        @ (posedge clock)
        #1 if ((outData == inData[1]) & (outIndex == 2'd1) & (outValid == 1'b1))
            $display("Channel 1 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 1 Fail***");
           end
         
        @ (posedge clock)
        inValid = 4'b0001;
        @ (posedge clock)
        #1 if ((outData == inData[0]) & (outIndex == 2'd0) & (outValid == 1'b1))
            $display("Channel 0 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 0 Fail***");
           end
        
        $display("Enabling each channel with equal priority");
        @ (posedge clock)
        inValid = 4'b1000;
        @ (posedge clock)
        #1 if ((outData == inData[3]) & (outIndex == 2'd3) & (outValid == 1'b1))
            $display("Channel 3 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 3 Fail***");
           end       
        
        @ (posedge clock)
        inValid = 4'b1100;
        @ (posedge clock)
        #1 if ((outData == inData[2]) & (outIndex == 2'd2) & (outValid == 1'b1))
            $display("Channel 2 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 2 Fail***");
           end
           
        @ (posedge clock)
        inValid = 4'b1110;
        @ (posedge clock)
        #1 if ((outData == inData[1]) & (outIndex == 2'd1) & (outValid == 1'b1))
            $display("Channel 1 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 1 Fail***");
           end
         
        @ (posedge clock)
        inValid = 4'b1111;
        @ (posedge clock)
        #1 if ((outData == inData[0]) & (outIndex == 2'd0) & (outValid == 1'b1))
            $display("Channel 0 pass");
           else begin
            test_pass <= 1'b0;
            $display("***Channel 0 Fail***");
           end
        
        $display("Increasing priority of channel 3");
        @ (posedge clock)
        inPriority[3] = 8'h01;
        @ (posedge clock)
        #1 if ((outData == inData[3]) & (outIndex == 2'd3) & (outValid == 1'b1))
           $display("Channel 3 pass");
          else begin
           test_pass <= 1'b0;
           $display("***Channel 3 Fail***");
          end       
        
        $display("Increasing priority of channel 2");
        @ (posedge clock)
        inPriority[2] = 8'h10;
        @ (posedge clock)
        #1 if ((outData == inData[2]) & (outIndex == 2'd2) & (outValid == 1'b1))
             $display("Channel 2 pass");
            else begin
             test_pass <= 1'b0;
             $display("***Channel 2 Fail***");
            end       
        
        $display("Increasing priority of channel 1");
        @ (posedge clock)
        inPriority[1] = 8'hF0;
        @ (posedge clock)
        #1 if ((outData == inData[1]) & (outIndex == 2'd1) & (outValid == 1'b1))
           $display("Channel 1 pass");
          else begin
           test_pass <= 1'b0;
           $display("***Channel 1 Fail***");
          end 
          
        $display("Increasing priority of channel 0");
        @ (posedge clock)
        inPriority[0] = 8'hFF;
        @ (posedge clock)
        #1 if ((outData == inData[0]) & (outIndex == 2'd0) & (outValid == 1'b1))
             $display("Channel 0 pass");
            else begin
             test_pass <= 1'b0;
             $display("***Channel 0 Fail***");
            end 
  
        $display("Disabling all channels");
        @ (posedge clock)
        inValid = 4'd0;
        @ (posedge clock)
        #1 if ((outValid == 1'b0))
           $display("Test pass");
          else begin
           test_pass <= 1'b0;
           $display("***Test Fail***");
          end 

        @ (posedge clock)
        if (test_pass)
            $display("All tests passed!");
        else
            $display("***Tests Failed - check transcript***");
        $finish;
    end
endmodule
