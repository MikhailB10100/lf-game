package objects;

class Animation {
    public var frames : Array<h2d.Tile>;
    public var speed : Float = 15;

    public function new(frames : Array<h2d.Tile>, speed : Float = 15) {
        for (frame in frames) {
            frame.dx = frame.width * -0.5;
            frame.dy = frame.height * -0.5;
        }
        this.frames = frames;
        this.speed = speed;
    }

    public static function fromSprite(spriteDir: String): Animation {
        var sprite = hxd.Res.load('${spriteDir}/sprite.png').toTile();
        var spriteInfo : typing.SpriteInfo = haxe.Json.parse(sys.io.File.getContent('res/${spriteDir}/sprite.json'));
        var tiles : Array<h2d.Tile> = [for (frame in spriteInfo.frames) sprite.sub(frame.x, frame.y, frame.width, frame.height)];

        return new Animation(tiles, spriteInfo.speed);
    }
}
