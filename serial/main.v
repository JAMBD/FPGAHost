module main(CLK,HSYNC,VSYNC,R,G,B,XCLK,PCLK,D,HIN,VIN);
	input CLK;
	output reg HSYNC;
	output reg VSYNC;
	output reg R;
	output reg G;
	output reg B;
	output reg XCLK;
	input PCLK;
	input [7:0] D;
	input HIN;
	input VIN;
	
	//hsync = 1589
	//pulse = 191
	//vsync = 834150
	//pulse = 3200
	
	reg [15:0] HCNT;
	reg [15:0] VCNT;
	reg drawH;
	reg drawV;
	reg [7:0] CAMDAT [1:0];
	reg BCNT;
	reg [15:0] PXCNT;
	reg [15:0] PVCNT;
	reg [255:0] RDAT [127:0];
	reg [255:0] GDAT [127:0];
	reg [255:0] BDAT [127:0];
	reg CR;
	reg CG;
	reg CB;
	always @(posedge PCLK)begin
		if(VIN)
			PVCNT <= 7'd0;
		else
			if(!HIN)begin
				if(PXCNT != 8'h0)
					PVCNT <= PVCNT + 7'd1;
				BCNT <= 1'b0;
				PXCNT <= 8'h0;
			end else begin
				BCNT <= !BCNT;
				if(BCNT)
					PXCNT <= PXCNT + 8'd1;
			end
		CAMDAT[BCNT] <= D;
	end
	
	always @(negedge CLK) begin
		XCLK <= ~XCLK;
		HCNT <= HCNT + 16'h1;
		if(HCNT == 16'd1588)begin
			HCNT <= 16'h0;
			drawH <= 1'b1;
		end else if(HCNT == 16'd1302)begin
			HSYNC <= 1'b0;
			VCNT <= VCNT + 16'h1;
		end else if(HCNT == 16'd1493)begin
			HSYNC <= 1'b1;
		end else if(HCNT == 16'd1270)begin
			drawH <= 1'b0;
		end
		if(VCNT == 16'd513)begin
			VSYNC <= 1'b0;
		end else if(VCNT == 16'd515)begin
			VSYNC <= 1'b1;
		end else if(VCNT == 16'd524)begin
			drawV <= 1'b1;
			VCNT <= 16'h0;
		end else if(VCNT == 16'd480)begin
			drawV <= 1'b0;
		end
		if(!BCNT && HIN && !VIN && PVCNT[15:8]==0 && PXCNT[15:9]==0) begin		
			RDAT[PVCNT[7:1]][PXCNT[8:1]] <= CAMDAT[1][6];
			GDAT[PVCNT[7:1]][PXCNT[8:1]] <= CAMDAT[1][7];
			BDAT[PVCNT[7:1]][PXCNT[8:1]] <= CAMDAT[1][5];
		end
		CR <= RDAT[VCNT[7:1]][HCNT[9:2]];
		CG <= GDAT[VCNT[7:1]][HCNT[9:2]];
		CB <= BDAT[VCNT[7:1]][HCNT[9:2]];
		R <= drawH && drawV && CR;
		G <= drawH && drawV && CG;
		B <= drawH && drawV && CB;
		
	end 
	
endmodule
