SetActiveLib -work
comp -include "$dsn\src\RAM.vhd" 
comp -include "$dsn\src\ram_TB.vhd" 
asim +access +r TESTBENCH_FOR_ram 
wave 
wave -noreg CLK
wave -noreg R
wave -noreg WR
wave -noreg OE
wave -noreg AE
wave -noreg AD
wave -noreg D
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\ram_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ram 
