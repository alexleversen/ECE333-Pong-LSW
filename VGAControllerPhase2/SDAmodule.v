`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers: Alex Leversen, Caleb Stoll, Addison Williams
// Campus Mailbox: 1821
// 
// Create Date:    10:47:39 04/29/2015 
// Module Name:    SDAmodule 
//
//////////////////////////////////////////////////////////////////////////////////
module SDAmodule(
	input ReadOrWrite, 
	input Select, 
	input ShiftOut,
	input StartStopAck,
	output ShiftIn,
	inout SDA
	);
	
	assign ShiftIn=SDA;

assign SDA=(ReadOrWrite) ? 1'bZ:((Select) ? ShiftOut:StartStopAck);

endmodule
/*	
always @*
if (ReadOrWrite==1) begin ShiftIn <= 1'bz; end
else 
		begin
		if (Select==1) begin ShiftIn <= ShiftOut; end 
		if (Select==0)  begin ShiftIn <= StartStopAck; end
		end 
*/