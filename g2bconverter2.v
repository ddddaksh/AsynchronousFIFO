module g2bconverter2 #(parameter width =4) (output wire [width-1:0]data_out, input wire [width-1:0] data_in);

    genvar i;
    assign data_out[width-1] = data_in[width-1];
    generate for(i=width-2;i>=0;i=i-1) begin
        assign data_out[i] = data_out[i+1] ^ data_in[i];
        end
    endgenerate

endmodule
