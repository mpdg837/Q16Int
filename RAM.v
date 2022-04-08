
module BRAMI32(
	input[14:0] addr,
	input[31:0] din,
	input clk,rst,we,
	output reg[31:0] out,
	
	input startReadRAM,
	
	output reg readRdyRAM,
	output reg saveRdyRAM
	
);

wire[14:0] raddr = addr[10:0];

reg[31:0] memory[2047:0];
reg[31:0] dout_r;

reg[11:0] n;

initial begin
	for(n=0;n<2048;n = n + 1) begin
		memory[n] = 0;
		end
end



reg[14:0] iaddr;
wire[14:0] iraddr = iaddr[10:0];
reg[31:0] idin;
reg iwe;
reg[31:0] iout;


always@(posedge clk) begin

	if(iwe) memory[iraddr[14:0]] <= idin;
	
	iout <= memory[iraddr[14:0]];
	
	
end	


reg[31:0] n_mem;
reg[31:0] f_mem;



reg[2:0] f_save;
reg[2:0] n_save;

reg[31:0] f_out;

reg f_readR;
reg f_saveR;

reg[7:0] f_tim;
reg[7:0] n_tim;

always@(posedge clk or posedge rst) begin
	if(rst) f_mem <= 0;
	else f_mem <= n_mem;
end

always@(posedge clk or posedge rst) begin
	if(rst) f_tim <= 0;
	else f_tim <= n_tim;
end


always@(posedge clk or posedge rst) begin
	if(rst) f_readR <= 0;
	else f_readR <= readRdyRAM;
end

always@(posedge clk or posedge rst) begin
	if(rst) f_saveR <= 0;
	else f_saveR <= saveRdyRAM;
end

always@(posedge clk or posedge rst) begin
	if(rst) f_out <= 0;
	else f_out <= out;
end

always@(posedge clk or posedge rst) begin
	if(rst) f_save <= 0;
	else f_save <= n_save;
end

always@(*)begin
	
	iaddr = 0;
	idin = 0;
	iwe = 0;
	
	n_save = f_save;
	n_tim = f_tim;
	
	if(f_save == 1 || f_save == 2) n_save = 0;
	

	if(f_save == 0)
		if(startReadRAM)begin
			n_save = 3;
			iaddr = addr;
			idin = 0;
			iwe = 0;
			n_tim = 0;
			
		end else if(we)begin
			n_save = 4;
			iaddr = addr;
			idin = din;
			iwe = we;
			n_tim = 0;
		end
	
	if(f_save == 3 || f_save == 4)begin
		
		
		if(f_tim == 8'd63)begin
			n_tim = 8'd0;
			
			case(f_save)
				3: n_save = 1;
				4: n_save = 2;
			endcase
		end else n_tim = f_tim + 8'd1;
		
	end

end

always@(*)begin
	
	saveRdyRAM = 0;
	readRdyRAM = 0;
	
	out = 0;
	n_mem = f_mem;
	
	case(f_save)
		1:begin
			readRdyRAM = 1;
			saveRdyRAM = 0;
			out = f_mem;
			
		end
		2:begin
			saveRdyRAM = 1;
			readRdyRAM = 0;
			out = f_mem;
			
		end
		3: if(f_tim == 8'd0) n_mem = iout;
		4: if(f_tim == 8'd0) n_mem = iout;
		default:;
	endcase
end

endmodule

