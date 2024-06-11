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
	
	logic [23:0] secret_key;
	
	assign secret_key = {14'd0, SW};
	
	logic [7:0] counter_i = 8'd0;
	
	logic [7:0] counter_j = 8'd0;
	
	
	s_memory my_mem(
		.data(data),
		.wren(wren),
		.address(address),
		.q(q),
		.clock(clk),
		.rden(rden)
	); 
	

	initialize_fsm initialize_fsm_inst(
		.clk(clk),
		.reset(reset_n),
		.data(data_1),
		.address(address_1),
		.wren(wren_1),
		.rden(rden_1),
		.not_complete(initalize_not_complete)
		); 
		
	shuffle_fsm shuffle_fsm_inst(
		.clk(clk),
		.reset(reset_n),
		.start(initalize_not_complete),
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
		.reset(reset_n),
		.start(shuffle_not_complete),
		.q(q),
		.secret_key(secret_key),
		.data(data_3),
		.address(address_3),
		.wren(wren_3),
		.rden(rden_3),
		.not_complete(decrypt_not_complete)
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
