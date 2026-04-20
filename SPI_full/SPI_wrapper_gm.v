module wrapper_gm (
    input clk, rst_n, MOSI, SS_n,
    output MISO
    );

// SPI receive interface
wire [9:0] rx_data; 
wire rx_valid;

// SPI transmit interface
wire [7:0] tx_data; 
wire tx_valid;

slave_gm dut (tx_data,tx_valid,SS_n,MOSI,MISO,rx_data,rx_valid,clk,rst_n);
RAM_GM my_ram (
    .din(rx_data),
    .dout(tx_data),
    .rx_valid(rx_valid),
    .tx_valid(tx_valid),
    .clk(clk),
    .rst_n(rst_n)
    );

endmodule