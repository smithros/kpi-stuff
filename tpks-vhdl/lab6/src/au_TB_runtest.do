SetActiveLib -work
comp -include "$dsn\src\AU.vhd" 
comp -include "$dsn\src\au_TB.vhd" 
asim +access +r TESTBENCH_FOR_au 
wave 
wave -noreg C
wave -noreg RST
wave -noreg START
wave -noreg RD
wave -noreg WRD
wave -noreg RET
wave -noreg CALL
wave -noreg DI
wave -noreg AB
wave -noreg AD
wave -noreg AQ
wave -noreg ARET
wave -noreg ACOP
wave -noreg RDY
wave -noreg ARETO
wave -noreg DO
wave -noreg BO
wave -noreg CNZ
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\au_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_au 
