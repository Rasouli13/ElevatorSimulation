`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:50:33 05/07/1023
// Design Name:   elevator
// Module Name:   C:/ISE project/Elevator/Elev2TEST.v
// Project Name:  Elevator
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: elevator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Elev2TEST;

	// Inputs
	reg F1;
	reg F2;
	reg F3;
	reg F4;
	reg F5;
	reg U1;
	reg U2;
	reg U3;
	reg U4;
	reg D2;
	reg D3;
	reg D4;
	reg D5;
	reg S1;
	reg S2;
	reg S3;
	reg S4;
	reg S5;
	reg clk;
	reg rst;

	// Outputs
	wire [1:0] AC;
	wire [2:0] DISP;
	wire Open;

	// Instantiate the Unit Under Test (UUT)
	elevator uut (
		.F1(F1), 
		.F2(F2), 
		.F3(F3), 
		.F4(F4), 
		.F5(F5), 
		.U1(U1), 
		.U2(U2), 
		.U3(U3), 
		.U4(U4), 
		.D2(D2), 
		.D3(D3), 
		.D4(D4), 
		.D5(D5), 
		.S1(S1), 
		.S2(S2), 
		.S3(S3), 
		.S4(S4), 
		.S5(S5), 
		.clk(clk), 
		.rst(rst), 
		.AC(AC), 
		.DISP(DISP), 
		.Open(Open)
	);

	initial begin
		// Initialize Inputs
		F1 = 0;
		F2 = 0;
		F3 = 0;
		F4 = 0;
		F5 = 0;
		U1 = 0;
		U2 = 0;
		U3 = 0;
		U4 = 0;
		D2 = 0;
		D3 = 0;
		D4 = 0;
		D5 = 0;
		S1 = 0;
		S2 = 0;
		S3 = 0;
		S4 = 0;
		S5 = 0;
		clk = 0;
		rst = 0;
		S1=1;
		#10
		
		
		D5 = 1;
		#15;
		
		D5 = 0;
		S1 = 0;	
		S2 = 1;
		F3 = 1;
		#10;
		
		S2 = 0;
		F3 = 0;
		S3 = 1;
		#30;
		
		S4 = 1;
		S3 = 0;
		D2 = 1;
		#10;
		
		D2 = 0;
		F5 = 0;
		#20;

		S5 = 1;
		S4 = 0;
		U2 = 1;
		#10;
		
		U2 = 0;
		U3 = 1;
		#10;
		
		S4 = 1;
		S5 = 0;
		U3 = 0;
		#10;
		
		S4 = 0;
		S3 = 1;
		#10
			
		S2 = 1;
		S3 = 0;
		#10;
		
		rst = 1;
		S1 = 1;
		S2=0;
		#10
		
 		$finish;
		
		
		

	end
      always #5 clk = ~clk;
endmodule

