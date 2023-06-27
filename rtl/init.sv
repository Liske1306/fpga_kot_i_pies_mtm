`timescale 1 ns / 1 ps

module init(
    input  logic clk40MHz,
    input  logic rst,
    input  logic in_player1_ready,
    input  logic in_player2_ready,
    input  logic player1_choose,
    input  logic player2_choose,
    input  logic [4:0] in_power,
    input  logic in_throw_flag,

    output logic player1_led,
    output logic player2_led,
    output logic out_player1_ready, 
    output logic out_player2_ready,
    output logic current_player,
    output logic [4:0] out_power,
    output logic out_throw_flag,
    output logic [7:0] turn
);

import variable_pkg::*;

logic player1_led_nxt, player2_led_nxt, out_player1_ready_nxt, out_player2_ready_nxt, current_player_nxt, out_throw_flag_nxt;
logic [4:0] out_power_nxt;
logic [7:0] turn_nxt;

enum logic [1:0] {
    CONNECT = 2'b00,
    CHOOSE_PLAYER = 2'b01,
    IDLE = 2'b10
} state, state_nxt;

always_ff @(posedge clk40MHz) begin
    if(rst) begin
        player1_led       <= OFF;
        player2_led       <= OFF;
        out_player1_ready <= OFF;
        out_player2_ready <= OFF;
        current_player    <= 'z;
        out_power         <= '1;
        out_throw_flag    <= OFF;
        turn              <= '0;
        state             <= CHOOSE_PLAYER;
    end
    else begin
        player1_led       <= player1_led_nxt;
        player2_led       <= player2_led_nxt;
        out_player1_ready <= out_player1_ready_nxt;
        out_player2_ready <= out_player2_ready_nxt;
        current_player    <= current_player_nxt;
        out_power         <= out_power_nxt;
        out_throw_flag    <= out_throw_flag_nxt;
        turn              <= turn_nxt;
        state             <= state_nxt;
    end
end

always_comb begin
    case(state)
    CONNECT: begin
        if((in_throw_flag == ON) && (in_power == '0)) begin
            player1_led_nxt = 1;
            player2_led_nxt = 1;
            state_nxt = CHOOSE_PLAYER;
        end
        else begin
            player1_led_nxt = 0;
            player2_led_nxt = 0;
            state_nxt = CONNECT;
        end
        out_player1_ready_nxt = OFF;
        out_player2_ready_nxt = OFF;
        current_player_nxt = 'z;
        out_power_nxt = '0;
        out_throw_flag_nxt = ON;
        turn_nxt = '0;
    end
    CHOOSE_PLAYER: begin
        if(((in_player1_ready == ON) && (out_player2_ready == ON)) || ((in_player2_ready == ON) && (out_player1_ready == ON)))begin
            player1_led_nxt = player1_led;
            player2_led_nxt = player2_led;
            out_player1_ready_nxt = out_player1_ready;
            out_player2_ready_nxt = out_player2_ready;
            current_player_nxt = current_player;
            turn_nxt = turn;
            state_nxt = IDLE;
        end
        else if((in_player1_ready == OFF) && (player1_choose == 1)) begin
            player1_led_nxt = 1;
            player2_led_nxt = 0;
            out_player1_ready_nxt = ON;
            out_player2_ready_nxt = OFF;
            current_player_nxt = PLAYER_1;
            turn_nxt = '0;
            state_nxt = CHOOSE_PLAYER;
        end
        else if((in_player2_ready == OFF) && (player2_choose == 1)) begin
            player1_led_nxt = 0;
            player2_led_nxt = 1;
            out_player2_ready_nxt = ON;
            out_player1_ready_nxt = OFF;
            current_player_nxt = PLAYER_2;
            turn_nxt = '0;
            state_nxt = CHOOSE_PLAYER;
        end
        else begin
            player1_led_nxt = 0;
            player2_led_nxt = 0;
            out_player2_ready_nxt = OFF;
            out_player1_ready_nxt = OFF;
            current_player_nxt = current_player;
            turn_nxt = '0;
            state_nxt = CHOOSE_PLAYER;
        end
        out_power_nxt = out_power;
        out_throw_flag_nxt = OFF;
    end
    IDLE: begin
        player1_led_nxt = player1_led;
        player2_led_nxt = player2_led;
        out_player1_ready_nxt = out_player1_ready;
        out_player2_ready_nxt = out_player2_ready;
        current_player_nxt = current_player;
        out_power_nxt = out_power;
        out_throw_flag_nxt = out_throw_flag;
        turn_nxt = turn;
        state_nxt = IDLE;
    end
    default: begin
        player1_led_nxt = player1_led;
        player2_led_nxt = player2_led;
        out_player1_ready_nxt = out_player1_ready;
        out_player2_ready_nxt = out_player2_ready;
        current_player_nxt = current_player;
        out_power_nxt = out_power;
        out_throw_flag_nxt = out_throw_flag;
        turn_nxt = turn;
        state_nxt = IDLE;
    end
    endcase
end

endmodule