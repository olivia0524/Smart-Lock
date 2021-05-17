module keypad(

	input [9:0] buttons,							//0 to 9 input keypad
	input enter,
	input delete,
	input reset,

	output [15:0] password,							//4-digit -> 16-bit password
	output enter_out,
	output delete_out,
	output reg [2:0] counter						//set counter to check 4 digit password
);

	reg [3:0] key_in;
	wire error_w;
	wire keydown;									//check for pressed key
	reg [3:0] reg0, reg1, reg2, reg3;
	reg [3:0] outreg0, outreg1, outreg2, outreg3;	//save the input digits

	
	always @(posedge reset, negedge enter | delete) begin
		counter <= 3'd0;
	end	
	
    //detect keydown
    assign keydown = | buttons;						//OR all bits together to check for 1

	//encoder
	always @(buttons) begin
	   case(buttons)
	   10'h001: key_in = 4'd0;						//0000000001 pressed 0: key_in = 4'b0000
	   10'h002: key_in = 4'd1;						//0000000010 pressed 1: key_in = 4'b0001
	   10'h004: key_in = 4'd2;						//0000000100 pressed 2: key_in = 4'b0010
	   10'h008: key_in = 4'd3;						//0000001000 pressed 3: key_in = 4'b0011
	   10'h010: key_in = 4'd4;
	   10'h020: key_in = 4'd5;
	   10'h040: key_in = 4'd6;
	   10'h080: key_in = 4'd7;
	   10'h100: key_in = 4'd8;
	   10'h200: key_in = 4'd9;						//1000000000 pressed 9: key_in = 4'b1001
	   default: key_in = 4'dX;
	   endcase
	end

	//set up shift register
	always @(posedge keydown) begin					//need keydown signal incase of inputting same digits
        counter <= counter + 1;						
		reg0 <= key_in;								//save 1st digit to reg0
		reg1 <= reg0;
		reg2 <= reg1;//
		reg3 <= reg2;								//1nd digit shifted to reg3, and 4th digit in reg0
	end
	
	always @(posedge enter | delete) begin			//save the input passwords
		outreg3 <= reg3;							//otherwise, if input another digit after pressed enter/delete
		outreg2 <= reg2;							//the origin password would be replaced with new digit
		outreg1 <= reg1;
		outreg0 <= reg0;
	end

	assign password = {outreg3, outreg2, outreg1, outreg0};
	assign enter_out = enter;
	assign delete_out = delete;

endmodule