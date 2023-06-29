`timescale 1 ns / 1 ps

module throw(
    input  logic clk40MHz,
    input  logic rst,
    input  logic left,
    input  logic turn,
    input  logic current_player,
    input  logic end_throw,

    output logic [4:0] power,
    output logic throw_flag
);

import variable_pkg::*;

logic [4:0] power_nxt;
logic throw_flag_nxt;
logic [20:0]counter_nxt, counter;

enum logic [1:0]{
    WAIT = 2'b00,
    UPDATE = 2'b01,
    HOLD = 2'b10
} state, state_nxt;

always_ff @(posedge clk40MHz) begin
    if(rst) begin
        power      <= '0;
        state      <= WAIT;
        throw_flag <= OFF;
        counter    <= '0;
    end
    else begin
        power      <= power_nxt;
        state      <= state_nxt;
        throw_flag <= throw_flag_nxt;
        counter    <= counter_nxt;
    end
end

always_comb begin
    case(state)
        WAIT: begin
            if((left == 1) && (turn==current_player)) begin
                state_nxt = UPDATE;
            end
            else begin
                state_nxt = WAIT;
            end
            power_nxt = '0;
            throw_flag_nxt = OFF;
            counter_nxt = '0;
        end
        UPDATE: begin
            if((left == 0)) begin
                state_nxt = HOLD;
                power_nxt = power;
                throw_flag_nxt = ON;
                counter_nxt = '0;
            end
            else begin
                state_nxt = UPDATE;
                if(counter >= 1880000) begin
                    power_nxt = power + 1;
                    counter_nxt = '0;
                end
                else begin
                    power_nxt = power;
                    counter_nxt = counter + 1;
                end
                throw_flag_nxt = OFF;
            end
        end
        HOLD: begin
            if(end_throw == 1) begin
                state_nxt = WAIT;
                throw_flag_nxt = OFF;
                power_nxt = '0;
            end
            else begin
                state_nxt = HOLD;
                throw_flag_nxt = ON;
                power_nxt = power;
            end
            counter_nxt = '0;
        end
        default: begin
            state_nxt = WAIT;
            throw_flag_nxt = OFF;
            power_nxt = '0;
            counter_nxt = '0;
        end
    endcase
end
endmodule