package objects;

class AnimationsController<Key: EnumValue> {
    public final animations = new Map<Key, objects.Animation>();
    public var currentAnimation : Key;
    public var anim : h2d.Anim;

    public function new(parent: h2d.Object) {
        anim = new h2d.Anim([h2d.Tile.fromColor(0x000000)]);
        parent.addChild(anim);
    }

    /**
        Play animation with specified key
        @param key key from controller generic enum
    **/
    public function play(key: Key) {
        if (currentAnimation == key) return;
        var animation: Null<Animation> = animations.get(key);
        if (animation == null) {
            throw "Animation not found";
        }
        currentAnimation = key;
        anim.play(animation.frames);
        anim.speed = animation.speed;
    }
}