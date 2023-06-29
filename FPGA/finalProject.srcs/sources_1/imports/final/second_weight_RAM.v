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


module second_weight_RAM
    #(parameter PRECISION = 6)
    (
    input [15:0] read_address,
    input Clk,

    output [PRECISION-1:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
reg [PRECISION-1:0] mem [0:4095];

initial
begin
	 $readmemh("C:/Users/mengy/Documents/University/ECE498/project_2/weight_second_binarize.txt", mem);
end

reg [PRECISION-1:0] _dataout;
assign  data_Out = _dataout;

always @(posedge Clk) begin   
	_dataout<= mem[read_address];
end


endmodule
