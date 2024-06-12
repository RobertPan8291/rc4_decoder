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
	
	logic [7:0] data; 
	logic wren; //write enable;
	logic [7:0] address; 
	logic [7:0] q;
	logic rden; //read enable;
	
		
	logic [7:0] data_1; 
	logic wren_1; //write enable;
	logic [7:0] address_1; 
	logic rden_1; //read enable;
	
	logic [7:0] data_2; 
	logic wren_2; //write enable;
	logic [7:0] address_2; 
	logic rden_2; //read enable;
	
	logic [7:0] data_3; 
	logic wren_3; //write enable;
	logic [7:0] address_3; 
	logic rden_3; //read enable;
	
	logic initalize_not_complete;
	logic shuffle_not_complete;
	logic decrypt_not_complete;
	
	logic [4:0] ROM_address;
	logic ROM_rden;
	logic [7:0] ROM_output;
	
	logic [7:0] decrypt_message;
	logic Decode_wren;
	logic [4:0] Decode_adddress;
	
	logic [7:0] Decode_q;
	
	logic [23:0] secret_key;
	logic failure;
	logic success;
	logic reset_all;
	
	logic stop;

	
	s_memory my_mem(
		.data(data),
		.wren(wren),
		.address(address),
		.q(q),
		.clock(clk),
		.rden(rden)
	); 
	
	key_controller key_controller_inst(
		.clk(clk),
		.reset(reset_n),
		.failure(failure),
		.success(success),
		.reset_all(reset_all),
		.secret_key(secret_key),
		.LEDR(LEDR)
		);
	
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

	
	Encode_ROM my_ROM(
		.address(ROM_address),
		.rden(ROM_rden),
		.clock(clk),
		.q(ROM_output)
		);

	Decoded_RAM Decoded_RAM_inst(
		.data(decrypt_message),
		.wren(Decode_wren),
		.address(Decode_adddress),
		.clock(clk),
		.q(Decode_q)
		);
	
	initialize_fsm initialize_fsm_inst(
		.clk(clk),
		.reset(reset_all),
		.stop(stop),
		.data(data_1),
		.address(address_1),
		.wren(wren_1),
		.rden(rden_1),
		.not_complete(initalize_not_complete)
		); 
		
	shuffle_fsm shuffle_fsm_inst(
		.clk(clk),
		.reset(reset_all),
		.start(initalize_not_complete),
		.stop(stop),
		.q(q),
		.secret_key(secret_key),
		.data(data_2),
		.address(address_2),
		.wren(wren_2),
		.rden(rden_2),
		.not_complete(shuffle_not_complete)
		);
		
	decrypt_fsm decrypt_fsm_inst(
		.clk(clk),
		.reset(reset_all),
		.start(shuffle_not_complete),
		.stop(stop),
		.q(q),
		.ROM_output(ROM_output),
		.secret_key(secret_key),
		.data(data_3),
		.decrypt_message(decrypt_message),
		.ROM_address(ROM_address),
		.Decode_adddress(Decode_adddress),
		.address(address_3),
		.wren(wren_3),
		.Decode_wren(Decode_wren),
		.rden(rden_3),
		.ROM_rden(ROM_rden),
		.not_complete(decrypt_not_complete),
		.failure(failure),
		.success(success)
		);
		
		
		
		
	to_RAM_mux to_RAM_mux_inst(
		.data_1(data_1),
		.address_1(address_1),
		.wren_1(wren_1),
		.rden_1(rden_1),
		.data_2(data_2),
		.address_2(address_2),
		.wren_2(wren_2),
		.rden_2(rden_2),
		.data_3(data_3),
		.address_3(address_3),
		.wren_3(wren_3),
		.rden_3(rden_3),
		.state({7'b0, decrypt_not_complete, shuffle_not_complete, initalize_not_complete}),
		.data(data),
		.wren(wren),
		.address(address),
		.rden(rden)
	);
		
		
		
	
	
endmodule
