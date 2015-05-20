`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:08:13 05/13/2015 
// Design Name: 
// Module Name:    TwoTemperatureConverter 
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
module TwoTemperatureConverter(
    input [7:0] Temp1,
    input [7:0] Temp2,
    output [3:0] Temp1D1,
    output [3:0] Temp1D0,
    output [3:0] Temp2D1,
    output [3:0] Temp2D0
    );

assign Temp1D1 = Temp1/10;
assign Temp1D0 = Temp1%10;
assign Temp2D1 = Temp2/10;
assign Temp2D0 = Temp2%10;

endmodule
