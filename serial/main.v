module main(CLK,HSYNC,VSYNC,R,G,B);
	input CLK;
	output reg HSYNC;
	output reg VSYNC;
	output reg R;
	output reg G;
	output reg B;
	
	//hsync = 1589
	//pulse = 191
	//vsync = 834150
	//pulse = 3200
	
	reg [15:0] HCNT;
	reg [15:0] VCNT;
	reg drawH;
	reg drawV;
	
	always @(negedge CLK) begin
		HCNT <= HCNT + 16'h1;
		if(HCNT == 16'd1588)begin
			HCNT <= 16'h0;
			HSYNC <= 1'b0;
			VCNT <= VCNT + 16'h1;
		end else if(HCNT == 16'd188)begin
			HSYNC <= 1'b1;
		end else if(HCNT == 16'd283)begin
			drawH <= 1'b1;
		end else if(HCNT == 16'd1541)begin
			drawH <= 1'b0;
		end
		if(VCNT == 16'd524)begin
			VCNT <= 16'h0;
			VSYNC <= 1'b0;
		end else if(VCNT == 16'd1)begin
			VSYNC <= 1'b1;
		end else if(VCNT == 16'd11)begin
			drawV <= 1'b1;
		end else if(VCNT == 16'd491)begin
			drawV <= 1'b0;
		end
		R <= drawH && drawV && HCNT[4];
		G <= drawH && drawV && VCNT[2];
		B <= drawH && drawV && HCNT[2];
		
	end 
	
endmodule
