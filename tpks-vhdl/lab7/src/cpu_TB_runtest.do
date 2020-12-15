SetActiveLib -work
comp -include "$dsn\src\DIV.vhd" 
comp -include "$dsn\src\LSM.vhd" 
comp -include "$dsn\src\FM.vhd" 
comp -include "$dsn\src\COP.vhd" 
comp -include "$dsn\src\ICTR.vhd" 
comp -include "$dsn\src\RAM.vhd" 
comp -include "$dsn\src\AU.vhd" 
comp -include "$dsn\src\CPU.vhd" 
comp -include "$dsn\src\cpu_TB.vhd" 
asim +access +r TESTBENCH_FOR_cpu 
wave 
wave -noreg C
wave -noreg RST
wave -noreg RDYP
wave -noreg DI
wave -noreg WRP
wave -noreg RDP
wave -noreg AP
wave -noreg DO
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\cpu_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_cpu 
