SetActiveLib -work
comp -include "$dsn\src\E_X_CALC.vhd" 
comp -include "$dsn\src\e_x_calc_TB.vhd" 
asim +access +r TESTBENCH_FOR_e_x_calc 
wave 
wave -noreg CLK
wave -noreg START
wave -noreg DI
wave -noreg RDY
wave -noreg DO
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\e_x_calc_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_e_x_calc 
