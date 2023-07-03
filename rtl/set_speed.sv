module set_speed(
    input  logic clk60MHz,
    input  logic rst,
    input  logic [3:0] in_power,
    input  logic [3:0] power,
    input  logic [2:0] wind,
    input  logic turn,
    input  logic current_player,
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
    if(current_player == PLAYER_1 && turn == PLAYER_1) begin
        if(wind <= 3) begin
            speed_nxt = power - wind - 1;
        end
        else begin
            speed_nxt = power - 3 + wind;
        end
    end
    else if(current_player == PLAYER_2 && turn == PLAYER_1) begin
        if(wind <= 3) begin
            speed_nxt = in_power - wind - 1;
        end
        else begin
            speed_nxt = in_power - 3 + wind;
        end
    end
    else if(current_player == PLAYER_1 && turn == PLAYER_2) begin
        if(wind <= 3) begin
            speed_nxt = in_power - 3 + wind;
        end
        else begin
            speed_nxt = in_power - wind - 1;
        end
    end
    else if(current_player == PLAYER_2 && turn == PLAYER_2)begin
        if(wind <= 3) begin
            speed_nxt = power - 3 + wind;
        end
        else begin
            speed_nxt = power - wind - 1;
        end
    end
    else begin
        speed_nxt = speed;
    end
end

endmodule