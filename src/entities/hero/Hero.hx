package entities.hero;

class Hero extends h2d.Object {
    var bounds : h2d.col.Bounds;
    public var animations : HeroAnimations;
    final GRAVITY : Float = 50;

    var verticalVelocity : Float = 0;
    var horizontalVelocity : Float = 0;
    var horizontalVelocityMultiplier : Float = 1;

    public function new(?parent: h2d.Object) {
        super(parent);

        bounds = new h2d.col.Bounds();
        
        bounds.y = 0;
        bounds.x = 0;
        
        this.animations = new HeroAnimations(this);
        // bounds.width = anim.frames[Math.floor(anim.currentFrame)].width;
        // bounds.height = anim.frames[Math.floor(anim.currentFrame)].height;
    }

    public function update(dt: Float, keys: { left : Bool, right : Bool, jump : Bool }, bottomBound: Float) {
        
        
        if ((keys.left && keys.right) || (!keys.left && !keys.right)) {
            horizontalVelocity = 0;
            if (verticalVelocity == 0) {
                animations.play(HeroAnimations.HeroAnimation.IDLE);
            }
        } else {
            if (verticalVelocity == 0) {
                animations.play(HeroAnimations.HeroAnimation.RUNNING);
            }
            if (keys.left) {
                horizontalMoveKeyHandler(this.scaleX == 1, dt);
            } else if (keys.right) {
                horizontalMoveKeyHandler(this.scaleX == -1, dt);
            }
        }

        if (keys.jump && verticalVelocity == 0) {
            verticalVelocity = -15;
        }

        this.y = Math.min(this.y + verticalVelocity * GRAVITY * dt, bottomBound);

        if (this.y == bottomBound) {
            verticalVelocity = 0;
        } else {
            verticalVelocity += GRAVITY * dt;
            if (horizontalVelocity == 0) {

            } else {
                animations.play(HeroAnimations.HeroAnimation.JUMP);
            }
        }

        this.x += horizontalVelocity * horizontalVelocityMultiplier * dt;
    }

    function horizontalMoveKeyHandler(flipCondition : Bool, dt : Float) {
        if (flipCondition) {
            this.scaleX *= -1;
            horizontalVelocityMultiplier = this.scaleX;
        }
        if (horizontalVelocity == 0) horizontalVelocity = 500;
    }
}