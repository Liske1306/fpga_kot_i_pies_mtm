/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

`timescale 1 ns / 1 ps

module set_wind(
    input  logic clk60MHz,
    input  logic rst,
    input  logic [2:0] turn,

    output logic [2:0] wind
);

logic [2:0] wind_nxt;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        wind <= '0;
    end
    else begin
        wind <= wind_nxt;
    end
end

always_comb begin
    wind_nxt =(5 * turn) + 2;
end
endmodule