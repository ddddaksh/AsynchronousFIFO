//`include "g2bconverter2.v"
module readpointerhandler #(parameter PTRWIDTH =3)(output reg [PTRWIDTH:0] b_rptr, 
                                                    output reg [PTRWIDTH:0] g_rptr,
                                                    output reg empty,
                                                    input [PTRWIDTH:0] g_wptr_sync,
                                                    input rrst_n,
                                                    input rclk,
                                                    input r_en);

wire [PTRWIDTH:0] b_rptr_next ;

assign b_rptr_next = b_rptr + (r_en & !empty); // Try taking read reset into consideration for this while doing waveform analysis
wire [PTRWIDTH:0]binary;

always @(posedge rclk or negedge rrst_n) begin
    if(rrst_n==0) begin
        b_rptr<=0;
        g_rptr<=0;
        //empty<=0;

    end
    else begin
        if(!empty & r_en) begin
        b_rptr<= b_rptr_next;
        g_rptr<= (b_rptr_next) ^ b_rptr_next>>1;
        end
    end
end

g2bconverter2  #(.width(PTRWIDTH+1))uut (binary,g_wptr_sync);


// always @(posedge rclk or negedge rrst_n) begin
//     if(rrst_n==0) empty<=0;
//     else empty <= (b_rptr == binary);
// end

always @(posedge rclk or negedge rrst_n) begin
    //if(rrst_n==0) assign empty =0;
      empty <= (b_rptr==binary);
end


endmodule


