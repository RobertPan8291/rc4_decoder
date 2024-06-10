module shuffle_fsm(
	input clk,
	input reset, 
	input start,
	input [7:0] q,
	input [23:0] secret_key,
	output logic [7:0] data,
   output logic [7:0] address,
	output logic rden,
	output logic wren,
	output logic not_complete	
	);
	
	logic [7:0] temp_reg;
	logic [7:0] counter_i = 8'd0;
	logic [7:0] counter_j = 8'd0;
	logic [7:0] secret_key_output;
	
	parameter [3:0] INITIALIZE = 4'b0000,
						 SHUFFLE = 4'b0010,
						 WAIT = 4'b0011,
						 RECORD = 4'b0100,
						 COMPUTE_J = 4'b0101;
						
   logic [3:0] state = INITIALIZE;
	
	secret_key_mux secret_key_mux_inst(
		.secret_key(secret_key),
		.sel(counter_i % 2'd3),
		.key(secret_key_output)
		);

	
	always_ff@(posedge clk or negedge reset) begin
		if(~reset) begin
			wren <= 1'b0; 
			rden <= 1'b1;
			address <= 8'd0;
			data <= 8'd0;
			not_complete <= 1'b0;
			counter_i <= 8'd0;
			counter_j <= 8'd0;
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
							end	
				RECORD: 	temp_reg <= q;
				COMPUTE_J: begin
								counter_i <= counter_i + 1;
								counter_j <= counter_j + temp_reg + secret_key_output;
							  end
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
				RECORD: state <= COMPUTE_J;
				COMPUTE_J: state <= SHUFFLE; 
			endcase 
		end
	end
	
	
endmodule
