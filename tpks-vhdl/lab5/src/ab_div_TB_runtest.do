SetActiveLib -work
comp -include "$dsn\src\AB_DIV.vhd" 
comp -include "$dsn\src\ab_div_TB.vhd" 
asim +access +r TESTBENCH_FOR_ab_div 
wave 
wave -noreg Clk
wave -noreg St
wave -noreg Dbus
wave -noreg Quotient
wave -noreg V
wave -noreg Rdy
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\ab_div_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ab_div 
