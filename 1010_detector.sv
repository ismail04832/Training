module seq_detector (
    input  logic clk,
    input  logic resetn,
    input  logic din,
    output logic dout
);
  typedef enum logic[1:0]{
    S0,S1,S10,S101
    
  } state_t;

  state_t curr_state, next_state;

  always_ff @(posedge clk) begin
    if(!resetn)
     curr_state<=S0;
    else curr_state<= next_state;
  end

  always_comb begin
     dout=0;
     next_state = curr_state;
     case(curr_state)
       S0:if (din==1) next_state=S1;else next_state = S0;
       S1:if (din==0) next_state= S10 ;else next_state =S1;
       S10:   next_state = din ? S101 : S0;
       S101:if(din==0)begin next_state =S10 ;dout=1 ;end else next_state =S1;
       endcase
  end
endmodule