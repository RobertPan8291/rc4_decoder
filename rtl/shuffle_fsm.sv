module shuffle_fsm(
	input clk,
	input reset, 
	input start,
	input stop,
	input [7:0] q,
	input [23:0] secret_key,
	output logic [7:0] data,
   output logic [7:0] address,
	output logic rden,
	output logic wren,
	output logic complete	
	);
	
	logic [7:0] temp_reg;
	logic [7:0] temp_reg_j;
	logic [8:0] counter_i = 9'd0;
	logic [7:0] counter_j = 8'd0;
	logic [7:0] secret_key_output;
	
	parameter [3:0] INITIALIZE = 4'b0000,
						 SHUFFLE = 4'b0010,
						 WAIT = 4'b0011,
						 RECORD = 4'b0100,
						 COMPUTE_J = 4'b0101,
						 READ_J = 4'b0110,
						 WAIT_J = 4'b0111,
						 WAIT_J_2 = 4'b1011,
						 WRITE_TO_J = 4'b1000,
						 WAIT_WRITE_J = 4'b1010,
						 WRITE_TO_I = 4'b1001,
						 WAIT_WRITE_I = 4'b1100,
						 INCREMENT = 4'b1110,
						 FINISH = 4'b1101,
						 STOP = 4'b1110;
						
   logic [3:0] state = INITIALIZE;
	
	logic [7:0] temp_addr;
	
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
			complete <= 1'b0;
			counter_i <= 9'd0;
			counter_j <= 8'd0;
		end else begin
			case(state) 
				INITIALIZE: begin
								wren <= 1'b0; 
								rden <= 1'b1;
								address <= 8'd0;
								data <= 8'd0;
								complete <= 1'b0;
								end
				SHUFFLE: begin
								wren <= 1'b0;
								rden <= 1'b1; 
								temp_addr <= address;
							end	
				RECORD: 	temp_reg <= q;
				COMPUTE_J: begin
								counter_j <= counter_j + temp_reg + secret_key_output;
							  end
				READ_J: begin
								address <= counter_j; //extract s[j] before we overwrite it
						  end
				WRITE_TO_J: begin
									temp_reg_j <= q; //storing s[j] in a temporary reg
									wren <= 1'b1;
									rden <= 1'd0;
									data <= temp_reg; //writing s[i] to s[j]
								end
				WRITE_TO_I: begin
									address <= counter_i;  //writing s[j] to s[i]
									data <= temp_reg_j;
								end
				INCREMENT: begin
									wren <= 1'b0;
									rden <= 1'd1;
									counter_i <= counter_i + 1; //increments i upon the end of one loop
									address <= address + 1;
							  end
				FINISH: begin
								complete = 1'b1; //sends complete signal, notifying decrypt fsm to begin its operations 
								wren <= 1'b0;
								rden <= 1'd0;
								address <= 8'd0;
								data <= 8'd0;
						  end
				STOP: begin
								wren <= 1'b0; 
								rden <= 1'b1;
								address <= 8'd0;
								data <= 8'd0;
								complete <= 1'b0;	
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
				SHUFFLE: begin
								if(counter_i == 9'd256) 
									state <= FINISH;
								else if(stop)
									state <= STOP;
								else
									state <= WAIT;
							end
				WAIT: state <= RECORD;
				RECORD: state <= COMPUTE_J;
				COMPUTE_J: state <= READ_J;
				READ_J: state <= WAIT_J;
				WAIT_J: state <= WAIT_J_2;
				WAIT_J_2: state <= WRITE_TO_J;
				WRITE_TO_J: state <= WAIT_WRITE_J;
				WAIT_WRITE_J: state <= WRITE_TO_I;
				WRITE_TO_I: state <= WAIT_WRITE_I;
				WAIT_WRITE_I: state <= INCREMENT;
				INCREMENT: state <= SHUFFLE;
				
			endcase 
		end
	end
	
	
endmodule