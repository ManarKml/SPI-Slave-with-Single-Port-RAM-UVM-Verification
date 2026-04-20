module RAM_GM(din,clk,rst_n,rx_valid,dout,tx_valid);
parameter MEM_DEPTH = 256;
parameter ADDR_SIZE = 8;
input [9:0] din;
input rx_valid,clk,rst_n;
output reg [7:0] dout;
output reg tx_valid;
reg [7:0] Wr_Addr,Rd_Addr;
reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
always @(posedge clk ) begin
	if (~rst_n) begin
		dout<=8'b0;
		tx_valid<=0;
        Wr_Addr<=0;
        Rd_Addr<=0;
	end
	else begin
		if(rx_valid)begin
			case (din[9:8])
			 2'b00: begin
			    Wr_Addr<=din[7:0];
				tx_valid<=0;
			end
			 2'b01: begin 
			    mem[Wr_Addr]<=din[7:0];
				tx_valid<=0;
			end
			 2'b10: begin
			    Rd_Addr<=din[7:0];
				tx_valid<=0;
			end
			 2'b11:begin
			    dout<=mem[Rd_Addr];
				tx_valid<=1;
			end
			endcase
			end
	end
end
endmodule