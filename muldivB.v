
module shar(
	input[15:0] in,
	input[3:0] arg,
	output[15:0] out
);

assign out = in >> {13'b0,arg};

endmodule

module shal(
	input[15:0] in,
	input[3:0] arg,
	output[15:0] out
);

assign out = in << {13'b0,arg};

endmodule


module muldivB(

	input overflow,
	input clk,
	input rst,
	
	input s,
	
	input inter,

	input[1:0] mOper,
	
	input[1:0] mreg1,
	input[1:0] mreg2,
	
	input[15:0] s_sreg1,
	input[15:0] s_sreg2,
	input[15:0] s_sreg3,
	input[15:0] s_sreg4,
	
	input mode,
	
	input ceer,
	
	output[15:0] muldiv,
	output divbrk,
	output bsha,
	
	output divbyzero
	
);

wire[15:0] num1;
wire[15:0] num2;

wire doDiv;
wire doMul;

wire f_m;
wire n_m;

wire[15:0] divRes;
wire[15:0] mulRes;

wire mwork;
wire rdy;
wire mrdy;

wire mmulbrk;
wire mdivbrk;

wire[15:0] sharout;
wire[15:0] shalout;

wire[15:0] sharout1;
wire[15:0] shalout1;

wire[15:0] sharout2;
wire[15:0] shalout2;

wire[15:0] sharout3;
wire[15:0] shalout3;

wire[15:0] sharout4;
wire[15:0] shalout4;

wire[15:0] sharout5;
wire[15:0] shalout5;

wire[15:0] sharout6;
wire[15:0] shalout6;

wire[15:0] sharout7;
wire[15:0] shalout7;

wire[15:0] sharout8;
wire[15:0] shalout8;

wire ss;

shar shr1(.in(num1),
			.arg(1),
			.out(sharout1)
);

shal shl1(.in(num1),
			.arg(1),
			.out(shalout1)
);

shar shr2(.in(num1),
			.arg(2),
			.out(sharout2)
);

shal shl2(.in(num1),
			.arg(2),
			.out(shalout2)
);

shar shr3(.in(num1),
			.arg(3),
			.out(sharout3)
);

shal shl3(.in(num1),
			.arg(3),
			.out(shalout3)
);


shar shr4(.in(num1),
			.arg(4),
			.out(sharout4)
);

shal shl4(.in(num1),
			.arg(4),
			.out(shalout4)
);


shar shr5(.in(num1),
			.arg(5),
			.out(sharout5)
);

shal shl5(.in(num1),
			.arg(5),
			.out(shalout5)
);


shar shr6(.in(num1),
			.arg(6),
			.out(sharout6)
);

shal shl6(.in(num1),
			.arg(6),
			.out(shalout6)
);


shar shr7(.in(num1),
			.arg(7),
			.out(sharout7)
);

shal shl7(.in(num1),
			.arg(7),
			.out(shalout7)
);


shar shr8(.in(num1),
			.arg(8),
			.out(sharout8)
);

shal shl8(.in(num1),
			.arg(8),
			.out(shalout8)
);

shaColl sCr(.arg(num2[2:0]),
			   .in1(sharout1),
				.in2(sharout2),
				.in3(sharout3),
				.in4(sharout4),
				.in5(sharout5),
				.in6(sharout6),
				.in7(sharout7),
				.in8(sharout8),
				
				.out(sharout)
);

shaColl sCl(.arg(num2[2:0]),
			   .in1(shalout1),
				.in2(shalout2),
				.in3(shalout3),
				.in4(shalout4),
				.in5(shalout5),
				.in6(shalout6),
				.in7(shalout7),
				.in8(shalout8),
				
				.out(shalout)
);




divider dvd(.clk(clk),
				.start(doDiv),
				.rst(rst),
				
				.num1(num1),
				.num2(num2),
	
				.work(mdivbrk),
				.result(divRes),
				.rdy(rdy),
				
				.mode(n_m)
);

multiplier mu(.clk(clk),
				  .rst(rst),
				  .start(doMul),
					
				  .mode(n_m),
				
				  .num1(num1),
				  .num2(num2),
	
				  .result(mulRes),
				  .rdy(mrdy),
				  .work(mmulbrk)
	
);



demul4 dm1(.mreg(mreg1),
				.s_sreg1(s_sreg1),
				.s_sreg2(s_sreg2),
				.s_sreg3(s_sreg3),
				.s_sreg4(s_sreg4),
					
				.num(num1)
);

demul4 dm2(.mreg(mreg2),
				.s_sreg1(s_sreg1),
				.s_sreg2(s_sreg2),
				.s_sreg3(s_sreg3),
				.s_sreg4(s_sreg4),
					
				.num(num2)
);

collectMulDiv cMD(.mmulbrk(mmulbrk),
						.mdivbrk(mdivbrk),
							
						.divbrk(divbrk)
);


manMul mMul(.clk(clk),
				.rst(rst),
				.mode(mode),
				
				.s(s),
				.mrdy(mrdy),
				.rdy(rdy),
				.mOper(mOper),

				.doDiv(doDiv),
				.doMul(doMul),
				.n_m(n_m),
				
				.divbyzero(divbyzero),
				.num2(num2)
);


bus buss(.clk(clk),
			.rst(rst),
	
			.s(s),
	
			.os(ss)
);
wire[15:0] excp=0;

regExtra reEx(.clk(clk),
				  .rst(rst),
	
				  .mOper(mOper),
				
				  .shalout(shalout),
				  .sharout(sharout),
				
				  .mrdy(mrdy),
				  .rdy(rdy),
				
				  .mulRes(mulRes),
				  .divRes(divRes),
				 
				
				  .muldiv(muldiv),
				  
				  .s(s)
				  
	
);

endmodule

module regExtra(
	input clk,
	input rst,
	
	input[1:0] mOper,
	
	input[15:0] shalout,
	input[15:0] sharout,
	
	input mrdy,
	input rdy,
	
	input[15:0] mulRes,
	input[15:0] divRes,
	
	
	input s,
	
	output reg[15:0] muldiv
	
);



reg[1:0] f_modesh;
reg[1:0] modesh;

reg[15:0] n_mmuldiv;
reg[15:0] mmuldiv;

reg[15:0] n_shareg;
reg[15:0] shareg;



reg n_index;
reg index;

always@(posedge clk or posedge rst) begin
	if(rst) modesh <= 0;
	else modesh <= f_modesh;
end

always@(*)begin
	f_modesh = modesh;
	
	if(s) begin
		if(mOper == 2'b00) f_modesh = 1;
		else if(mOper == 2'b11) f_modesh = 2;
		else f_modesh = 0;
	end
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		mmuldiv <=0;
	end
	else begin
		mmuldiv <= n_mmuldiv;
		
	end
end

always@(posedge clk or posedge rst)begin
	if(rst) begin
		shareg <=0;
	end
	else begin
		shareg <= n_shareg;
		
	end
end




always@(posedge clk or posedge rst)begin
	if(rst) begin
		index <=0;
	end
	else begin
		index <= n_index;
		
	end
end


always@(*)begin
	n_shareg = shareg;

	if(modesh == 1) n_shareg = shalout;
	else if(modesh == 2) n_shareg = sharout;
	
end

always@(*)begin
	n_mmuldiv = mmuldiv;
	
	if(mrdy) n_mmuldiv = mulRes;
	else if(rdy) n_mmuldiv = divRes;
	
end


always@(*)begin
	n_index = index;
	
	if(modesh != 0) n_index = 0;
	
	if(mrdy) n_index = 1;
	else if(rdy) n_index = 1;
	
end


always@(*)
	case(index)
		0: muldiv <= shareg;
		1: muldiv <= mmuldiv;
		default: muldiv <= mmuldiv;
	endcase
	
	
endmodule

module shaColl(
	input[2:0] arg,
	input[15:0] in1,
	input[15:0] in2,
	input[15:0] in3,
	input[15:0] in4,
	input[15:0] in5,
	input[15:0] in6,
	input[15:0] in7,
	input[15:0] in8,
	
	output reg[15:0] out
);

always@(*)
	case(arg)
		0: out <= in1;
		1: out <= in2;
		2: out <= in3;
		3: out <= in4;
		4: out <= in5;
		5: out <= in6;
		6: out <= in7;
		7: out <= in8;
		default: out <= in1;
	endcase
	
endmodule

module exceptCollector(
	input clk,
	input rst,
	
	input divbyzero,
	input stackoverflow,
	input overflow,
	
	output reg[15:0] excp,
	
	output reg expirq
);

reg[15:0] f_out;

always@(posedge clk or posedge rst)begin
	if(rst) f_out <= 0;
	else f_out <= excp;
end

always@(*)begin
	excp = f_out;
	
	if(divbyzero) excp = 16'd1;
	if(stackoverflow) excp = 16'd2;
	if(overflow) excp = 16'd3;
	
end

endmodule

module bus(
	input clk,
	input rst,
	
	input s,
	
	output reg os
);

reg f_os;

always@(posedge clk or posedge rst)begin
	if(rst) os <= 0;
	else os <= f_os;
end

always@(*)begin
	f_os <= s;
end

endmodule

module buff7(
	input clk,
	input rst,
	
	input[15:0] in,
	
	output reg[15:0] out
);

reg[15:0] f_out;

always@(posedge clk or posedge rst)begin
	if(rst) out <= 0;
	else out <= f_out;
end

always@(*)begin
	f_out = in;
	
end

endmodule

module manMul(
	input clk,
	input rst,
	input mode,
	
	input s,
	input mrdy,
	input rdy,
	input[1:0] mOper,
	input[15:0] num2,
	
	output reg doDiv,
	output reg doMul,
	output reg n_m,
	
	output reg divbyzero
);



reg f_m;


always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_m <= 0;
	end
	else begin
		f_m <= n_m;
	end
end



always@(*)begin
	
	divbyzero = 0;
	doDiv = 0;
	doMul = 0;
	
	n_m = f_m;
	
	if(~(mrdy | rdy) && s)
		case(mOper) 
			2'b01: begin
					
					n_m = mode;
					doMul = 1;
				end
			2'b10: begin
					if(num2 == 0) divbyzero = 1;
					n_m = mode;
					doDiv = 1;
				end
			default:;
		endcase
end

endmodule


module collectMulDiv(
	
	input mmulbrk,
	input mdivbrk,
	
	output divbrk
);

assign divbrk = mmulbrk | mdivbrk;

endmodule

module demul4(
	input[1:0] mreg,
	input[15:0] s_sreg1,
	input[15:0] s_sreg2,
	input[15:0] s_sreg3,
	input[15:0] s_sreg4,
	
	output reg[15:0] num
);

always@(*)begin
	case(mreg)
		0: num = s_sreg1;
		1: num = s_sreg2;
		2: num = s_sreg3;
		3: num = s_sreg4;
	endcase
end


endmodule
