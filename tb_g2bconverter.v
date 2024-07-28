`include "g2bconverter2.v"
module tb_g2bconverter;

    parameter WIDTH = 4;
    reg [WIDTH-1:0] gray;
    wire [WIDTH-1:0] binary;

    // Instantiate the gray to binary converter
    g2bconverter2 #(.width(WIDTH)) converter (
        .data_out(binary),
        .data_in(gray)
    );

    initial begin
        // Apply Gray code test vectors and display results
        gray = 'b000; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b001; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 4'b1100; #10;
        $display("Gray: %b, Binary: %b", gray, binary);

        gray = 3'b011; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b010; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b110; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b111; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b101; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        gray = 3'b100; #10;
        $display("Gray: %b, Binary: %b", gray, binary);
        
        $finish;
    end

    initial begin 
        $dumpfile("tb_g2bconverter.vcd");
        $dumpvars(0, tb_g2bconverter);
    end
endmodule
