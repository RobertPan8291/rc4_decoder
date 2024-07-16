module core2(
	input clk,
	input reset_n,
	input stop,
	output logic total_failure,
	output logic success,
	output logic [23:0] secret_key
	); 
	
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
	
	logic initalize_complete;
	logic shuffle_complete;
	logic decrypt_complete;
	
	logic [4:0] ROM_address;
	logic ROM_rden;
	logic [7:0] ROM_output;
	
	logic [7:0] decrypt_message;
	logic Decode_wren;
	logic [4:0] Decode_adddress;
	
	logic [7:0] Decode_q;
	
	logic failure;
	logic reset_all;

	logic [9:0] LEDR;
		
	s_memory my_mem_2(
		.data(data),
		.wren(wren),
		.address(address),
		.q(q),
		.clock(clk),
		.rden(rden)
	); 
	
	key_controller_2 key_controller_2_inst(
		.clk(clk),
		.reset(reset_n),
		.failure(failure),
		.total_failure(total_failure),
		.success(success),
		.reset_all(reset_all),
		.secret_key(secret_key),
		.LEDR(LEDR)
		);
	
	Encode_ROM my_ROM_2(
		.address(ROM_address),
		.rden(ROM_rden),
		.clock(clk),
		.q(ROM_output)
		);

	Decoded_RAM Decoded_RAM_2_inst(
		.data(decrypt_message),
		.wren(Decode_wren),
		.address(Decode_adddress),
		.clock(clk),
		.q(Decode_q)
		);
	
	initialize_fsm initialize_fsm_2_inst(
		.clk(clk),
		.reset(reset_all),
		.data(data_1),
		.stop(stop),
		.address(address_1),
		.wren(wren_1),
		.rden(rden_1),
		.complete(initalize_complete)
		); 
		
	shuffle_fsm shuffle_fsm_2_inst(
		.clk(clk),
		.reset(reset_all),
		.start(initalize_complete),
		.q(q),
		.stop(stop),
		.secret_key(secret_key),
		.data(data_2),
		.address(address_2),
		.wren(wren_2),
		.rden(rden_2),
		.complete(shuffle_complete)
		);
		
	decrypt_fsm decrypt_fsm_2_inst(
		.clk(clk),
		.reset(reset_all),
		.start(shuffle_complete),
		.q(q),
		.stop(stop),
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
		.complete(decrypt_complete),
		.failure(failure),
		.success(success)
		);
		
		
		
		
	to_RAM_mux to_RAM_mux_2_inst(
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
		.state({7'b0, decrypt_complete, shuffle_complete, initalize_complete}),
		.data(data),
		.wren(wren),
		.address(address),
		.rden(rden)
	);
		
		
		
	
	
endmodule