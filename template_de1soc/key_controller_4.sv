module key_controller_4(	
	input clk,
	input reset,
	input failure,
	input success,
	output logic total_failure,
	output logic reset_all,
	output logic [23:0] secret_key,
	output logic [9:0] LEDR
	); 
	
	parameter [4:0] START = 5'b00000, 
						 RESET = 5'b00001,
						 WAIT = 5'b00010,
						 SUCCESS = 5'b00011,
						 FAILURE = 5'b00100;
						 
	logic [4:0] state = START; 
	
	always_ff @(posedge clk) begin
		case(state) 
			START: begin
						secret_key <= 24'd0;
						reset_all <= 1'b0;
						LEDR <= 10'd0;
						total_failure <= 1'b0;
					 end
			RESET: begin
						secret_key <= secret_key + 1'b1;
						reset_all <= 1'b0;
						LEDR <= 10'd0;
						total_failure <= 1'b0;

					 end
			WAIT: begin
						reset_all <= 1'b1;
						LEDR <= 10'd0;
					end
			SUCCESS: begin
						LEDR <= 10'd3;
						end
			FAILURE: begin
						LEDR <= 10'd4;
						total_failure <= 1'b1;
						end
		 endcase
			
	end

	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			state <= START;
		end else begin
			case(state) 
				START: state <= WAIT;
				RESET: begin 
							if(secret_key == 24'b0100_0000_0000_0000_0000_0000)
								state <= FAILURE;
							else if ((secret_key % 3'd4) == 3'd3)
								state <= WAIT;
							else 
								state <= RESET; 
						 end
				WAIT: begin
							if(failure)
								state <= RESET;
							else if(success)
								state <= SUCCESS;
							else 
								state <= WAIT;
						end
				SUCCESS: state <= SUCCESS;
				FAILURE: state <= FAILURE;
			endcase
				
		end
	
	end
	
	
	
endmodule


					