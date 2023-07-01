`timescale 1 ns / 1 ps

module turn_manager(
    input  logic clk60MHz,
    input  logic rst,
    input  logic in_throw_flag,
    input  logic throw_flag,

    output logic [2:0] turn
);

import variable_pkg::*;

logic [2:0] turn_nxt;
logic throw_flag_pre, in_throw_flag_pre;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        turn <= 3'b001;
        throw_flag_pre <= OFF;
        in_throw_flag_pre <= OFF;
    end
    else begin
        turn <= turn_nxt;
        throw_flag_pre <= throw_flag;
        in_throw_flag_pre <= in_throw_flag;
    end
end

always_comb begin
    if(((throw_flag_pre == ON)&&(throw_flag == OFF)) || ((in_throw_flag_pre == ON)&&(in_throw_flag == OFF))) begin
        turn_nxt = turn + 1;
    end
    else begin
        turn_nxt = turn;
    end
end



endmodule