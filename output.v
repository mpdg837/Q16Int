

module outputX(
	input clk,
	input rst,
	
	input inter,
	
	input[1:0] reg1,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input outA,
	input outB,
	
	input s,
	
	output[15:0] out1,
	output[15:0] out2
);
reg[15:0] n_out1a;
reg[15:0] n_out1b;
reg[15:0] n_out2;

reg[15:0] s_out1a;
reg[15:0] s_out1b;
reg[15:0] s_out2;

always@(posedge clk or posedge rst)begin
	if(rst)begin
		s_out1a <= 0;

	end else
	begin
		s_out1a <= n_out1a;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst)begin
		s_out2 <= 0;
	end else
	begin
		s_out2 <= n_out2;
	end
end

always@(*)begin
	n_out2 = 0;
	
	if(s & outB) begin
		if(~inter)
			case(reg1)
				0: n_out2 = sreg1;
				1: n_out2 = sreg2;
				2: n_out2 = sreg3;
				3: n_out2 = sreg4;
			endcase
		
	
	end
end

always@(*)begin
	n_out1a = s_out1a;

	
	if(s & outA) begin
		if(~inter)
			case(reg1)
				0: n_out1a = sreg1;
				1: n_out1a = sreg2;
				2: n_out1a = sreg3;
				3: n_out1a = sreg4;
			endcase
	end
end


assign out1 = s_out1a;
assign out2 = s_out2;
endmodule
