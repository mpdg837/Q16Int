module przebuffer(
	input rst,
	
	input feirq,
	output reg eirq,
	
	input clk,
	input irq1,
	input irq2,
	input irq3,
	input rem,
	
	output reg oirq1,
	output reg oirq2,
	output reg oirq3
);

reg f_oirq1;
reg f_oirq2;
reg f_oirq3;

reg n_rem;

always@(posedge clk)begin
	if(rst) n_rem <= 0;
	else n_rem <= rem;
end

always@(posedge clk)begin
	if(rst) eirq <= 0;
	else eirq <= feirq;
end


always@(posedge clk)begin
	if(rst) begin
		f_oirq1 <= 0;
		f_oirq2 <= 0;
		f_oirq3 <= 0;

	end else begin
		f_oirq1 <= oirq1;
		f_oirq2 <= oirq2;
		f_oirq3 <= oirq3;
	end
end

always@(*)begin
		
	oirq1 = f_oirq1;
	oirq2 = f_oirq2;
	oirq3 = f_oirq3;
		
	if(irq1 | irq2 | irq3)begin
		if((~f_oirq1) & (~f_oirq2) & (~f_oirq3))begin
			oirq1 = irq1;
			oirq2 = irq2;
			oirq3 = irq3;
		end
		
	end else
		if(n_rem)begin
			oirq1 = 0;
			oirq2 = 0;
			oirq3 = 0;
		end
end

endmodule


module counter(
	input clk,
	input rst,
	
	input irq1,
	input irq2,
	input irq3,
	
	input hlt,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input[1:0] reg1,
	input[1:0] reg2,
	
	input[3:0] mOper,
	input[14:0] data,
	
	input s,
	input aeq,
	
	input lt,
	input gt,
	input eq,
	
	input exp,
	
	output[14:0] addr,
	
	output eirq,
	
	output inter,
	
	input cmpStart,
	
	input read,
	input save
);

wire[15:0] toSave;
wire push;
wire pop;

wire[15:0] toCont;

stackAddr sAddrA(.clk(clk),
					  .rst(rst),
	
					  .toSave(toSave),
					  .push(push),
	
					  .pop(pop),
					  .out(toCont)
	
);

wire rexp;
wire iexp;

wire[14:0] s_addr;
wire[14:0] i_addr;


wire[7:0] s_stackAddr;


wire[7:0] i_stackAddr;

wire[7:0] i_irq;
wire[7:0] s_irq;

wire oirq1;
wire oirq2;
wire oirq3;

wire rem;

wire ieirq;


przebuffer pba1(.rst(rst),
					 .clk(clk),
					 
					 .feirq(ieirq),
					 .eirq(eirq),
	
					 .irq1(irq1),
					 .irq2(irq2),
					 .irq3(irq3),
					 
					 .rem(rem),
	
						.oirq1(oirq1),
						.oirq2(oirq2),
						.oirq3(oirq3)
);

addrBus aB(.clk(clk),
			  .rst(rst),
	
			  .iaddr(i_addr),
	
			  .addr(s_addr)
);


stackBus sB(.clk(clk),
				.rst(rst),
				
				.s_stackAddr(s_stackAddr),
		
				.i_stackAddr(i_stackAddr),
				
				.i_irq(i_irq),
				.s_irq(s_irq)
);

saveAddr sA(.s(s),
				.clk(clk),
				
				.gt(gt),
				.lt(lt),
				.eq(eq),

				.irq1(oirq1),
				.irq2(oirq2),
				.irq3(oirq3),
				
				.exp(exp),
				
				.rem(rem),
				
				.hlt(hlt),
				.aeq(aeq),
				
				.inter(inter),
				
			
				.i_stackAddr(i_stackAddr),
				
				
				.s_stackAddr(s_stackAddr),
				
				.toSave(toSave),
				.push(push),
	
				.pop(pop),
				.toCont(toCont),
					  
				.mOper(mOper),
				.dataAddr(data),
	
				.s_addr(s_addr),
				.i_addr(i_addr),
				
				.eirq(ieirq),
				
				.i_irq(i_irq),
				.s_irq(s_irq),
				
				.cmpStart(cmpStart),
				
				.read(read),
				.save(save)
);

assign addr = s_addr;

endmodule

module buf1clear(
	input clk,
	input rst,
	input clr,
	
	input in,
	output reg out
);

reg f_out;

always@(posedge clk or posedge rst)begin
	if(rst) f_out <= 0;
	else f_out <= out;
end

always@(*)begin
	out  =f_out;
	
	if(clr) out = 0;
	
	if(in) out = 1;
end

endmodule

module stackBus(
	input clk,
	input rst,
	
	
	input[7:0] i_stackAddr,
	input[7:0] i_irq,

	
	output reg[7:0] s_stackAddr,
	output reg[7:0] s_irq 
);

always@(posedge clk or posedge rst) begin
	if(rst) begin
		s_irq <= 0;
	end else
	begin
		s_irq <= i_irq;
	end
end

always@(posedge clk or posedge rst) begin
	if(rst) begin
		s_stackAddr <= 0;
	end else
	begin
		s_stackAddr <= i_stackAddr;
	end
end

endmodule

module saveAddr(
	input clk,
	
	input s,
	
	input gt,
	input lt,
	input eq,
	
	input irq1,
	input irq2,
	input irq3,
	
	input exp,
	input cmpStart,
	
	output reg rem,
	
	input hlt,
	
	input[3:0] mOper,
	input[14:0] dataAddr,
	

	
	input[7:0] s_stackAddr,
	input[7:0] s_irq,

	
	output reg[7:0] i_irq,
	output reg[7:0] i_stackAddr,
	
	output reg pop,
	output reg push,
	
	output reg[15:0] toSave,
	input[15:0] toCont,
	
	output reg eirq,
	
	input aeq,
	input[14:0] s_addr,
	output reg[14:0] i_addr,
	
	output reg inter,
	
	input read,
	input save
);

localparam NOP = 4'd0;
localparam JEQ = 4'd1;
localparam JGT = 4'd2;
localparam JLT = 4'd3;
localparam JIS = 4'd4;
localparam JMP = 4'd5;
localparam NEX = 4'd6;
localparam CALL = 4'd7;
localparam RET = 4'd8;


wire isaeq = (aeq & eq);

reg stack1 = 0;
reg stack2 = 0;
always@(posedge clk)
	stack2 <= stack1;
	
always@(*) begin
	
	pop = 0;
	push = 0;
	toSave = 0;
	stack1 = 0;
	
	i_stackAddr = s_stackAddr;
	
	i_addr = s_addr;
	i_irq = s_irq;
	
	eirq = 0;
	rem = 0;
	
	inter = 0;
	
	if(s_irq != 0) 
		if(~stack2) inter = 1;
	
	if(s) begin
		
		
		if((irq1 | irq2 | irq3 | exp) && (~inter)) begin
			// Realizacja przerwania
				
					push = 1;
					
					if(save) stack1 = 1;
					if(mOper != NEX) begin
						toSave = s_addr;
					end else
						toSave = s_addr + 1;
									
					i_stackAddr = s_stackAddr + 8'b1;
					i_irq = s_stackAddr + 8'd1;
					
					case({irq3,irq2,irq1})
						1: i_addr = 16'd2;
						2: i_addr = 16'd3;
						3: i_addr = 16'd4;
						4: i_addr = 16'd5;
						5: i_addr = 16'd6;
						6: i_addr = 16'd7;
						7: i_addr = 16'd8;
						default:;
					endcase
					
					if(exp) i_addr = 16'd8;
				

		end else
			case(mOper)
				default: i_addr = s_addr;
				JEQ: 	if(isaeq | eq) i_addr = dataAddr;
						else i_addr = s_addr + 15'b1;
				JLT:  if(isaeq | lt) i_addr = dataAddr;
						else i_addr = s_addr + 15'b1;
				JGT:  if(isaeq | gt) i_addr = dataAddr;
						else i_addr = s_addr + 15'b1;	
				
				JMP: i_addr = dataAddr;
				
				NEX: begin
						if(hlt) begin
							i_addr = s_addr;
						end
						
						if(~(hlt)) i_addr = s_addr + 15'b1;
						end
						
				CALL: begin
									
								push = 1;
								toSave = s_addr + 15'd1;
								
							
								i_stackAddr = s_stackAddr + 8'b1;
								i_addr = dataAddr;
						
						end
				RET:  begin
							if(s_stackAddr == s_irq && (inter)) begin
								i_irq = 0;
								eirq = 1;
							end
							
							i_stackAddr = s_stackAddr - 8'b1;
							pop = 1;
							i_addr = toCont;
							
						end
				
			endcase
		
			rem = 1;
	end
end

endmodule

module addrBus(
	input clk,
	input rst,
	
	input[14:0] iaddr,
	
	output reg[14:0] addr
);

always@(posedge clk or posedge rst)begin
	if(rst) begin
		addr <= 0;
	end else
	begin
		addr <= iaddr;
	end
	
end

endmodule

module stackAddr(
	input clk,
	input rst,
	
	input[15:0] toSave,
	input push,
	
	input pop,
	output reg[15:0] out
	
);

reg[15:0] memory[255:0];

reg[7:0] f_numStack = 0;
reg[7:0] numStack = 0;


always@(posedge clk or posedge rst)begin
	if(rst) begin
		f_numStack <= 0;
		end
	else begin
		f_numStack <= numStack;
		end
end

always@(posedge clk)begin
	
	
	if(push) begin
		memory[f_numStack + 1] = toSave;	
	end
		
	out = memory[f_numStack];
	
end

always@(*)begin
	numStack = f_numStack;
	
	
	
	if(pop) begin
		numStack = f_numStack - 1;
	end
	
	if(push) begin
		numStack = f_numStack + 1;
	end
end

endmodule
