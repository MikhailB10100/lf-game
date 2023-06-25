package objects;

/**
    Class-controller for animations.
**/
class AnimationsController<Key: EnumValue> {
    /**
        Map with Animation objects for specified generic enum.
    **/
    public final animations = new Map<Key, objects.Animation>();
    /**
        h2d.Anim object that adds to the parent passed to constructor.
    **/
    public final anim : h2d.Anim;
    /**
        Animation that currently plays.
    **/
    public var currentAnimation : Key;

    public function new(parent: h2d.Object) {
        anim = new h2d.Anim([h2d.Tile.fromColor(0x000000)]);
        parent.addChild(anim);
    }

    /**
        Play animation with specified key.
        @param key key from controller generic enum.
    **/
    public function play(key: Key, ?next: Key) {
        if (currentAnimation == key) return;
        var animation = animations.get(key);
        if (animation == null) {
            throw "Animation not found";
        } 
        currentAnimation = key;
        anim.play(animation.frames);
        // anim.speed = animation.frames.length;
        // TODO: check it later.
        anim.speed = 60;
        if (next != null) {
            var isNextExists = animations.exists(next);
            if (!isNextExists) {
                throw "Next animation not found";
            }
            anim.onAnimEnd = function() {
                anim.onAnimEnd = function() {}
                this.play(next);
            };
        }
    }
}