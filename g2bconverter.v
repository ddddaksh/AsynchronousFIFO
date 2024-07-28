module g2bconverter #(parameter width =4)(output wire [width-1:0]d_out, input wire [width-1:0]d_in);
  genvar i;
  generate
    for(i=0;i<width;i=i+1) begin
      assign d_out[i] = ^(d_in >> i);
    end
  endgenerate
            
        
endmodule    