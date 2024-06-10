module to_RAM_mux(
	input [7:0] data_1,
   input [7:0] address_1,
	input rden_1,
	input wren_1,
	input [7:0] data_2,
   input [7:0] address_2,
	input rden_2,
	input wren_2,
	input [9:0] state,
	output logic [7:0] data,
   output logic [7:0] address,
	output logic rden,
	output logic wren
	);
	
	always_comb begin
		case(state) 
			00000000000: begin	
							data <= data_1;
							address <= address_1;
							rden <= rden_1;
							wren <= wren_1;
					 end
			0000000001: begin
							data <= data_2;
							address <= address_2;
							rden <= rden_2;
							wren <= wren_2;
					 end
			default: begin 
							data <= data_2;
							address <= address_2;
							rden <= rden_2;
							wren <= wren_2;
						end
			
		endcase
	
	end
	
endmodule

	