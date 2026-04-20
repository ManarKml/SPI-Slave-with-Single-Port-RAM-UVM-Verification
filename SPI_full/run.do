vlib work
vlog -f src_files.list +cover=sbeft -covercells
vsim -voptargs=+acc work.SPI_top -cover
add wave -position insertpoint sim:/SPI_top/wrapperif/*
run -all
coverage exclude -src SPI_RAM.v -line 40 -code b
coverage exclude -src SPI_RAM.v -line 40 -code s
coverage save SPI_coverage.ucdb -onexit -du WRAPPER
coverage report -detail -cvg -directive -comments -output funcov_assercov_SPI.txt
quit -sim
vcover report SPI_coverage.ucdb -details -annotate -all -output codecov_SPI.txt
vcover report SPI_coverage.ucdb -du=WRAPPER -recursive -assert -directive -cvg -codeAll -output cov_rprt_summary_SPI.txt
