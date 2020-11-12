SetActiveLib -work
comp -include "$dsn\src\ICTR.vhd" 
comp -include "$dsn\src\ictr_TB.vhd" 
asim +access +r TESTBENCH_FOR_ictr 
wave 
wave -noreg CLK
wave -noreg R
wave -noreg WR
wave -noreg D
wave -noreg F
wave -noreg A
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\ictr_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ictr 
