`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////


module PE(
    input Clk, rst,
    
    input[15:0] weight_addr,
    input [15:0] in_addr,
    // input coming from middle buffer
    input [5:0] data_o_0,
    input [5:0] data_o_1,
    input [5:0] data_o_2,
    input [5:0] data_o_3,
    input [5:0] data_o_4,
    input [5:0] data_o_5,
    input [5:0] data_o_6,
    input [5:0] data_o_7,
    input [5:0] data_o_8,
    
    input [1:0] layer_index,
    
    output [11:0] data_res0,
    output [11:0] data_res1,
    output [11:0] data_res2,
    output [11:0] data_res3,
    output [11:0] data_res4,
    output [11:0] data_res5,
    output [11:0] data_res6,
    output [11:0] data_res7,
    output [11:0] data_res8
    );
    // all 9 processing units are used on compute 3*3 matrix for next layer's input
    wire [5:0] weight_o[0:8];
    wire [5:0] data_Out [0:8];
    // weight for all three layers
    wire [5:0] weight_out1;
    wire [5:0] weight_out2;
    wire [5:0] weight_padded [0:24];
    // weight for first two layers
    wire [5:0] _weight_out;
    
    wire [5:0] in_1 [0:8];
    
    
    reg [5:0] weight_bef [0:8];
    reg [5:0] in_2 [0:8];
    reg [5:0] in [0:8];
    
    assign weight_padded[0] = 6'b000000;
    assign weight_padded[1] = 6'b000000;
    assign weight_padded[2] = 6'b000000;
    assign weight_padded[3] = 6'b000000;
    assign weight_padded[4] = 6'b000000;
    assign weight_padded[5] = 6'b000000;
    assign weight_padded[6] = weight_bef[0];
    assign weight_padded[7] = weight_bef[1];
    assign weight_padded[8] = weight_bef[2];
    assign weight_padded[9] = 6'b000000;
    assign weight_padded[10] = 6'b000000;
    assign weight_padded[11] = weight_bef[3];
    assign weight_padded[12] = weight_bef[4];
    assign weight_padded[13] = weight_bef[5];
    assign weight_padded[14] = 6'b000000;
    assign weight_padded[15] = 6'b000000;
    assign weight_padded[16] = weight_bef[6];
    assign weight_padded[17] = weight_bef[7];
    assign weight_padded[18] = weight_bef[8];
    assign weight_padded[19] = 6'b000000;
    assign weight_padded[20] = 6'b000000;
    assign weight_padded[21] = 6'b000000;
    assign weight_padded[22] = 6'b000000;
    assign weight_padded[23] = 6'b000000;
    assign weight_padded[24] = 6'b000000;
    
    
    integer i;
    always@(*) begin
        in_2[0] = data_o_0;
        in_2[1] = data_o_1;
        in_2[2] = data_o_2;
        in_2[3] = data_o_3;
        in_2[4] = data_o_4;
        in_2[5] = data_o_5;
        in_2[6] = data_o_6;
        in_2[7] = data_o_7;
        in_2[8] = data_o_8;
        for (i = 0; i < 9; i=i+1) begin
            weight_bef[i] <= data_Out[i];
            in[i] = layer_index[1] ? in_2[i] : in_1[i];    // if layer=2 or 3, take in input from datapath
//            in[i] = in_1[i];
        end
    end
    assign _weight_out = layer_index[0] ? weight_out1 : weight_out2;

    
    input_RAM inp (
                    .read_address(in_addr), .Clk(Clk),
                    .data_Out0(in_1[0]),
                    .data_Out1(in_1[1]),
                    .data_Out2(in_1[2]),
                    .data_Out3(in_1[3]),
                    .data_Out4(in_1[4]),
                    .data_Out5(in_1[5]),
                    .data_Out6(in_1[6]),
                    .data_Out7(in_1[7]),
                    .data_Out8(in_1[8]));
    
    weight_RAM weight1 (
            .read_address(weight_addr), .Clk(Clk),
            .data_Out(weight_out1));
    second_weight_RAM weight2 (
            .read_address(weight_addr), .Clk(Clk),
            .data_Out(weight_out2));
            
    third_weight_RAM weight3(.Clk(Clk), .read_address(weight_addr),
                    .data_Out0(data_Out[0]),
                    .data_Out1(data_Out[1]),
                    .data_Out2(data_Out[2]),
                    .data_Out3(data_Out[3]),
                    .data_Out4(data_Out[4]),
                    .data_Out5(data_Out[5]),
                    .data_Out6(data_Out[6]),
                    .data_Out7(data_Out[7]),
                    .data_Out8(data_Out[8])
    );
    
    Processing_unit_12 pe0( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[0]),
                        .weight3_1(weight_padded[1]), 
                        .weight3_2(weight_padded[2]),
                        .weight3_3(weight_padded[5]),
                        .weight3_4(weight_padded[6]),
                        .weight3_5(weight_padded[7]),
                        .weight3_6(weight_padded[10]),
                        .weight3_7(weight_padded[11]),
                        .weight3_8(weight_padded[12]),
                        .in(in[0]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res0)
    );
    Processing_unit_12 pe1( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[1]),
                        .weight3_1(weight_padded[2]), 
                        .weight3_2(weight_padded[3]),
                        .weight3_3(weight_padded[6]),
                        .weight3_4(weight_padded[7]),
                        .weight3_5(weight_padded[8]),
                        .weight3_6(weight_padded[11]),
                        .weight3_7(weight_padded[12]),
                        .weight3_8(weight_padded[13]),
                        .in(in[1]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res1)
    );
    Processing_unit_12 pe2( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[2]),
                        .weight3_1(weight_padded[3]), 
                        .weight3_2(weight_padded[4]),
                        .weight3_3(weight_padded[7]),
                        .weight3_4(weight_padded[8]),
                        .weight3_5(weight_padded[9]),
                        .weight3_6(weight_padded[12]),
                        .weight3_7(weight_padded[13]),
                        .weight3_8(weight_padded[14]),
                        .in(in[2]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res2)
    );
    Processing_unit_12 pe3( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[5]),
                        .weight3_1(weight_padded[6]), 
                        .weight3_2(weight_padded[7]),
                        .weight3_3(weight_padded[10]),
                        .weight3_4(weight_padded[11]),
                        .weight3_5(weight_padded[12]),
                        .weight3_6(weight_padded[15]),
                        .weight3_7(weight_padded[16]),
                        .weight3_8(weight_padded[17]),
                        .in(in[3]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res3)
    );
    Processing_unit_12 pe4( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[6]),
                        .weight3_1(weight_padded[7]), 
                        .weight3_2(weight_padded[8]),
                        .weight3_3(weight_padded[11]),
                        .weight3_4(weight_padded[12]),
                        .weight3_5(weight_padded[13]),
                        .weight3_6(weight_padded[16]),
                        .weight3_7(weight_padded[17]),
                        .weight3_8(weight_padded[18]),
                        .in(in[4]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res4)
    );
    Processing_unit_12 pe5( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[7]),
                        .weight3_1(weight_padded[8]), 
                        .weight3_2(weight_padded[9]),
                        .weight3_3(weight_padded[12]),
                        .weight3_4(weight_padded[13]),
                        .weight3_5(weight_padded[14]),
                        .weight3_6(weight_padded[17]),
                        .weight3_7(weight_padded[18]),
                        .weight3_8(weight_padded[19]),
                        .in(in[5]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res5)
    );
    Processing_unit_12 pe6( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[10]),
                        .weight3_1(weight_padded[11]), 
                        .weight3_2(weight_padded[12]),
                        .weight3_3(weight_padded[15]),
                        .weight3_4(weight_padded[16]),
                        .weight3_5(weight_padded[17]),
                        .weight3_6(weight_padded[20]),
                        .weight3_7(weight_padded[21]),
                        .weight3_8(weight_padded[22]),
                        .in(in[6]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res6)
    );
    Processing_unit_12 pe7( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[11]),
                        .weight3_1(weight_padded[12]), 
                        .weight3_2(weight_padded[13]),
                        .weight3_3(weight_padded[16]),
                        .weight3_4(weight_padded[17]),
                        .weight3_5(weight_padded[18]),
                        .weight3_6(weight_padded[21]),
                        .weight3_7(weight_padded[22]),
                        .weight3_8(weight_padded[23]),
                        .in(in[7]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res7)
    );
    Processing_unit_12 pe8( .Clk(Clk), .rst(rst),
                        .weight(_weight_out), 
                        .weight3_0(weight_padded[12]),
                        .weight3_1(weight_padded[13]), 
                        .weight3_2(weight_padded[14]),
                        .weight3_3(weight_padded[17]),
                        .weight3_4(weight_padded[18]),
                        .weight3_5(weight_padded[19]),
                        .weight3_6(weight_padded[22]),
                        .weight3_7(weight_padded[23]),
                        .weight3_8(weight_padded[24]),
                        .in(in[8]),
                        .in_1(in[1]),
                        .in_2(in[2]),
                        .in_3(in[3]),
                        .in_4(in[4]),
                        .in_5(in[5]),
                        .in_6(in[6]),
                        .in_7(in[7]),
                        .in_8(in[8]),
                        .layer_index(layer_index),
                        .result(data_res8)
    );
endmodule
