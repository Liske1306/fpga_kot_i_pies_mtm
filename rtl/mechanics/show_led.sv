/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

module show_led(
    input  logic clk60MHz,
    input  logic rst,
    input  logic turn,
    input  logic throw_flag,
    input  logic left,
    output logic [3:0] led
);

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        led[3:0] <= '0;
    end
    else begin
        led[0] <= '1;
        led[1] <= turn;
        led[2] <= throw_flag;
        led[3] <= left;
    end
end

endmodule