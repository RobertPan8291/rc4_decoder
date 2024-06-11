module decrypt_fsm(
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
	
	/*parameter [24:0] INITIALIZE = 25'b0_0000_0000_0000_0000_0000_0000,
						  INCREMENT = 25'd0_0000_0000_0000_0001_0000_0010,
						  READ_SI = 25'd0_0000_0000_0000_0000_0000_0110,
						  WAIT_FOR_SI = 25'd0_0000_0000_0000_0000_0000_0110,
						  COMPUTE_J = 25'd16,
						  READ_SJ = 25'd32,
						  WAIT_FOR_SJ = 25'd64, 
						  WRITE_SJ = 25'd128,
						  WRITE_SI = 25'd256;*/
						  
						  
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
						  COMPUTE_IJ = 5'b01100;
							 
	logic [7:0] counter_k; 
	logic [7:0] counter_i;
	logic [7:0] counter_j;
	
	logic [7:0] temp_reg_i;
	logic [7:0] temp_reg_j;
	logic [7:0] temp_reg_f; 
	
	logic [7:0] temp_reg_i_and_j;

	logic [24:0] state = INITIALIZE; 
	
	
	always_ff @(posedge clk) begin
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
									rden <= 1'b0;
									address <= 8'd0;
									data <= 8'd0;
									not_complete <= 1'b0;
									counter_i <= 8'd0;
									counter_j <= 8'd0;
								end
				INCREMENT: begin
									counter_i <= counter_i + 1;
									wren <= 1'b0; 
									rden <= 1'b1;
									address <= address + 1;
							  end
				COMPUTE_J: begin
									temp_reg_i <= q;
									counter_j <= counter_j + q; 
							  end
				READ_SJ: begin
									address <= counter_j;
							end
				WRITE_TO_J: begin
									wren <= 1'b1;
									rden <= 1'b0;
									temp_reg_j <= q; 
									data <= temp_reg_i;
							 end
				WRITE_TO_I: begin
									address <= counter_i;  
									data <= temp_reg_j;
								end
				COMPUTE_IJ: begin
									wren <= 1'b0;
									rden <= 1'd1;
									temp_reg_i_and_j <= temp_reg_j + temp_reg_i;
							  end
				READ_F: begin
				
					
						  end
				
			endcase
		end
	
	end
	
	/*assign rden = state[1];
	assign wren = state[0];
	assign not_complete = state[24];
	
	assign counter_i = state[8] ? counter_i + 1'b1 : counter_i;
	
	always_comb begin
		if(state[2]) begin
			address = counter_i;
		end 
		else if(state[3]) begin
			address = counter_j;
		end 
		else begin 
			address = 0;
		end 
		
		if(state[0]) begin //Initialize state
			rden = 1'b0; 
			wren = 1'b0; 
			not_complete = 1'b0;
			data = 8'd0;
			address = 8'd0;
			counter_i = 8'd0;
			counter_j = 8'd0; 
		end 
		else if(state[1]) begin
			rden = 1'b1;
			wren = 1'b0; 
			not_complete = 1'b0;


		
		end
		
		
		else begin
			rden = 1'b0; 
			wren = 1'b0; 
			not_complete = 1'b0;
			data = 8'd0;
			address = 8'd0;
		end
	
	end*/
	
		
	
	
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
				INCREMENT: state <= READ_SI;
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
				COMPUTE_IJ: state <= INCREMENT;
			endcase
		
		
		end
	end
	

endmodule

