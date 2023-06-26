module bufor100_40(
    input clk,
    input logic [11:0] xpos_nxt,
    input logic [11:0] ypos_nxt,
    output logic [11:0] xpos,
    output logic [11:0] ypos
);


always_ff @(posedge clk) begin
    xpos <= xpos_nxt;
    ypos <= ypos_nxt;
end

endmodule