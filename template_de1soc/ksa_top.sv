module ksa_top(
	input CLOCK_50,
	input [3:0] KEY, 
	input [9:0] SW,
	output logic [9:0] LEDR, 
	output logic [6:0] HEX0,
	output logic [6:0] HEX1,
	output logic [6:0] HEX2,
	output logic [6:0] HEX3,
	output logic [6:0] HEX4,
	output logic [6:0] HEX5
	);
	
	
	logic clk; 
	logic reset_n;
	
	assign clk = CLOCK_50;
	assign reset_n = KEY[3];
	
	logic stop;
	
	logic total_failure_1;
	logic success_1;
	logic [23:0] secret_key_1;
	
	logic total_failure_2;
	logic success_2;
	logic [23:0] secret_key_2;
	
	logic total_failure_3;
	logic success_3;
	logic [23:0] secret_key_3;
	
	logic total_failure_4;
	logic success_4;
	logic [23:0] secret_key_4;
	
	logic [23:0] secret_key;
	
	logic success; 
	
	assign success = success_1 || success_2 || success_3 || success_4;
	
	logic failure; 
	
	assign failure = total_failure_1 && total_failure_2 && total_failure_3 && total_failure_4;

	
	SevenSegmentDisplayDecoder display1(
		.nIn(secret_key[3:0]),
		.ssOut(HEX0)
	);
	
	SevenSegmentDisplayDecoder display2(
		.nIn(secret_key[7:4]),
		.ssOut(HEX1)
	);

	SevenSegmentDisplayDecoder display3(
		.nIn(secret_key[11:8]),
		.ssOut(HEX2)
	);

	SevenSegmentDisplayDecoder display4(
		.nIn(secret_key[15:12]),
		.ssOut(HEX3)
	);

	SevenSegmentDisplayDecoder display5(
		.nIn(secret_key[19:16]),
		.ssOut(HEX4)
	);

	SevenSegmentDisplayDecoder display6(
		.nIn(secret_key[23:20]),
		.ssOut(HEX5)
	);

	
	core1 core1_inst(
		.clk(clk),
		.reset_n(reset_n),
		.stop(stop),
		.total_failure(total_failure_1),
		.success(success_1),
		.secret_key(secret_key_1)
	);
	
	core2 core2_inst(
		.clk(clk),
		.reset_n(reset_n),
		.stop(stop),
		.total_failure(total_failure_2),
		.success(success_2),
		.secret_key(secret_key_2)
	);
	
	core3 core3_inst(
		.clk(clk),
		.reset_n(reset_n),
		.stop(stop),
		.total_failure(total_failure_3),
		.success(success_3),
		.secret_key(secret_key_3)
	);
	
	core4 core4_inst(
		.clk(clk),
		.reset_n(reset_n),
		.stop(stop),
		.total_failure(total_failure_4),
		.success(success_4),
		.secret_key(secret_key_4)
	);
	
	master_hex_controller master_hex_controller_inst(
		.success_state({success_4, success_3, success_2, success_1}),
		.secret_key_1(secret_key_1),
		.secret_key_2(secret_key_2),
		.secret_key_3(secret_key_3),
		.secret_key_4(secret_key_4),
		.secret_key(secret_key)
	);
		
	master_state_controller master_state_controller_inst(
		.clk(clk),
		.reset(reset_n),
		.success(success),
		.stop(stop)
	);
	
	master_LED_controller master_LED_controller_inst(
		.success_state({success_4, success_3, success_2, success_1}),
		.failure(failure),
		.LEDR(LEDR)
	);

		
	
	
endmodule
