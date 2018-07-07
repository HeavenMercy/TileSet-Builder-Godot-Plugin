tool
extends WindowDialog

onready var ss_file_dialog = get_node("ss_file_dialog")
onready var ss_path = get_node("vbox/ss_hbox/ss_path")
onready var ss_select_btn = get_node("vbox/ss_hbox/ss_select_btn")

onready var x_ts_spin = get_node("vbox/tile_size_hbox/x_SpinBox")
onready var y_ts_spin = get_node("vbox/tile_size_hbox/y_SpinBox")
onready var x_o_spin = get_node("vbox/offset_hbox/x_SpinBox")
onready var y_o_spin = get_node("vbox/offset_hbox/y_SpinBox")
onready var x_s_spin = get_node("vbox/spacing_hbox/x_SpinBox")
onready var y_s_spin = get_node("vbox/spacing_hbox/y_SpinBox")
onready var submit_btn = get_node("vbox/submit_btn")

onready var dest_folder_dialog = get_node("dest_folder_dialog")
onready var dest_path = get_node("vbox/dest_hbox/dest_path")
onready var dest_select_btn = get_node("vbox/dest_hbox/dest_select_btn")
onready var gene_scn_CheckBox = get_node("vbox/gene_scn_CheckBox")

signal tileset_data_provided( texture_path, tile_size, offset, spacing, destination, scene_only )

func _ready():
	ss_select_btn.connect( "pressed", ss_file_dialog, "popup_centered" )
	dest_select_btn.connect( "pressed", dest_folder_dialog, "popup_centered" )
	submit_btn.connect( "pressed", self, "_on_submit_btn_pressed" )
	ss_file_dialog.connect( "file_selected", ss_path, "set_text" )
	dest_folder_dialog.connect( "dir_selected", dest_path, "set_text" )

func _on_submit_btn_pressed():
	emit_signal( "tileset_data_provided", ss_path.get_text(),
		Vector2( x_ts_spin.get_value(), y_ts_spin.get_value() ),
		Vector2( x_o_spin.get_value(), y_o_spin.get_value() ),
		Vector2( x_s_spin.get_value(), y_s_spin.get_value() ),
		dest_path.get_text(), get_node("vbox/gene_scn_CheckBox").is_pressed() )
	hide()
