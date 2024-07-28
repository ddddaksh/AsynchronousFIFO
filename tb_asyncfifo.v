`include "asynchronous_fifo.v"

module tb_asyncfifo;

  parameter DATA_WIDTH = 8;
  parameter DEPTH = 8;

  // Testbench signals
  reg wclk, wrst_n;
  reg rclk, rrst_n;
  reg w_en, r_en;
  reg [DATA_WIDTH-1:0] data_in;
  wire [DATA_WIDTH-1:0] data_out;
  wire full, empty;

  // Instantiate the asynchronous FIFO
  asynchronous_fifo #(DEPTH, DATA_WIDTH) as_fifo (
    .wclk(wclk),
    .wrst_n(wrst_n),
    .rclk(rclk),
    .rrst_n(rrst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Generate write clock
  always #10 wclk = ~wclk;

  // Generate read clock
  always #15 rclk = ~rclk;

  // Task to write data to the FIFO
  task write_data(input [DATA_WIDTH-1:0] data);
    begin
      @(posedge wclk);
      if (!full) begin
        w_en = 1;
        data_in = data;
        @(posedge wclk);
        w_en = 0;
        $display("Time %0t: Wrote data = %h", $time, data);
      end else begin
        $display("Time %0t: FIFO is full. Cannot write data = %h", $time, data);
      end
    end
  endtask

  // Task to read data from the FIFO
  task read_data();
    begin
      @(posedge rclk);
      if (!empty) begin
        r_en = 1;
        @(posedge rclk);
        r_en = 0;
        $display("Time %0t: Read data = %h", $time, data_out);
      end else begin
        $display("Time %0t: FIFO is empty. Cannot read data", $time);
      end
    end
  endtask

  initial begin
    // Initialize signals
    wclk = 0;
    rclk = 0;
    wrst_n = 0;
    rrst_n = 0;
    w_en = 0;
    r_en = 0;
    data_in = 0;

    // Apply reset
    @(posedge wclk);
    wrst_n = 1;
    rrst_n = 1;
    $display("Time %0t: Reset applied", $time);

    // Write data to the FIFO
    write_data(8'hA1);
    write_data(8'hB2);
    write_data(8'hC3);
    write_data(8'hD4);
    write_data(8'hE5);
    write_data(8'hF6);
    write_data(8'h07);
    write_data(8'h18);

    // Attempt to write when full
    write_data(8'hFF);

    // Read data from the FIFO
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();

    // Attempt to read when empty
    read_data();

    // Test reset functionality during operation
    @(posedge wclk);
    wrst_n = 0;
    rrst_n = 0;
    $display("Time %0t: Reset during operation", $time);

    @(posedge wclk);
    wrst_n = 1;
    rrst_n = 1;
    $display("Time %0t: Reset released", $time);

    // Write and read again after reset
    write_data(8'hAA);
    write_data(8'hBB);
    write_data(8'hC3);
    write_data(8'hD4);
    write_data(8'hE5);
    write_data(8'hF6);
    write_data(8'h07);
    write_data(8'h18);

    write_data(8'hFF);
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();


    @(posedge wclk);
    wrst_n = 0;
    rrst_n = 0;
    $display("Time %0t: Reset during operation", $time);

    @(posedge wclk);
    wrst_n = 1;
    rrst_n = 1;
    $display("Time %0t: Reset released", $time);
    //r_en =1;
   
    write_data(8'hAA);
    read_data();
    
    write_data(8'hBB);
    
    read_data();
    #10
    $finish;
  end

  initial begin
    $dumpfile("asyncfifo_tb.vcd");
    $dumpvars(0, tb_asyncfifo);
  end

endmodule
