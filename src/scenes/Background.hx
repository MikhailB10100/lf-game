package scenes;

class Background extends h2d.Scene {
    var bounds : h2d.col.Bounds;
    
    public function new(?parent: h2d.Object) {
        super();
        this.width = 5000;
        this.height = 1080;
        var backgroundTile = hxd.Res.our_game.cityskyline.toTile();
        backgroundTile.scaleToSize(this.width, this.height);
        var background = new h2d.Bitmap(backgroundTile, this);
        background.setPosition(0, 0);
        bounds = new h2d.col.Bounds();
        bounds.width = this.width;
        bounds.height = this.height;
        bounds.y = 0;
        bounds.x = 0;
        parent.addChild(this);
    }
}