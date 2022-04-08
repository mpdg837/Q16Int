
module main(
	input clk,
	
	input krst,

	input kin1,
	input kin2,
	input kin3,
	input kin4,

	input ps2clk,
	input ps2data,

	
//	output R,
	output G,
	output B,
	
	output hsync,
	output vsync,
	
	output sound,
	
	output[3:0] led
	
);

wire inclk;
wire iclk  =clk;

inputclock inclo(.clk(iclk),
					  .dclk(inclk)
);

wire kkrst;

keyrstmodule krsta(.clk(iclk),
				 .in(krst),
	
				 .tclk(inclk),
				 
				 .rst(kkrst)
);

wire irq1;
wire irq2;
wire irq3;
wire irq4;
wire irq5;
wire irq6;
wire irq7;

wire saverdy;
wire readrdy;



wire readstart;

wire[1:0] outsel;

wire[31:0] oout1;
wire[31:0] oout2;
wire[31:0] oout3;

wire[31:0] iin1;
wire[31:0] iin2;
wire[31:0] iin3;

wire irst = kkrst;

wire clkm;




wire[31:0] toCPU;

wire[15:0] in1 ;
wire[15:0] in2 ;


wire[14:0] addrCPU;
wire[31:0] fromCPU;
wire wCPU;


wire[15:0] out1;
wire[15:0] out2;


wire[31:0] fromPro;
wire[31:0] inToPro;

wire[31:0] tomRAM8;
wire wmRAM8;
wire[14:0] addrmRAM8;
	
wire[31:0] toCPURAM8;


wire[11:0] addrmROM;
wire[31:0] toCPUROM;

wire mrdy;
wire[23:0] mout;
wire[23:0] min;

wire mstart;



div_input dI50(.clk(iclk),.rst(irst),.clkm(clkm));

keyDevice kD(.clk(clk),
				 .tclk(inclk),
				 
				 .rst(irst),
				 .krst(krst),
				 
				 .irq(irq1),
				
				 .in1(kin1),
				 .in2(kin2),
				 .in3(kin3),
				 .in4(kin4),
				 
				 .out(iin2)
	
);

keyboard keybo(.clk(iclk),
					.rst(irst),
					
					.irq(irq2),
	
					.ps2clk(ps2clk),
					.ps2data(ps2data), 
					.out(iin3)

);


CPU cpu1(.clk(iclk),
			.clk_tim(clkm),
			.rst(irst),
			
			
			.irq1(irq1),
			.irq2(irq2),
			.irq3(irq3),
			.irq4(irq4),
			.irq5(irq5),
			.irq6(irq6),
			.irq7(irq7),
			
			.in1(in1),
			.in2(in2),

	
			.status(status),
	
			// Memory
	
	
			.out1(out1),
			.out2(out2),
			
			.workx(work),
			
			.prst(prst),
			
			// Mem
			.toCPU(toCPU),
		
			.addrCPU(addrCPU),
			.fromCPU(fromCPU),
			.wCPU(wCPU),
			
			.saverdy(saverdy),
			
			.readrdy(readrdy),
			.readstart(readstart),
			
			.outsel(outsel)
	
);

connector cnn(.clk(iclk),
				  .rst(irst),
	
				  .out1(out1),
				  .out2(out2),
	
				  .out(fromPro)
);

wire readRdyRAM;
wire saveRdyRAM;
wire startReadRAM;

wire readRdyROM = 1;
wire startReadROM;


bussystem bussystem(
	.clk(iclk),
	.rst(irst),
	
	.toCPU(toCPU),
		
	.addrCPU(addrCPU),
	.fromCPU(fromCPU),
	.wCPU(wCPU),
	
	.tomRAM8(tomRAM8),
	.wmRAM8(wmRAM8),
	.addrmRAM8(addrmRAM8),
		
	.toCPURAM8(toCPURAM8),


	.addrmROM(addrmROM),
	.toCPUROM(toCPUROM),
	
	.outsel(outsel),
	
	.in1(iin1),
	.in2(iin2),
	.in3(iin3),

	
	.inToPro(inToPro),

	.fromPro(fromPro),
	.out1(oout1),
	.out2(oout2),
	.out3(oout3),
	
			
	.saverdy(saverdy),
			
	.readrdy(readrdy),
	.readstart(readstart),
	
	
	.readRdyRAM(readRdyRAM),
	.readRdyROM(readRdyROM),
	
	.startReadROM(startReadROM),
	.startReadRAM(startReadRAM),
	
	.saveRdyRAM(saveRdyRAM)
);

wire[14:0] xaddr;
wire[31:0] xdin;

wire xwe;

wire[31:0] xout;
BRAMI32 bram8(
	.addr(addrmRAM8),
	.din(tomRAM8),
	
	.clk(iclk),
	.rst(irst),
	
	.we(wmRAM8),
	.out(toCPURAM8),
	
	.startReadRAM(startReadRAM),
	
	.readRdyRAM(readRdyRAM),
	.saveRdyRAM(saveRdyRAM)
	
);

KERNAL kernal(
	.clk(iclk),
	.addr(addrmROM),
	.out(toCPUROM)
);

coprocesor cop(.clk(iclk),
					.rst(irst),

					.devaddr(2'b01),
	
					.in(oout1),
					.out(iin1),

					.mrdy(mrdy),
					.mout(mout),
	
					.min(min),
					.mstart(mstart),
					
					.irq(irq3)
	
);

RTC rtc(.clk(iclk),
				 .dclk(clkm),
				.rst(irst),
				
				.start(mstart),
				.in(min),
	
				.rdy(mrdy),
				.out(mout),
				
				.led(led)
);


wire[23:0] outG;
wire stG;
connectorGraphics cGA(.clk(iclk),
							 .rst(irst),
							 
							 .in(oout2),
							 .devaddr(2'd2),
	
							 .out(outG),
							 .start(stG)
);

G10k graphics(.clk(iclk),
				  .rst(irst),
					
				  .in(outG),
				  .start(stG),
					
				  .irq(irq4),
				  .irqc(irq5),
				  
				  .R(R),
				  .G(G),
				  .B(B),
						
				  .hsync(hsync),
				  .vsync(vsync)
	
);

wire[23:0] outB;
wire stB;

connectorGraphics cGB(.clk(iclk),
							 .rst(irst),
							 
							 .in(oout3),
							 .devaddr(2'd3),
	
							 .out(outB),
							 .start(stB)
);

Buzzer16 bz16(.clk(iclk),
				  .rst(irst),
	
				  .start(stB),
				  .in(outB),
	
				  .sound(sound)
);

assign in1 = {inToPro[15:0]};
assign in2 = {inToPro[31:16]};

endmodule

module inputclock(
	input clk,
	output reg dclk
);

always@(posedge clk)
	dclk <= ~dclk;
endmodule

