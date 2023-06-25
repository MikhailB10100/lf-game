package entities.hero;

/**
    Class that represents hero.
**/
class Hero extends h2d.Object {
    var bounds : h2d.col.Bounds;
    /**
        Controller for hero's animation.
    **/
    public final ANIMATIONS: HeroAnimationsController;
    /**
        Force of gravity.
    **/
    public final GRAVITY = 50;
    /**s
        Initial move speed.
    **/
    public final INITIAL_MOVE_SPEED = 800;
    /**
        Initial vertical velocity.
    **/
    public final INITIAL_VERTICAL_VELOCITY = -25;

    var verticalVelocity : Float = 0;
    var horizontalVelocity : Float = 0;
    var horizontalVelocityMultiplier : Float = 1;

    public function new(?parent: h2d.Object) {
        super(parent);

        bounds = new h2d.col.Bounds();
        
        bounds.y = 0;
        bounds.x = 0;
        
        this.ANIMATIONS = new HeroAnimationsController(this);
        // bounds.width = anim.frames[Math.floor(anim.currentFrame)].width;
        // bounds.height = anim.frames[Math.floor(anim.currentFrame)].height;
    }

    /**
		Update hero.
		Called each frame right before rendering.
		@param dt Time elapsed since last frame, normalized.
		@param keys Pressed keys. [TODO: refactor].
		@param bottomBound Current scene bottom bound. [TODO: refactor].
	**/
    public function update(dt: Float, keys: { left : Bool, right : Bool, jump : Bool }, bottomBound: Float) {
        if (!keys.left && !keys.right && horizontalVelocity != 0) {
            ANIMATIONS.play(HeroAnimationsController.HeroAnimation.POST_RUNNING, HeroAnimationsController.HeroAnimation.IDLE);
        }
        if ((keys.left && keys.right) || (!keys.left && !keys.right)) {
            horizontalVelocity = 0;
            if (verticalVelocity == 0 && horizontalVelocity == 0 && ANIMATIONS.currentAnimation != HeroAnimationsController.HeroAnimation.POST_RUNNING) {
                ANIMATIONS.play(HeroAnimationsController.HeroAnimation.IDLE);
            }
        } else {
            if (verticalVelocity == 0) {
                ANIMATIONS.play(HeroAnimationsController.HeroAnimation.RUNNING);
            }
            if (keys.left) {
                horizontalMoveKeyHandler(this.scaleX == 1, dt);
            } else if (keys.right) {
                horizontalMoveKeyHandler(this.scaleX == -1, dt);
            }
        }

        if (keys.jump && verticalVelocity == 0) {
            verticalVelocity = INITIAL_VERTICAL_VELOCITY;
        }

        this.y = Math.min(this.y + verticalVelocity * GRAVITY * dt, bottomBound);

        if (this.y == bottomBound) {
            verticalVelocity = 0;
        } else {
            verticalVelocity += GRAVITY * dt;
            if (horizontalVelocity == 0) {
                //
            } else {
                ANIMATIONS.play(HeroAnimationsController.HeroAnimation.JUMP);
            }
        }

        this.x += horizontalVelocity * horizontalVelocityMultiplier * dt;
    }

    function horizontalMoveKeyHandler(flipCondition : Bool, dt : Float) {
        if (flipCondition) {
            this.scaleX *= -1;
            horizontalVelocityMultiplier = this.scaleX;
        }
        if (horizontalVelocity == 0) horizontalVelocity = INITIAL_MOVE_SPEED;
    }
}