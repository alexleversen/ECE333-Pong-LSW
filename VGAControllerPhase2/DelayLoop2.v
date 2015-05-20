`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:42:02 03/17/2015 
// Design Name: 
// Module Name:    DelayLoop 
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
module DelayLoop2(MR, Timeout, Clock);
parameter EndCount = 10000; //delay time (clock cycles)
parameter NumberOfBits = 27;
input MR, Clock;
output reg Timeout;
reg [NumberOfBits-1:0] count;

always @(count)
	if(count == EndCount) Timeout <= 1;
	else Timeout <= 0;

always @(posedge Clock)
	if(MR == 0) begin count <= 0; end
	else if(count == EndCount) count <= 0;
	else count <= count + 1'b1;
	
endmodule
