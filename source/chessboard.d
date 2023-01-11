module chessboard;

import bindbc.sfml;
import sfmlextensions;

class Chessboard {
    this(sfVector2u windowSize) {
        _windowSize = windowSize;
        initChessboardRectangles();

        assert(_chessboardRectangles.length == 64, "Invalid length");
    }

    void render(sfRenderWindow* renderWindow) {
        foreach (sfRectangleShape* rect; _chessboardRectangles) {
            assert(rect !is null, "rect cannot be null");

            renderWindow.sfRenderWindowExt_draw(rect);
        }
    }

    private {
        void initChessboardRectangles() {
            float blockSize = (cast(float)_windowSize.x) / 8f;
            sfColor fillColor;

            for (float x = 0; x < 8; ++x) {
                for (float y = 0; y < 8; ++y) {
                    if (x % 2 == 0) {
                        if (y % 2 == 0) {
                            fillColor = sfBlack;
                        } else {
                            fillColor = sfWhite;
                        }
                    } else {
                        if (y % 2 != 0) {
                            fillColor = sfBlack;
                        } else {
                            fillColor = sfWhite;
                        }
                    }
                    sfRectangleShape* shape = sfRectangleShape_create();
                    shape.sfRectangleShape_setSize(sfVector2f(blockSize, blockSize));
                    shape.sfRectangleShape_setFillColor(fillColor);
                    shape.sfRectangleShape_setPosition(sfVector2f(blockSize * x, blockSize * y));
                    _chessboardRectangles ~= shape;
                }
            }
        }

        sfRectangleShape*[] _chessboardRectangles;
        sfVector2u _windowSize;
    }
}