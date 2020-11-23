SetActiveLib -work
comp -include "$dsn\src\FM.vhd" 
comp -include "$dsn\src\fm_TB.vhd" 
asim +access +r TESTBENCH_FOR_fm 
wave 
wave -noreg CLK
wave -noreg WR
wave -noreg AB
wave -noreg AD
wave -noreg AQ
wave -noreg Q
wave -noreg B
wave -noreg D
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\fm_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fm 
