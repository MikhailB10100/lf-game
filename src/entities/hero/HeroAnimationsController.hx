package entities.hero;

/**
    TODO: write docs.
**/
enum HeroAnimation {
    /**
        Animation of hero's idle (afk).
    **/
    IDLE;
    /**
        Animation of hero's run.
    **/
    RUNNING;
    /**
        Animation of hero's jump.
    **/
    JUMP;
}

/**
    AnimationsController for Hero.
**/
class HeroAnimationsController extends objects.AnimationsController<HeroAnimation> {
    public function new(parent: h2d.Object) {
        super(parent);
        this.animations.set(HeroAnimation.IDLE, new objects.Animation([hxd.Res.our_game.hero1_untitled_mainview.toTile()]));
        this.animations.set(
            HeroAnimation.RUNNING,
            objects.Animation.fromSprite("sprites/hero/running"),
        );
        this.animations.set(
            HeroAnimation.JUMP,
            objects.Animation.fromSprite("sprites/hero/jump2")
        );
        this.play(HeroAnimation.IDLE);
    }
}
