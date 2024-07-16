module master_hex_controller_tb();
	reg [3:0] success_state;
	reg [23:0] secret_key_1;
	reg [23:0] secret_key_2;
	reg [23:0] secret_key_3;
	reg [23:0] secret_key_4;
	wire [23:0] secret_key;

	master_hex_controller DUT(	
		.success_state(success_state),
		.secret_key_1(secret_key_1),
		.secret_key_2(secret_key_2),
		.secret_key_3(secret_key_3),
		.secret_key_4(secret_key_4),
		.secret_key(secret_key)
	);
	
	initial begin
		secret_key_1 = 24'd6;
		secret_key_2 = 24'd19;
		secret_key_3 = 24'd8;
		secret_key_4 = 24'd15;
		success_state = 4'b0000;
		#20;
		success_state = 4'b0001;
		#20;
		success_state = 4'b0010;
		#20;
		success_state = 4'b0100;
		#20;
		success_state = 4'b1000;
		#20;
	end
	
	
endmodule
