module initialize_fsm(
	input clk,
	input reset, 
	input stop,
	output logic [7:0] data,
   output logic [7:0] address,
	output logic rden,
	output logic wren,
	output logic complete
	);
	
	always_ff@(posedge clk or negedge reset) begin
		if(~reset) begin 
			wren <= 1'b1; 
			rden <= 1'b0;
			address <= 8'd0;
			data <= 8'd0;
			complete <= 1'b0;
		end else begin
			if(address < 8'd255 && ~stop && ~complete) begin //Increments address and data every clk cycle to populate s[]
				wren <= 1'b1; 
				address <= address + 1;
				data <= data + 1;
				rden <= 1'b0;
			end 
			else if (stop) begin
				complete <= 1'b0;
				wren <= 1'b0; 
				rden <= 1'b0;
				address <= 8'd0;
				data <= 8'd0;
			end
			else begin
				complete <= 1'b1; //when finished, sends the complete signal to the next fsm, indicating that it should begin
				wren <= 1'b0; 
				rden <= 1'b0;
				address <= 8'd0;
				data <= 8'd0;
			end
		end
	end
	
endmodule
