`timescale 1 ns / 1 ps

module choose_player(
    input  logic clk40MHz,
    input  logic rst,
    input  logic in_player1_ready,
    input  logic in_player2_ready,
    input  logic player1_choose,
    input  logic player2_choose,

    output logic player1_led,
    output logic player2_led,
    output logic out_player1_ready, 
    output logic out_player2_ready,
    output logic current_player
);

import variable_pkg::*;

logic player1_led_nxt, player2_led_nxt, out_player1_ready_nxt, out_player2_ready_nxt, current_player_nxt;

enum logic {
    IDLE = 1'b0,
    CHOOSE_PLAYER = 1'b1
} state, state_nxt;

always_ff @(posedge clk40MHz) begin
    if(rst) begin
        player1_led       <= OFF;
        player2_led       <= OFF;
        out_player1_ready <= OFF;
        out_player2_ready <= OFF;
        current_player    <= 'z;
        state             <= CHOOSE_PLAYER;
    end
    else begin
        player1_led       <= player1_led_nxt;
        player2_led       <= player2_led_nxt;
        out_player1_ready <= out_player1_ready_nxt;
        out_player2_ready <= out_player2_ready_nxt;
        current_player    <= current_player_nxt;
        state             <= state_nxt;
    end
end

always_comb begin
    case(state)
    CHOOSE_PLAYER: begin
        if(((in_player1_ready == ON) && (out_player2_ready == ON)) || ((in_player2_ready == ON) && (out_player1_ready == ON)))begin
            player1_led_nxt = player1_led;
            player2_led_nxt = player2_led;
            out_player1_ready_nxt = out_player1_ready;
            out_player2_ready_nxt = out_player2_ready;
            current_player_nxt = current_player;
            state_nxt = IDLE;
        end
        else if((in_player1_ready == OFF) && (player1_choose == 1)) begin
            player1_led_nxt = 1;
            player2_led_nxt = 0;
            out_player1_ready_nxt = ON;
            out_player2_ready_nxt = OFF;
            current_player_nxt = PLAYER_1;
            state_nxt = CHOOSE_PLAYER;
        end
        else if((in_player2_ready == OFF) && (player2_choose == 1)) begin
            player1_led_nxt = 0;
            player2_led_nxt = 1;
            out_player2_ready_nxt = ON;
            out_player1_ready_nxt = OFF;
            current_player_nxt = PLAYER_2;
            state_nxt = CHOOSE_PLAYER;
        end
        else begin
            player1_led_nxt = 0;
            player2_led_nxt = 0;
            out_player2_ready_nxt = OFF;
            out_player1_ready_nxt = OFF;
            current_player_nxt = current_player;
            state_nxt = CHOOSE_PLAYER;
        end
    end
    IDLE: begin
        player1_led_nxt = player1_led;
        player2_led_nxt = player2_led;
        out_player1_ready_nxt = out_player1_ready;
        out_player2_ready_nxt = out_player2_ready;
        current_player_nxt = current_player;
        state_nxt = IDLE;
    end
    endcase
end

endmodule