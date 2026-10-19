
module PISO #(
    parameter WIDTH = 4
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic             load,
    input  logic             shift,
    input  logic [WIDTH-1:0] data_in,
    output logic             data_out
);

    logic [WIDTH-1:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= '0;
        else if (load)
            shift_reg <= data_in;
        else if (shift)
            shift_reg <= {1'b0, shift_reg[WIDTH-1:1]};
    end

    assign data_out = shift_reg[0];

endmodule
