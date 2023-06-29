`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// 
//////////////////////////////////////////////////////////////////////////////////


module conv_datapath(
    input Clk,
    input rst,
    
    // data from control
    input [15:0] in_addr,
    input [15:0] weight_addr,
     
    // control signal from control state 
    input [1:0] layer_index,
    input read_buf, load_buf, sum_entry, clear_entry,
    input read_buf_2, load_buf_2, sum_entry_2, clear_entry_2,  
    input read_buf_3, load_buf_3, sum_entry_3, clear_entry_3,
    output [11:0] mult_res
    
    );
    
    reg [11:0] data_res [0:8];
    
//    wire read_buf_;
//    wire load_buf_;
    wire full_o;
    wire full_o_2;
    wire full_o_3;
    wire [5:0] data_o [0:8];
    wire [5:0] data_o_2 [0:8];
    wire [5:0] data_o_3 [0:8];
    wire [11:0] data_res_o [0:8];
    wire [5:0] weight_o [0:8];
    integer i;
    initial begin
        for (i = 0; i < 9; i=i+1) begin
            data_res[i] <= 12'd0;
        end
    end
    always@(*) begin
        data_res[0] <= data_res_o[0];
        data_res[1] <= data_res_o[1];
        data_res[2] <= data_res_o[2];
        data_res[3] <= data_res_o[3];
        data_res[4] <= data_res_o[4];
        data_res[5] <= data_res_o[5];
        data_res[6] <= data_res_o[6];
        data_res[7] <= data_res_o[7];
        data_res[8] <= data_res_o[8];
    end

    assign mult_res = data_res[0];
    
    middle_input_buffer bff0(
            .Clk(Clk), .rst(rst), 
    // valid-ready input protocol
            .load(load_buf), .read(read_buf), .sum(sum_entry), .clear(clear_entry),
            .data0(data_res[0]),
            .data1(data_res[1]),
            .data2(data_res[2]),
            .data3(data_res[3]),
            .data4(data_res[4]),
            .data5(data_res[5]),
            .data6(data_res[6]),
            .data7(data_res[7]),
            .data8(data_res[8]),
            .full_o(full_o),
            .data_o0(data_o[0]),
            .data_o1(data_o[1]),
            .data_o2(data_o[2]),
            .data_o3(data_o[3]),
            .data_o4(data_o[4]),
            .data_o5(data_o[5]),
            .data_o6(data_o[6]),
            .data_o7(data_o[7]),
            .data_o8(data_o[8])
    );
    
    middle_input_buffer bff1(
            .Clk(Clk), .rst(rst), 
    // valid-ready input protocol
            .load(load_buf_2), .read(read_buf_2), .sum(sum_entry_2), .clear(clear_entry_2),
            .data0(data_res[0]),
            .data1(data_res[1]),
            .data2(data_res[2]),
            .data3(data_res[3]),
            .data4(data_res[4]),
            .data5(data_res[5]),
            .data6(data_res[6]),
            .data7(data_res[7]),
            .data8(data_res[8]),
            .full_o(full_o_2),
            .data_o0(data_o_2[0]),
            .data_o1(data_o_2[1]),
            .data_o2(data_o_2[2]),
            .data_o3(data_o_2[3]),
            .data_o4(data_o_2[4]),
            .data_o5(data_o_2[5]),
            .data_o6(data_o_2[6]),
            .data_o7(data_o_2[7]),
            .data_o8(data_o_2[8])
    );
    middle_input_buffer bff3(
            .Clk(Clk), .rst(rst), 
    // valid-ready input protocol
            .load(load_buf_3), .read(read_buf_3), .sum(sum_entry_3), .clear(clear_entry_3),
            .data0(data_res[0]),
            .data1(data_res[1]),
            .data2(data_res[2]),
            .data3(data_res[3]),
            .data4(data_res[4]),
            .data5(data_res[5]),
            .data6(data_res[6]),
            .data7(data_res[7]),
            .data8(data_res[8]),
            .full_o(full_o_3),
            .data_o0(data_o_3[0]),
            .data_o1(data_o_3[1]),
            .data_o2(data_o_3[2]),
            .data_o3(data_o_3[3]),
            .data_o4(data_o_3[4]),
            .data_o5(data_o_3[5]),
            .data_o6(data_o_3[6]),
            .data_o7(data_o_3[7]),
            .data_o8(data_o_3[8])
    );
    
    // all 9 processing units are used on compute 3*3 matrix for next layer's input
    PE  Processing_unit(
                        .Clk(Clk), .rst(rst),
                        .weight_addr(weight_addr),
                        .in_addr(in_addr),
    // input coming from middle buffer
                        .data_o_0(data_o[0]),
                        .data_o_1(data_o[1]),
                        .data_o_2(data_o[2]),
                        .data_o_3(data_o[3]),
                        .data_o_4(data_o[4]),
                        .data_o_5(data_o[5]),
                        .data_o_6(data_o[6]),
                        .data_o_7(data_o[7]),
                        .data_o_8(data_o[8]),
                        .layer_index(layer_index),
    
                        .data_res0(data_res_o[0]),
                        .data_res1(data_res_o[1]),
                        .data_res2(data_res_o[2]),
                        .data_res3(data_res_o[3]),
                        .data_res4(data_res_o[4]),
                        .data_res5(data_res_o[5]),
                        .data_res6(data_res_o[6]),
                        .data_res7(data_res_o[7]),
                        .data_res8(data_res_o[8])
    );
    
        
endmodule

