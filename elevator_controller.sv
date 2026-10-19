module elevator_cont (
    input logic clk,
    input logic reset,
    input logic up_request,
    input logic down_request,
    output logic [1:0] state
);
 typedef enum logic [1:0] {
        IDLE        = 2'b00,
        MOVING_UP   = 2'b01,
        MOVING_DOWN = 2'b10
    } state_t;
state_t current_state, next_state;
 assign state = current_state;

always_ff@(posedge clk) begin
  if (reset) begin current_state <= IDLE; end
  else begin current_state<= next_state ;end

end

always_comb begin 
  next_state= current_state;
  case(current_state)
  IDLE: begin
    if (up_request) begin
      next_state=MOVING_UP;
    end
    else if (down_request) begin
      next_state=MOVING_DOWN; end
  end
  MOVING_UP: begin
    if(!(up_request))begin
    if(down_request)begin
      next_state=MOVING_DOWN;end
      else begin next_state= IDLE;end
    end
  end

  MOVING_DOWN: begin
                
                if (!down_request) begin
                    if (up_request) begin
                        next_state = MOVING_UP;
                    end else begin
                        next_state = IDLE;
                    end
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
    
