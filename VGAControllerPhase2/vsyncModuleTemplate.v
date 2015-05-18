`timescale 1ns / 1ps
//File: vsyncModuleTemplate.v
//Author: 
//Date: 
//The line increment is synchronized with the hsync pulse
//synch pulse is generated at the end of the line: Active Video-BackPorch-SynchPulse-FrontPorch
//this is how it is done by the video timer of the pong game
//LineEnd and FrameEnd are ANDed to restart frame

module vsyncModuleTemplate(LineEnd, SynchPulse, FrontPorch, ActiveVideo, BackPorch, vsync, yposition, reset, clock);
parameter yresolution=10;
input [yresolution-1:0] SynchPulse, FrontPorch, ActiveVideo, BackPorch;
input reset, clock, LineEnd;
output vsync;
output reg [yresolution-1:0] yposition;
wire [yresolution-1:0] ycount;
wire FrameEnd, LineEndOneShot;
//hsynch starts next line
//ClockedPositiveOneShot RestartUnit(LineEnd, LineEndOneShot, reset, clock);
ClockedNegativeOneShot LineEndUnit(LineEnd, LineEndOneShot, reset, clock);

wire [yresolution-1:0] EndCount=SynchPulse+FrontPorch+ActiveVideo+BackPorch;
//a counter is needed to generate synch signal and y coordinate
always@(ycount, SynchPulse, BackPorch, ActiveVideo, FrontPorch) 
	yposition<=ycount;

assign vsync = ~(ycount>(ActiveVideo+FrontPorch)&&ycount<=(ActiveVideo+SynchPulse+FrontPorch));
//assign vsync = ~(ycount>=(ActiveVideo+BackPorch+FrontPorch)&&ycount<=(ActiveVideo+FrontPorch+SynchPulse+BackPorch));
assign FrameEnd = ycount == EndCount;

UniversalCounter10bitsV5 YPositionCounter(10'd0,10'd0, EndCount, ycount, FrameEnd, FrameEnd||LineEndOneShot, , reset, clock);
endmodule
