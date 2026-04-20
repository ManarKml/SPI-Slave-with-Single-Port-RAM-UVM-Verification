module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;
localparam WRITE     = 3'b010;
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;
reg       received_address;

reg [2:0] cs, ns;

always @(posedge clk) begin
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (~received_address) // if not received address 
                        ns = READ_ADD; //receive address
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        MISO <= 0;
        counter <=0; //sfrt al counter hna 
    end
    else begin
        case (cs)
            IDLE : begin
                rx_valid <= 0; 
            end
            CHK_CMD : begin
                counter <= 10;     
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end
            end
            READ_DATA : begin
                if (tx_valid) begin
                    rx_valid <= 0;
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                        //MISO <=0; // Not a bug — just prevent MISO from latching the last transmitted bit before the next read operation
                    end
                end
                else begin
                    if (counter > 0 && ~rx_valid) begin // 10 cycles 
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin  // assert rx_valid then wait for tx-valid to be asserted 
                        rx_valid <= 1;
                        counter <= 8;
                    end
                end
            end
        endcase
    end
end


`ifdef SIM

// IDLE to CHK_CMD
property p_idle_to_chk;
  @(posedge SPI_slave_if.clk) disable iff (~SPI_slave_if.rst_n)
    (cs == IDLE && !SPI_slave_if.SS_n) |-> (ns == CHK_CMD);
endproperty
assert_idle_to_chk : assert property (p_idle_to_chk);
cover_idle_to_chk : cover property (p_idle_to_chk);

// CHK_CMD to WRITE or READ_ADD or READ_DATA
property p_chk_to_next;
  @(posedge SPI_slave_if.clk) disable iff (~SPI_slave_if.rst_n)
    (cs == CHK_CMD) |-> (ns == WRITE || ns == READ_ADD || ns == READ_DATA|| ns ==IDLE);
endproperty
assert_chk_to_next : assert property (p_chk_to_next);
cover_chk_to_next : cover property (p_chk_to_next);

// WRITE to IDLE
property p_write_to_idle;
  @(posedge SPI_slave_if.clk) disable iff (~SPI_slave_if.rst_n)
    (cs == WRITE) |-> ns == IDLE || ns == WRITE;
endproperty
assert_write_to_idle : assert property (p_write_to_idle);
cover_write_to_idle : cover property (p_write_to_idle);

// READ_ADD to IDLE
property p_readadd_to_idle;
  @(posedge SPI_slave_if.clk) disable iff (~SPI_slave_if.rst_n)
    (cs == READ_ADD) |-> (ns == READ_ADD || ns == IDLE);
endproperty
assert_readadd_to_idle : assert property (p_readadd_to_idle);
cover_readadd_to_idle : cover property (p_readadd_to_idle);

// READ_DATA to IDLE
property p_readdata_to_idle;
  @(posedge SPI_slave_if.clk) disable iff (~SPI_slave_if.rst_n)
    (cs == READ_DATA) |-> (ns == READ_DATA || ns == IDLE);
endproperty
assert_readdata_to_idle : assert property (p_readdata_to_idle);
cover_readdata_to_idle : cover property (p_readdata_to_idle);
  

`endif
endmodule