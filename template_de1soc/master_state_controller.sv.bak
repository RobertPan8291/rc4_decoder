module master_state_controller(
	input clk,
	input reset,
	input success,
	output logic stop
	);
	
	parameter [3:0] IDLE = 4'b0000;
						 STOP = 4'b0001;
					
					
	logic [3:0] state = IDLE;
						
						
	always_ff@(posedge clk) begin
			if(state == STOP)
				stop <= 1'b1;
			else
				stop <= 1'b0;
	
	end
		
	always_ff@(posedge clk or negedge reset) begin
		if(~reset) begin
			state <= IDLE;
		end else begin
			case(state) 
				IDLE: begin
							if(success)
								state <= STOP;
							else 
								state <= IDLE;
						end
				STOP: state <= STOP; 
			endcase
		end
		
	
	end
	
endmodule
