/**
    Core Game class.
**/
class Game extends hxd.App {
    var bottomBound : Float;
    var pad = hxd.Pad.createDummy();

    var background : scenes.Background;
    var hero : entities.hero.Hero;

    override function init() {
        hxd.Pad.wait(function(p) this.pad = p);
        hxd.Res.initEmbed();

        background = new scenes.Background(s2d);
        bottomBound = background.height * 0.5;
        
        hero = new entities.hero.Hero(background);

        background.camera.follow = hero;
        background.camera.anchorX = 0.5;
        background.camera.anchorY = 0.8;
        hero.setPosition(background.width * 0.5, background.height * 0.5);
    }

    override function update( dt : Float ) {
        var keys = {
            left : hxd.Key.isDown(hxd.Key.LEFT) || hxd.Key.isDown("A".code) || pad.xAxis < -0.5,
            right : hxd.Key.isDown(hxd.Key.RIGHT) || hxd.Key.isDown("D".code) || pad.xAxis > 0.5,
            jump : hxd.Key.isDown(hxd.Key.UP) || hxd.Key.isDown("W".code) || hxd.Key.isDown(hxd.Key.SPACE) || pad.yAxis < - 0.5 || pad.buttons[hxd.Pad.DEFAULT_CONFIG.A],
        };

        hero.update(dt, keys, bottomBound);
    }

    static function main() {
        new Game();
    }
}