onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testgarage/ACSC_t
add wave -noupdate /testgarage/aes_key_t
add wave -noupdate /testgarage/authentication_led_t
add wave -noupdate /testgarage/authentication_t
add wave -noupdate /testgarage/bad_encryption_t
add wave -noupdate /testgarage/clk_t
add wave -noupdate /testgarage/close_light_t
add wave -noupdate /testgarage/command_t
add wave -noupdate /testgarage/key_led_t
add wave -noupdate /testgarage/open_light_t
add wave -noupdate /testgarage/reached_bottom_t
add wave -noupdate /testgarage/reached_top_t
add wave -noupdate /testgarage/reset_t
add wave -noupdate /testgarage/switch_t
add wave -noupdate /testgarage/timeout_t
add wave -noupdate /testgarage/G1/state
add wave -noupdate /testgarage/G2/state_reg_3_q
add wave -noupdate /testgarage/G2/state_reg_2_q
add wave -noupdate /testgarage/G2/state_reg_1_q
add wave -noupdate /testgarage/G2/state_reg_0_q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 215
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
WaveRestoreZoom {0 ns} {368 ns}
