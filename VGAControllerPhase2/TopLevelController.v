`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Addison Williams, Alex Leversen, Caleb Stoll
// 
// Create Date:    21:46:48 05/12/2015 
// Design Name: 
// Module Name:    TopLevController 
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
module TopLevelController(
    input Start,
    input [7:0] FirstChip,
    input [7:0] SecondChip,
    input [7:0] RecData,
    input Done,
    output reg StartReading,
    output reg [7:0] FirstByte,
    output reg [7:0] FirstTemp,
    output reg [7:0] SecondTemp,
    input Reset,
    input Clock
    );
	 
reg [3:0] nState;
reg [3:0] State; 
reg ClearTimer;
wire Timout;

always @(posedge Clock)
if (Reset==1) State<=0; else State<=nState;

always@(*)
case(State)
	0: begin if (Start==1) nState<=1; else if(Start==0) nState<=0; end
	1: begin nState<=2; end
	2: begin if (Timeout==1) nState<=3; else nState<=2; end
	3: begin if (Done==1) nState<=4; else nState<=3; end
	4: begin nState <= 5; end
	5: begin nState <= 6; end
	6: begin if (Timeout==1) nState<=7; else nState<=6; end
	7: begin if (Done==1) nState<=8; else nState<=7; end
	8: begin nState<=1;end
	default: begin nState<=0; end
endcase

always @(posedge Clock)
case(State)
	0: 		begin StartReading<=0; FirstByte<=0;          FirstTemp<=0; 		  SecondTemp<=0;          ClearTimer<=0; end
	1: 		begin StartReading<=1; FirstByte<=FirstChip;  FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=0; end
	2:			begin StartReading<=1; FirstByte<=FirstChip;  FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=1; end
	3: 		begin StartReading<=0; FirstByte<=FirstChip;  FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=0; end
	4: 		begin StartReading<=0; FirstByte<=FirstChip;  FirstTemp<=RecData;   SecondTemp<=SecondTemp; ClearTimer<=0; end
	5: 		begin StartReading<=1; FirstByte<=SecondChip; FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=0; end
	6: 		begin StartReading<=1; FirstByte<=SecondChip; FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=1; end
	7: 		begin StartReading<=0; FirstByte<=SecondChip; FirstTemp<=FirstTemp; SecondTemp<=SecondTemp; ClearTimer<=0; end
	8: 		begin StartReading<=0; FirstByte<=SecondChip; FirstTemp<=FirstTemp; SecondTemp<=RecData;    ClearTimer<=0; end
	default: begin StartReading<=0; FirstByte<=0;          FirstTemp<=0; 		  SecondTemp<=0;          ClearTimer<=0; end
endcase

DelayLoop2 Timer(ClearTimer, Timeout, Clock);

endmodule
