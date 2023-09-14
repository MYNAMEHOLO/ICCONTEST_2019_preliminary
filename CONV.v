`timescale 1ns/10ps
module  CONV(clk,reset,busy,ready,iaddr,idata,cwr,caddr_wr,cdata_wr,crd,caddr_rd,cdata_rd,csel);
input clk;
input reset; //async high
input ready;
input signed [19:0] idata;
input [19:0] cdata_rd;
output reg busy;
output reg [11:0] iaddr;
output reg crd;
output reg [11:0] caddr_rd;
output reg cwr;
output reg signed  [19:0] cdata_wr;
output reg [11:0] caddr_wr;
output reg [2:0] csel;

/// write my code here
// comb. logic here
parameter IDLE = 0,
		  GET_p4 = 1,
		  GET_p0 = 2,
		  GET_p1 = 3,
		  GET_p2 = 4,
		  GET_p3 = 5,
		  GET_p5 = 6,
		  GET_p6 = 7,
		  GET_p7 = 8,
		  GET_p8 = 9,
		  CONV0 = 10,
		  BIAS0 = 11,
		  ROUNDING0 = 12,
		  RELU0 = 13,
		  WRITING0 = 14,
		  CONV1 = 15,
		  BIAS1 = 16,
		  ROUNDING1 = 17,
		  RELU1 = 18,
		  WRITING1 = 19,
		  CHECKPOINT = 20,
		  MEM0_P0 = 21,
		  MEM0_P1 = 22,
		  MEM0_P2 = 23,
		  MEM0_P3 = 24,
		  MEM0_WR = 25,
		  MEM1_P0 = 26,
		  MEM1_P1 = 27,
		  MEM1_P2 = 28,
		  MEM1_P3 = 29,
		  MEM1_WR = 30,
		  CHECKPOINT2 = 31,
		  WAIT = 32,
		  GET_L1K0 = 33,
		  L2_WRITE1 = 34,
		  GET_L1K1 = 35,
		  WAITING = 36,
		  CHECKPOINT3 = 37;  








// Signed Bias
parameter signed BIAS_0 = 20'h01310;
parameter signed BIAS_1 = 20'hF7295;
wire signed [39:0] bias0;
wire signed [39:0] bias1;
assign bias0 = { 4'h0 , BIAS_0 , 16'h0000};
assign bias1 = { 4'hF , BIAS_1 , 16'h0000};

// Kernel 0 
parameter signed kernel0_0 = 20'h0A89E;
parameter signed kernel0_1 = 20'h092D5;
parameter signed kernel0_2 = 20'h06D43;
parameter signed kernel0_3 = 20'h01004;
parameter signed kernel0_4 = 20'hF8F71;
parameter signed kernel0_5 = 20'hF6E54;
parameter signed kernel0_6 = 20'hFA6D7;
parameter signed kernel0_7 = 20'hFC834;
parameter signed kernel0_8 = 20'hFAC19;
// Kernel 1
parameter signed kernel1_0 = 20'hFDB55;
parameter signed kernel1_1 = 20'h02992;
parameter signed kernel1_2 = 20'hFC994;
parameter signed kernel1_3 = 20'h050FD;
parameter signed kernel1_4 = 20'h02F20;
parameter signed kernel1_5 = 20'h0202D;
parameter signed kernel1_6 = 20'h03BD7;
parameter signed kernel1_7 = 20'hFD369;
parameter signed kernel1_8 = 20'h05E68;

// define counter cnt_64 for kernel;
reg [5:0] cnt_64;
// addr for 3*3 ker
reg [11:0] center;

// ker0
wire signed [19:0] ker0_0 ;
wire signed [19:0] ker0_1 ;
wire signed [19:0] ker0_2 ;
wire signed [19:0] ker0_3 ;
wire signed [19:0] ker0_4 ;
wire signed [19:0] ker0_5 ;
wire signed [19:0] ker0_6 ;
wire signed [19:0] ker0_7 ;
wire signed [19:0] ker0_8 ;
assign ker0_0 = ((center <= 12'd63) || (cnt_64 == 6'd0)) ? 20'd0: kernel0_0;
assign ker0_1 = (center <= 12'd63)? 20'd0: kernel0_1;
assign ker0_2 = ((center <= 12'd63) || (cnt_64 == 6'd63))? 20'd0: kernel0_2;
assign ker0_3 = (cnt_64 == 6'd0)? 20'd0: kernel0_3;
assign ker0_4 = kernel0_4;
assign ker0_5 = (cnt_64 == 6'd63)? 20'd0: kernel0_5;
assign ker0_6 = ( (cnt_64 == 6'd0) || ((center >= 12'd4032) && (center <= 12'd4095)) )? 20'd0: kernel0_6;
assign ker0_7 = ((center >= 12'd4032) && (center <= 12'd4095))? 20'd0: kernel0_7;
assign ker0_8 = (((center >= 12'd4032) && (center <= 12'd4095)) ||
		 		(cnt_64 == 6'd63) )? 20'd0: kernel0_8;

// ker1
wire signed [19:0] ker1_0;
wire signed [19:0] ker1_1;
wire signed [19:0] ker1_2;
wire signed [19:0] ker1_3;
wire signed [19:0] ker1_4;
wire signed [19:0] ker1_5;
wire signed [19:0] ker1_6;
wire signed [19:0] ker1_7;
wire signed [19:0] ker1_8;
assign ker1_0 = ((center <= 12'd63) || (cnt_64 == 6'd0)) ? 20'd0: kernel1_0;
assign ker1_1 = (center <= 12'd63)? 20'd0: kernel1_1;
assign ker1_2 = ((center <= 12'd63) || (cnt_64 == 6'd63))? 20'd0: kernel1_2;
assign ker1_3 = (cnt_64 == 6'd0)? 20'd0: kernel1_3;
assign ker1_4 = kernel1_4;
assign ker1_5 = (cnt_64 == 6'd63)? 20'd0: kernel1_5;
assign ker1_6 = ( (cnt_64 == 6'd0) || ((center >= 12'd4032) && (center <= 12'd4095)) )? 20'd0: kernel1_6;
assign ker1_7 = ((center >= 12'd4032) && (center <= 12'd4095))? 20'd0: kernel1_7;
assign ker1_8 = (((center >= 12'd4032) && (center <= 12'd4095)) ||
		 		(cnt_64 == 6'd63) )? 20'd0: kernel1_8;

// origin pixel data
reg signed [19:0] pixel [8:0];

// Max pooling
///FSM Here
reg [37:0] cs,ns;
//cs logic
always@(posedge clk or posedge reset)begin
	if(reset)begin
		cs <= 'd0;
		cs[IDLE] <= 1'd1;
	end
	else cs <= ns;
end

//ns logic
always@(*)begin
	ns = 'd0;
	case(1'd1)
		cs[IDLE]:begin
			if(reset) ns[IDLE] = 1'd1;
			else if(ready) ns[GET_p4] = 1'd1;
			else ns[IDLE] = 1'd1;
		end
		cs[GET_p4]: ns[GET_p0] = 1'd1;
		cs[GET_p0]: ns[GET_p1] = 1'd1;
		cs[GET_p1]: ns[GET_p2] = 1'd1;
		cs[GET_p2]: ns[GET_p3] = 1'd1;
		cs[GET_p3]: ns[GET_p5] = 1'd1;
		cs[GET_p5]: ns[GET_p6] = 1'd1;
		cs[GET_p6]: ns[GET_p7] = 1'd1;
		cs[GET_p7]: ns[GET_p8] = 1'd1;
		cs[GET_p8]: ns[CONV0] = 1'd1;
		cs[CONV0]: ns[BIAS0] = 1'd1;
		cs[BIAS0]: ns[ROUNDING0] = 1'd1;
		cs[ROUNDING0]: ns[RELU0] = 1'd1;
		cs[RELU0]: ns[WRITING0] = 1'd1;
		cs[WRITING0]: ns[CONV1] = 1'd1;
		cs[CONV1]: ns[BIAS1] = 1'd1;
		cs[BIAS1]: ns[ROUNDING1] = 1'd1;
		cs[ROUNDING1]: ns[RELU1] = 1'd1;
		cs[RELU1]: ns[WRITING1] = 1'd1;
		cs[WRITING1]:begin
			if(center == 12'd4095 ) ns[CHECKPOINT] = 1'd1;
			else ns[GET_p4] = 1'd1;
		end
		cs[CHECKPOINT]: ns[MEM0_P0] = 1'd1;
		cs[MEM0_P0]: ns[MEM0_P1] = 1'd1;
		cs[MEM0_P1]: ns[MEM0_P2] = 1'd1;
		cs[MEM0_P2]: ns[MEM0_P3] = 1'd1;
		cs[MEM0_P3]: ns[MEM0_WR] = 1'd1;
		cs[MEM0_WR]: ns[WAIT] = 1'd1;
		cs[WAIT]:	ns[MEM1_P0] = 1'd1;
		cs[MEM1_P0]: ns[MEM1_P1] = 1'd1;
		cs[MEM1_P1]: ns[MEM1_P2] = 1'd1;
		cs[MEM1_P2]: ns[MEM1_P3] = 1'd1;
		cs[MEM1_P3]: ns[MEM1_WR] = 1'd1;
		cs[MEM1_WR]:begin
			if(center == 12'd4030) ns[CHECKPOINT2] = 1'd1;
			else ns[MEM0_P0] = 1'd1;
		end
		cs[CHECKPOINT2]: ns[GET_L1K0] = 1'd1;
		cs[GET_L1K0]: ns[L2_WRITE1] = 1'd1;
		cs[L2_WRITE1]: ns[GET_L1K1] = 1'd1;
		cs[GET_L1K1]: ns[WAITING] = 1'd1;
		cs[WAITING]: begin
			if(center == 12'd2048) ns[CHECKPOINT3] = 1'd1;
			else ns[GET_L1K0] = 1'd1;
		end
		cs[CHECKPOINT3]: ns[CHECKPOINT3] = 1'd1;
		default:ns[IDLE] = 1'd1; 
	endcase
end

reg signed [39:0] conv_40bit;
reg signed [39:0] conv [8:0];

integer i;

//output logic
always@(posedge clk or posedge reset)begin
	if(reset)begin
		busy <= 'd0;
		iaddr <= 'd0;
		crd <= 'd0;
		caddr_rd <= 'd0;
		cwr <= 'd0;
		cdata_wr <= 'd0;
		caddr_wr <= 'd0;
		csel <= 'd0;
		center <= 'd0;
		cnt_64 <= 'd0;
		conv_40bit <= 'd0;
		for(i=0; i<9; i=i+1 )begin
			pixel[i] <= 'd0;
			conv[i] <= 'd0;
		end
	end
	else begin
		case(1'd1)
			cs[IDLE]: begin
				iaddr <= 'd0;
				crd <= 'd0;
				caddr_rd <= 'd0;
				cwr <= 'd0;
				cdata_wr <= 'd0;
				caddr_wr <= 'd0;
				csel <= 'd0;
				center <= 'd0;
				cnt_64 <= 'd0;
				conv_40bit <= 'd0;
				for(i=0; i<9; i=i+1 )begin
					pixel[i] <= 'd0;
					conv[i] <= 'd0;
				end
				if(reset) busy <= 1'd0;
				else busy <= 1'd1;
			end
			cs[GET_p4]:begin
				pixel[4] <= idata;
				iaddr <= center - 12'd65;
			end 
			cs[GET_p0]:begin
				pixel[0] <= idata;
				iaddr <= center - 12'd64;
			end
			cs[GET_p1]:begin
				pixel[1] <= idata;
				iaddr <= center - 12'd63;
			end
			cs[GET_p2]:begin
				pixel[2] <= idata;
				iaddr <= center - 12'd1;
			end
			cs[GET_p3]:begin
				pixel[3] <= idata;
				iaddr <= center + 12'd1;
			end
			cs[GET_p5]:begin
				pixel[5] <= idata;
				iaddr <= center + 12'd63;
			end
			cs[GET_p6]:begin
				pixel[6] <= idata;
				iaddr <= center + 12'd64;
			end
			cs[GET_p7]:begin
				pixel[7] <= idata;
				iaddr <= center + 12'd65;
			end
			cs[GET_p8]:begin
				pixel[8] <= idata;
			end
			cs[CONV0]:begin
				conv[0] <= pixel[0] * ker0_0;
				conv[1] <= pixel[1] * ker0_1;
				conv[2] <= pixel[2] * ker0_2;
				conv[3] <= pixel[3] * ker0_3;
				conv[4] <= pixel[4] * ker0_4;
				conv[5] <= pixel[5] * ker0_5;
				conv[6] <= pixel[6] * ker0_6;
				conv[7] <= pixel[7] * ker0_7;
				conv[8] <= pixel[8] * ker0_8;
			end
			cs[BIAS0]:begin
				conv_40bit <= conv[0] + conv[1] + conv[2] + conv[3] + conv[4] + 
							   conv[5] + conv[6] + conv[7] + conv[8] + bias0;
			end
			cs[ROUNDING0]:begin
				if(!conv_40bit[39]) cdata_wr <= { conv_40bit[39], conv_40bit[34:32] ,
												 conv_40bit[31:16]} + conv_40bit[15];
				else cdata_wr <= { conv_40bit[39], conv_40bit[34:32] ,conv_40bit[31:16]} - conv_40bit[15];
			end
			cs[RELU0]:begin
				cdata_wr <= (cdata_wr[19])? 20'd0: cdata_wr;
				cwr <= 1'd1;
				csel <= 3'b001;
			end
			cs[WRITING0]:begin
				cwr <= 1'd0;
			end
			cs[CONV1]:begin
				conv[0] <= pixel[0] * ker1_0;
				conv[1] <= pixel[1] * ker1_1;
				conv[2] <= pixel[2] * ker1_2;
				conv[3] <= pixel[3] * ker1_3;
				conv[4] <= pixel[4] * ker1_4;
				conv[5] <= pixel[5] * ker1_5;
				conv[6] <= pixel[6] * ker1_6;
				conv[7] <= pixel[7] * ker1_7;
				conv[8] <= pixel[8] * ker1_8;
			end
			cs[BIAS1]:begin
				conv_40bit <= conv[0] + conv[1] + conv[2] + conv[3] + conv[4] + 
							   conv[5] + conv[6] + conv[7] + conv[8] + bias1;
			end
			cs[ROUNDING1]:begin
				if(!conv_40bit[39]) cdata_wr <= { conv_40bit[39], conv_40bit[34:32] ,
												 conv_40bit[31:16]} + conv_40bit[15];
				else cdata_wr <= { conv_40bit[39], conv_40bit[34:32] ,conv_40bit[31:16]} - conv_40bit[15];
			end
			cs[RELU1]:begin
				cdata_wr <= (cdata_wr[19])? 20'd0: cdata_wr;
				cwr <= 1'd1;
				csel <= 3'b010;
			end
			cs[WRITING1]:begin
				iaddr <= center + 1'd1;
				center <= center + 1'd1;
				cnt_64 <= cnt_64 + 1'd1;
				cwr <= 1'd0;
				caddr_wr <= caddr_wr + 1'd1;
			end
			cs[CHECKPOINT]:begin
				// busy <= 1'd0;
				center <= 'd0;
				caddr_rd <= 'd0;
				cnt_64 <= 'd0;
				crd <= 1'd1;
				csel <= 3'b001;
				pixel[0] <= 'd0;
				// pixel[1] count for the max pooling pixel numbers. 0 ~ 1023;
				pixel[1] <= 'd0;
			end
			cs[MEM0_P0]:begin
				pixel[0] <= cdata_rd;
				caddr_rd <= center + 1'd1;
			end
			cs[MEM0_P1]:begin
				pixel[0] <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				caddr_rd <= center + 12'd64;
			end
			cs[MEM0_P2]:begin
				pixel[0] <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				caddr_rd <= center + 12'd65;
			end
			cs[MEM0_P3]:begin
				caddr_wr <= pixel[1][11:0];
				cdata_wr <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				csel <= 3'b011;
				crd <= 1'd0;
				cwr <= 1'd1;
			end
			cs[MEM0_WR]:begin
				cwr <= 1'd0;
				csel <= 3'b010;
				caddr_rd <= center;
			end
			cs[WAIT]:begin
				crd <= 1'd1;
				pixel[0] <= 'd0;
			end
			cs[MEM1_P0]:begin
				pixel[0] <= cdata_rd;
				caddr_rd <= center + 1'd1;
			end
			cs[MEM1_P1]:begin
				pixel[0] <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				caddr_rd <= center + 12'd64;
			end
			cs[MEM1_P2]:begin
				pixel[0] <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				caddr_rd <= center + 12'd65;
			end
			cs[MEM1_P3]:begin
				caddr_wr <= pixel[1][11:0];
				cdata_wr <= (pixel[0] <= cdata_rd)? cdata_rd: pixel[0];
				csel <= 3'b100;
				crd <= 1'd0;
				cwr <= 1'd1;
			end
			cs[MEM1_WR]:begin
				cwr <= 1'd0;
				crd <= 1'd1;
				csel <= 3'b001;
				caddr_rd <= (cnt_64 == 6'd31)? (center + 12'd66) : (center + 12'd2); 
				pixel[1] <= pixel[1] + 1'd1;
				cnt_64 <= (cnt_64 == 6'd31)? 6'd0 : cnt_64 + 1'd1;
				center <= (cnt_64 == 6'd31)? (center + 12'd66) : (center + 12'd2); 
			end
			cs[CHECKPOINT2]:begin
				// busy <= 1'd0;
				center <= 'd0;
				caddr_rd <= 'd0;
				crd <= 1'd1;
				cwr <= 1'd0;
				csel <= 3'b011;
				pixel[0] <= 'd0;
				// pixel[1] count for the max  numbers. 0 ~ 1023;
				pixel[1] <= 'd0;
			end
			// caddr_rd count by pixel[1]
			// pixel addr count by center
			cs[GET_L1K0]:begin
				cdata_wr <= cdata_rd;
				csel <= 3'b101;
				cwr <= 1'd1;
				crd <= 1'd0;
				caddr_wr <= center;
				center <= center + 1'd1;
			end
			cs[L2_WRITE1]:begin
				crd <= 1'd1;
				cwr <= 1'd0;
				csel <= 3'b100;
			end
			cs[GET_L1K1]:begin
				cdata_wr <= cdata_rd;
				csel <= 3'b101;
				cwr <= 1'd1;
				crd <= 1'd0;
				caddr_wr <= center;
				center <= center + 1'd1;
			end
			cs[WAITING]:begin
				crd <= 1'd1;
				cwr <= 1'd0;
				csel <= 3'b011;
				caddr_rd <= caddr_rd + 1'd1;
			end
			cs[CHECKPOINT3]:begin
				busy <= 1'd0;
			end
			default:begin
				busy <= 1'd0;
			end
		endcase
	end
end
//end
endmodule