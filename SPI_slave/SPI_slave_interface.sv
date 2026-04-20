interface SPI_slave_interface (clk);

// Signals
input bit clk;
bit  mosi, SS_n, rst_n, tx_valid;
logic [7:0] tx_data;
bit miso, rx_valid,MISO_ref, rx_valid_ref;
logic [9:0] rx_data,rx_data_ref;

endinterface : SPI_slave_interface