`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:49 05/14/2015 
// Design Name: 
// Module Name:    game 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module game(input go,
				input clk25,
				input reset,
				input [9:0] xpos,
				input [9:0] ypos,
				input rota,
				input rotb,
				output [2:0] red,
				output [2:0] green,
				output [1:0] blue,
				output reg Play,
				output reg [1:0] Cause,
				output reg [3:0] Score,
				inout SDA,
				output SCL);
		
// paddle movement		
reg [8:0] paddlePosition;
reg [2:0] quadAr, quadBr;
always @(posedge clk25) quadAr <= {quadAr[1:0], rota};
always @(posedge clk25) quadBr <= {quadBr[1:0], rotb};
reg Play1, Play2, Cause1, Cause2;

always @(posedge clk25)
	begin Play <= Play1 || Play2;
			Cause <= {Cause2, Cause1}; end

always @(posedge clk25)
if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
begin
	Play1 <= 1; Cause1 <= 1;
	if(quadAr[2] ^ quadBr[1]) begin
		if(paddlePosition < 508)        // make sure the value doesn't overflow
			paddlePosition <= paddlePosition + 4;
	end
	else begin
		if(paddlePosition > 3)        // make sure the value doesn't underflow
			paddlePosition <= paddlePosition - 4;
	end
end
else
	begin Play1 <= 0; Cause1 <= 0; end

		
// ball movement	
reg [9:0] ballX;
reg [8:0] ballY;
reg ballXdir, ballYdir;
reg bounceX, bounceY;
	
wire endOfFrame = (xpos == 0 && ypos == 480);
	
always @(posedge clk25) begin
		if (endOfFrame) begin // update ball position at end of each frame
			//if (ballX == 0 && ballY == 0) begin // cheesy reset handling, assumes initial value of 0
			  if(reset == 1 || (ballX == 0 && ballY == 0)) begin
				ballX <= 480;
				ballY <= 300;
			end
			else begin
				if (ballXdir ^ bounceX) 
					ballX <= ballX + 2;
				else 
					ballX <= ballX - 2;	

				if (ballYdir ^ bounceY) 
					ballY <= ballY + 2;
				else
					ballY <= ballY - 2;	
			end
		end	
		end		
		
	 wire [7:0] Temp1, Temp2,Temp1D1Seg,Temp1D0Seg,Temp2D1Seg,Temp2D0Seg,RecData,FirstByte;
	 wire [3:0] Temp1D1,Temp1D0,Temp2D1,Temp2D0;
	 wire DONE,StartReading;
	 TwoTemperatureConverter ConvertUnit(Temp1,Temp2,Temp1D1,Temp1D0,Temp2D1,Temp2D0);
	 TopLevelController TopLevelController(go,8'b10010011,8'b10010101,RecData,DONE,StartReading,FirstByte,Temp1,Temp2,reset,clk25);
	 ReadTempI2C ReadUnit(20'd19200,30'd100000000,FirstByte,clk25,reset,StartReading,RecData,DONE,SCL,SDA);
		
		
		
		
		
		
wire digpix1, digpix2;
VGA7SegDisplay(575 , 50, xpos, ypos, Temp1D0, digpix1);
VGA7SegDisplay(600 , 50, xpos, ypos, Temp1D1, digpix2);
//VGA7SegDisplay(input [9:0] digitXPosition, digitYPosition, xpos, ypos,[3:0] digit,digitpixel
// pixel color	
reg [5:0] missTimer;	
wire visible = (xpos < 640 && ypos < 480);
wire top = (visible && ypos <= 10);
wire bottom = (visible && ypos >= 476);
wire left = (visible && xpos <= 8);
wire right = (visible && xpos >= 636);
wire border = (visible && (left || right || top));
wire paddle = (xpos >= paddlePosition+4 && xpos <= paddlePosition+124 && ypos >= 440 && ypos <= 447);
wire ball = (xpos >= ballX && xpos <= ballX+7 && ypos >= ballY && ypos <= ballY+7);
wire background = (visible && !(border || paddle || ball));
wire checkerboard = (xpos[5] ^ ypos[5]);
wire missed = visible && missTimer != 0;

assign red   = { missed || border || paddle, 2'b00 };
assign green = { !missed && (border || paddle || ball || digpix1 || digpix2), 2'b00 };
assign blue  = { !missed && (border || ball), background && checkerboard };//, background && !checkerboard, background && !checkerboard  }; 
		
// ball collision	
always @(posedge clk25) begin
	if (!endOfFrame) begin
		if (ball && (left || right))
			bounceX <= 1;
		if (ball && (top || bottom || (paddle && ballYdir)))
			bounceY <= 1;
		if (ball && bottom)
			begin missTimer <= 63; Play2 <= 1; Cause2 <= 1; end 
		else
			begin Play2 <= 0; Cause2 <= 0; end
	end
	else begin
		//if (ballX == 0 && ballY == 0) begin // cheesy reset handling, assumes initial value of 0
		  if(reset == 1 || (ballX == 0 && ballY == 0)) begin
			Score <= 0;
			ballXdir <= 1;
			ballYdir <= 1;
			bounceX <= 0;
			bounceY <= 0;
		end 
		else begin
			if (bounceX)
				ballXdir <= ~ballXdir;
			if (bounceY)
				ballYdir <= ~ballYdir;			
			bounceX <= 0;
			bounceY <= 0;
			if (missTimer != 0)
				missTimer <= missTimer - 1; 
		end
	end
end
		
endmodule
