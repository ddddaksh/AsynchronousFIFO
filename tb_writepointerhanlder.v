//`timescale 1ns / 1ps
`include "writepointerhandler.v"

module tb_writepointerhandler;
    parameter PTRWIDTH = 3;
    reg wr_reset_n;
    reg wclk;
    reg w_en;
    reg [PTRWIDTH:0] g_rdptr_sync;
    wire [PTRWIDTH:0] b_wrptr;
    wire [PTRWIDTH:0] g_wrptr;
    wire full;

    // Instantiate the DUT (Device Under Test)
    writepointerhandler #(PTRWIDTH) uut (
        .b_wrptr(b_wrptr),
        .g_wrptr(g_wrptr),
        .full(full),
        .wr_reset_n(wr_reset_n),
        .wclk(wclk),
        .w_en(w_en),
        .g_rdptr_sync(g_rdptr_sync)
    );

    // Clock generation
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;  // 10ns period clock
    end

    // Test sequence
    initial begin
        // Initialize inputs
        wr_reset_n = 0;
        w_en = 0;
        g_rdptr_sync = 0;

        // Apply reset
        #10;
        wr_reset_n = 1;
        #10;

        // Edge Case: Write to Full Condition
        // Fill the FIFO to full capacity
        $display("Filling FIFO to full capacity");
        while (!full) begin
            @(posedge wclk);
            w_en = 1;
        end

        // Check that the FIFO is full and no further writes are allowed
        if (full) $display("FIFO is full");

        // Edge Case: Reset during operation
        $display("Applying reset during operation");
        @(posedge wclk);
        wr_reset_n = 0;
        @(posedge wclk);
        wr_reset_n = 1;
        w_en = 0;

        // Check that pointers are reset
        if (b_wrptr == 0 && g_wrptr == 0) $display("Pointers reset correctly after reset");

        // Edge Case: Write and Read synchronization
        $display("Writing and synchronizing read pointer");
        wr_reset_n = 1;
        g_rdptr_sync = 0;
        repeat (2 ** PTRWIDTH) begin
            @(posedge wclk);
            if (!full) begin
                w_en = 1;
                g_rdptr_sync = b_wrptr;  // Simulate read pointer catching up
            end else begin
                w_en = 0;
            end
        end

        // Edge Case: Wrap Around Condition
        $display("Testing wrap-around condition");
        wr_reset_n = 0;
        @(posedge wclk);
        wr_reset_n = 1;
        repeat (2 ** (PTRWIDTH + 1)) begin
            @(posedge wclk);
            if (!full) begin
                w_en = 1;
            end else begin
                w_en = 0;
            end
        end

        // Check that FIFO wraps around correctly
        if (!full) $display("FIFO wrapped around correctly");

        // Finish simulation
        #50;
        $display("Test finished at time %0t", $time);
        $finish;
    end

    // Monitoring outputs
    initial begin
        $monitor("Time: %0t | wr_reset_n: %b | wclk: %b | w_en: %b | g_rdptr_sync: %h | b_wrptr: %h | g_wrptr: %h | full: %b", 
                 $time, wr_reset_n, wclk, w_en, g_rdptr_sync, b_wrptr, g_wrptr, full);
    end

    // Dumping waveforms
    initial begin
        $dumpfile("tb_writepointerhandler.vcd");
        $dumpvars(0, tb_writepointerhandler);
    end
endmodule
