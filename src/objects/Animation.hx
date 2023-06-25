package objects;

/**
    Class-storage for h2d.Anim data. Used for AnimationsController.    
**/
class Animation {
    /**
        Frames of h2d.Anim.
    **/
    public final frames : Array<h2d.Tile>;
    /**
        Speed of h2d.Anim.
    **/
    public function new(frames : Array<h2d.Tile>) {
        for (frame in frames) {
            frame.dx = frame.width * -0.5;
            frame.dy = frame.height * -0.5;
        }
        this.frames = frames;
    }

    /**
        Create Animation from sprite. Requires sprite.json. More info: [TODO: insert link to information].
        @param spriteDir source directory of sprite.png and sprite.json.
        @return Animation
    **/
    public static function fromSprite(spriteDir: String): Animation {
        var sprite = hxd.Res.load('${spriteDir}/sprite.png').toTile();
        var spriteInfo : typing.SpriteInfo = haxe.Json.parse(sys.io.File.getContent('res/${spriteDir}/sprite.json'));
        var tiles : Array<h2d.Tile> = [for (frame in spriteInfo.frames) sprite.sub(frame.x, frame.y, frame.width, sprite.height)];
        return new Animation(tiles);
    }
}
