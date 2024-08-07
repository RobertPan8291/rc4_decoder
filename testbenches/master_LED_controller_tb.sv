module master_LED_controller_tb();
	reg [3:0] success_state; 
	reg failure;
	wire [9:0] LEDR;
	
	master_LED_controller DUT(
		.success_state(success_state),
		.failure(failure),
		.LEDR(LEDR)
	); 
	
	initial begin
		success_state = 4'd0;
		failure = 1'b0;
		#20;
		success_state = 4'd1;
		#20;
		success_state = 4'd2;
		#20;
		success_state = 4'd4;
		#20;
		success_state = 4'd8;
		#20;
		failure = 1'b1;
		#20;
	end
	
endmodule
