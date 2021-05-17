module pwChecker (
	
	input clk,
	input start,
	input [15:0]data1,						//data from keypad
	input [15:0]data2,				 		//data (without available bit) from register file

	output reg finish,
	output match
	
);

	reg [15:0]data1_Q1, data2_Q1;			//1st DFF output
	reg [15:0]data_Q2;                    	//2nd DFF output
	reg [3:0]data_Q3;                     	//3rd DFF output
	reg [1:0]counter;                     	//set counter = 3 for finished signal checking
	reg in_progress;						//when not inprogress, counter hold still

	wire [15:0]xnor_out;                   	//XNOR gate output, output 1 for same, 0 for different	
	wire [3:0]and_out;                    	//AND gate output

	assign xnor_out[15] = ~(data1_Q1[15] ^ data2_Q1[15]);
	assign xnor_out[14] = ~(data1_Q1[14] ^ data2_Q1[14]);
	assign xnor_out[13] = ~(data1_Q1[13] ^ data2_Q1[13]);
	assign xnor_out[12] = ~(data1_Q1[12] ^ data2_Q1[12]);
	assign xnor_out[11] = ~(data1_Q1[11] ^ data2_Q1[11]);
	assign xnor_out[10] = ~(data1_Q1[10] ^ data2_Q1[10]);
	assign xnor_out[9] = ~(data1_Q1[9] ^ data2_Q1[9]);
	assign xnor_out[8] = ~(data1_Q1[8] ^ data2_Q1[8]);
	assign xnor_out[7] = ~(data1_Q1[7] ^ data2_Q1[7]);
	assign xnor_out[6] = ~(data1_Q1[6] ^ data2_Q1[6]);
	assign xnor_out[5] = ~(data1_Q1[5] ^ data2_Q1[5]);
	assign xnor_out[4] = ~(data1_Q1[4] ^ data2_Q1[4]);
	assign xnor_out[3] = ~(data1_Q1[3] ^ data2_Q1[3]);
	assign xnor_out[2] = ~(data1_Q1[2] ^ data2_Q1[2]);
	assign xnor_out[1] = ~(data1_Q1[1] ^ data2_Q1[1]);
	assign xnor_out[0] = ~(data1_Q1[0] ^ data2_Q1[0]);


	assign and_out[0] = &data_Q2[3:0];    	//AND all the bits together, 1 for same, 0 for different
	assign and_out[1] = &data_Q2[7:4];
	assign and_out[2] = &data_Q2[11:8];
	assign and_out[3] = &data_Q2[15:12];

	assign match = &data_Q3;
	
	//DFF1
	always @(posedge start) begin
        data1_Q1 <= data1;
        data2_Q1 <= data2;
        finish <= 0;
        counter <= 0;
        in_progress <= 1;
	end

	//DFF2
	always @(posedge clk) begin
	   if (counter == 3) begin
	       finish <= 1;
	       in_progress <= 0;
	   end
	   else
	       finish <= 0;
        
        if (in_progress) begin
            data_Q2 <= xnor_out;            //operate at posedge clk
            data_Q3 <= and_out;
            counter <= counter + 1;			//counter +1 after each clk cyc only when in progress
        end
	end



endmodule