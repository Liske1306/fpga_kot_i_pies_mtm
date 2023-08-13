/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 *
 */

module set_speed(
    input  logic clk60MHz,
    input  logic rst,
    input  logic [4:0] in_power,
    input  logic [4:0] power,
    input  logic [2:0] wind,
    input  logic turn,
    input  logic [1:0] current_player,
    output logic [4:0] speed
);

logic [4:0] speed_nxt;

import variable_pkg::*;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        speed <= '0;
    end
    else begin
        speed <= speed_nxt;
    end
end

always_comb begin
    if((current_player == PLAYER_1) && (turn == 0)) begin
        if(wind[2]==1) begin
            speed_nxt = in_power + wind[1:0];
        end
        else begin
            speed_nxt = in_power - wind[1:0];
        end
    end
    else if((current_player == PLAYER_2) && (turn == 0)) begin
        if(wind[2]==1) begin
            speed_nxt = power + wind[1:0];
        end
        else begin
            speed_nxt = power - wind[1:0];
        end
    end
    else if((current_player == PLAYER_1) && (turn == 1)) begin
        if(wind[2]==1) begin
            speed_nxt = power - wind[1:0];
        end
        else begin
            speed_nxt = power + wind[1:0];
        end
    end
    else if((current_player == PLAYER_2) && (turn == 1))begin
        if(wind[2]==1) begin
            speed_nxt = in_power - wind[1:0];
        end
        else begin
            speed_nxt = in_power + wind[1:0];
        end
    end
    else begin
        speed_nxt = speed;
    end
end

endmodule