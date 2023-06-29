`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module input_RAM
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
reg [PRECISION-1:0] mem [0:8191];

initial
begin
	 $readmemb("C:/Users/mengy/Documents/University/ECE498/project_2/input_binarize.txt", mem);
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
	_dataout[0]<= mem[read_address];
	_dataout[1]<= mem[read_address+16'd1];
	_dataout[2]<= mem[read_address+16'd2];
	_dataout[3]<= mem[read_address+16'd3];
	_dataout[4]<= mem[read_address+16'd4];
	_dataout[5]<= mem[read_address+16'd5];
	_dataout[6]<= mem[read_address+16'd6];
	_dataout[7]<= mem[read_address+16'd7];
	_dataout[8]<= mem[read_address+16'd8];
end


endmodule
