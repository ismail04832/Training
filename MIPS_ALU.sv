module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [5:0]  aluc,
    output logic [31:0] r,
    output logic        zero,
    output logic        carry,
    output logic        negative,
    output logic        overflow,
    output logic        flag
);
    logic [32:0] sum, diff;

    
    assign sum  = {1'b0, a} + {1'b0, b};
    assign diff = {1'b0, a} - {1'b0, b};

    always_comb begin
        case (aluc)
            
            6'b100000 : r = sum[31:0];                        // ADD
            6'b100001 : r = sum[31:0];                        // ADDU
            6'b100010 : r = diff[31:0];                       // SUB
            6'b100011 : r = diff[31:0];                       // SUBU

            
            6'b100100 : r = a & b;                             // AND
            6'b100101 : r = a | b;                             // OR
            6'b100110 : r = a ^ b;                             // XOR
            6'b100111 : r = ~(a | b);                          // NOR

            // Comparaisons
            6'b101010 : r = {31'b0, ($signed(a) < $signed(b))}; // SLT  (Signed)
            6'b101011 : r = {31'b0, (a < b)};                 // SLTU 

           
            6'b000000 : r = b << a[4:0];                      // SLL
            6'b000010 : r = b >> a[4:0];                      // SRL
            6'b000011 : r = $signed(b) >>> a[4:0];             // SRA 
            
            6'b000100 : r = b << a[4:0];                      // SLLV
            6'b000110 : r = b >> a[4:0];                      // SRLV
            6'b000111 : r = $signed(b) >>> a[4:0];             // SRAV

        
            6'b001111 : r = {a[15:0], 16'h0000};               // LUI

            default   : r = 32'b0;
        endcase
    end

    
    assign zero     = (r == 32'b0);
    assign negative = r[31];

    assign carry    = ((aluc == 6'b100000) || (aluc == 6'b100001)) ? sum[32] :
                      ((aluc == 6'b100010) || (aluc == 6'b100011)) ? diff[32] : 1'b0;

    assign overflow = (aluc == 6'b100000) ? ((a[31] == b[31]) && (r[31] != a[31])) :
                      (aluc == 6'b100010) ? ((a[31] != b[31]) && (r[31] != a[31])) : 1'b0;

    assign flag     = (aluc == 6'b101010) ? ($signed(a) < $signed(b)) :
                      (aluc == 6'b101011) ? (a < b) : 1'b0;

endmodule