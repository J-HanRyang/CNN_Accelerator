module CSA#(
	parameter BIT = 16
)(
	input [BIT-1:0] x, y, z,
	output [BIT-1:0] sum, cout
);

reg [BIT-1:0] s, c;
integer i;

always @(*) begin
	for (i = 0; i < BIT; i = i + 1) begin
		s[i] <= x[i] ^ y[i] ^ z[i];
		c[i] <= (x[i] & y[i]) | (y[i] & z[i]) | (z[i] & x[i]);
	end
end

assign sum = s;
assign cout = c;

endmodule


module CSA_25_input#(
	parameter BIT = 16
)(
	input [BIT-1:0] 	in1, in2, in3, in4, in5,
				in6, in7, in8, in9, in10,
				in11, in12, in13, in14, in15,
				in16, in17, in18, in19, in20,
				in21, in22, in23, in24, in25,

	output [BIT-1:0]	result

);

wire [BIT-1:0] sum1[0:7], cout1[0:7], cout1s[0:7];
wire [BIT-1:0] sum2[0:5], cout2[0:5], cout2s[0:5];
wire [BIT-1:0] sum3[0:3], cout3[0:3], cout3s[0:3];
wire [BIT-1:0] sum4[0:1], cout4[0:1], cout4s[0:1];
wire [BIT-1:0] sum5[0:1], cout5[0:1], cout5s[0:1];
wire [BIT-1:0] sum6, cout6, cout6s;
wire [BIT-1:0] final_sum, final_cout, cout;

    // First level
CSA #(.BIT(BIT)) CSA0 (.x(in1), .y(in2), .z(in3), .sum(sum1[0]), .cout(cout1[0]));
CSA #(.BIT(BIT)) CSA1 (.x(in4), .y(in5), .z(in6), .sum(sum1[1]), .cout(cout1[1]));
CSA #(.BIT(BIT)) CSA2 (.x(in7), .y(in8), .z(in9), .sum(sum1[2]), .cout(cout1[2]));
CSA #(.BIT(BIT)) CSA3 (.x(in10), .y(in11), .z(in12), .sum(sum1[3]), .cout(cout1[3]));
CSA #(.BIT(BIT)) CSA4 (.x(in13), .y(in14), .z(in15), .sum(sum1[4]), .cout(cout1[4]));
CSA #(.BIT(BIT)) CSA5 (.x(in16), .y(in17), .z(in18), .sum(sum1[5]), .cout(cout1[5]));
CSA #(.BIT(BIT)) CSA6 (.x(in19), .y(in20), .z(in21), .sum(sum1[6]), .cout(cout1[6]));
CSA #(.BIT(BIT)) CSA7 (.x(in22), .y(in23), .z(in24), .sum(sum1[7]), .cout(cout1[7]));

assign cout1s[0] = cout1[0] << 1;
assign cout1s[1] = cout1[1] << 1;
assign cout1s[2] = cout1[2] << 1;
assign cout1s[3] = cout1[3] << 1;
assign cout1s[4] = cout1[4] << 1;
assign cout1s[5] = cout1[5] << 1;
assign cout1s[6] = cout1[6] << 1;
assign cout1s[7] = cout1[7] << 1;

    // Second level
CSA #(.BIT(BIT)) CSA8 (.x(sum1[0]), .y(sum1[1]), .z(sum1[2]), .sum(sum2[0]), .cout(cout2[0]));
CSA #(.BIT(BIT)) CSA9 (.x(sum1[3]), .y(sum1[4]), .z(sum1[5]), .sum(sum2[1]), .cout(cout2[1]));
CSA #(.BIT(BIT)) CSA10 (.x(sum1[6]), .y(sum1[7]), .z(in25), .sum(sum2[2]), .cout(cout2[2]));

CSA #(.BIT(BIT)) CSA11 (.x(cout1s[0]), .y(cout1s[1]), .z(cout1s[2]), .sum(sum2[3]), .cout(cout2[3]));
CSA #(.BIT(BIT)) CSA12 (.x(cout1s[3]), .y(cout1s[4]), .z(cout1s[5]), .sum(sum2[4]), .cout(cout2[4]));
CSA #(.BIT(BIT)) CSA13 (.x(cout1s[6]), .y(cout1s[7]), .z(16'b0), .sum(sum2[5]), .cout(cout2[5]));

assign cout2s[0] = cout2[0] << 1;
assign cout2s[1] = cout2[1] << 1;
assign cout2s[2] = cout2[2] << 1;

assign cout2s[3] = cout2[3] << 1;
assign cout2s[4] = cout2[4] << 1;
assign cout2s[5] = cout2[5] << 1;

    // Third level
CSA #(.BIT(BIT)) CSA14 (.x(sum2[0]), .y(sum2[1]), .z(sum2[2]), .sum(sum3[0]), .cout(cout3[0]));
CSA #(.BIT(BIT)) CSA15 (.x(sum2[3]), .y(sum2[4]), .z(sum2[5]), .sum(sum3[1]), .cout(cout3[1]));

CSA #(.BIT(BIT)) CSA16 (.x(cout2s[0]), .y(cout2s[1]), .z(cout2s[2]), .sum(sum3[2]), .cout(cout3[2]));
CSA #(.BIT(BIT)) CSA17 (.x(cout2s[3]), .y(cout2s[4]), .z(cout2s[5]), .sum(sum3[3]), .cout(cout3[3]));

assign cout3s[0] = cout3[0] << 1;
assign cout3s[1] = cout3[1] << 1;

assign cout3s[2] = cout3[2] << 1;
assign cout3s[3] = cout3[3] << 1;

    // Forth level
CSA #(.BIT(BIT)) CSA18 (.x(sum3[1]), .y(sum3[2]), .z(cout3s[0]), .sum(sum4[0]), .cout(cout4[0]));
CSA #(.BIT(BIT)) CSA19 (.x(sum3[3]), .y(cout3s[1]), .z(cout3s[2]), .sum(sum4[1]), .cout(cout4[1]));

assign cout4s[0] = cout4[0] << 1;
assign cout4s[1] = cout4[1] << 1;

    // Fifth level
CSA #(.BIT(BIT)) CSA20 (.x(sum3[0]), .y(sum4[0]), .z(cout4s[0]), .sum(sum5[0]), .cout(cout5[0]));
CSA #(.BIT(BIT)) CSA21 (.x(sum4[1]), .y(cout3s[3]), .z(cout4s[1]), .sum(sum5[1]), .cout(cout5[1]));

assign cout5s[0] = cout5[0] << 1;
assign cout5s[1] = cout5[1] << 1;

    // Final level
CSA #(.BIT(BIT)) CSA22 (.x(sum5[0]), .y(sum5[1]), .z(cout5s[0]), .sum(sum6), .cout(cout6));

assign cout6s = cout6 << 1;

CSA #(.BIT(BIT)) CSA23 (.x(sum6), .y(cout6s), .z(cout5s[1]), .sum(final_sum), .cout(final_cout));
	
assign cout = final_cout << 1;

assign result = cout + final_sum;
	
endmodule
