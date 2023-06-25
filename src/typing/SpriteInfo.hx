package typing;

/**
    Describes object from sprite.json file. [TODO: insert information of sprite.json].
**/
typedef SpriteInfo = {
    /**
        Path to sprite relative to sprite.json.
    **/
    path: String,
    /**
        Array of frames positions and sizes.
    **/
    frames: Array<{ x: Int, y: Int, width: Int, height: Int }>
}
