module serial (CLK,TXD,RXD,LED);
	input CLK;
	input RXD;
	output reg TXD;
	output LED;
	
	wire SCLK;
	
	assign LED = TXD;
	
	reg [9:0] data;
	
	reg [7:0] cirBuf [7:0];
	reg [2:0] head;
	
	reg [7:0] in;
	reg [2:0] inSt;
	
	slowClock slowClock_0(
		.CLK (CLK),
		.SCLK (SCLK));
	initial begin
		cirBuf[0] = 8'h11;
		cirBuf[1] = 8'h22;
		cirBuf[2] = 8'h33;
		cirBuf[3] = 8'h44;
		cirBuf[4] = 8'h55;
		cirBuf[5] = 8'h66;
		cirBuf[6] = 8'h77;
		cirBuf[7] = 8'h88;
		TXD = 1;
	end
	always @(negedge SCLK)begin
		if(data != 10'b0)begin
			TXD = data[9];
			data = {data[8:0],1'b0};
		end
		else begin
			head = head + 3'h1;
			if(cirBuf[head]!=8'h0)begin
				data = {1'b0,cirBuf[head],1'b1};
				cirBuf[head] = 8'h0;
			end
		end
		if(inSt > 0 || (!RXD && inSt==0))begin
			in[inSt] = RXD;
			inSt = inSt + 3'h1;
			if(inSt == 0)begin
				cirBuf[head-1] = in;
			end
		end
	end
endmodule 