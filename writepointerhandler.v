`include "g2bconverter2.v"
module writepointerhandler #(parameter PTRWIDTH =3)(output reg [PTRWIDTH:0] b_wptr, 
                           output reg [PTRWIDTH:0] g_wptr,
                           output reg full,
                           input [PTRWIDTH:0] g_rptr_sync,
                           input wrst_n, 
                           input wclk, 
                           input w_en);


    //wire [PTRWIDTH:0] gray;
    wire [PTRWIDTH:0] binary;
    //g2bconverter2 #(.width(PTRWIDTH+1)) uut(gray,b_wptr);
    // Making a an assignment ot parallely store next stage. If I do it in the alwyas block the grey code conversion takes places at the next clock cycle hence there my be a loss of synchronisation
   wire [PTRWIDTH:0] b_wptr_next;
   assign b_wptr_next = b_wptr+(w_en & !full);
    
    always@(posedge wclk or negedge wrst_n) begin
        if(wrst_n==0) begin
            b_wptr<=0;
            g_wptr<=0;
            full<=0;
        end
        else begin
            if(!full && w_en) begin
                b_wptr <= b_wptr_next;
                g_wptr <= b_wptr_next ^ (b_wptr_next>>1);
            end
        end
    end

    
    //g2bconverter2 uut(gray,b_wptr);
    g2bconverter2  #(.width(PTRWIDTH+1))uut2 (binary,g_rptr_sync);

   //always @(posedge wclk) 
    //assign full = b_wptr[PTRWIDTH]!=binary[PTRWIDTH] & b_wptr[PTRWIDTH-1:0] == binary [PTRWIDTH-1:0];
    //assign empty = b_wptr == binary;
    

    always @(posedge wclk or negedge wrst_n) begin
        //if(wrst_n==0) full<=0;
        full <= b_wptr[PTRWIDTH]!=binary[PTRWIDTH] & b_wptr[PTRWIDTH-1:0] == binary [PTRWIDTH-1:0];

    end

endmodule




