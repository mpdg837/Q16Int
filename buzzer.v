module Buzzer16(
	input clk,
	input rst,
	
	input start,
	input[23:0] in,
	
	output sound
);

wire[5:0] sig;


buzzerMan bMan(.clk(clk),
			 .rst(rst),
	
			 .in(in),
			 .start(start),
	
			 .sig(sig)
);

generator gen(.rst(rst),
				  .sound(sig),
				  .clk(clk),
				  
				  .clkm(sound)
	
);



endmodule

module buzzerMan(
	input clk,
	input rst,
	
	input[23:0] in,
	input start,
	
	output reg[5:0] sig
);

reg[5:0] f_sig;

localparam NOP = 8'd0;
localparam SET = 8'd1;
localparam STOP = 8'd2;

always@(posedge clk or posedge rst)
	if(rst) f_sig <= 0;
	else f_sig <= sig;
	
always@(*)begin
	sig = f_sig;
	
	case(in[23:16])
		NOP:;
		SET: sig = in[5:0];
		STOP: sig = 0;
		default:;
	endcase
end

endmodule

module generator(
	input rst,
	input[5:0] sound,
	input clk,
	output reg clkm
	
);

reg[17:0] n_licz;
reg[17:0] licz;

reg n_sclk;
reg f_sclk;

reg n_clka;
reg clka;


always@( posedge clk or posedge rst)begin
	if(rst)begin
		licz <= 0;
		clka <= 1'b1;
		f_sclk <= 0;
	
	end else if(clk) begin
	
		f_sclk <= n_sclk;
		licz <= n_licz;
		clka <= n_clka;
	

	end 
end

always@(*)begin
	
	n_clka = clka;
	n_sclk = f_sclk;
	
	

	if(licz == {sound,12'b0})begin
		n_licz = 18'b0;
		
		if(sound == 6'b111111 || sound == 6'b0) n_clka = 1'b1;
		else if(sound == 6'b000001) begin
			n_clka = 1'b1;
		end
		else begin
			n_clka = ~clka ;

		end
		
	end else
	begin
		n_licz = licz + 18'd1;
	end

end

always@(posedge clk)
	clkm <= n_clka;

endmodule
