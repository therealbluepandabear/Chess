module sfmlextensions;

import bindbc.sfml;

enum isDrawable(T) = is(T == sfRectangleShape*) || is(T == sfSprite*);

void sfRenderWindowExt_draw(T)(sfRenderWindow* renderWindow, T drawable) {
    import std.format;
    static assert(isDrawable!T, format("Cannot call any draw method on type %s", T.stringof));

    static if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(drawable, null);
    } else static if (is(T == sfSprite*)) {
        renderWindow.sfRenderWindow_drawSprite(drawable, null);
    }
}

sfVector2f sfVector2fExt_splat(float size) {
    return sfVector2f(size, size);
}

void sfSpriteExt_sizeToBounds(sfSprite* sprite, sfTexture* texture, sfVector2f bounds) {
    sprite.sfSprite_setScale(sfVector2f(bounds.x / texture.sfTexture_getSize().x, bounds.y / texture.sfTexture_getSize().y));
}