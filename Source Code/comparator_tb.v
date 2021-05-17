module comparator_tb;
	reg clk;
	reg start;
	reg reset;
	reg [16:0]data_in;
	reg compare_done, compare_match;		//result from pwChecker

	wire [1:0]read_addr;
	wire [1:0]del_addr;
	wire compare_start;						//signal telling pwCheck to compare
	wire finish;
	wire match;								//signal telling RF to delete


	comparator comparator_inst (
		.clk(clk),
		.start(start),
		.reset(reset),
		.data_in(data_in),
		.compare_done(compare_done),
		.compare_match(compare_match),

		.read_addr(read_addr),
		.del_addr(del_addr),
		.compare_start(compare_start),
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
		reset = 1;
		start = 0;
		compare_done = 0;
		#20;

		reset = 0;
		start = 1;
		data_in = 17'h1FFFF;
		#20;									//wait 3 cycles for comparation
		start = 0;
		#40;

		compare_done = 1;
		compare_match = 0;
		#10;
		data_in = 17'h11111;
		#10;
		
		compare_done = 0;
		#80;

		compare_done = 1;
		compare_match = 1;
		#40;
		
		start = 1;
		data_in = 17'h01111;
		#20;
		start = 0;
		#40;
		
		data_in =17'h02222;
		#40;

    $finish;
	end


endmodule