`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineers: Alex Leversen, Caleb Stoll, Addison Williams
// Campus Mailbox: 1821
// 
// Create Date:    10:32:06 04/29/2015 
// Module Name:    BaudRateGenerator 
//
//////////////////////////////////////////////////////////////////////////////////
module BaudRateGeneratorI2C(
    input Enable,
    output reg ClockI2C,
    input Reset,
    input Clock,
    input [19:0] BaudRate,
    input [29:0] ClockFrequency
    );
 
reg [15:0] 	baud_count;

always @ (posedge Clock)
	if(Reset==1) begin baud_count<=1'b0;
		ClockI2C<=1'b1;
		end
	else if (Enable==0)
		begin
			baud_count<=1'b0;
			ClockI2C<=1'b1;
		end
	else if (baud_count==ClockFrequency/(BaudRate*2)-1)
		begin
		baud_count<=1'b0;
		ClockI2C<=~ClockI2C;
		end
	else
		begin
		baud_count<=baud_count+1'b1;
		ClockI2C<=ClockI2C;
		end
		

endmodule


//module BaudRateGenerator (ClockI2C, Reset, clk55MHz, BaudRate, Frequency);
//input Reset, clk55MHz;
//input [19:0] BaudRate;  //up to 1,000,000
//input [29:0] Frequency; //up to 1GHz

//output reg  ClockI2C; 
//reg [15:0] 	baud_count;
//
// always @(posedge Clock)
//      if(Reset==1) begin baud_count <= 1'b0;
//      	     	ClockI2C <= 1'b1;
//					end
//	//	else if (baud_count == 8) 
//	else 
//		begin
//		if(Enable==1)
//			begin
//				if (baud_count == ClockFrequency/(BaudRate*16)) 
//					begin
//							baud_count <= 1'b0;
//							ClockI2C <= 1'b0;
//					end
//				else
//					begin
//							baud_count <= baud_count + 1'b1;
//							ClockI2C <= 1'b1;
//					end
//			end
//		else
//			begin
//				baud_count <= 1'b0;
//				ClockI2C <= 1'bz;
//			end
//		end
//
//endmodule
