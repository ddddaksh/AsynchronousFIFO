module two_fsynchroniser #(parameter WIDTH =3) (output reg [WIDTH:0]sync_out, input [WIDTH:0] data_in, input clk, input reset_n);
    reg [WIDTH:0]q1;
always @(posedge clk) begin// Sycnhronous Reset
    if(reset_n==0) begin
        q1<=0;
        sync_out<=0;
        end
    else begin 
        q1<=data_in;
        sync_out<=q1;
    end
end
endmodule
        
