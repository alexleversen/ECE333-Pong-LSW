`timescale 1ns / 1ps
//File: CRTClockTemplate.v
//Generate 25MHz VGA clock from a SystemClock
//
//ECE333 Spring 2015
//Term Project on Pong game on VGA
//this is a template to be completed by students

module CRTClockTemplate(SystemClock, CRTclock, Reset, Clock);

parameter SystemClockSize=10;
input [SystemClockSize-1:0] SystemClock;

output reg	CRTclock;
input Reset, Clock;

//parameter PixelClock=2;
parameter PixelClock=25;	//MHz
reg [SystemClockSize-1:0] Count;

always @(posedge Clock)
	if(Reset == 1) begin Count <= 0; CRTclock <= 0; end
	else if(Count == ((SystemClock/PixelClock)/2 - 1))
				begin CRTclock <= ~CRTclock; Count <= 0; end
		  else
				Count <= Count+1;

//a counter is needed to generate CRTclock



endmodule

