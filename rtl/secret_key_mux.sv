module secret_key_mux(
	input [23:0] secret_key, 
	input [1:0] sel,
	output logic [7:0] key
	);
	
	always_comb begin
		case(sel) 
			2'b00: key <= secret_key[23:16];
			2'b01: key <= secret_key[15:8];
			2'b10: key <= secret_key[7:0];
			default: key <= secret_key[7:0];
		endcase

	end
	
endmodule
