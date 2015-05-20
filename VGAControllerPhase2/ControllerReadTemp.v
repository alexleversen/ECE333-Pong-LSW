`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Alex Leverson, Caleb Stoll, and Addison Williams
// 
// Create Date:    08:36:57 05/06/2015 
// Design Name: 
// Module Name:    ControllerReadTemp 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Read Temperature Controller I2C
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ControllerReadTemp(Go, SDA, WriteLoad, RW, ShiftHold, Select, BaudEnable, StartStopAck, DONE, Reset, ClockI2C, Clock);
input Clock, ClockI2C, Reset, SDA, Go;
output reg BaudEnable, DONE, RW, Select, ShiftHold, StartStopAck, WriteLoad;
wire OneShotNegative, OneShotPositive;
reg [3:0] State, NextState, DataCounter;
parameter InitialState = 0, StartState = 1, LoadState = 2, WriteState = 3;
parameter ACKWriteState = 4, CheckState = 5, ReadState = 6, ACKReadState = 7;
parameter TransitState = 8, StopState = 9;
reg ClearTimer;

ClockedNegativeOneShot OneShotNeg(ClockI2C, OneShotNegative, Reset, Clock);
ClockedPositiveOneShot OneShotPos(ClockI2C, OneShotPositive, Reset, Clock);
reg ACKbit;

always @(posedge Clock)
	if(Reset == 1) begin State <= InitialState; ACKbit <= 1; end
	else begin State <= NextState;
					if(OneShotPositive == 1) ACKbit <= SDA; else ACKbit <= ACKbit; end
					
always @(posedge Clock)
	if(Reset == 1) begin DataCounter <= 4'd9; end
	else
	case(State)
	LoadState: if(OneShotNegative == 1) DataCounter <= DataCounter - 1'b1;
					else DataCounter <= DataCounter;
	WriteState: if(OneShotNegative == 1) DataCounter <= DataCounter - 1'b1;
					else DataCounter <= DataCounter;
	ReadState: if(OneShotPositive == 1) DataCounter <= DataCounter - 1'b1;
					else DataCounter <= DataCounter;
	default: DataCounter <= 4'd9;
	endcase
	
always @(State, Go, Timeout, ClockI2C, OneShotPositive,DataCounter,SDA)
	case(State)
	InitialState: if((Go == 1) && (ClockI2C == 1)) NextState <= StartState; else NextState <= InitialState;
	StartState: if(Timeout == 1) NextState <= LoadState; else NextState <= StartState;
	LoadState: if((DataCounter < 9) /*&& (Timeout == 1)*/) NextState <= WriteState; else NextState <= LoadState;
	WriteState: if(DataCounter == 0) NextState <= ACKWriteState; else NextState <= WriteState;
	ACKWriteState: if(OneShotPositive == 1) NextState <= CheckState; else NextState <= ACKWriteState;
	CheckState: if(SDA == 0) NextState <= ReadState; else NextState <= StartState;
	ReadState: if(DataCounter == 1) NextState <= ACKReadState; else NextState <= ReadState;
	ACKReadState: if(OneShotPositive == 1) NextState <= TransitState; else NextState <= ACKReadState;
	TransitState: if(Timeout == 1) NextState <= StopState; else NextState <= TransitState;
	StopState: if(Timeout == 1) NextState <= InitialState; else NextState <= StopState;
	default: NextState <= InitialState;
	endcase
	
always @(posedge Clock)
	case(State)
	InitialState: begin BaudEnable <= 0; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 1; DONE = 0; ClearTimer <= 0; end
	StartState:   begin BaudEnable <= 0; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 0; DONE = 0; ClearTimer <= 1; end
	LoadState:    begin BaudEnable <= 1; RW <= 0; WriteLoad <= 1; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 0; DONE = 0; ClearTimer <= 1; end
	WriteState:   begin BaudEnable <= 1; RW <= 0; WriteLoad <= 0; Select <= 1; ShiftHold <= OneShotNegative; StartStopAck <= 0; DONE = 0; ClearTimer <= 0; end
	ACKWriteState:begin BaudEnable <= 1; RW <= 1; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 0; DONE = 0; ClearTimer <= 0; end
	CheckState:   begin BaudEnable <= 1; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 1; DONE = 0; ClearTimer <= 0; end
	ReadState:    begin BaudEnable <= 1; RW <= 1; WriteLoad <= 0; Select <= 1; ShiftHold <= OneShotPositive; StartStopAck <= 0; DONE = 0; ClearTimer <= 0; end
	ACKReadState: begin BaudEnable <= 1; RW <= 1; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 0; DONE = 0; ClearTimer <= 0; end
	TransitState: begin BaudEnable <= 0; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 0; DONE = 0; ClearTimer <= 1; end
	StopState:    begin BaudEnable <= 0; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 1; DONE = 1; ClearTimer <= 1; end
	default:      begin BaudEnable <= 0; RW <= 0; WriteLoad <= 0; Select <= 0; ShiftHold <= 0; 					StartStopAck <= 1; DONE = 0; ClearTimer <= 0; end
	endcase
		
DelayLoop2 Timer(ClearTimer, Timeout, Clock);

endmodule
