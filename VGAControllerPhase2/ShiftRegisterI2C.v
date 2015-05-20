`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers: Alex Leversen, Caleb Stoll, Addison Williams
// Campus Mailbox: 1821
// 
// Create Date:    10:47:01 04/29/2015 
// Module Name:    ShiftRegisterI2C 
//
//////////////////////////////////////////////////////////////////////////////////
module ShiftRegisterI2C(
	 input [7:0] SentData,
	 input Clock,
	 input Reset,
	 input ShiftIn,
	 input ShiftOrHold,
	 input WriteLoad,
	 output reg [7:0] RecData,
	 output reg ShiftOut
    );


always @(posedge Clock)
begin 
if (Reset==1) RecData <=8'd0;
else if (WriteLoad==1) RecData <= SentData;
else if (ShiftOrHold==0) RecData <= RecData;
else begin 
		RecData <= {RecData[6:0],ShiftIn};
	  end
end

always @ (RecData)
ShiftOut<=RecData[7];
endmodule
