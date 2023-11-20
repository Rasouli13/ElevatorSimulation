module register (
    input in,
    input clr,
    output reg out
);
    initial begin
        out = 0;
    end
	
    always @(in or clr) begin
        if (clr)
            out = 0;
        else if (in)
            out = 1;
    end
endmodule



module elevator(
	input F1,F2,F3,F4,F5,
	input U1,U2,U3,U4,
	input D2,D3,D4,D5,
	input S1,S2,S3,S4,S5,
	input clk,rst,
	output [1:0] AC,
	output [2:0] DISP,
	output Open
);

reg [2:0] Timer;
reg [3:0] state;

//name of states
`define FirstFloor			4'd1
`define SecondFloor			4'd2
`define ThirdFloor 			4'd3
`define FourthFloor 		4'd4
`define FifthFloor 			4'd5

`define OpenOnUp 			4'd6
`define OpenOnDown 			4'd7
`define GoUp	 			4'd8
`define GoDown 				4'd9


// A register for each button
wire _F1, _F2, _F3, _F4, _F5;
wire _U1, _U2, _U3, _U4;
wire _D2, _D3, _D4, _D5;
reg clrF1, clrF2, clrF3, clrF4, clrF5;
reg clrU1, clrU2, clrU3, clrU4;
reg clrD2, clrD3, clrD4, clrD5;

register regF1(.in(F1), .clr(clrF1), .out(_F1));
register regF2(.in(F2), .clr(clrF2), .out(_F2));
register regF3(.in(F3), .clr(clrF3), .out(_F3));
register regF4(.in(F4), .clr(clrF4), .out(_F4));
register regF5(.in(F5), .clr(clrF5), .out(_F5));

register regU1(.in(U1), .clr(clrU1), .out(_U1));
register regU2(.in(U2), .clr(clrU2), .out(_U2));
register regU3(.in(U3), .clr(clrU3), .out(_U3));
register regU4(.in(U4), .clr(clrU4), .out(_U4));

register regD2(.in(D2), .clr(clrD2), .out(_D2));
register regD3(.in(D3), .clr(clrD3), .out(_D3));
register regD4(.in(D4), .clr(clrD4), .out(_D4));
register regD5(.in(D5), .clr(clrD5), .out(_D5));
// A register for each button

//register for Sensors
wire _S1, _S2, _S3, _S4, _S5;
reg clrS1, clrS2, clrS3, clrS4, clrS5;
register regS1(.in(S1), .clr(clrS1), .out(_S1));
register regS2(.in(S2), .clr(clrS2), .out(_S2));
register regS3(.in(S3), .clr(clrS3), .out(_S3));
register regS4(.in(S4), .clr(clrS4), .out(_S4));
register regS5(.in(S5), .clr(clrS5), .out(_S5));
//register for Sensors

//all buttons of a floor
wire B1, B2, B3, B4, B5;
assign B1 = _F1 | _U1;
assign B2 = _F2 | _U2 | _D2;
assign B3 = _F3 | _U3 | _D3;
assign B4 = _F4 | _U4 | _D4;
assign B5 = _F5 | _D5;
//all buttons of a floor

wire NB1, NB2, NB3, NB4, NB5;
assign NB1 = (!B2 && !B3 && !B4 && !B5) || B1;
assign NB2 = (!B1 && !B3 && !B4 && !B5) || B2;
assign NB3 = (!B1 && !B2 && !B4 && !B5) || B3;
assign NB4 = (!B1 && !B2 && !B3 && !B5) || B4;
assign NB5 = (!B1 && !B2 && !B3 && !B4) || B5;


//up and inside
wire FU2, FU3, FU4;
assign FU2 = _F2 | U2;
assign FU3 = _F3 | U3;
assign FU4 = _F4 | U4;
//up and inside

//down and inside
wire FD2, FD3, FD4;
assign FD2 = _F2 | D2;
assign FD3 = _F3 | D3;
assign FD4 = _F4 | D4;
//down and inside

wire goingDown;
assign goingDown = (_S4 && (B3 || B2 || B1)) ? 1'b1 : ((_S3 && (B2 || B1)) ? 1'b1 : ((_S2 && B1) ? 1'b1 : 1'b0));

assign DISP = (S1) ? 3'd1 : ((S2) ? 3'd2 : ((S3) ? 3'd3 : ((S4) ? 3'd4 : ((S5) ? 3'd5 : 3'd0))));

assign AC = (state == `GoUp) ? 2'd1 : ((state == `GoDown) ? 2'd2 : 2'd0);

assign  Open = (state == `GoUp) ? 1'b0 : ((state == `GoDown) ? 1'b0 : 1'b1);

initial begin
	clrF1 <= 0; clrF2 <= 0; clrF3 <= 0; clrF4 <= 0; clrF5 <= 0;
    clrU1 <= 0; clrU2 <= 0; clrU3 <= 0; clrU4 <= 0;
    clrD2 <= 0; clrD3 <= 0; clrD4 <= 0;	clrD5 <= 0;
	clrS1 <= 0; clrS2 <= 0; clrS3 <= 0; clrS4 <= 0; clrS5 <= 0;
	Timer <= 3'd0;
	state <= `FirstFloor;
end

always @(posedge clk) begin//Timer
    if (state == `OpenOnUp || state == `OpenOnDown)
        Timer = Timer + 1'b1;
    else
        Timer = 3'd0;
end

always @(posedge clk or posedge rst) begin
	if(rst) begin
		{clrF1, clrF2, clrF3, clrF4, clrF5} = 5'b11111;
		{clrU1, clrU2, clrU3, clrU4} = 4'b1111;
		{clrD2, clrD3, clrD4, clrD5} = 4'b1111;
		
		state <= `FirstFloor;
	end
	else begin 
		case(state)
			`FirstFloor: begin
				{clrF1, clrU1} = 2'b11;
				{clrS2, clrS3, clrS4, clrS5} = 4'b1111;
				if(S1 && (B2 || B3 || B4 || B5))
					state <= `OpenOnUp;
				$display("1st");
			end
				
			`SecondFloor: begin
				{clrF2, clrU2, clrD2} = 3'b111;
				{clrS1, clrS3, clrS4, clrS5} = 4'b1111;
				if(S2 && (B3 || B4 || B5) && !goingDown)
					state <= `OpenOnUp;
				else if(S2 && B1)
					state <= `OpenOnDown;
				$display("2nd");

			end

			`ThirdFloor: begin
				{clrF3, clrU3, clrD3} = 3'b111;
				{clrS2, clrS1, clrS4, clrS5} = 4'b1111;
				if(S3 && (B4 || B5) && !goingDown)begin
					state <= `OpenOnUp;
					end
				else if(S3 && (B1 || B2))
					state <= `OpenOnDown;
				$display("3rd");

			end

			`FourthFloor: begin
				{clrF4, clrU4, clrD4} = 3'b111;
				{clrS2, clrS3, clrS1, clrS5} = 4'b1111;
				if(S4 && B5 && !goingDown)
					state <= `OpenOnUp;
				else if(S4 && (B1 || B2 || B3))
					state <= `OpenOnDown;	
				$display("4th");
			end

			`FifthFloor: begin
				{clrF5, clrD5} = 2'b11;
				{clrS2, clrS3, clrS4, clrS1} = 4'b1111;
				if(S5 && (B1 || B2 || B3 || B4))
					state <= `OpenOnDown;
				$display("5th");
			end

			`OpenOnUp: begin
				{clrF1, clrF2, clrF3, clrF4, clrF5} = 5'b00000;
				{clrU1, clrU2, clrU3, clrU4} = 4'b0000;
				{clrD2, clrD3, clrD4, clrD5} = 4'b0000;
				
				state <= `GoUp;
				$display("OOU");

			end

			`OpenOnDown: begin
				{clrF1, clrF2, clrF3, clrF4, clrF5} = 5'b00000;
				{clrU1, clrU2, clrU3, clrU4} = 4'b0000;
				{clrD2, clrD3, clrD4, clrD5} = 4'b0000;
				
					state <= `GoDown;
				$display("OOD");
			end

			`GoUp: begin
				if(S2 && (FU2 || NB2))
					state <= `SecondFloor;
				else if(S3 && (FU3 || NB3))
					state <= `ThirdFloor;
				else if(S4 && (FU4 || NB4))
					state <= `FourthFloor;
				else if(S5 && (B5 || NB5))
					state <= `FifthFloor;
				$display("GU");	
				
			end

			`GoDown: begin
				if(S1 && (B1 || NB1))
					state <= `FirstFloor;
				else if(S2 && (FD2 || NB2))
					state <= `SecondFloor;
				else if(S3 && (FD3))
					state <= `ThirdFloor;
				else if(S4 && (FD4 || NB4))
					state <= `FourthFloor;
				$display("GD");
			end
		endcase
	end
end



endmodule