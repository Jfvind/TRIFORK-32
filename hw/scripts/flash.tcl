# Connect to the board (Can only be found if only one board is connected)
open_hw_manager
connect_hw_server
open_hw_target

set device [lindex [get_hw_devices] 0]
current_hw_device $device

# Add Configuration Memory (Macronix mx25l3273f (for Basys3))
create_hw_cfgmem -hw_device $device -mem_dev [lindex [get_cfgmem_parts mx25l3273f-spi-x1_x2_x4] 0]

set mem_device [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]

# Set the file to flash (passed as an argument from xtask)
set bin_file [lindex $argv 0]
set_property PROGRAM.FILES [list $bin_file] $mem_device

# Configure programming options
set_property PROGRAM.ADDRESS_RANGE  {use_file} $mem_device
set_property PROGRAM.PRM_FILE {} $mem_device
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} $mem_device
set_property PROGRAM.BLANK_CHECK  0 $mem_device
set_property PROGRAM.ERASE  1 $mem_device
set_property PROGRAM.CFG_PROGRAM  1 $mem_device
set_property PROGRAM.VERIFY  1 $mem_device
set_property PROGRAM.CHECKSUM  0 $mem_device

# Flashing to board.
puts "Flashing $bin_file to device..."
startgroup 
    if {![string equal [get_property PROGRAM.HW_CFGMEM_TYPE $device] [get_property MEM_TYPE [get_property CFGMEM_PART $mem_device]]] }  { 
        create_hw_bitstream -hw_device $device [get_property PROGRAM.HW_CFGMEM_BITFILE $device]; 
        program_hw_devices $device; 
    }; 
    program_hw_cfgmem -hw_cfgmem $mem_device
endgroup

puts "Flashing Complete!"