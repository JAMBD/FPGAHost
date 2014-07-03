module serial (CLK,TXD,RXD,LED);
	input CLK;
	input RXD;
	output reg TXD;
	output LED;
	
	wire SCLK;
	wire SYNC;
	
	assign LED = RXD;
	
	reg [7:0] data;

	reg [7:0] cirBuf [7:0];
	reg [2:0] head;
	
	reg [7:0] in;
	reg [3:0] inSt;
	
	assign SYNC = (RXD);
	
	slowClock slowClock_0(
		.SYNC (SYNC),
		.CLK (CLK),
		.SCLK (SCLK));
		 
	initial begin
		cirBuf[0] = 8'hAA;
		cirBuf[1] = 8'h22;
		cirBuf[2] = 8'h33;
		cirBuf[3] = 8'h44;
		cirBuf[4] = 8'h55;
		cirBuf[5] = 8'h66;
		cirBuf[6] = 8'h77;
		cirBuf[7] = 8'h88;
		TXD = 1'b1;
		inSt = 4'd0;
		head = 3'h0;
	end
	always @(negedge SCLK)begin
		if(inSt == 4'h0 && !RXD)begin
			inSt <= 4'd9;
			TXD <= 1'b0;
			data <= cirBuf[head];
		end if(inSt == 4'h1)begin
			inSt <= 4'h0;
			head <= head + 3'h1;
			cirBuf[head] <= in;
			TXD <= 1'b1;
		end else if(inSt != 4'h0)begin
			in[4'h8 - inSt] <= RXD;
			TXD <= data[4'h8 - inSt];
			inSt <= inSt - 4'h1;
		end
	end
endmodule 