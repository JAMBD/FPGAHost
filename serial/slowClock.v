module slowClock (SYNC,CLK,SCLK);
	input SYNC;
	input CLK;
	output reg SCLK;
	
	reg [31:0] cnt;
	reg pSYNC;
	
	always @ (posedge CLK) begin
		if(!SYNC && pSYNC)begin
			cnt <= 32'd651;
		end else begin
			cnt <= cnt + 32'd1;
			if(cnt == 32'd1302)begin
				cnt <= 32'd0;
				SCLK <= ~SCLK;
			end
		end
		pSYNC <= SYNC;
	end
	
endmodule
