interface pmod_if();
  
    logic       player1_ready;
    logic       player2_ready;
    logic [4:0] power;
    logic       throw_flag;
  
    modport in(
        input player1_ready,
        input player2_ready,
        input power,
        input throw_flag
    );
    
    modport out(
        output player1_ready,
        output player2_ready,
        output power,
        output throw_flag
    );
    
endinterface