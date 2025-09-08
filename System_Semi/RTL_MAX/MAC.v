module MAC
#(
	parameter DATA_BW = 8
)(
	input CLK,
	input RSTN,
	input EN,

	input signed [DATA_BW-1:0] IFMAP_DATA_IN1,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN2,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN3,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN4,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN5,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN6,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN7,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN8,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN9,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN10,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN11,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN12,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN13,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN14,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN15,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN16,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN17,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN18,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN19,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN20,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN21,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN22,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN23,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN24,
	input signed [DATA_BW-1:0] IFMAP_DATA_IN25,

	input signed [DATA_BW-1:0] FILTER_DATA_IN1,
	input signed [DATA_BW-1:0] FILTER_DATA_IN2,
	input signed [DATA_BW-1:0] FILTER_DATA_IN3,
	input signed [DATA_BW-1:0] FILTER_DATA_IN4,
	input signed [DATA_BW-1:0] FILTER_DATA_IN5,
	input signed [DATA_BW-1:0] FILTER_DATA_IN6,
	input signed [DATA_BW-1:0] FILTER_DATA_IN7,
	input signed [DATA_BW-1:0] FILTER_DATA_IN8,
	input signed [DATA_BW-1:0] FILTER_DATA_IN9,
	input signed [DATA_BW-1:0] FILTER_DATA_IN10,
	input signed [DATA_BW-1:0] FILTER_DATA_IN11,
	input signed [DATA_BW-1:0] FILTER_DATA_IN12,
	input signed [DATA_BW-1:0] FILTER_DATA_IN13,
	input signed [DATA_BW-1:0] FILTER_DATA_IN14,
	input signed [DATA_BW-1:0] FILTER_DATA_IN15,
	input signed [DATA_BW-1:0] FILTER_DATA_IN16,
	input signed [DATA_BW-1:0] FILTER_DATA_IN17,
	input signed [DATA_BW-1:0] FILTER_DATA_IN18,
	input signed [DATA_BW-1:0] FILTER_DATA_IN19,
	input signed [DATA_BW-1:0] FILTER_DATA_IN20,
	input signed [DATA_BW-1:0] FILTER_DATA_IN21,
	input signed [DATA_BW-1:0] FILTER_DATA_IN22,
	input signed [DATA_BW-1:0] FILTER_DATA_IN23,
	input signed [DATA_BW-1:0] FILTER_DATA_IN24,
	input signed [DATA_BW-1:0] FILTER_DATA_IN25,

	output signed [2*DATA_BW-1:0] MUL_DATA_OUT
);

reg signed [DATA_BW-1:0] ifmap_data_in_buf1;
reg signed [DATA_BW-1:0] ifmap_data_in_buf2;
reg signed [DATA_BW-1:0] ifmap_data_in_buf3;
reg signed [DATA_BW-1:0] ifmap_data_in_buf4;
reg signed [DATA_BW-1:0] ifmap_data_in_buf5;
reg signed [DATA_BW-1:0] ifmap_data_in_buf6;
reg signed [DATA_BW-1:0] ifmap_data_in_buf7;
reg signed [DATA_BW-1:0] ifmap_data_in_buf8;
reg signed [DATA_BW-1:0] ifmap_data_in_buf9;
reg signed [DATA_BW-1:0] ifmap_data_in_buf10;
reg signed [DATA_BW-1:0] ifmap_data_in_buf11;
reg signed [DATA_BW-1:0] ifmap_data_in_buf12;
reg signed [DATA_BW-1:0] ifmap_data_in_buf13;
reg signed [DATA_BW-1:0] ifmap_data_in_buf14;
reg signed [DATA_BW-1:0] ifmap_data_in_buf15;
reg signed [DATA_BW-1:0] ifmap_data_in_buf16;
reg signed [DATA_BW-1:0] ifmap_data_in_buf17;
reg signed [DATA_BW-1:0] ifmap_data_in_buf18;
reg signed [DATA_BW-1:0] ifmap_data_in_buf19;
reg signed [DATA_BW-1:0] ifmap_data_in_buf20;
reg signed [DATA_BW-1:0] ifmap_data_in_buf21;
reg signed [DATA_BW-1:0] ifmap_data_in_buf22;
reg signed [DATA_BW-1:0] ifmap_data_in_buf23;
reg signed [DATA_BW-1:0] ifmap_data_in_buf24;
reg signed [DATA_BW-1:0] ifmap_data_in_buf25;

reg signed [DATA_BW-1:0] filter_data_in_buf1;
reg signed [DATA_BW-1:0] filter_data_in_buf2;
reg signed [DATA_BW-1:0] filter_data_in_buf3;
reg signed [DATA_BW-1:0] filter_data_in_buf4;
reg signed [DATA_BW-1:0] filter_data_in_buf5;
reg signed [DATA_BW-1:0] filter_data_in_buf6;
reg signed [DATA_BW-1:0] filter_data_in_buf7;
reg signed [DATA_BW-1:0] filter_data_in_buf8;
reg signed [DATA_BW-1:0] filter_data_in_buf9;
reg signed [DATA_BW-1:0] filter_data_in_buf10;
reg signed [DATA_BW-1:0] filter_data_in_buf11;
reg signed [DATA_BW-1:0] filter_data_in_buf12;
reg signed [DATA_BW-1:0] filter_data_in_buf13;
reg signed [DATA_BW-1:0] filter_data_in_buf14;
reg signed [DATA_BW-1:0] filter_data_in_buf15;
reg signed [DATA_BW-1:0] filter_data_in_buf16;
reg signed [DATA_BW-1:0] filter_data_in_buf17;
reg signed [DATA_BW-1:0] filter_data_in_buf18;
reg signed [DATA_BW-1:0] filter_data_in_buf19;
reg signed [DATA_BW-1:0] filter_data_in_buf20;
reg signed [DATA_BW-1:0] filter_data_in_buf21;
reg signed [DATA_BW-1:0] filter_data_in_buf22;
reg signed [DATA_BW-1:0] filter_data_in_buf23;
reg signed [DATA_BW-1:0] filter_data_in_buf24;
reg signed [DATA_BW-1:0] filter_data_in_buf25;

wire signed [2*DATA_BW-1:0] mul_result_reg1;
wire signed [2*DATA_BW-1:0] mul_result_reg2;
wire signed [2*DATA_BW-1:0] mul_result_reg3;
wire signed [2*DATA_BW-1:0] mul_result_reg4;
wire signed [2*DATA_BW-1:0] mul_result_reg5;
wire signed [2*DATA_BW-1:0] mul_result_reg6;
wire signed [2*DATA_BW-1:0] mul_result_reg7;
wire signed [2*DATA_BW-1:0] mul_result_reg8;
wire signed [2*DATA_BW-1:0] mul_result_reg9;
wire signed [2*DATA_BW-1:0] mul_result_reg10;
wire signed [2*DATA_BW-1:0] mul_result_reg11;
wire signed [2*DATA_BW-1:0] mul_result_reg12;
wire signed [2*DATA_BW-1:0] mul_result_reg13;
wire signed [2*DATA_BW-1:0] mul_result_reg14;
wire signed [2*DATA_BW-1:0] mul_result_reg15;
wire signed [2*DATA_BW-1:0] mul_result_reg16;
wire signed [2*DATA_BW-1:0] mul_result_reg17;
wire signed [2*DATA_BW-1:0] mul_result_reg18;
wire signed [2*DATA_BW-1:0] mul_result_reg19;
wire signed [2*DATA_BW-1:0] mul_result_reg20;
wire signed [2*DATA_BW-1:0] mul_result_reg21;
wire signed [2*DATA_BW-1:0] mul_result_reg22;
wire signed [2*DATA_BW-1:0] mul_result_reg23;
wire signed [2*DATA_BW-1:0] mul_result_reg24;
wire signed [2*DATA_BW-1:0] mul_result_reg25;

booth_multiplier BM1 (.multiplier(ifmap_data_in_buf1), .multiplicand(filter_data_in_buf1), .product(mul_result_reg1));
booth_multiplier BM2 (.multiplier(ifmap_data_in_buf2), .multiplicand(filter_data_in_buf2), .product(mul_result_reg2));
booth_multiplier BM3 (.multiplier(ifmap_data_in_buf3), .multiplicand(filter_data_in_buf3), .product(mul_result_reg3));
booth_multiplier BM4 (.multiplier(ifmap_data_in_buf4), .multiplicand(filter_data_in_buf4), .product(mul_result_reg4));
booth_multiplier BM5 (.multiplier(ifmap_data_in_buf5), .multiplicand(filter_data_in_buf5), .product(mul_result_reg5));
booth_multiplier BM6 (.multiplier(ifmap_data_in_buf6), .multiplicand(filter_data_in_buf6), .product(mul_result_reg6));
booth_multiplier BM7 (.multiplier(ifmap_data_in_buf7), .multiplicand(filter_data_in_buf7), .product(mul_result_reg7));
booth_multiplier BM8 (.multiplier(ifmap_data_in_buf8), .multiplicand(filter_data_in_buf8), .product(mul_result_reg8));
booth_multiplier BM9 (.multiplier(ifmap_data_in_buf9), .multiplicand(filter_data_in_buf9), .product(mul_result_reg9));
booth_multiplier BM10 (.multiplier(ifmap_data_in_buf10), .multiplicand(filter_data_in_buf10), .product(mul_result_reg10));
booth_multiplier BM11 (.multiplier(ifmap_data_in_buf11), .multiplicand(filter_data_in_buf11), .product(mul_result_reg11));
booth_multiplier BM12 (.multiplier(ifmap_data_in_buf12), .multiplicand(filter_data_in_buf12), .product(mul_result_reg12));
booth_multiplier BM13 (.multiplier(ifmap_data_in_buf13), .multiplicand(filter_data_in_buf13), .product(mul_result_reg13));
booth_multiplier BM14 (.multiplier(ifmap_data_in_buf14), .multiplicand(filter_data_in_buf14), .product(mul_result_reg14));
booth_multiplier BM15 (.multiplier(ifmap_data_in_buf15), .multiplicand(filter_data_in_buf15), .product(mul_result_reg15));
booth_multiplier BM16 (.multiplier(ifmap_data_in_buf16), .multiplicand(filter_data_in_buf16), .product(mul_result_reg16));
booth_multiplier BM17 (.multiplier(ifmap_data_in_buf17), .multiplicand(filter_data_in_buf17), .product(mul_result_reg17));
booth_multiplier BM18 (.multiplier(ifmap_data_in_buf18), .multiplicand(filter_data_in_buf18), .product(mul_result_reg18));
booth_multiplier BM19 (.multiplier(ifmap_data_in_buf19), .multiplicand(filter_data_in_buf19), .product(mul_result_reg19));
booth_multiplier BM20 (.multiplier(ifmap_data_in_buf20), .multiplicand(filter_data_in_buf20), .product(mul_result_reg20));
booth_multiplier BM21 (.multiplier(ifmap_data_in_buf21), .multiplicand(filter_data_in_buf21), .product(mul_result_reg21));
booth_multiplier BM22 (.multiplier(ifmap_data_in_buf22), .multiplicand(filter_data_in_buf22), .product(mul_result_reg22));
booth_multiplier BM23 (.multiplier(ifmap_data_in_buf23), .multiplicand(filter_data_in_buf23), .product(mul_result_reg23));
booth_multiplier BM24 (.multiplier(ifmap_data_in_buf24), .multiplicand(filter_data_in_buf24), .product(mul_result_reg24));
booth_multiplier BM25 (.multiplier(ifmap_data_in_buf25), .multiplicand(filter_data_in_buf25), .product(mul_result_reg25));

CSA_25_input CSA (
	.in1(mul_result_reg1), .in2(mul_result_reg2), .in3(mul_result_reg3), .in4(mul_result_reg4), .in5(mul_result_reg5),
	.in6(mul_result_reg6), .in7(mul_result_reg7), .in8(mul_result_reg8), .in9(mul_result_reg9), .in10(mul_result_reg10),
	.in11(mul_result_reg11), .in12(mul_result_reg12), .in13(mul_result_reg13), .in14(mul_result_reg14), .in15(mul_result_reg15),
	.in16(mul_result_reg16), .in17(mul_result_reg17), .in18(mul_result_reg18), .in19(mul_result_reg19), .in20(mul_result_reg20),
	.in21(mul_result_reg21), .in22(mul_result_reg22), .in23(mul_result_reg23), .in24(mul_result_reg24), .in25(mul_result_reg25),
	.result(MUL_DATA_OUT)
);

always @(posedge CLK, negedge RSTN) begin
	if(!RSTN) begin
        	ifmap_data_in_buf1 <= 0;
        	ifmap_data_in_buf2 <= 0;
	        ifmap_data_in_buf3 <= 0;
	        ifmap_data_in_buf4 <= 0;
        	ifmap_data_in_buf5 <= 0;
       		ifmap_data_in_buf6 <= 0;
        	ifmap_data_in_buf7 <= 0;
        	ifmap_data_in_buf8 <= 0;
        	ifmap_data_in_buf9 <= 0;
        	ifmap_data_in_buf10 <= 0;
        	ifmap_data_in_buf11 <= 0;
        	ifmap_data_in_buf12 <= 0;
        	ifmap_data_in_buf13 <= 0;
        	ifmap_data_in_buf14 <= 0;
        	ifmap_data_in_buf15 <= 0;
        	ifmap_data_in_buf16 <= 0;
        	ifmap_data_in_buf17 <= 0;
        	ifmap_data_in_buf18 <= 0;
        	ifmap_data_in_buf19 <= 0;
        	ifmap_data_in_buf20 <= 0;
        	ifmap_data_in_buf21 <= 0;
        	ifmap_data_in_buf22 <= 0;
        	ifmap_data_in_buf23 <= 0;
        	ifmap_data_in_buf24 <= 0;
        	ifmap_data_in_buf25 <= 0;
       
		filter_data_in_buf1 <= 0;
        	filter_data_in_buf2 <= 0;
        	filter_data_in_buf3 <= 0;
        	filter_data_in_buf4 <= 0;
        	filter_data_in_buf5 <= 0;
        	filter_data_in_buf6 <= 0;
        	filter_data_in_buf7 <= 0;
        	filter_data_in_buf8 <= 0;
        	filter_data_in_buf9 <= 0;
        	filter_data_in_buf10 <= 0;
        	filter_data_in_buf11 <= 0;
        	filter_data_in_buf12 <= 0;
        	filter_data_in_buf13 <= 0;
        	filter_data_in_buf14 <= 0;
        	filter_data_in_buf15 <= 0;
        	filter_data_in_buf16 <= 0;
        	filter_data_in_buf17 <= 0;
        	filter_data_in_buf18 <= 0;
        	filter_data_in_buf19 <= 0;
        	filter_data_in_buf20 <= 0;
        	filter_data_in_buf21 <= 0;
        	filter_data_in_buf22 <= 0;
        	filter_data_in_buf23 <= 0;
        	filter_data_in_buf24 <= 0;
        	filter_data_in_buf25 <= 0;
	end

	else if(EN) begin
        	ifmap_data_in_buf1 <= IFMAP_DATA_IN1;
        	ifmap_data_in_buf2 <= IFMAP_DATA_IN2;
        	ifmap_data_in_buf3 <= IFMAP_DATA_IN3;
        	ifmap_data_in_buf4 <= IFMAP_DATA_IN4;
        	ifmap_data_in_buf5 <= IFMAP_DATA_IN5;
        	ifmap_data_in_buf6 <= IFMAP_DATA_IN6;
        	ifmap_data_in_buf7 <= IFMAP_DATA_IN7;
        	ifmap_data_in_buf8 <= IFMAP_DATA_IN8;
        	ifmap_data_in_buf9 <= IFMAP_DATA_IN9;
        	ifmap_data_in_buf10 <= IFMAP_DATA_IN10;
        	ifmap_data_in_buf11 <= IFMAP_DATA_IN11;
        	ifmap_data_in_buf12 <= IFMAP_DATA_IN12;
        	ifmap_data_in_buf13 <= IFMAP_DATA_IN13;
        	ifmap_data_in_buf14 <= IFMAP_DATA_IN14;
        	ifmap_data_in_buf15 <= IFMAP_DATA_IN15;
        	ifmap_data_in_buf16 <= IFMAP_DATA_IN16;
        	ifmap_data_in_buf17 <= IFMAP_DATA_IN17;
        	ifmap_data_in_buf18 <= IFMAP_DATA_IN18;
        	ifmap_data_in_buf19 <= IFMAP_DATA_IN19;
        	ifmap_data_in_buf20 <= IFMAP_DATA_IN20;
        	ifmap_data_in_buf21 <= IFMAP_DATA_IN21;
        	ifmap_data_in_buf22 <= IFMAP_DATA_IN22;
        	ifmap_data_in_buf23 <= IFMAP_DATA_IN23;
        	ifmap_data_in_buf24 <= IFMAP_DATA_IN24;
        	ifmap_data_in_buf25 <= IFMAP_DATA_IN25;

		filter_data_in_buf1 <= FILTER_DATA_IN1;
        	filter_data_in_buf2 <= FILTER_DATA_IN2;
        	filter_data_in_buf3 <= FILTER_DATA_IN3;
        	filter_data_in_buf4 <= FILTER_DATA_IN4;
        	filter_data_in_buf5 <= FILTER_DATA_IN5;
        	filter_data_in_buf6 <= FILTER_DATA_IN6;
        	filter_data_in_buf7 <= FILTER_DATA_IN7;
        	filter_data_in_buf8 <= FILTER_DATA_IN8;
        	filter_data_in_buf9 <= FILTER_DATA_IN9;
        	filter_data_in_buf10 <= FILTER_DATA_IN10;
        	filter_data_in_buf11 <= FILTER_DATA_IN11;
        	filter_data_in_buf12 <= FILTER_DATA_IN12;
        	filter_data_in_buf13 <= FILTER_DATA_IN13;
        	filter_data_in_buf14 <= FILTER_DATA_IN14;
        	filter_data_in_buf15 <= FILTER_DATA_IN15;
        	filter_data_in_buf16 <= FILTER_DATA_IN16;
        	filter_data_in_buf17 <= FILTER_DATA_IN17;
        	filter_data_in_buf18 <= FILTER_DATA_IN18;
        	filter_data_in_buf19 <= FILTER_DATA_IN19;
        	filter_data_in_buf20 <= FILTER_DATA_IN20;
        	filter_data_in_buf21 <= FILTER_DATA_IN21;
        	filter_data_in_buf22 <= FILTER_DATA_IN22;
        	filter_data_in_buf23 <= FILTER_DATA_IN23;
        	filter_data_in_buf24 <= FILTER_DATA_IN24;
        	filter_data_in_buf25 <= FILTER_DATA_IN25;
	end
end

endmodule
