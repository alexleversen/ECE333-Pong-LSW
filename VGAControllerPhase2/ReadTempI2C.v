`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:06 05/12/2015 
// Design Name: 
// Module Name:    ReadTempI2C 
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
module ReadTempI2C(
    input [19:0] BaudRate,
    input [29:0] ClockFrequency,
    input [7:0] FirstByte,
    input Clock,
    input Reset,
    input Start,
    output [7:0] RecData,
    output Done,
    output SCL,
    inout SDA
    );
	 
wire BaudEnable, ClockI2C, WriteLoad,ReadorWrite, ShiftHold, Select;

BaudRateGeneratorI2C BaudUnit(BaudEnable,ClockI2C,Reset,Clock,BaudRate,ClockFrequency);

ControllerReadTemp controllerUnit(Start, SDA, WriteLoad, ReadorWrite, ShiftHold, Select, BaudEnable, StartStopAck, Done, Reset, ClockI2C, Clock);

MasterDataUnitI2C DataUnit(WriteLoad, ReadorWrite, ShiftHold, Select, BaudEnable, FirstByte, RecData, SDA, SCL, StartStopAck, Reset, Clock, BaudRate, ClockFrequency); 
endmodule
