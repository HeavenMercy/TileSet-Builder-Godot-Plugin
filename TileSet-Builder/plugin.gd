tool
extends EditorPlugin
func get_name(): return "TileSet-Builder"

####################################################################
var btn
var dialog
var err_dialog

var i
var tex
var tex_size
var tile_pos
var tile_set
var tile; var root; var pkd_scn
####################################################################

func _enter_tree():
    dialog = preload("res://addons/TileSet-Builder/dialog.tscn").instance()
    get_editor_interface().get_base_control().add_child( dialog )
    dialog.connect( "tileset_data_provided", self, "build_tileset" )

    err_dialog = AcceptDialog.new()
    get_editor_interface().get_base_control().add_child(err_dialog)
    err_dialog.set_hide_on_ok( true )

    tile_set = TileSet.new()
    tex = ImageTexture.new()

    btn = Button.new()
    btn.set_anchor(MARGIN_LEFT, 30)
    btn.set_text( dialog.window_title )
    btn.connect( "pressed", dialog, "popup_centered" )
    add_control_to_container( EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, btn )

func destroy(obj):
    if obj != null and obj.has_method("queue_free"):
        obj.queue_free()

func _exit_tree():
    remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, btn)
    get_editor_interface().get_base_control().remove_child(err_dialog)
    get_editor_interface().get_base_control().remove_child( dialog )
    
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
    var img = Image.new()
    img.load( tex_path )
    tex.create_from_image( img, 0 )
    tex_size = tex.get_size()

    if tile_size.x <= 0 or tile_size.y <= 0:
        err_dialog.set_text(
            "Error: The tile size "+String(tile_size)+" must be larger than 0" )
        err_dialog.popup_centered()
        return

    if (tex_path.to_lower() == "res://"):
        err_dialog.set_text("Error: Must provide and image file paths!" )
        err_dialog.popup_centered()
        return

    if tile_size.x > tex_size.x or tile_size.y > tex_size.y:
        err_dialog.set_text(
            "Error: The tile size "+String(tile_size)+\
            " doesn't fit in the texture size "+String(tex_size)+"" )
        err_dialog.popup_centered()
        return

    i = 0
    tile_set.clear()
    tile_pos = offset
    if scene_only:
        root = Node.new()
        root.set_name( "tileset_root")

    while tile_pos.y < tex_size.y - offset.y:
        while tile_pos.x < tex_size.x - offset.x:
            if scene_only:
                tile = Sprite.new()
                tile.set_region( true )
                tile.set_texture( tex )
                tile.set_name( "tile@" + String(i) )
                tile.set_region_rect( Rect2(tile_pos, tile_size) )
                tile.position = tile_pos + Vector2(20, 20)

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
    ResourceSaver.save(
        dest_path+"/"+i+(".tscn" if scene_only else ".tres"),
        (pkd_scn if scene_only else tile_set),
        ResourceSaver.FLAG_BUNDLE_RESOURCES )

    err_dialog.set_text( ("Scene" if scene_only else "TileSet")+\
        " successfully created in '"+dest_path+"'!" )
    err_dialog.popup_centered()


