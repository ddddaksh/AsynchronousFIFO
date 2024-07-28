module fifomemory#(parameter WIDTH =8, DEPTH =8, PTRWIDTH = $clog2(DEPTH) )(
        output reg [WIDTH-1:0] data_out,
        input empty, full,
        
        input  w_en,
        input  r_en,
        input [WIDTH-1:0] data_in,
        input wclk,
        input rclk,
        input [PTRWIDTH:0] b_wptr,
        input [PTRWIDTH:0] b_rptr
        


);

    reg [WIDTH-1:0] fifo [0:DEPTH-1];

    always@(posedge wclk) begin
        if(w_en & !full) begin
            fifo[b_wptr]<=data_in;
        end
    end

    always@(posedge rclk) begin
        if(r_en &!empty) begin
            data_out<=fifo[b_rptr];
        end
    end

endmodule