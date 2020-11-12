SetActiveLib -work
comp -include "$dsn\src\ALU1.vhd" 
comp -include "$dsn\src\alu1_TB.vhd" 
asim +access +r TESTBENCH_FOR_alu1 
wave 
wave -noreg C0
wave -noreg F
wave -noreg A
wave -noreg B
wave -noreg N
wave -noreg CY
wave -noreg Z
wave -noreg Y
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\alu1_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_alu1 
