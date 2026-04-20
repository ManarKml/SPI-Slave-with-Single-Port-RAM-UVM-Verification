vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs=+acc work.top  -cover
add wave /top/RAMif/*
coverage save RAM_top.ucdb -onexit
run -all
#Excluded the default case in the case statement since all possible cases are already covered
coverage exclude -src RAM.v -line 40 -code b
coverage exclude -src RAM.v -line 40 -code s
#quit -sim
#vcover report RAM_top.ucdb -details -annotate -all -output CC_SVA_cov_rprt_RAM.txt
#vcover report RAM_top.ucdb -du=RAM -recursive -assert -directive -cvg -codeAll -output cov_rprt_summary_RAM.txt