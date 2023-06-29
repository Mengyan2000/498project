`timescale 1 ps / 1 ps 
module testbench();

parameter in_len=7;
parameter out_len=15;  
parameter precision = 6;
parameter period = 40; 


reg Clk,rst;

wire [7:0] State;
wire [11:0] mul_res_o;
//wire [11:0] data_O [0:8];
wire [15:0] in_addr;
wire [15:0] weight_addr;
wire load_buf, read_buf, sum_buf, clear_buf;

top_level uut
//FIR_structural u_FIR_structural
    (
    .Clk(Clk),
    .rst(rst),
    .State(State),
    .mul_res_o(mul_res_o),
    .in_addr(in_addr), .weight_addr(weight_addr),
    .read_buf(read_buf), .load_buf(load_buf), .sum_buf(sum_buf), .clear_buf(clear_buf)
    );

//wire [15:0] weight_addr;
//wire [15:0] in_addr;
//wire [11:0]data_res_o;
//wire weight_o;

//PE pe0(
//    .Clk(Clk), .rst(rst),
//    .weight_addr(weight_addr),
//    .in_addr(in_addr),
//    // artificial input coming from testbench
//    .data_o_0(),
//    .data_o_1(),
//    .data_o_2(),
//    .data_o_3(),
//    .data_o_4(),
//    .data_o_5(),
//    .data_o_6(),
//    .data_o_7(),
//    .data_o_8(), 
//    .layer_index(layer_index),
    
//    .data_res0(data_O[0]),
//    .data_res1(data_O[1]),
//    .data_res2(data_O[2]),
//    .data_res3(data_O[3]),
//    .data_res4(data_O[4]),
//    .data_res5(data_O[5]),
//    .data_res6(data_O[6]),
//    .data_res7(data_O[7]),
//    .data_res8(data_O[8])
//    );

always                          
begin                           
   #(period/2); Clk=~Clk;     
   
end


//always @(posedge Clk) begin
//	if(rst) begin
//		weight_addr<=16'd0;
//		in_addr <= 16'd0;
//	end
//	else begin  
	           
//		weight_addr <= weight_addr+1'b1;
//		in_addr <= in_addr+1'b1;
                
//	end
//end
		
// setup initial condition
initial begin                                       

	Clk = 0;


	rst = 1;
	#period     
	rst = 0; 
//	layer_index = 2'b01;
//	weight_addr = 16'd0;
//	in_addr = 16'd0;
//	#(period*100);
//	layer_index = 2'b10;
//    #(period*100);
//	layer_index = 2'b11;                           
	                               
end 

endmodule
