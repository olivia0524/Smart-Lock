`timescale 1 ns/10 ps

module keypad_tb;

	reg [9:0] buttons;
	reg enter;
	reg delete;
	reg reset;

	wire [15:0] password;
	wire enter_out;
	wire delete_out;
	wire [2:0] counter;

	keypad keypad_inst (
		.buttons(buttons),
		.enter(enter),
		.delete(delete),
		.reset(reset),
		
		.password(password),
		.enter_out(enter_out),
		.delete_out(delete_out),
		.counter(counter)
		);

	initial
	begin
		// 4-digit & enter = 1
		reset = 1;
		buttons = 10'h000;
		#20;

		reset = 0;
		buttons[0] = 1;
		#20;

		buttons[0] = 0;
		#10;
		buttons[3] = 1;
		#10;

		buttons[3] = 0;
		#10;
		buttons[5] = 1;
		#10;

		buttons[5] = 0;
		#10;
		buttons[8] = 1;
		#10;

		buttons[8] = 0;
		#10;
		enter = 1;
		#10;

		enter = 0;
		#20;


		// 4-digit & delete = 1
		reset = 1;
		#20;

		reset = 0;
		buttons[1] = 1;
		#20;

		buttons[1] = 0;
		#10;
		buttons[2] = 1;
		#10;

		buttons[2] = 0;
		#10;
		buttons[6] = 1;
		#10;

		buttons[6] = 0;
		#10;
		buttons[9] = 1;
		#10;

		buttons[9] = 0;
		#10;
		delete = 1;
		#10;

		delete = 0;
		#20;


		// 3-digit & enter = 1
		reset = 1;
		#20;

		reset = 0;
		buttons[0] = 1;
		#20;

		buttons[0] = 0;
		#10;
		buttons[3] = 1;
		#10;

		buttons[3] = 0;
		#10;
		buttons[5] = 1;
		#10;

		buttons[5] = 0;
		#10;
		enter = 1;
		#10;

		enter = 0;
		#20;


		// 2-digit & delete = 1
		reset = 1;
		#20;

		reset = 0;
		buttons[4] = 1;
		#20;

		buttons[4] = 0;
		#10;
		buttons[7] = 1;
		#10;

		buttons[7] = 0;
		#10;
		delete = 1;
		#20;

		delete = 0;
		#20;
		
		$monitor($time, "%h,%b,%b,%d", password, enter_out, delete_out, counter);

    $finish;
	end
		
endmodule






