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
module game(input clk25,
				input reset,
				input [9:0] xpos,
				input [9:0] ypos,
				input rota,
				input rotb,
				output [2:0] red,
				output [2:0] green,
				output [1:0] blue,
				output Play,
				output Cause);
		
// paddle movement		
reg [8:0] paddlePosition;
reg [2:0] quadAr, quadBr;
always @(posedge clk25) quadAr <= {quadAr[1:0], rota};
always @(posedge clk25) quadBr <= {quadBr[1:0], rotb};

always @(posedge clk25)
if(quadAr[2] ^ quadAr[1] ^ quadBr[2] ^ quadBr[1])
begin
	Play = 1; Cause = 0;
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
	Play <= 0;
		
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
		
// pixel color	
reg [5:0] missTimer;	
wire visible = (xpos < 640 && ypos < 480);
wire top = (visible && ypos <= 10);
wire bottom = (visible && ypos >= 476);
wire left = (visible && xpos <= 10);
wire right = (visible && xpos >= 636);
wire border = (visible && (left || right || top));
wire paddle = (xpos >= paddlePosition+4 && xpos <= paddlePosition+124 && ypos >= 440 && ypos <= 447);
wire ball = (xpos >= ballX && xpos <= ballX+7 && ypos >= ballY && ypos <= ballY+7);
wire background = (visible && !(border || paddle || ball));
wire checkerboard = (xpos[5] ^ ypos[5]);
wire missed = visible && missTimer != 0;

assign red   = { missed || border || paddle, 2'b00 };
assign green = { !missed && (border || paddle || ball), 2'b00 };
assign blue  = { !missed && (border || ball), background && checkerboard };//, background && !checkerboard, background && !checkerboard  }; 
		
// ball collision	
always @(posedge clk25) begin
	if (!endOfFrame) begin
		if (ball && (left || right))
			bounceX <= 1;
		if (ball && (top || bottom || (paddle && ballYdir)))
			bounceY <= 1;
		if (ball && bottom)
			missTimer <= 63;
	end
	else begin
		//if (ballX == 0 && ballY == 0) begin // cheesy reset handling, assumes initial value of 0
		  if(reset == 1 || (ballX == 0 && ballY == 0)) begin
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