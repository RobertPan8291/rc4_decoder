module key_controller(	
	input clk,
	input reset,
	input failure,
	input success,
	output logic reset_all,
	output logic [23:0] secret_key
	); 
	
	parameter [4:0] START = 5'b00000, 
						 RESET = 5'b00001,
						 WAIT = 5'b00010,
						 SUCCESS = 5'b00011;
						 
	logic [4:0] state = START; 
	
	always_ff @(posedge clk) begin
		case(state) 
			START: begin
						secret_key <= 24'd0;
						reset_all <= 1'b0;
					 end
			RESET: begin
						secret_key <= secret_key + 1'b1;
						reset_all <= 1'b0;
					 end
			WAIT: begin
						reset_all <= 1'b1;
					end
		 endcase
			
	end

	always_ff @(posedge clk or negedge reset) begin
		if(~reset) begin
			state <= START;
		end else begin
			case(state) 
				START: state <= WAIT;
				RESET: state <= WAIT; 
				WAIT: begin
							if(failure)
								state <= RESET;
							else if(success)
								state <= SUCCESS;
							else 
								state <= WAIT;
						end
				SUCCESS: state <= SUCCESS;
			endcase
				
		end
	
	end
	
	
	
endmodule


						 
	