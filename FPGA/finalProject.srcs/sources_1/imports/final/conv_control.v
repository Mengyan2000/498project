module conv_control(
    input Clk,
    input rst,
    // input from datapath
    // output to datapath
    output [15:0] in_address,
    output [15:0] weight_address,
    output load_reg,
    output read_reg,
    output sum_reg,
    output clear_reg,
    output [1:0] layer_index,
    output read_buf_2, load_buf_2, sum_entry_2, clear_entry_2,
    output read_buf_3, load_buf_3, sum_entry_3, clear_entry_3,
    // output to top-level
    output reg [7:0] State
);
    
    
    localparam STATE_INIT = 8'd0;
    localparam FIRST_layer_mul = 8'd1;
    localparam FIRST_layer_sum = 8'd2;
    localparam FIRST_layer_clear = 8'd3;
    localparam SECOND_layer_mul = 8'd4;
    localparam SECOND_layer_sum = 8'd5;
    localparam SECOND_layer_clear = 8'd6;
    localparam THIRD_layer_mul = 8'd7;
    localparam THIRD_layer_sum = 8'd8;
    localparam THIRD_layer_clear = 8'd9;
    
    localparam IDLE = 8'd30;


    parameter first_in = 256;
    parameter first_out = 32;
    

    reg [15:0] _weight_addr;
    reg [15:0] _in_addr;
    reg load, read, sum, clear;
    reg load_2, read_2, sum_2, clear_2;
    reg load_3, read_3, sum_3, clear_3;
    reg [1:0] layer_index_;
    // we need counter for both in_channel and out_channel
    reg [15:0] first_counter_in;
    reg [15:0] first_counter_out;
    reg [15:0] sec_counter_in;
    reg [15:0] sec_counter_out;
    reg [15:0] trd_counter_in;
    reg [15:0] trd_counter_out;

    assign in_address = _in_addr;
    assign weight_address = _weight_addr;
    assign load_reg = load;
    assign read_reg = read;
    assign sum_reg = sum;
    assign clear_reg = clear;
    assign read_buf_2 = read_2;
    assign load_buf_2 = load_2; 
    assign sum_entry_2 = sum_2;
    assign clear_entry_2 = clear_2;
    assign read_buf_3 = read_3;
    assign load_buf_3 = load_3; 
    assign sum_entry_3 = sum_3;
    assign clear_entry_3 = clear_3;
    assign layer_index = layer_index_;

initial  begin
    State = 8'd0; 
    first_counter_in = first_in-1;
    first_counter_out = first_out-1;
    sec_counter_in = first_out-1;
    sec_counter_out = 127;
    trd_counter_in = first_out-1;
    trd_counter_out = 127;
    
    // control and data signal for datapath 
    load = 1'b0;
    read = 1'b0;
    sum = 1'b0;
    clear = 1'b0;
    load_2 = 1'b0;
    read_2 = 1'b0;
    sum_2 = 1'b0;
    clear_2 = 1'b0;
    load_3 = 1'b0;
    read_3 = 1'b0;
    sum_3 = 1'b0;
    clear_3 = 1'b0;
    _weight_addr = 16'd0;
    _in_addr = 16'd0;
    layer_index_ = 2'd0;
end


always @(posedge Clk) begin                       
    case (State)
        // Press Button[3] to start the state machine. Otherwise, stay in the STATE_INIT state        
        STATE_INIT : begin
            if (rst == 1'b0) State <= FIRST_layer_mul;
        end      
        IDLE : begin
            load <= 1'b0;
            _in_addr <= 16'd0;
            _weight_addr <=  16'd0;
            sum <= 1'b0;
            clear <= 1'b0;
            read <= 1'b0;
        end      
        // This is the Start sequence            
        FIRST_layer_mul : begin
            first_counter_in <= first_counter_in - 1'b1;
            layer_index_ = 2'b01;
            if (first_counter_in == 16'h0000) begin
                State <= FIRST_layer_sum;
                load <= 1'b1;
                _in_addr <= 16'd0;
                sum <= 1'b0;
                clear <= 1'b0;
            end
            else begin
                _weight_addr <= _weight_addr+1;
                _in_addr <= _in_addr+9;
                load <= 1'b0;
                sum <= 1'b1;
                clear <= 1'b0;
            end
        end
        
        FIRST_layer_sum : begin
            load <= 1'b0;
            sum <= 1'b0;
            State <= FIRST_layer_clear;
            clear <= 1'b1;
            layer_index_ = 2'b01;
        end
        
        FIRST_layer_clear : begin
            first_counter_out <= first_counter_out - 1'b1;
            layer_index_ = 2'b01;
            if (first_counter_out == 1'b0) begin
                State <= SECOND_layer_mul;
                clear <= 1'b0;
                _weight_addr = 16'd0;
            end
            else begin
                State <= FIRST_layer_mul;
                first_counter_in = first_in-1;
                load <= 1'b0;
                sum <= 1'b1;
            end
        end
        
        // input from first buffer, weight from second weight RAM
        SECOND_layer_mul : begin
            sec_counter_in <= sec_counter_in - 1'b1;
            layer_index_ = 2'b10;
            
            if (sec_counter_in == 16'h0000) begin
                State <= SECOND_layer_sum;
                load_2 <= 1'b1;
                sum_2 <= 1'b0;
                clear_2 <= 1'b0;
                read <= 1'b0;       // read first layer's output
            end
            else begin
                _weight_addr <= _weight_addr+1;
                load_2 <= 1'b0;
                sum_2 <= 1'b1;
                clear_2 <= 1'b0;    
                read <= 1'b1;       // read from first buffer
            end
        end
        
        SECOND_layer_sum : begin
            layer_index_ = 2'b10;
            load_2 <= 1'b0;
            sum_2 <= 1'b0;
            State <= SECOND_layer_clear;
            clear_2 <= 1'b1;
        end
        
        SECOND_layer_clear : begin
            sec_counter_out <= sec_counter_out - 1'b1;
            layer_index_ = 2'b10;
            if (sec_counter_out == 1'b0) begin
                State <= THIRD_layer_mul;
                clear_2 <= 1'b0;
                _weight_addr = 16'd0;
            end
            else begin
                State <= SECOND_layer_mul;
                sec_counter_in = first_out-1;
                load_2 <= 1'b0;
                sum_2 <= 1'b1;
            end
        end
        
        THIRD_layer_mul : begin
            trd_counter_in <= trd_counter_in - 1'b1;
            layer_index_ = 2'b11;
            
            if (trd_counter_in == 16'h0000) begin
                State <= THIRD_layer_sum;
                load_3 <= 1'b1;
                sum_3 <= 1'b0;
                clear_3 <= 1'b0;
                read <= 1'b0;       // read first layer's output
            end
            else begin
                _weight_addr <= _weight_addr+1;
                load_3 <= 1'b0;
                sum_3 <= 1'b1;
                clear_3 <= 1'b0;    
                read <= 1'b1;       // read from first buffer
            end
        end
        
        THIRD_layer_sum : begin
            layer_index_ = 2'b11;
            load_3 <= 1'b0;
            sum_3 <= 1'b0;
            State <= THIRD_layer_clear;
            clear_3 <= 1'b1;
        end
        
        THIRD_layer_clear : begin
            trd_counter_out <= trd_counter_out - 1'b1;
            layer_index_ = 2'b11;
            if (trd_counter_out == 1'b0) begin
                State <= IDLE;
                clear_3 <= 1'b0;
                _weight_addr = 16'd0;
            end
            else begin
                State <= THIRD_layer_mul;
                trd_counter_in = first_out-1;
                load_3 <= 1'b0;
                sum_3 <= 1'b1;
            end
        end

    endcase 
    end

endmodule