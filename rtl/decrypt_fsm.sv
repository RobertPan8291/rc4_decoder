module decrypt_fsm(
	input clk,
	input reset, 
	input start,
	input [7:0] q,
	input [7:0] ROM_output,
	input [23:0] secret_key,
	input stop,
	output logic [7:0] data,
	output logic [7:0] decrypt_message,
   output logic [4:0] ROM_address,
	output logic [4:0] Decode_adddress,
	output logic [7:0] address,
	output logic rden,
	output logic wren,
	output logic ROM_rden,
	output logic Decode_wren,
	output logic complete,
	output logic failure,
	output logic success
	); 
	
						  
	parameter [4:0]  INITIALIZE = 5'b00000,
						  INCREMENT = 5'b00001,
						  READ_SI = 5'b00010,
						  WAIT_FOR_SI = 5'b00011,
						  COMPUTE_J = 5'b00100,
						  READ_SJ = 5'b00101,
						  WAIT_J = 5'b00110,
						  WAIT_J_2 = 5'b00111,
						  WRITE_TO_J = 5'b01000,
						  WAIT_WRITE_J = 5'b01001,
						  WRITE_TO_I = 5'b01010,
						  WAIT_WRITE_I = 5'b01011,
						  COMPUTE_IJ = 5'b01100,
						  READ_F = 5'b01101,
						  WAIT_F = 5'b01110,
						  WAIT_F_2 = 5'b01111,
						  F_XOR = 5'b10000,
						  F_XOR_WAIT = 5'b10001,
						  CHECK = 5'b10010,
						  REFRESH = 5'b10011,
						  FINISH = 5'b10100,
						  FAILURE = 5'b10101,
						  STOP = 5'b10110;
						  
						  
						  
	logic [7:0] counter_k; 
	logic [7:0] counter_i;
	logic [7:0] counter_j;
	
	logic [7:0] temp_reg_i;
	logic [7:0] temp_reg_j;
	logic [7:0] temp_reg_f; 
	logic [7:0] temp_reg_msg;
	
	logic [7:0] temp_reg_i_and_j;

	logic [4:0] state = INITIALIZE; 
	
	
	always_ff @(posedge clk) begin
		if(~reset) begin
			wren <= 1'b0; 
			rden <= 1'b1;
			address <= 8'd0;
			data <= 8'd0;
			complete <= 1'b0;
			counter_i <= 8'd0;
			counter_j <= 8'd0;
			counter_k <= 8'd0;
			ROM_address <= 5'd0;
			ROM_rden <= 1'b0;
			Decode_wren <= 1'b0;
			Decode_adddress <= 5'd0;
			decrypt_message <= 8'd0;
		end else begin
			case(state)
				INITIALIZE: begin 
									wren <= 1'b0; 
									rden <= 1'b0;
									address <= 8'd0;
									data <= 8'd0;
									complete <= 1'b0;
									counter_i <= 8'd0;
									counter_j <= 8'd0;
									counter_k <= 8'd0;
									ROM_address <= 5'd0;
									ROM_rden <= 1'd0;
									Decode_wren <= 1'b0;
									Decode_adddress <= 5'd0;
									decrypt_message <= 8'd0;
									failure <= 1'b0;
									success <= 1'b0;
								end
				INCREMENT: begin
									counter_i <= counter_i + 1; //i = i+1
									wren <= 1'b0; 
									rden <= 1'b1;
									address <= address + 1;
									failure <= 1'b0;
									success <= 1'b0;

							  end
				COMPUTE_J: begin
									temp_reg_i <= q;
									counter_j <= counter_j + q; //j = j + s[i]
							  end
				READ_SJ: begin
									address <= counter_j;
							end
				WRITE_TO_J: begin
									wren <= 1'b1; //after storing j, writes s[i] to s[j]
									rden <= 1'b0;
									temp_reg_j <= q; 
									data <= temp_reg_i;
							 end
				WRITE_TO_I: begin
									address <= counter_i;  //writing s[j] to s[i]
									data <= temp_reg_j;
								end
				COMPUTE_IJ: begin
									wren <= 1'b0;
									rden <= 1'd1;
									ROM_rden <= 1'd1;
									temp_reg_i_and_j <= temp_reg_j + temp_reg_i; //calculating s[i] +s[j]
							  end
				READ_F: begin
									address <= temp_reg_i_and_j; //extracting f
									ROM_address <= counter_k; 
						  end
				F_XOR: begin
									Decode_adddress <= counter_k; 
									Decode_wren <= 1'b1;
									decrypt_message <= q ^ ROM_output;
									temp_reg_msg <= q ^ ROM_output;
						end
				REFRESH: begin
								address <= counter_i;
								Decode_wren <= 1'b0;
								ROM_rden <= 1'b0;
								counter_k <= counter_k + 1'b1;
								decrypt_message <= 8'd0;
							end
				FINISH: begin  //enters this state when this core has discovered the solution
							success <= 1'b1;
							wren <= 1'b0; 
							rden <= 1'b1;
							address <= 8'd0;
							data <= 8'd0;
							complete <= 1'b0;
							counter_i <= 8'd0;
							counter_j <= 8'd0;
							counter_k <= 8'd0;
							ROM_address <= 5'd0;
							ROM_rden <= 1'b0;
							Decode_wren <= 1'b0;
							Decode_adddress <= 5'd0;
							decrypt_message <= 8'd0;
						 end
				FAILURE: begin //enters this state when this core exhausted all possibility
								failure <= 1'b1;
								wren <= 1'b0; 
								rden <= 1'b1;
								address <= 8'd0;
								data <= 8'd0;
								complete <= 1'b0;
								counter_i <= 8'd0;
								counter_j <= 8'd0;
								counter_k <= 8'd0;
								ROM_address <= 5'd0;
								ROM_rden <= 1'b0;
								Decode_wren <= 1'b0;
								Decode_adddress <= 5'd0;
								decrypt_message <= 8'd0;
							end
					STOP: begin //enters this state when another core discovered the solution
									wren <= 1'b0; 
									rden <= 1'b0;
									address <= 8'd0;
									data <= 8'd0;
									complete <= 1'b0;
									counter_i <= 8'd0;
									counter_j <= 8'd0;
									counter_k <= 8'd0;
									ROM_address <= 5'd0;
									ROM_rden <= 1'd0;
									Decode_wren <= 1'b0;
									Decode_adddress <= 5'd0;
									decrypt_message <= 8'd0;
									failure <= 1'b0;
									success <= 1'b0;
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
										state <= INCREMENT;
									else
										state <= INITIALIZE;
								end
				INCREMENT: 	begin
									if(counter_k == 8'd32)
										state <= FINISH;
									else if (stop)
										state <= STOP;
									else
										state <= READ_SI;
								end					
				READ_SI: state <= WAIT_FOR_SI; 
				WAIT_FOR_SI: state <= COMPUTE_J;
				COMPUTE_J: state <= READ_SJ;
				READ_SJ: state <= WAIT_J;
				WAIT_J: state <= WAIT_J_2;
				WAIT_J_2: state <= WRITE_TO_J;
				WRITE_TO_J: state <= WAIT_WRITE_J;
				WAIT_WRITE_J: state <= WRITE_TO_I;
				WRITE_TO_I: state <= WAIT_WRITE_I;
				WAIT_WRITE_I: state <= COMPUTE_IJ;
				COMPUTE_IJ: state <= READ_F;
				READ_F: state <= WAIT_F;
				WAIT_F: state <= WAIT_F_2;
				WAIT_F_2: state <= F_XOR;
				F_XOR: state <= F_XOR_WAIT;
				F_XOR_WAIT: state <= CHECK;
				CHECK: begin
							if((temp_reg_msg > 8'd122 || temp_reg_msg < 8'd97) && temp_reg_msg != 8'd32)
									state <= FAILURE;
							else 
									state <= REFRESH;
							
						 end
				REFRESH: state <= INCREMENT;
				FINISH: state <= FINISH;
				FAILURE: state <= INITIALIZE;
			endcase
		
		
		end
	end
	

endmodule

