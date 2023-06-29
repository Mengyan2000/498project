`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2022 01:00:50 AM
// Design Name: 
// Module Name: Processing_unit
// Purpose: the small prcessing unit for one weight convolution
// Arguments: weight_address, activation[3,3], layer_index(1,2,3), 
// output: result
// 
//////////////////////////////////////////////////////////////////////////////////


module Processing_unit_12
    #(
        PRECISION = 6)
    (
    input Clk,
    input rst,
    
    input [5:0] weight, 
    input [5:0] weight3_0,
    input [5:0] weight3_1, 
    input [5:0] weight3_2,
    input [5:0] weight3_3,
    input [5:0] weight3_4,
    input [5:0] weight3_5,
    input [5:0] weight3_6,
    input [5:0] weight3_7,
    input [5:0] weight3_8,
    input [5:0] in,
    input [5:0] in_1,
    input [5:0] in_2,
    input [5:0] in_3,
    input [5:0] in_4,
    input [5:0] in_5,
    input [5:0] in_6,
    input [5:0] in_7,
    input [5:0] in_8,
    
    
    //control signal
    input [1:0] layer_index,
    
    output [11:0] result
    );
    
    parameter PRECISION_FRA = PRECISION-1;
    
    wire [5:0] weight3[0:8];
    wire [5:0] in3[0:8];
 ///////////////////////////////////////////multiply in fraction binary form, sign*unsign/////////////////
    reg [11:0] mul_res9 [0:8];
    reg [11:0] mul_res;  
    // we have one binary number represent weights' integer part
    reg [6:0] weight_opp;  
    reg [6:0] weight_opp3[0:8];
    reg [11:0] result_reg;   
    reg [11:0] result_single3;     
    
    
    integer i;
    assign result = result_reg;
    assign weight3[0] = weight3_0;
    assign weight3[1] = weight3_1;
    assign weight3[2] = weight3_2;
    assign weight3[3] = weight3_3;
    assign weight3[4] = weight3_4;
    assign weight3[5] = weight3_5;
    assign weight3[6] = weight3_6;
    assign weight3[7] = weight3_7;
    assign weight3[8] = weight3_8;
    assign in3[0] = in;
    assign in3[1] = in_1;
    assign in3[2] = in_2;
    assign in3[3] = in_3;
    assign in3[4] = in_4;
    assign in3[5] = in_5;
    assign in3[6] = in_6;
    assign in3[7] = in_7;
    assign in3[8] = in_8;
    // only weight could be negative      
    always@(*) begin  
        if (layer_index == 2'b01 || layer_index == 2'b10) begin
            weight_opp = 7'b1000000 - {1'b0,weight};
            if (weight[5] == 1'b1) begin           // if weight is negative
                if (in == 6'd0 || weight == 6'd0) begin
                    mul_res = 12'd0;
                    result_reg = 12'h0000;
                end else begin
                    mul_res = in * weight_opp[5:0];
                    result_reg = 13'b0000000000000-{1'b0, mul_res};
                end
            end
            else if (in[5] == 1'b0 && weight[5] == 1'b0) begin
                mul_res = in * weight;
                result_reg = {1'b0, mul_res[10:0]};
            end
         end
         else if (layer_index == 2'b11) begin
            result_reg = 12'd0;
            for (i=0; i < 9; i=i+1) begin
                weight_opp3[i] = 7'b1000000-{1'b0,weight3[i]};
                if (weight3[i][5] == 1'b1) begin
                    if (in3[i] == 6'd0 || weight3[i] == 6'd0) begin
                        mul_res9[i] = 12'd0;
                        result_single3 = 12'h0000;
                    end else begin
                        mul_res9[i] = in3[i] * weight_opp3[i][5:0];
                        result_single3 = 13'b0000000000000-{1'b0, mul_res9[i]};
                    end
                end
                else if (in3[i][5] == 1'b0 && weight3[i][5] == 1'b0) begin
                    mul_res9[i] = in3[i] * weight3[i];
                    result_single3 = {1'b0, mul_res9[i][10:0]};
                end
                result_reg = result_reg + result_single3;
            end
         end
    end
endmodule



    
    
