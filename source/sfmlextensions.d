module sfmlextensions;

import bindbc.sfml;

enum isDrawable(T) = is(T == sfRectangleShape*);

void sfRenderWindowExt_draw(T)(sfRenderWindow* renderWindow, T drawable) {
    static assert(isDrawable!T, format("Cannot call any draw method on type %s", T.stringof));

    static if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(drawable, null);
    }
}