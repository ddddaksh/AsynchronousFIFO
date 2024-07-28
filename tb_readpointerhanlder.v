`include "readpointerhandler.v"
module tb_readpointerhandler;

    // Parameters
    parameter PTRWIDTH = 3;

    // Signals
    reg read_reset_n;
    reg rdclk;
    reg r_en;
    reg [PTRWIDTH:0] g_wptr_sync;
    wire [PTRWIDTH:0] b_rd_ptr;
    wire [PTRWIDTH:0] g_rd_ptr;
    wire empty;

    // Instantiate the readpointerhandler module
    readpointerhandler #(PTRWIDTH) uut (
        .b_rd_ptr(b_rd_ptr),
        .g_rd_ptr(g_rd_ptr),
        .g_wptr_sync(g_wptr_sync),
        .read_reset_n(read_reset_n),
        .empty(empty),
        .rdclk(rdclk),
        .r_en(r_en)
    );

    // Clock generation
    initial begin
        rdclk = 0;
        forever #5 rdclk = ~rdclk; // 100 MHz clock
    end

    // Stimulus generation
    initial begin
        // Initialize inputs
        read_reset_n = 0;
        r_en = 0;
        g_wptr_sync = 0;

        // Apply reset
        #10 read_reset_n = 1;

        // Write cycles
        // Simulate write operations by changing g_wptr_sync
        #10 g_wptr_sync = 1; // Write 1st data
        $display("Time: %0t - Writing 1st data, g_wptr_sync = %0d", $time, g_wptr_sync);
        
        #10 g_wptr_sync = 2; // Write 2nd data
        $display("Time: %0t - Writing 2nd data, g_wptr_sync = %0d", $time, g_wptr_sync);

        #10 g_wptr_sync = 3; // Write 3rd data
        $display("Time: %0t - Writing 3rd data, g_wptr_sync = %0d", $time, g_wptr_sync);

        #10 g_wptr_sync = 4; // Write 4th data
        $display("Time: %0t - Writing 4th data, g_wptr_sync = %0d", $time, g_wptr_sync);

        #10 g_wptr_sync = 5; // Write 5th data
        $display("Time: %0t - Writing 5th data, g_wptr_sync = %0d", $time, g_wptr_sync);

        // Read cycles
        // Simulate read operations by enabling r_en
        #10 r_en = 1; // Read 1st data
        $display("Time: %0t - Reading 1st data, r_en = %0d", $time, r_en);
        #20 r_en = 0;
        
        #10 r_en = 1; // Read 2nd data
        $display("Time: %0t - Reading 2nd data, r_en = %0d", $time, r_en);
        #20 r_en = 0;
        
        #10 r_en = 1; // Read 3rd data
        $display("Time: %0t - Reading 3rd data, r_en = %0d", $time, r_en);
        #20 r_en = 0;
        
        #10 r_en = 1; // Read 4th data
        $display("Time: %0t - Reading 4th data, r_en = %0d", $time, r_en);
        #20 r_en = 0;
        
        #10 r_en = 1; // Read 5th data
        $display("Time: %0t - Reading 5th data, r_en = %0d", $time, r_en);
        #20 r_en = 0;

        // Check empty flag
        #10 g_wptr_sync = 7; // Change the write pointer to simulate write
        $display("Time: %0t - Simulating write, g_wptr_sync = %0d", $time, g_wptr_sync);
        
        #10 r_en = 1; // Attempt to read more
        $display("Time: %0t - Attempting to read more, r_en = %0d", $time, r_en);
        #20 r_en = 0;

        // Apply reset again
        #10 read_reset_n = 0;
        $display("Time: %0t - Applying reset, read_reset_n = %0d", $time, read_reset_n);
        
        #10 read_reset_n = 1;
        $display("Time: %0t - Releasing reset, read_reset_n = %0d", $time, read_reset_n);

        // Finish simulation
        #100 $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("Time: %0t, b_rd_ptr: %0d, g_rd_ptr: %0d, g_wptr_sync: %0d, empty: %0d, read_reset_n: %0d, r_en: %0d",
                 $time, b_rd_ptr, g_rd_ptr, g_wptr_sync, empty, read_reset_n, r_en);
    end

    // Dumpfile and dumpvars for waveform
    initial begin
        $dumpfile("readpointerhandler_tb.vcd");
        $dumpvars(0, tb_readpointerhandler);
    end

endmodule
