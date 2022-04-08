
module RAMController(
	input clk,
	input rst,
	input inter,
	
	input[1:0] ereg1,
	
	input[15:0] edata,
	input[1:0] mOper,
	
	input[15:0] sreg1,
	input[15:0] sreg2,
	input[15:0] sreg3,
	input[15:0] sreg4,
	
	input s,
	
	
	input[7:0] stackAddr,
	input wStackAddr,
	
	output reg[15:0] toRAM,
	output reg[15:0] RAMaddr,
	output reg w
);

localparam NOP = 2'd0;
localparam RAM = 2'd1;
localparam URAM = 2'd2;
localparam SAVE = 2'd3;

reg[15:0] n_toRAM;

reg[15:0] RAMaddrn;
reg[15:0] RAMaddri;

reg[15:0] n_RAMaddrn;
reg[15:0] n_RAMaddri;

wire[15:0] num1;

reg n_w;


demul4 dm5(.mreg(ereg1),
				.s_sreg1(sreg1),
				.s_sreg2(sreg2),
				.s_sreg3(sreg3),
				.s_sreg4(sreg4),
					
				.num(num1)
);


always@(posedge clk or posedge rst)
	if(rst) RAMaddri <= 0;
	else RAMaddri <= n_RAMaddri;

always@(posedge clk or posedge rst)
	if(rst) RAMaddrn <= 0;
	else RAMaddrn <= n_RAMaddrn;
	
always@(posedge clk or posedge rst)begin
	if(rst) begin
		toRAM <= 0;
	
	end
	else begin
		toRAM <= n_toRAM;
	
	end
end


always@(posedge clk or posedge rst)begin
	if(rst) begin
	
		w <= 0;
	end
	else begin
	
		w <= n_w;
	end
end


always@(*)begin
	n_toRAM = 0;

	if(s)begin
		case(mOper)
			
			SAVE: begin
					n_toRAM = num1;
				
			end
			
			default:;
		endcase
	
	end else
	begin
		n_toRAM = 0;
	
	
	end
end

always@(*)begin
	n_w = 0;
	
	if(s)begin
		case(mOper)
			
			SAVE: begin
					n_w = 1;
			end
			
			default:;
		endcase
	
	end else
	begin
		n_w = 0;
	
	end
end
always@(*)begin
	n_RAMaddri = RAMaddri;
	n_RAMaddrn = RAMaddrn;
	
	if(wStackAddr)
		if(inter) n_RAMaddri = {8'b00010011,stackAddr};
		else n_RAMaddrn = {8'b00010011,stackAddr};
	else if(s)begin
		case(mOper)
			NOP: ;
			RAM: begin
					if(inter) n_RAMaddri = edata[15:0];
					else n_RAMaddrn = edata[15:0];
			end
			URAM: begin
					if(inter) n_RAMaddri = {num1[15:0]};
					else n_RAMaddrn = {num1[15:0]};
			end
			default:;
		endcase
	
	end 
	
end

always@(*)
	if(inter) begin
		
		RAMaddr <= RAMaddri;
		end
	else begin
		
		RAMaddr <= RAMaddrn;
		end
endmodule
