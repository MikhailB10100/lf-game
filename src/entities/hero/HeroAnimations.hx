package entities.hero;

/**
    enum of Hero animations
**/
enum HeroAnimation {
    IDLE;
    RUNNING;
    JUMP;
}

class HeroAnimations extends objects.AnimationsController<HeroAnimation> {
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
