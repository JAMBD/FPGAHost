module slowClock (CLK,SCLK);
	
	input CLK;
	output reg SCLK;
	
	reg [32:0] cnt;
	
	always @ (posedge CLK) begin
		cnt = cnt + 32'd1;
		if(cnt == 32'd2604)begin
			cnt = 0;
			SCLK = ~SCLK;
		end
	end
	
endmodule
