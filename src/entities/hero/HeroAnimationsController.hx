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
        Animation of hero's stopping after run.
    **/
    POST_RUNNING;
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
        this.animations.set(
            HeroAnimation.IDLE,
            objects.Animation.fromSprite("sprites/hero/idle")
        );
        this.animations.set(
            HeroAnimation.RUNNING,
            objects.Animation.fromSprite("sprites/hero/running"),
        );
        this.animations.set(
            HeroAnimation.JUMP,
            objects.Animation.fromSprite("sprites/hero/jump")
        );
        this.animations.set(
            HeroAnimation.POST_RUNNING,
            objects.Animation.fromSprite("sprites/hero/post-running")
        );
        this.play(HeroAnimation.IDLE);
    }
}
