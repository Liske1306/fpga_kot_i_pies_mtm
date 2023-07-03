module set_ypos(
    input  logic clk60MHz,
    input  logic rst,
    input  logic in_throw_flag,
    input  logic throw_flag,
    input  logic end_throw,
    output logic [11:0] ypos_prebuff
);

logic [11:0] ypos_prebuff_nxt;
logic [5:0] speed, speed_nxt;
logic [16:0] counter, counter_nxt;

enum logic [2:0]{
    WAIT = 2'b00,
    UP = 2'b01,
    DOWN = 2'b10
} state, state_nxt;

always_ff @(posedge clk60MHz) begin
    if(rst) begin
        ypos_prebuff <= 769;
        speed        <= 20;
        counter      <= '0;
        state        <= WAIT;
    end
    else begin
        ypos_prebuff <= ypos_prebuff_nxt;
        speed        <= speed_nxt;
        counter      <= counter_nxt;
        state        <= state_nxt;
    end
end

always_comb begin
    case(state)
        WAIT: begin
            if((in_throw_flag == 1) || (throw_flag == 1))begin
                state_nxt = UP;
            end
            else begin
                state_nxt = WAIT;
            end
            speed_nxt = 20;
            counter_nxt = '0;
            ypos_prebuff_nxt = 768;
        end
        UP: begin
            if(counter >= 100000)begin
                ypos_prebuff_nxt = ypos_prebuff - speed;
                speed_nxt = speed - 1;
                counter_nxt = '0;
            end
            else begin
                ypos_prebuff_nxt = ypos_prebuff;
                speed_nxt = speed;
                counter_nxt = counter + 1;
            end

            if(speed <= 1) begin
                state_nxt = DOWN;
            end
            else begin
                state_nxt = UP;
            end
        end
        DOWN: begin
            if(counter >= 100000)begin
                ypos_prebuff_nxt = ypos_prebuff + speed;
                speed_nxt = speed + 1;
                counter_nxt = '0;
            end
            else begin
                ypos_prebuff_nxt = ypos_prebuff;
                speed_nxt = speed;
                counter_nxt = counter + 1;
            end

            if(end_throw == 1) begin
                state_nxt = WAIT;
            end
            else begin
                state_nxt = DOWN;
            end
        end
        default: begin
            speed_nxt = 20;
            counter_nxt = '0;
            ypos_prebuff_nxt = 768;
            state_nxt = WAIT;
        end
    endcase
end

endmodule