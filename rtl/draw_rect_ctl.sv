`timescale 1 ns / 1 ps

module draw_rect_ctl (
     input  logic clk,
     input  logic rst,
     input  logic mouse_left,
     input  logic [11:0] mouse_xpos,
     input  logic [11:0] mouse_ypos,
     output  logic [11:0] xpos,
     output  logic [11:0] ypos
);

import vga_pkg::*;

//Współczynnik odbijania wynosi ~1

enum bit  [1:0] {IDLE = 2'b00, FALLING = 2'b01, STAY = 2'b10, BOUNCE = 2'b11} state, state_nxt;
logic [11:0] xpos_nxt;
logic [11:0] ypos_nxt;

logic [15:0] speed;
logic [15:0] speed_nxt;
logic [18:0] divide;
logic [18:0] divide_nxt;
logic [2:0] bounces;
logic [2:0] bounces_nxt;

always_ff @(posedge clk) begin
    if(rst) begin
        xpos  <= '0;
        ypos  <= '0;
        state <= IDLE;
        speed <= '0;
        divide  <= '0;
        bounces  <= '0;
    end
    else begin
        xpos  <= xpos_nxt;
        ypos  <= ypos_nxt;
        state <= state_nxt;
        speed <= speed_nxt;
        divide <=divide_nxt;
        bounces <=bounces_nxt;
    end
end

always_comb begin
    case (state)
        IDLE: begin
            xpos_nxt = mouse_xpos;
            ypos_nxt = mouse_ypos;
            speed_nxt = '0;
            divide_nxt = '0;
        end
        FALLING: begin
            xpos_nxt = xpos;
            if(divide >= 400000) begin
                ypos_nxt = ypos + (speed>>3);
                speed_nxt = speed + 1;
                divide_nxt = '0;
            end
            else begin
                ypos_nxt = ypos;
                speed_nxt = speed;
                divide_nxt = divide + 1;
            end
        end
        STAY: begin
            xpos_nxt = xpos;
            ypos_nxt = VER_PIXELS - RECT_HEIGHT;
            speed_nxt = '0;
            divide_nxt = '0;
        end
        BOUNCE: begin
            xpos_nxt = xpos;
            if(divide >= 400000) begin
                ypos_nxt = ypos - (speed>>3);
                speed_nxt = speed - 1;
                divide_nxt = '0;
            end
            else begin
                ypos_nxt = ypos;
                speed_nxt = speed;
                divide_nxt = divide + 1;
            end
        end
    endcase
end

always_comb begin
    case (state)
        IDLE: begin
            if(mouse_left == '1) begin
                state_nxt = FALLING;
            end
            else begin
                state_nxt = IDLE;
            end
            bounces_nxt = bounces;
        end
        FALLING: begin
            if(ypos >= VER_PIXELS - RECT_HEIGHT) begin
                if(bounces==4) begin
                    bounces_nxt = bounces;
                    state_nxt = STAY;
                end
                else begin
                    bounces_nxt = bounces + 1;
                    state_nxt = BOUNCE;
                end
            end
            else begin
                bounces_nxt = bounces;
                state_nxt = FALLING;
            end
        end
        STAY: begin
            if(rst) begin
                state_nxt = IDLE;
            end
            else begin
                state_nxt = STAY;
            end
            bounces_nxt = bounces;
        end
        BOUNCE: begin
            if(speed == '0) begin
                state_nxt = FALLING;
            end
            else begin
                state_nxt = BOUNCE;
            end
            bounces_nxt = bounces;
        end
    endcase
end

endmodule
 