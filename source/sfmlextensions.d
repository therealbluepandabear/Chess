module sfmlextensions;

import bindbc.sfml;

enum bool isDrawable(T) = is(T == sfRectangleShape*) || is(T == sfSprite*) || is(T == sfCircleShape*);

void sfRenderWindowExt_draw(T)(sfRenderWindow* renderWindow, T drawable)
if (isDrawable!T) {
    static if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(drawable, null);
    } else static if (is(T == sfSprite*)) {
        renderWindow.sfRenderWindow_drawSprite(drawable, null);
    } else static if (is(T == sfCircleShape*)) {
        renderWindow.sfRenderWindow_drawCircleShape(drawable, null);
    }
}

sfVector2f sfVector2fExt_splat(float size) {
    return sfVector2f(size, size);
}

sfVector2f sfSpriteExt_getSize(sfSprite* sprite) {
    return sfVector2f(sprite.sfSprite_getGlobalBounds().width, sprite.sfSprite_getGlobalBounds().height);
}
