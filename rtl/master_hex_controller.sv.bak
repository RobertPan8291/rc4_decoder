module master_hex_controller(
	input [3:0] success_state,
	input [23:0] secret_key_1,
	input [23:0] secret_key_2,
	input [23:0] secret_key_3,
	input [23:0] secret_key_4,
	output logic [23:0] secret_key
	);
	
	always_comb begin
		case(success_state) 
			0001: secret_key = secret_key_1;
			0010: secret_key = secret_key_2;
			0100: secret_key = secret_key_3;
			1000: secret_key = secret_key_4;
			default: secret_key = secret_key_1;
		endcase
	end

endmodule 
	