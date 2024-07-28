`include "fifomemory.v"
`include "readpointerhandler.v"
`include "writepointerhandler.v"
`include "two_fsynchroniser.v"
//`include "g2bconverter2.v"

module asynchronous_fifo #(parameter DEPTH=8, DATA_WIDTH = 8)(
    output [DATA_WIDTH-1:0] data_out,
    output full, empty,
    input [DATA_WIDTH-1:0] data_in,
    input wclk, wrst_n,
    input rclk, rrst_n,
    input w_en, r_en
    
    
    
);

parameter PTR_WIDTH = $clog2(DEPTH);

// Synchronization signals
wire [PTR_WIDTH:0] g_wptr_sync, g_rptr_sync;
wire [PTR_WIDTH:0] b_wptr, b_rptr;
wire [PTR_WIDTH:0] g_wptr, g_rptr;

// Memory address wires
wire [PTR_WIDTH-1:0] waddr, raddr;

// Instantiate synchronizers
two_fsynchroniser #(PTR_WIDTH) sync_wptr (g_wptr_sync, g_wptr, rclk, rrst_n);
two_fsynchroniser #(PTR_WIDTH) sync_rptr (g_rptr_sync, g_rptr, wclk, wrst_n);

// Instantiate write pointer handler
writepointerhandler #(PTR_WIDTH) wptr_h(
    .b_wptr(b_wptr),
    .g_wptr(g_wptr),
    .full(full),
    .wrst_n(wrst_n),
    .wclk(wclk),
    .w_en(w_en),
    .g_rptr_sync(g_rptr_sync)
);

// Instantiate read pointer handler
readpointerhandler #(PTR_WIDTH) rptr_h(
    .b_rptr(b_rptr),
    .g_rptr(g_rptr),
    .g_wptr_sync(g_wptr_sync),
    .rrst_n(rrst_n),
    .empty(empty),
    .rclk(rclk),
    .r_en(r_en)
);

// Instantiate FIFO memory
fifomemory #(DEPTH, DATA_WIDTH) fifom (
    .data_out(data_out),
    .empty(empty),
    .full(full),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .wclk(wclk),
    .rclk(rclk),
    .b_wptr(b_wptr),
    .b_rptr(b_rptr)
);

endmodule
