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
	
	logic [7:0] data = 8'd0; 
	logic wren; //write enable;
	logic [7:0] address = 8'd0; 
	logic [7:0] q;
	logic rden; //read enable;
	
	logic finish_generation = 1'b0;

	parameter [3:0] INITIALIZE = 4'b0001,
						 SHUFFLE = 4'b0010;
						 
		
	logic [3:0] state = INITIALIZE;
	
	s_memory my_mem(
		.data(data),
		.wren(wren),
		.address(address),
		.q(q),
		.clock(clk),
		.rden(rden)
	); 
	

	always_ff @(posedge clk) begin
		if(state == INITIALIZE) begin
				wren <= 1'b1; 
				address <= address + 1;
				data <= data + 1;
				rden <= 1'b0;
		end 
		else if(state == SHUFFLE) begin
				wren <= 1'b0;
				address <= address + 1;				
				rden <= 1'b1;


		end
	end
	
	always_ff @(posedge clk) begin
		if(~reset_n) begin
			state <= INITIALIZE;
		end else begin
			case(state)
				INITIALIZE: begin
									if(address == 8'd254) begin
										state <= SHUFFLE;
									end
								end
			endcase
		end
	
	end
	
	
endmodule
