`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers: Alex Leversen, Caleb Stoll, Addison Williams
// Campus Mailbox: 1821
// 
// Create Date:    10:25:35 04/29/2015 
// Module Name:    MasterDataUnitI2C 
//
//////////////////////////////////////////////////////////////////////////////////
module MasterDataUnitI2C (WriteLoad, ReadorWrite, ShiftorHold, Select, BaudEnable, SentData,  ReceivedData, SDA, SCL, StartStopAck, Reset, clock, BaudRate, ClockFrequency); 
parameter       LENGTH = 8; 
input WriteLoad, ReadorWrite, ShiftorHold, Select, BaudEnable, StartStopAck; 
inout SDA; 
input Reset, clock; 
output SCL; 
input [LENGTH-1:0]    SentData; 
output [LENGTH-1:0]  ReceivedData; 
input [19:0] BaudRate;  //up to 1,000,000 
input [29:0] ClockFrequency; //up to 1GHz 
assign SCL =  ClockI2C; 
wire ClockI2C; 
BaudRateGeneratorI2C  BaudUnit(BaudEnable, ClockI2C, Reset, clock, BaudRate, ClockFrequency); 
wire ShiftDataIn, ShiftDataOut; 
ShiftRegisterI2C shiftUnit(SentData,clock,Reset, ShiftDataIn,ShiftorHold,WriteLoad,ReceivedData,ShiftDataOut);
SDAmodule SDAUnit(ReadorWrite, Select, ShiftDataOut,StartStopAck,ShiftDataIn,SDA);
endmodule 
