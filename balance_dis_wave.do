onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /baldis_tb/st
add wave -noupdate /baldis_tb/clk
add wave -noupdate /baldis_tb/reset
add wave -noupdate /baldis_tb/ten_in
add wave -noupdate /baldis_tb/one_df_in
add wave -noupdate /baldis_tb/suc
add wave -noupdate /baldis_tb/led_s70
add wave -noupdate /baldis_tb/D70
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67833 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1050 ns}
