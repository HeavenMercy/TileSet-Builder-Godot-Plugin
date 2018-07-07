tool
extends EditorPlugin
func get_name(): return "TileSet-Builder"

####################################################################
var btn = null
var dialog = null
var err_dialog = null

var i = null
var tex = null
var tex_size = null
var tile_pos = null
var tile_set = null
var tile = null; var root = null; var pkd_scn = null
####################################################################

func _enter_tree():
	dialog = preload( "dialog.tscn" ).instance()
	get_base_control().add_child( dialog )
	dialog.connect( "tileset_data_provided", self, "build_tileset" )

	err_dialog = AcceptDialog.new()
	get_base_control().add_child(err_dialog)
	err_dialog.set_hide_on_ok( true )

	tile_set = TileSet.new()
	tex = ImageTexture.new()

	btn = Button.new()
	btn.set_text( "Build TileSet" )
	btn.connect( "pressed", dialog, "popup_centered" )
	add_control_to_container( CONTAINER_CANVAS_EDITOR_MENU, btn )

func destroy(obj):
	if obj != null and obj.has_method("queue_free"):
		obj.queue_free()

func _exit_tree():
	destroy( btn )
	destroy( dialog )
	destroy( err_dialog )
	##########################
	destroy( tex )
	destroy( tile_set )
	destroy( tile )
	destroy( root )
	destroy( pkd_scn )

######################################################################

func build_tileset( tex_path, tile_size, offset, spacing, dest_path, scene_only ):
	tex.load( tex_path )
	tex.set_flags( 0 )
	tex_size = tex.get_size()

	if tile_size.x > tex_size.x or tile_size.y > tex_size.y:
		err_dialog.set_text(
			"[color=red]Error: The tile size "+String(tile_size)+\
			" doesn't fit in the texture size "+String(tex_size)+" ![/color]" )
		err_dialog.popup_centered()
	else:
		i = 0
		tile_set.clear()
		tile_pos = offset
		if scene_only:
			root = Node.new()
			root.set_name( "root")

		while tile_pos.y < tex_size.y - offset.y:
			while tile_pos.x < tex_size.x - offset.x:
				if scene_only:
					tile = Sprite.new()
					tile.set_region( true )
					tile.set_texture( tex )
					tile.set_name( "tile@" + String(i) )
					tile.set_region_rect( Rect2(tile_pos, tile_size) )
					tile.set_pos( tile_pos + Vector2(20, 20) )

					root.add_child( tile )
					tile.set_owner( root )
				else:
					tile_set.create_tile( i )
					tile_set.tile_set_name( i, "tile@" + String(i) )
					tile_set.tile_set_region( i, Rect2(tile_pos, tile_size) )
					tile_set.tile_set_texture( i, tex )

				i += 1
				tile_pos.x += tile_size.x + spacing.x
			tile_pos.x = offset.x
			tile_pos.y += tile_size.y + spacing.y

		if scene_only:
			pkd_scn = PackedScene.new()
			pkd_scn.pack( root )
		i = tex_path.get_file()
		i = i.substr( 0, i.find_last('.') )
		ResourceSaver.save( dest_path+"/"+i+(".tscn" if scene_only else ".tres"),
			(pkd_scn if scene_only else tile_set), ResourceSaver.FLAG_BUNDLE_RESOURCES )

		err_dialog.set_text( ("Scene" if scene_only else "TileSet")+\
			" successfully created in '"+dest_path+"'!" )
		err_dialog.popup_centered()
