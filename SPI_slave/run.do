vlib work
vlog -f SPI_slave.list  +cover -covercells  +define+SIM
vsim -voptargs=+acc work.SPI_slave_top -cover -sv_seed random -l sim.spi_log
add wave /SPI_slave_top/SPI_slave_if/*
coverage save SPI_slave.ucdb -onexit
run -all
#quit -sim
#vcover report SPI_slave.ucdb -details -annotate -all -output coverage_SPI_slave_rpt.txt
##+define+SIM