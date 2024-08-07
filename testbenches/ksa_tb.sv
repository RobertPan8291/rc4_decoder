`timescale 1ps/1ps

module ksa_top_tb();	
	reg CLOCK_50;
   reg [3:0] KEY; 
	reg [9:0] SW;
	wire [9:0] LEDR; 
	wire [6:0] HEX0;
	wire [6:0] HEX1;
	wire [6:0] HEX2;
	wire [6:0] HEX3;
	wire [6:0] HEX4;
	wire [6:0] HEX5;
	
	ksa_top DUT(
		.CLOCK_50(CLOCK_50),
		.KEY(KEY),
		.SW(SW),
		.LEDR(LEDR),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
	);
	
	always #5 CLOCK_50 = ~CLOCK_50;
	
	initial begin
		SW = 10'b1001001001;
		CLOCK_50 = 1'b0;
		KEY[3] = 1'b0;
		#10;
		KEY[3] = 1'b1;
	
	end
	
endmodule
