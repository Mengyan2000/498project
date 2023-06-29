`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2022 09:01:04 PM
// Design Name: 
// Module Name: weight_RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// ECE385-HelperTools/PNG-To-Txt
// Author: Rishi Thakkar
//////////////////////////////////////////////////////////////////////////////////


module third_weight_RAM
    #(parameter PRECISION = 6)
    (
    input [15:0] read_address,
    input Clk,

    output [PRECISION-1:0] data_Out0,
    output [PRECISION-1:0] data_Out1,
    output [PRECISION-1:0] data_Out2,
    output [PRECISION-1:0] data_Out3,
    output [PRECISION-1:0] data_Out4,
    output [PRECISION-1:0] data_Out5,
    output [PRECISION-1:0] data_Out6,
    output [PRECISION-1:0] data_Out7,
    output [PRECISION-1:0] data_Out8

);

// mem has width of 3 bits and a total of 400 addresses
reg [PRECISION-1:0] mem [0:36863];
 
wire [15:0] _address;
 
assign _address = read_address % 9;
initial
begin
	 $readmemh("C:/Users/mengy/Documents/University/ECE498/project_2/weight_third_binarize.txt", mem);
end

reg [PRECISION-1:0] _dataout [0:8];
assign  data_Out0 = _dataout[0];
assign  data_Out1 = _dataout[1];
assign  data_Out2 = _dataout[2];
assign  data_Out3 = _dataout[3];
assign  data_Out4 = _dataout[4];
assign  data_Out5 = _dataout[5];
assign  data_Out6 = _dataout[6];
assign  data_Out7 = _dataout[7];
assign  data_Out8 = _dataout[8];

always @(posedge Clk) begin   
	_dataout[0]<= mem[_address];
	_dataout[1]<= mem[_address+16'd1];
	_dataout[2]<= mem[_address+16'd2];
	_dataout[3]<= mem[_address+16'd3];
	_dataout[4]<= mem[_address+16'd4];
	_dataout[5]<= mem[_address+16'd5];
	_dataout[6]<= mem[_address+16'd6];
	_dataout[7]<= mem[_address+16'd7];
	_dataout[8]<= mem[_address+16'd8];
end


endmodule
