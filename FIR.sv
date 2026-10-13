module fir_filter #(
    parameter DATA_WIDTH  = 16,
    parameter COEFF_WIDTH = 16,
    parameter NUM_TAPS    = 8
) (
    input  logic                                     clk,
    input  logic                                     rst_n,
    input  logic signed [DATA_WIDTH-1:0]             x_in,
    input  logic                                    x_valid,
    input  logic signed [COEFF_WIDTH-1:0]            coeffs [0:NUM_TAPS-1],
    output logic signed [DATA_WIDTH+COEFF_WIDTH+3:0] y_out,
    output logic                     y_valid
);
  logic signed[DATA_WIDTH-1:0] sf[0:NUM_TAPS-1];
  logic signed [DATA_WIDTH + COEFF_WIDTH + 3 : 0] acc;


 
 always_ff@(posedge clk) begin
  if(!rst_n)begin
    for (int i = 0; i < NUM_TAPS; i++) begin
    sf[i] <= '0;
end
    y_valid<='0;
    y_out<='0;

  end else if(x_valid) begin
     y_out<= acc;
     y_valid<=1;
     sf[0]<= x_in;
     for(int i=NUM_TAPS-1;i>0;i--) begin
       sf[i]<=sf[i-1];
     end
  end else y_valid <=0;
  end
  always_comb begin
    acc = '0;

    acc = acc + x_in * coeffs[0];

    for (int i = 1; i < NUM_TAPS; i++) begin
        acc = acc + sf[i-1] * coeffs[i];
    end
end

endmodule