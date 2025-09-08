module Convolver
#(
	parameter ADDR_WIDTH  = 14,
	parameter IMAGE_WIDTH = 98,
	parameter FILTER_WIDTH = 5,
	parameter FEATURE_WIDTH = 32,
	parameter BITWIDTH    = 8
)(
	input wire clk,
	input wire resetn,
	input wire signed [BITWIDTH-1:0] IMAGE_RAM_DIN,
	input wire signed [BITWIDTH-1:0] FILTER_RAM_DIN,
	input wire signed [2*BITWIDTH-1:0] FEATURE_RAM_DIN,
	input wire IMAGE_RAM_DATA_VAL,
	input wire FILTER_RAM_DATA_VAL,
	input wire FEATURE_RAM_DATA_VAL,

	output wire IMAGE_RAM_EN,
	output wire FILTER_RAM_EN,
	output wire FEATURE_RAM_EN,
	output wire FEATURE_RAM_WEN,

	output wire [ADDR_WIDTH-1:0] IMAGE_RAM_ADDRESS,
	output wire [ADDR_WIDTH-1:0] FILTER_RAM_ADDRESS,
	output wire [ADDR_WIDTH-1:0] FEATURE_RAM_ADDRESS,

	output wire signed [2*BITWIDTH-1:0] FEATURE_RAM_DOUT,
	output wire eoc
);

reg img_ram_en;
reg fil_ram_en;
reg fea_ram_en;
reg fea_ram_wen;

reg [ADDR_WIDTH-1:0] img_cur_addr, img_next_addr;
reg [ADDR_WIDTH-1:0] fil_cur_addr, fil_next_addr;
reg [ADDR_WIDTH-1:0] fea_cur_addr, fea_next_addr;
reg [6:0] img_row_addr;
reg [6:0] img_col_addr;
reg [4:0] c_cnt25, c_cnt5;
reg [4:0] n_cnt25, n_cnt5;
reg [5:0] c_cnt32_col, c_cnt32_row;
reg [5:0] n_cnt32_col, n_cnt32_row;
reg [7:0] cnt196;
reg img_val_cnt, fil_val_cnt, mac_cnt;

assign IMAGE_RAM_EN = img_ram_en;
assign FILTER_RAM_EN = fil_ram_en;
assign FEATURE_RAM_EN = fea_ram_en;
assign FEATURE_RAM_WEN = fea_ram_wen;
reg fin;

assign IMAGE_RAM_ADDRESS = img_cur_addr;
assign FILTER_RAM_ADDRESS = fil_cur_addr;
assign FEATURE_RAM_ADDRESS = fea_cur_addr;
assign eoc = fin;

reg [BITWIDTH-1:0] IMAGE_RAM[0:24];
reg [BITWIDTH-1:0] FILTER_RAM[0:24];
reg [BITWIDTH-1:0] SHIFT_RAM[0:195];
reg mac_en, fea_en, fea_end;
reg shift_col_en, shift_row_en, shift_9_en;


reg [2:0] c_state, n_state;
parameter IDLE  = 3'd0;
parameter LOAD  = 3'd1;
parameter MAC   = 3'd2;
parameter FEATURE = 3'd3;
parameter SHIFT_COL = 3'd4;
parameter SHIFT_ROW = 3'd5;
parameter SHIFT_9 = 3'd6;
parameter EOC = 3'd7;

integer i,j;

always @(posedge clk or negedge resetn) begin
	if (!resetn) begin
		c_state       <= IDLE;
		img_cur_addr  <= 0;
		fil_cur_addr  <= 0;
		fea_cur_addr  <= 0;
		img_row_addr <= 0;
		img_col_addr<= 0;
		c_cnt25 <= 0;
		c_cnt5 <= 0;
		cnt196 <= 0;
		c_cnt32_col <= 0;
		c_cnt32_row <= 0;
		img_val_cnt <= 0;
		fil_val_cnt <= 0;
		mac_cnt <= 0;

		for (i = 0; i < 25; i = i + 1) begin
			IMAGE_RAM[i] <= 0;
			FILTER_RAM[i] <= 0;
		end

	end else begin
		c_state <= n_state;
		img_cur_addr <= img_next_addr;
		fil_cur_addr <= fil_next_addr;
		fea_cur_addr <= fea_next_addr;
		c_cnt5 <= n_cnt5;
		c_cnt25 <= n_cnt25;
		c_cnt32_col <= n_cnt32_col;
		c_cnt32_row <= n_cnt32_row;
	end
end

always @(*) begin
	case (c_state)
		IDLE: begin
			n_state = LOAD;
		end

		LOAD: begin
			if (mac_en) begin
				n_state = MAC;
			end else begin
				n_state = LOAD;
			end
		end

		MAC: begin
			if (fea_en) begin
				n_state = FEATURE;
			end else begin
				n_state = MAC;
			end
		end

		FEATURE : begin
			if (fea_end) begin
				n_state <= EOC;
			end
			else if (!fea_en) begin
				if (shift_row_en) begin
					n_state = SHIFT_ROW;
				end
				else if (shift_9_en) begin
					n_state = SHIFT_9;
				end else begin
					n_state = SHIFT_COL;
				end
			end
		end

		SHIFT_COL : begin
			if (mac_en) begin
				n_state = MAC;
			end else begin
				n_state = SHIFT_COL;
			end
		end

		SHIFT_ROW : begin
			if (mac_en) begin
				n_state = MAC;
			end else begin
				n_state = SHIFT_ROW;
			end
		end

		SHIFT_9 : begin
			if (mac_en) begin
				n_state = MAC;
			end else begin
				n_state = SHIFT_9;
			end
		end

		EOC : begin
		end

		default: begin
			n_state = IDLE;
		end
	endcase
end

always @(*) begin
	case (c_state)
		IDLE: begin
			img_ram_en    = 0;
			fil_ram_en    = 0;
			fea_ram_en    = 0;
			fea_ram_wen   = 0;
			img_next_addr  = 0;
			fil_next_addr  = 0;
			fea_next_addr  = 0;
			n_cnt5  = 0;
			n_cnt25  = 0;
			n_cnt32_col  = 0;
			n_cnt32_row  = 0;
			mac_en = 0;
			fea_en = 0;
			fea_end = 0;
			shift_col_en = 0;
			shift_row_en = 0;
			shift_9_en = 0;
			fin = 0;
		end

		LOAD: begin
			if (IMAGE_RAM_DATA_VAL && !img_val_cnt) begin
				IMAGE_RAM[c_cnt25] = IMAGE_RAM_DIN;
				img_val_cnt =1;
				if (n_cnt25 == 24) begin
					n_cnt25 = 0;
					n_cnt5 = 2;
					n_cnt32_col = c_cnt32_col + 1;
					mac_en = 1;
					img_col_addr = img_col_addr + 1;
					img_row_addr = img_row_addr - 4;
				end
				else if (c_cnt5 == 4) begin
					n_cnt5 = 0;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = 0;
					img_row_addr = img_row_addr + 1;
				end
				else begin
					n_cnt5 = c_cnt5 + 1;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = img_col_addr + 1;
				end

				if (c_cnt25 >14) begin
					SHIFT_RAM[cnt196] = IMAGE_RAM[c_cnt25];
					cnt196 = cnt196 + 1;
				end
			end

			img_next_addr = img_row_addr * IMAGE_WIDTH + img_col_addr;

			if (FILTER_RAM_DATA_VAL && !fil_val_cnt) begin
				FILTER_RAM[fil_cur_addr] = FILTER_RAM_DIN;
				fil_next_addr = fil_cur_addr + 1;
				fil_val_cnt = 1;
			end

			if (!IMAGE_RAM_DATA_VAL && img_val_cnt) img_val_cnt = 0;
			if (!FILTER_RAM_DATA_VAL && fil_val_cnt) fil_val_cnt = 0;

			img_ram_en = 1;
			fil_ram_en = 1;
		end

		MAC: begin
			mac_en = 0;
			img_ram_en    = 0;
			fil_ram_en    = 0;
			fea_en = 1;
		end

		FEATURE : begin
			if (fea_next_addr == 1024) begin
				fea_end = 1;
			end 
			else begin
				fea_next_addr = fea_cur_addr + 1;
				fea_en = 0;
			end
			if (c_cnt32_row) begin
				shift_9_en = 1;
			end begin
				shift_col_en = 1;
			end
			fea_ram_en = 1;
			fea_ram_wen = 1;
		end

		SHIFT_COL : begin
			if (shift_col_en) begin
				IMAGE_RAM[0] = IMAGE_RAM[3];
				IMAGE_RAM[1] = IMAGE_RAM[4];
				IMAGE_RAM[5] = IMAGE_RAM[8];
				IMAGE_RAM[6] = IMAGE_RAM[9];
				IMAGE_RAM[10] = IMAGE_RAM[13];
				IMAGE_RAM[11] = IMAGE_RAM[14];
				IMAGE_RAM[15] = IMAGE_RAM[18];
				IMAGE_RAM[16] = IMAGE_RAM[19];
				IMAGE_RAM[20] = IMAGE_RAM[23];
				IMAGE_RAM[21] = IMAGE_RAM[24];
				shift_col_en = 0;
			end

			if (IMAGE_RAM_DATA_VAL && !img_val_cnt) begin
				IMAGE_RAM[c_cnt25+2] = IMAGE_RAM_DIN;
				img_val_cnt = 1;
				if (n_cnt25 == 22) begin
					n_cnt5 = 2;
					n_cnt25 = 0;
					n_cnt32_col = c_cnt32_col + 1;
					img_col_addr = img_col_addr + 1;
					img_row_addr = img_row_addr - 4;
					mac_en = 1;
					if (n_cnt32_col == 32) begin
						img_col_addr = 0;
						n_cnt32_col = 0;
						img_row_addr = img_row_addr + 5;
						n_cnt32_row = c_cnt32_row + 1;
						n_cnt5 = 0;
						n_cnt25 = 10;
						shift_row_en = 1;
					end
				end
				else if (c_cnt5 == 4) begin
					n_cnt5 = 2;
					n_cnt25 = c_cnt25 + 3;
					img_row_addr = img_row_addr + 1;
					img_col_addr = img_col_addr - 2;
				end
				else begin
					n_cnt5 = c_cnt5 + 1;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = img_col_addr + 1;
				end

				if (cnt196 == 196) begin
					cnt196 = 0;
				end
				else if (c_cnt25 >14) begin	
					SHIFT_RAM[cnt196] = IMAGE_RAM[c_cnt25+2];
					cnt196 = cnt196 + 1;
				end
			end

			if (!IMAGE_RAM_DATA_VAL && img_val_cnt) img_val_cnt = 0;

			img_next_addr = img_row_addr * IMAGE_WIDTH + img_col_addr;

			img_ram_en    = 1;
			fil_ram_en    = 1;
			fea_ram_en    = 0;
			fea_ram_wen   = 0;
		end

		SHIFT_ROW : begin
			if (shift_row_en) begin
				for (i = 0; i < 10; i = i + 1) begin
					IMAGE_RAM[i] = SHIFT_RAM[i];
				end
				shift_row_en = 0;
				cnt196 = 0;
			end

			if (IMAGE_RAM_DATA_VAL && !img_val_cnt) begin
				IMAGE_RAM[c_cnt25] = IMAGE_RAM_DIN;
				img_val_cnt =1;
				if (n_cnt25 == 24) begin
					n_cnt25 = 10;
					n_cnt5 = 2;
					n_cnt32_col = c_cnt32_col + 1;
					mac_en = 1;
					img_col_addr = img_col_addr + 1;
					img_row_addr = img_row_addr - 2;
				end
				else if (c_cnt5 == 4) begin
					n_cnt5 = 0;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = 0;
					img_row_addr = img_row_addr + 1;
				end
				else begin
					n_cnt5 = c_cnt5 + 1;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = img_col_addr + 1;
				end

				if (c_cnt25 > 14) begin
					SHIFT_RAM[cnt196] = IMAGE_RAM[c_cnt25];
					cnt196 = cnt196 + 1;
				end
			end

			if (!IMAGE_RAM_DATA_VAL && img_val_cnt) img_val_cnt = 0;
			img_next_addr = img_row_addr * IMAGE_WIDTH + img_col_addr;

			shift_row_en = 0;
			img_ram_en    = 1;
			fil_ram_en    = 1;
			fea_ram_en    = 0;
			fea_ram_wen   = 0;
		end

		SHIFT_9 : begin
			if (shift_9_en) begin
				IMAGE_RAM[0] = IMAGE_RAM[3];
				IMAGE_RAM[1] = IMAGE_RAM[4];
				IMAGE_RAM[5] = IMAGE_RAM[8];
				IMAGE_RAM[6] = IMAGE_RAM[9];
				IMAGE_RAM[10] = IMAGE_RAM[13];
				IMAGE_RAM[11] = IMAGE_RAM[14];
				IMAGE_RAM[15] = IMAGE_RAM[18];
				IMAGE_RAM[16] = IMAGE_RAM[19];
				IMAGE_RAM[20] = IMAGE_RAM[23];
				IMAGE_RAM[21] = IMAGE_RAM[24];
				IMAGE_RAM[2] = SHIFT_RAM[img_col_addr*2];
				IMAGE_RAM[3] = SHIFT_RAM[img_col_addr*2+1];
				IMAGE_RAM[4] = SHIFT_RAM[img_col_addr*2+2];
				IMAGE_RAM[7] = SHIFT_RAM[img_col_addr*2+3];
				IMAGE_RAM[8] = SHIFT_RAM[img_col_addr*2+4];
				IMAGE_RAM[9] = SHIFT_RAM[img_col_addr*2+5];
				shift_9_en = 0;
			end

			if (IMAGE_RAM_DATA_VAL && !img_val_cnt) begin
				IMAGE_RAM[c_cnt25+2] = IMAGE_RAM_DIN;
				img_val_cnt = 1;
				if (n_cnt25 == 22) begin
					n_cnt5 = 2;
					n_cnt25 = 10;
					n_cnt32_col = c_cnt32_col + 1;
					img_col_addr = img_col_addr + 1;
					img_row_addr = img_row_addr - 2;
					mac_en = 1;
					if (n_cnt32_col == 32) begin
						img_col_addr = 0;
						n_cnt32_col = 0;
						img_row_addr = img_row_addr + 3;
						n_cnt32_row = c_cnt32_row + 1;
						n_cnt5 = 0;
						n_cnt25 = 10;
						shift_row_en = 1;
					end
				end
				else if (c_cnt5 == 4) begin
					n_cnt5 = 2;
					n_cnt25 = c_cnt25 + 3;
					img_row_addr = img_row_addr + 1;
					img_col_addr = img_col_addr - 2;
				end
				else begin
					n_cnt5 = c_cnt5 + 1;
					n_cnt25 = c_cnt25 + 1;
					img_col_addr = img_col_addr + 1;
				end

				if (cnt196 == 196) begin
					cnt196 = 0;
				end
				else if (c_cnt25 >14) begin	
					SHIFT_RAM[cnt196] = IMAGE_RAM[c_cnt25+2];
					cnt196 = cnt196 + 1;
				end
			end

			if (!IMAGE_RAM_DATA_VAL && img_val_cnt) img_val_cnt = 0;

			img_next_addr = img_row_addr * IMAGE_WIDTH + img_col_addr;

			img_ram_en    = 1;
			fil_ram_en    = 1;
			fea_ram_en    = 0;
			fea_ram_wen   = 0;
		end			

		EOC : begin
			img_ram_en    = 0;
			fil_ram_en    = 0;
			fea_ram_en    = 0;
			fea_ram_wen   = 0;
			fin = 1;
		end
	endcase	
end


MAC u_MAC (
	.CLK(clk),
	.RSTN(resetn),
	.EN(mac_en),

	.IFMAP_DATA_IN1(IMAGE_RAM[0]),
	.IFMAP_DATA_IN2(IMAGE_RAM[1]),
	.IFMAP_DATA_IN3(IMAGE_RAM[2]),
	.IFMAP_DATA_IN4(IMAGE_RAM[3]),
	.IFMAP_DATA_IN5(IMAGE_RAM[4]),
	.IFMAP_DATA_IN6(IMAGE_RAM[5]),
	.IFMAP_DATA_IN7(IMAGE_RAM[6]),
	.IFMAP_DATA_IN8(IMAGE_RAM[7]),
	.IFMAP_DATA_IN9(IMAGE_RAM[8]),
	.IFMAP_DATA_IN10(IMAGE_RAM[9]),
	.IFMAP_DATA_IN11(IMAGE_RAM[10]),
	.IFMAP_DATA_IN12(IMAGE_RAM[11]),
	.IFMAP_DATA_IN13(IMAGE_RAM[12]),
	.IFMAP_DATA_IN14(IMAGE_RAM[13]),
	.IFMAP_DATA_IN15(IMAGE_RAM[14]),
	.IFMAP_DATA_IN16(IMAGE_RAM[15]),
	.IFMAP_DATA_IN17(IMAGE_RAM[16]),
	.IFMAP_DATA_IN18(IMAGE_RAM[17]),
	.IFMAP_DATA_IN19(IMAGE_RAM[18]),
	.IFMAP_DATA_IN20(IMAGE_RAM[19]),
	.IFMAP_DATA_IN21(IMAGE_RAM[20]),
	.IFMAP_DATA_IN22(IMAGE_RAM[21]),
	.IFMAP_DATA_IN23(IMAGE_RAM[22]),
	.IFMAP_DATA_IN24(IMAGE_RAM[23]),
	.IFMAP_DATA_IN25(IMAGE_RAM[24]),

	.FILTER_DATA_IN1(FILTER_RAM[0]),
	.FILTER_DATA_IN2(FILTER_RAM[1]),
	.FILTER_DATA_IN3(FILTER_RAM[2]),
	.FILTER_DATA_IN4(FILTER_RAM[3]),
	.FILTER_DATA_IN5(FILTER_RAM[4]),
	.FILTER_DATA_IN6(FILTER_RAM[5]),
	.FILTER_DATA_IN7(FILTER_RAM[6]),
	.FILTER_DATA_IN8(FILTER_RAM[7]),
	.FILTER_DATA_IN9(FILTER_RAM[8]),
	.FILTER_DATA_IN10(FILTER_RAM[9]),
	.FILTER_DATA_IN11(FILTER_RAM[10]),
	.FILTER_DATA_IN12(FILTER_RAM[11]),
	.FILTER_DATA_IN13(FILTER_RAM[12]),
	.FILTER_DATA_IN14(FILTER_RAM[13]),
	.FILTER_DATA_IN15(FILTER_RAM[14]),
	.FILTER_DATA_IN16(FILTER_RAM[15]),
	.FILTER_DATA_IN17(FILTER_RAM[16]),
	.FILTER_DATA_IN18(FILTER_RAM[17]),
	.FILTER_DATA_IN19(FILTER_RAM[18]),
	.FILTER_DATA_IN20(FILTER_RAM[19]),
	.FILTER_DATA_IN21(FILTER_RAM[20]),
	.FILTER_DATA_IN22(FILTER_RAM[21]),
	.FILTER_DATA_IN23(FILTER_RAM[22]),
	.FILTER_DATA_IN24(FILTER_RAM[23]),
	.FILTER_DATA_IN25(FILTER_RAM[24]),

	.MUL_DATA_OUT(FEATURE_RAM_DOUT)
);


endmodule
