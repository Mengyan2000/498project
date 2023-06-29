module middle_input_buffer
#(
    in_channel= 32, 
    matrix = 9, 
    width = 12,
    index=5
)
(
    input Clk,
    input rst, 

    // valid-ready input protocol
    input load,
    input read,
    input sum,
    input clear,
    input [width-1:0] data0,
    input [width-1:0] data1,
    input [width-1:0] data2,
    input [width-1:0] data3,
    input [width-1:0] data4,
    input [width-1:0] data5,
    input [width-1:0] data6,
    input [width-1:0] data7,
    input [width-1:0] data8,
    output full_o,
    // read_out
    output [5:0] data_o0,
    output [5:0] data_o1,
    output [5:0] data_o2,
    output [5:0] data_o3,
    output [5:0] data_o4,
    output [5:0] data_o5,
    output [5:0] data_o6,
    output [5:0] data_o7,
    output [5:0] data_o8
);

/******************************** Declarations *******************************/
// Need memory to hold queued data
    reg [5:0] buffer_data [0:in_channel-1][0:8];  // row=31, col=9, 6-bit data
    reg [15:0] buffer_sum [0:8];
// Pointers which point to the read and write ends of the queue
    reg [index-1:0] read_ptr, write_ptr;
    wire [index:0] read_ptr_next, write_ptr_next;
    reg [8:0] queue_counter;

    assign write_ptr_next = ({27'd0, write_ptr} == in_channel-1)? 5'b00000: write_ptr + 5'b1;
    assign read_ptr_next = ({27'd0, read_ptr} == in_channel-1)? 5'b00000: read_ptr + 5'b1;


    assign full_o = ({26'b0, queue_counter} == in_channel)? 1'b1: 1'b0;
    
    integer i;
    integer j;
/*************************** Non-Blocking Assignments ************************/
    always @(posedge Clk, posedge rst) begin
    if (rst) begin
        read_ptr  <= {(index){1'b1}};
        write_ptr <= {(index){1'b1}};
        queue_counter <= 9'd0;
        for (i = 0; i < in_channel; i = i+1)
        begin
            for (j = 0; j < 9; j=j+1) begin
                buffer_data[i][j] <= 6'd0;
            end
        end
        for (i = 0; i < 9; i = i+1)
        begin  
            buffer_sum[i] <= 16'd0;
        end
    end
    else begin
        if (sum == 1'b1) begin
                buffer_sum[0] <= buffer_sum[0]+data0;
                buffer_sum[1] <= buffer_sum[1]+data1;
                buffer_sum[2] <= buffer_sum[2]+data2;
                buffer_sum[3] <= buffer_sum[3]+data3;
                buffer_sum[4] <= buffer_sum[4]+data4;
                buffer_sum[5] <= buffer_sum[5]+data5;
                buffer_sum[6] <= buffer_sum[6]+data6;
                buffer_sum[7] <= buffer_sum[7]+data7;
                buffer_sum[8] <= buffer_sum[8]+data8;
        end
        else if (clear == 1'b1) begin
            for (i = 0; i < 9; i = i+1)
            begin  
                buffer_sum[i] <= 16'd0;
            end
        end
        else if (load == 1'b1) begin // load case
                if (buffer_sum[0][15] == 1'b1) begin
                    buffer_data[write_ptr][0] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][0] <= buffer_sum[0][10:5];
                end
                
		        if (buffer_sum[1][15] == 1'b1) begin
                    buffer_data[write_ptr][1] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][1] <= buffer_sum[1][10:5];
                end
                
                if (buffer_sum[2][15] == 1'b1) begin
                    buffer_data[write_ptr][2] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][2] <= buffer_sum[2][10:5];
                end
                if (buffer_sum[3][15] == 1'b1) begin
                    buffer_data[write_ptr][3] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][3] <= buffer_sum[3][10:5];
                end  
                
                if (buffer_sum[4][15] == 1'b1) begin
                    buffer_data[write_ptr][4] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][4] <= buffer_sum[4][10:5];
                end
                
                if (buffer_sum[5][15] == 1'b1) begin
                    buffer_data[write_ptr][5] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][5] <= buffer_sum[5][10:5];
                end  
                
                if (buffer_sum[6][15] == 1'b1) begin
                    buffer_data[write_ptr][6] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][6] <= buffer_sum[6][10:5];
                end 
                
                if (buffer_sum[7][15] == 1'b1) begin
                    buffer_data[write_ptr][7] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][7] <= buffer_sum[7][10:5];
                end
                
                if (buffer_sum[8][15] == 1'b1) begin
                    buffer_data[write_ptr][8] <= 6'b000000;
                end
                else begin
                    buffer_data[write_ptr][8] <= buffer_sum[8][10:5];
                end
		        
                write_ptr <= write_ptr_next;
                queue_counter <= queue_counter + 9'd1;
            end
        else if (read == 1'b1) begin // read_case
                
                read_ptr <= read_ptr_next;
                queue_counter <= queue_counter - 9'd1;
        end
    end

end


assign data_o0 = buffer_data[read_ptr][0];
assign data_o1 = buffer_data[read_ptr][1];
assign data_o2 = buffer_data[read_ptr][2];
assign data_o3 = buffer_data[read_ptr][3];
assign data_o4 = buffer_data[read_ptr][4];
assign data_o5 = buffer_data[read_ptr][5];
assign data_o6 = buffer_data[read_ptr][6];
assign data_o7 = buffer_data[read_ptr][7];
assign data_o8 = buffer_data[read_ptr][8];

endmodule
