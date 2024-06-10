module shuffle_fsm(
	input clk,
	input reset, 
	input start,
	input [7:0] q,
	output logic [7:0] data,
   output logic [7:0] address,
	output logic rden,
	output logic wren,
	output logic not_complete	
	);
	
	logic [7:0] temp_reg;

	
	parameter [3:0] INITIALIZE = 4'b0000,
						 SHUFFLE = 4'b0010,
						 WAIT = 4'b0011,
						 RECORD = 4'b0100,
						 COMPUTE_J = 4'b0101;
						
   logic [3:0] state = INITIALIZE;

	
	always_ff@(posedge clk or negedge reset) begin
		if(~reset) begin
			wren <= 1'b0; 
			rden <= 1'b1;
			address <= 8'd0;
			data <= 8'd0;
			not_complete <= 1'b0;
		end else begin
			case(state) 
				INITIALIZE: begin
								wren <= 1'b0; 
								rden <= 1'b1;
								address <= 8'd0;
								data <= 8'd0;
								not_complete <= 1'b0;
								end
				SHUFFLE: begin
								wren <= 1'b0;
								rden <= 1'b1; 
								address <= address + 1;
								//counter_i <= counter_i + 1;
							end	
				RECORD: 	temp_reg <= q;
			endcase
		end
		
	
	end
	
	
	always_ff@(posedge clk or negedge reset) begin
		if(~reset) begin
			state <= INITIALIZE;
		end else begin
			case(state)
				INITIALIZE: begin
									if(start)
										state <= SHUFFLE;
									else
										state <= INITIALIZE;
								end
				SHUFFLE: state <= WAIT;
				WAIT: state <= RECORD;
				RECORD: state <= SHUFFLE;
			endcase 
		end
	end
	
	
endmodule
