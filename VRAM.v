
module spriteRAM(
	input clk,
	input[8:0] addr,

	input w,
	input[8:0] waddr,
	input[31:0] save,
	
	output reg[31:0] out
);

reg[31:0] memory[511:0];
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

always@(posedge clk)begin
	if(w) memory[waddr] <= save;
	
	out <= memory[addr];
end
	

endmodule


module VRAM(
	input clk,
	input[12:0] addr,
	
	input[12:0] waddr,
	input w,
	input[7:0] in,
	
	input ws,
	input sel,
	input[3:0] ins,
	
	output reg[7:0] out
);

reg[3:0] memory1[8191:0];
reg[3:0] memory2[8191:0];

localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

	
	
always@(posedge clk)begin
		
		if(ws)begin
			if(sel) memory2[waddr] <= ins;
			else memory1[waddr] <= ins;
		end
		if(w) begin
			memory1[waddr] <= in[3:0];
			memory2[waddr] <= in[7:4];
		end
		
		out <= {memory2[addr],memory1[addr]};
	end
endmodule


