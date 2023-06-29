module top_level(
    input Clk,
    input rst,
    
    // outputs to top level 
    output [7:0] State,
    output [11:0] mul_res_o,
    output [15:0] in_addr,
    output [15:0] weight_addr,
    output read_buf, load_buf, sum_buf, clear_buf
    );
    
    wire [15:0] in_addr_o;
    wire [15:0]weight_addr_o;
    wire [1:0] layer_o;
    wire read_buf_o, load_buf_o, sum_buf_o, clear_buf_o;
    wire read_2_o, load_2_o, sum_2_o, clear_2_o;
    wire read_3_o, load_3_o, sum_3_o, clear_3_o;
    wire [7:0] State_o;
    
    reg [15:0] in_addr_i;
    reg [15:0] weight_addr_i;
    reg [1:0] layer_i;
    reg read_buf_i, load_buf_i, sum_buf_i, clear_buf_i;
    reg read_2_i, load_2_i, sum_2_i, clear_2_i;
    reg read_3_i, load_3_i, sum_3_i, clear_3_i;
    
    always@(*) begin
        in_addr_i = in_addr_o;
        weight_addr_i = weight_addr_o;
        read_buf_i = read_buf_o;
        load_buf_i = load_buf_o;
        sum_buf_i = sum_buf_o;
        clear_buf_i = clear_buf_o;
        read_2_i = read_2_o; 
        load_2_i = load_2_o; 
        sum_2_i = sum_2_o;
        clear_2_i = clear_2_o;
        read_3_i = read_3_o; 
        load_3_i = load_3_o; 
        sum_3_i = sum_3_o;
        clear_3_i = clear_3_o;
        layer_i = layer_o;
    end
    
    assign State = State_o;
    assign in_addr = in_addr_i;
    assign weight_addr = weight_addr_i;
    assign read_buf = read_buf_i;
    assign load_buf = load_buf_i;
    assign sum_buf = sum_buf_i;
    assign clear_buf = clear_buf_i;
    
    conv_datapath dp0 (.Clk(Clk), .rst(rst),
    // data from control
            .in_addr(in_addr_i),
            .weight_addr(weight_addr_i),
     
    // control signal from control state 
            .read_buf(read_buf_i), .load_buf(load_buf_i), .sum_entry(sum_buf_i), .clear_entry(clear_buf_i),
            .layer_index(layer_i),
            .read_buf_2(read_2_i), 
            .load_buf_2(load_2_i), 
            .sum_entry_2(sum_2_i), 
            .clear_entry_2(clear_2_i),
            .read_buf_3(read_3_i), 
            .load_buf_3(load_3_i), 
            .sum_entry_3(sum_3_i), 
            .clear_entry_3(clear_3_i),
            .mult_res(mul_res_o)
    );
    
    conv_control ctl0(
            .Clk(Clk),
            .rst(rst),
    // input from datapath
    
    // output to datapath
            .in_address(in_addr_o),
            .weight_address(weight_addr_o),
            .load_reg(load_buf_o),
            .read_reg(read_buf_o),
            .sum_reg(sum_buf_o),
            .clear_reg(clear_buf_o),
            .layer_index(layer_o),
            .read_buf_2(read_2_o), 
            .load_buf_2(load_2_o), 
            .sum_entry_2(sum_2_o), 
            .clear_entry_2(clear_2_o),
            .read_buf_3(read_3_o), 
            .load_buf_3(load_3_o), 
            .sum_entry_3(sum_3_o), 
            .clear_entry_3(clear_3_o),
    // output to top-level
            .State(State_o)
);
    
    
endmodule