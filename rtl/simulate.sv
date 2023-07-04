module simulate(
    input  logic clk60MHz,
    input  logic rst,
    input  logic in_throw_flag,
    input  logic throw_flag,
    input  logic turn,
    input  logic [11:0] ypos_prebuff,
    input  logic [4:0] speed,
    output logic [6:0] hp_player1,
    output logic [6:0] hp_player2,
    output logic [11:0] ypos_particle,
    output logic [11:0] xpos_particle,
    output logic end_throw
);

logic [6:0] hp_player1_nxt, hp_player2_nxt;
logic [11:0] xpos_particle_nxt;
logic end_throw_nxt;
logic [18:0] counter, counter_nxt;

import variable_pkg::*;

enum logic [2:0]{
    WAIT = 2'b00,
    THROW = 2'b01,
    HIT = 2'b10
} state, state_nxt;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        hp_player1    <= 100;
        hp_player2    <= 100;
        xpos_particle <= 1025;
        end_throw     <= 0;
        state         <= WAIT;
        counter       <= '0;
        ypos_particle <= 768;
    end
    else begin
        hp_player1    <= hp_player1_nxt;
        hp_player2    <= hp_player2_nxt;
        xpos_particle <= xpos_particle_nxt;
        end_throw     <= end_throw_nxt;
        state         <= state_nxt;
        counter       <= counter_nxt;
        ypos_particle <= ypos_prebuff;
    end
end

always_comb begin
    case(state)
        WAIT: begin
            if(throw_flag == 1 || in_throw_flag == 1) begin
                state_nxt = THROW;
                if(turn == PLAYER_1)begin
                    xpos_particle_nxt = 262;
                end
                else begin
                    xpos_particle_nxt = 712;
                end
            end
            else begin
                state_nxt = WAIT;
                xpos_particle_nxt = 1025;
            end
            hp_player1_nxt = hp_player1;
            hp_player2_nxt = hp_player2;
            end_throw_nxt = '0;
            counter_nxt = '0;
        end
        THROW: begin
            if((ypos_particle >= 455) &&  (ypos_particle <= 760)|| (xpos_particle >= 497) && (xpos_particle <= 527) && (ypos_particle >= 384)) begin
                state_nxt = HIT;
            end
            else begin
                state_nxt = THROW;
            end
            if(counter >= (500000))begin
                    if(turn == PLAYER_1)begin
                        xpos_particle_nxt = xpos_particle + speed;
                    end
                    else begin
                        xpos_particle_nxt = xpos_particle - speed;
                    end
                counter_nxt = '0;
            end
            else begin
                counter_nxt = counter + 1;
                xpos_particle_nxt = xpos_particle;
            end
            end_throw_nxt = '0;
            hp_player1_nxt = hp_player1;
            hp_player2_nxt = hp_player2;
        end
        HIT: begin
            if((turn == PLAYER_1) && (xpos_particle >= 712) && (xpos_particle <= 862)) begin
                if((xpos_particle >= 762) && (xpos_particle <= 812)) begin
                    hp_player2_nxt = hp_player2 - 30;
                end
                else begin
                    hp_player2_nxt = hp_player2 - 10;
                end
                hp_player1_nxt = hp_player1;
            end
            else if((turn == PLAYER_2) && (xpos_particle >= 112) && (xpos_particle <= 262)) begin
                if((xpos_particle >= 162) && (xpos_particle <= 212)) begin
                    hp_player1_nxt = hp_player1 - 30;
                end
                else begin
                    hp_player1_nxt = hp_player1 - 10;
                end
                hp_player2_nxt = hp_player2;
            end
            else begin
                hp_player1_nxt = hp_player1;
                hp_player2_nxt = hp_player2;
            end
            xpos_particle_nxt = xpos_particle;
            end_throw_nxt = 1;
            state_nxt = WAIT;
            counter_nxt = '0;
        end
        default: begin
            hp_player1_nxt = hp_player1;
            hp_player2_nxt = hp_player2;
            xpos_particle_nxt = xpos_particle;
            end_throw_nxt = 1;
            state_nxt = WAIT;
            counter_nxt = '0;
        end
    endcase
end
endmodule