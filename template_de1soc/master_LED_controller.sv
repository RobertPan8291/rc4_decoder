module master_LED_controller(
	input [3:0] success_state,
	input failure,
	output logic [9:0] LEDR
	);
	
	always_comb begin
		casex({failure, success_state})
			5'b1xxxx: LEDR = 10'b1000000000;
			5'b00001: LEDR = 10'd1;
			5'b00010: LEDR = 10'd2;
			5'b00100: LEDR = 10'd4;
			5'b01000: LEDR = 10'd8;
			default: LEDR = 10'd0;
		endcase
		
	end

endmodule
