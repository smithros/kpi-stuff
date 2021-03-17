SetActiveLib -work
comp -include "$dsn\src\tpks2.vhd" 
comp -include "$dsn\src\tpks2_TB.vhd" 
asim +access +r TESTBENCH_FOR_tpks2 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg X
wave -noreg Y
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\tpks2_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_tpks2 
