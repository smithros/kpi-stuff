SetActiveLib -work
comp -include "$dsn\src\LPF_HB_LAB.vhd" 
comp -include "$dsn\src\lpf_hb_lab_TB.vhd" 
asim +access +r TESTBENCH_FOR_lpf_hb_lab 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg X
wave -noreg Y
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\lpf_hb_lab_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_lpf_hb_lab 
