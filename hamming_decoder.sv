module hamming_decoder (
    input  logic [6:0]  codeword_in,
    output logic [3:0]  data_out,
    output logic        error_detected,
    output logic        error_corrected,
    output logic [2:0]  syndrome_out
);

logic [6:0]  corrected;
logic [2:0]  S;


always_comb begin
   corrected = codeword_in;
   S[0]=codeword_in[0]^codeword_in[2]^codeword_in[4]^codeword_in[6];
   S[1]=codeword_in[1]^codeword_in[2]^codeword_in[5]^codeword_in[6];
   S[2]=codeword_in[3]^codeword_in[4]^codeword_in[5]^codeword_in[6];

 if(!S) begin
   error_detected=0;
   error_corrected=0;
   data_out={codeword_in[6],codeword_in[5],codeword_in[4],codeword_in[2]};
 end else begin
   error_detected=1;
   corrected[S-1] = ~corrected[S-1];
   error_corrected=1;
   data_out={corrected[6],corrected[5],corrected[4],corrected[2]};
  end
syndrome_out =S;
end 

endmodule
