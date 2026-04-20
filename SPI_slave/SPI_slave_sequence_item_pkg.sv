package SPI_slave_sequence_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class SPI_slave_sequence_item extends uvm_sequence_item;
		`uvm_object_utils(SPI_slave_sequence_item);

		// Signals
		rand bit  mosi, SS_n, clk, rst_n, tx_valid;
		rand bit [7:0] tx_data;
		logic miso, rx_valid;
		logic [9:0] rx_data,rx_data_ref;
		logic MISO_ref, rx_valid_ref;
  		rand bit [10:0] MOSI_data;
		bit [10:0] last_MOSI_data;
		int clock_cycles;
		bit my_flag; // flag==1 means i'm waiting for read address operation before read data comes 
		bit [7:0] prev_tx_data; // to stop randomization and preserve last value of tx_data when sending miso bits to master

        function new(string name = "SPI_slave_sequence_item");
			super.new(name);
			my_flag=1;
		endfunction
	
		
		// Constraint blocks
		constraint rst_constraint {
			rst_n dist {1:/99,0:/1};//Reset to be asserted with a low probability , 99% off & 1% on
		}


    constraint MOSI_start_bits_c {
		// if rst_n asserted ,next operation can't be read data until read address operation come 
		if (clock_cycles == 0 && ~SS_n && my_flag) {MOSI_data[10:8] inside {3'b000,3'b001,3'b110}};
		else if(clock_cycles == 0 && ~SS_n) {MOSI_data[10:8] inside {3'b000,3'b001,3'b110, 3'b111} };
		else  MOSI_data == last_MOSI_data;
	}
	constraint SS_n_c {
		if (MOSI_data [10:8]==3'b111) { //READ_DATA
	if (clock_cycles==22){
		SS_n == 1;
	}
	else SS_n == 0;
	}
	else {
	if (clock_cycles==12) 
		SS_n == 1;
	else SS_n == 0;
	}
	}

	constraint MOSI_data_bits_c {
	if (clock_cycles > 0 && clock_cycles <12 )
	mosi == MOSI_data[11 - clock_cycles];
	else
	mosi == 0;
	}



	function void post_randomize ;
	//if (ss_n_ prev && ~sS_n)
	//MOSI_data_prev=MOSI_data;
	if(~SS_n & rst_n)
	clock_cycles=clock_cycles+1;
	else
	clock_cycles=0;
	if ((MOSI_data[10:8] == 3'b111 && clock_cycles > 22) ||
				(MOSI_data[10:8] != 3'b111 && clock_cycles > 12)) begin
				clock_cycles = 0;
			end
     last_MOSI_data=MOSI_data;
	 prev_tx_data = tx_data;
	 if(~rst_n || MOSI_data[10:8]==3'b111) my_flag=1;
	 else if(MOSI_data[10:8]==3'b110) my_flag =0;
endfunction

	constraint c_tx_valid {
   		 if (MOSI_data[10:8] ==3'b111 && clock_cycles >13) {
     	 tx_valid == 1;
		 tx_data == prev_tx_data;}
    		else
      	tx_valid == 0;
  		}
   

		// Convert to string functions
		function string convert2string();
  			return $sformatf(
   			"%s rst_n = %0b, ss_n= %0b, mosi= %0b, tx_valid = %0b, tx_data = %0b, rx_data = %0b, MISO = %0b,rx_valid = %0b",
    		super.convert2string(), rst_n, SS_n, mosi, tx_valid, tx_data, rx_data, miso,rx_valid);
			endfunction : convert2string


  		function string convert2string_stimulus();
  			return $sformatf(
    		" rst_n = %0b, ss_n= %0b, mosi= %0b, tx_valid = %0b, tx_data = %0b, rx_data = %0b, MISO = %0b,rx_valid = %0b",
    		rst_n, SS_n, mosi, tx_valid, tx_data, rx_data, miso,rx_valid);
			endfunction : convert2string_stimulus

	endclass : SPI_slave_sequence_item

endpackage : SPI_slave_sequence_item_pkg