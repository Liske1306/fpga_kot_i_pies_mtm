/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

`timescale 1 ns / 1 ps

module turn_manager(
    input  logic clk60MHz,
    input  logic rst,
    input  logic in_throw_flag,
    input  logic throw_flag,
    input  logic [1:0] current_player,

    output logic [2:0] turn
);

import variable_pkg::*;

logic [2:0] turn_nxt;

enum logic {
    WAIT = 1'b0,
    UPDATE = 1'b1
} state, state_nxt;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        turn <= 3'b001;
        state <= WAIT;
    end
    else begin
        turn <= turn_nxt;
        state <= state_nxt;
    end
end

always_comb begin
    case(state)
    WAIT: begin
        if(((throw_flag == 1) || (in_throw_flag == 1)) && ((current_player == PLAYER_1) || (current_player == PLAYER_2))) begin
            state_nxt = UPDATE;
        end
        else begin
            state_nxt = WAIT;
        end 
        turn_nxt = turn;
    end
    UPDATE: begin
        if((throw_flag == 0) && (in_throw_flag == 0)) begin
        turn_nxt = turn + 1;
        state_nxt = WAIT;
        end
        else begin
            turn_nxt = turn;
            state_nxt = UPDATE;            
        end
    end
    endcase
end



endmodule