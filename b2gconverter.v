module b2gconverter #(parameter width =4) (output wire [width-1:0]data_out, input wire [width-1:0] data_in);

    assign data_out = data_in ^ (data_in>>1);


endmodule
