module saver_tb;
	reg clk;
	reg start;
	reg reset;
	reg [16:0]data_in;

	wire [1:0]read_addr;
	wire [1:0]save_addr;
	wire finish;
	wire save_start;
	wire error;


	saver saver_inst (
		.clk(clk),
		.start(start),
		.reset(reset),
		.data_in(data_in),

		.read_addr(read_addr),
		.save_addr(save_addr),
		.finish(finish),
		.save_start(save_start),
		.error(error)
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
		#20;

		reset = 0;
		start = 1;
		data_in = 17'h1FFFF;
		#20;
        
        start = 0;
		data_in = 17'h0FFFF;
		#80;
		
		start = 1;
		data_in = 17'h1FFFF;
		#20;
		
		start = 0;
		data_in = 17'h1AAAA;
		#20;
		
		data_in = 17'h15555;
		#20;

    $finish;
	end

endmodule