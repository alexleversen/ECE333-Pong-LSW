`timescale 1ns / 1ps
//Music score in RAM
module MusicScore(Cause, ReadOrWrite, Address, KeyInput, KeyOutput, TimeInput, TimeOutput,Clock, Reset);
input ReadOrWrite, Clock, Reset;
input [1:0] Cause;
parameter DataLength=4;
input [DataLength-1:0] KeyInput, TimeInput;
output reg [DataLength-1:0] KeyOutput, TimeOutput;
parameter AddressBits=5;
input [AddressBits-1:0] Address;
parameter MemorySize=20;

reg [DataLength-1:0] Keys1 [0:MemorySize-1];
reg [DataLength-1:0] Keys2 [0:MemorySize-1];
reg [DataLength-1:0] Times1 [0:MemorySize-1];
reg [DataLength-1:0] Times2 [0:MemorySize-1];

always@(posedge Clock or posedge Reset)
	if(Reset==1) begin
		begin
		Keys1[0]<=1; Times1[0]<=1;
		Keys1[1]<=0; Times1[1]<=0;
		
		Keys2[0]<=3; Times2[0]<=1;
		Keys2[1]<=0; Times2[1]<=0;
		end
	end 
	else if (ReadOrWrite==1) begin	//read memory
		if(Cause == 2'b10) 
			begin KeyOutput<=Keys1[Address]; TimeOutput<=Times1[Address]; end
		if(Cause == 2'b01)
			begin KeyOutput<=Keys2[Address]; TimeOutput<=Times2[Address]; end
		end
	else begin
		Keys1[Address]<=KeyInput; Times1[Address]<=TimeInput;
	end
endmodule
