module master_LED_controller(
	input [3:0] success_state,
	input failure,
	output logic [9:0] LEDR
	);
	
	always_comb begin
		casex({failure, success_state})
			1xxxx: LEDR = 10'b1000000000;
			00001: LEDR = 10'd1;
			00010: LEDR = 10'd2;
			00100: LEDR = 10'd4;
			01000: LEDR = 10'd8;
			default: LEDR = 10'd0;
		endcase
		
	end

endmodule
