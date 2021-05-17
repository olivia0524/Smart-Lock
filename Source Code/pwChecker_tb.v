`timescale 1 ns/10 ps

module pwChecker_tb;

	reg clk;
	reg start;
	reg [15:0]data1;
	reg [15:0]data2;

	wire finish;
	wire match;


	pwChecker  pwChecker_inst (
		.clk(clk),
		.start(start),
		.data1(data1),
		.data2(data2),

		.finish(finish),
		.match(match)
		);


	
	always
	begin
	clk = 1;
	#10;
	clk = 0;
	#10;
	end

	initial
	begin
		start = 0;
		#20;

		start = 1;
		data1 = 16'hF1F1;		//test for different passwords
		data2 = 16'h1F1F;
		#20;

		start = 0;
		#60;

		start = 1;
		data1 = 16'hF1F1;		//test for matched passwords
		data2 = 16'hF1F1;
		#20;

		start = 0;
		#60;
		
		$monitor($time, "%b, %b", finish, match);
		
	$finish;
	end


endmodule