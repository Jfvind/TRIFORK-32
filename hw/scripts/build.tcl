# Generate output directory (git ignored)
set outputDir ./hw/vivado
file mkdir $outputDir

# Setup project (name is "system")
create_project -force system $outputDir -part xc7a35tcpg236-1

# Add Wildcat verilog and constraints
add_files [glob ./wildcat/generated/*.v]
add_files -fileset constrs_1 ./hw/constraints/basys3.xdc

# Copy hex files (data0 - data3) so Vivado can find them for $readmemh.
foreach f [glob -nocomplain ./wildcat/data*.hex] {
    file copy -force $f $outputDir/
    file copy -force $f .
}

# Set top module to RustSoCTop
set_property top RustSoCTop [current_fileset]

# Create XADC wiz 
create_ip -name xadc_wiz -vendor xilinx.com -library ip -version 3.3 -module_name xadc_wiz_0
set_property -dict [list \
  CONFIG.INTERFACE_SELECTION {Enable_DRP} \
  CONFIG.SEQUENCER_MODE {Continuous} \
  CONFIG.XADC_STARUP_SELECTION {channel_sequencer} \
  CONFIG.CHANNEL_ENABLE_VAUXP6_VAUXN6 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP14_VAUXN14 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP7_VAUXN7 {true} \
  CONFIG.CHANNEL_ENABLE_VAUXP15_VAUXN15 {true} \
] [get_ips xadc_wiz_0]
generate_target all [get_ips xadc_wiz_0]
synth_ip [get_ips xadc_wiz_0]

# Run Synthesis
puts "Running Synthesis..."
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Run Implementation
puts "Running Implementation..."
launch_runs impl_1 -jobs 4
wait_on_run impl_1

# Generate Bitstream and BIN file
puts "Generating Bitstream..."
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

puts "Build Complete! Bitstream is in $outputDir/system.runs/impl_1/RustSoCTop.bin"