# Constrain clock to 200 M. 
# No I/O constraints as only interested in timing through the module - ignore DRC violation
create_clock -period 5.000 -name clock -waveform {0.000 2.500} [get_ports clock]
