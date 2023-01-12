module game;

import window;
import bindbc.sfml;
import chessboard;
import chesspiece;
import sfmlextensions;

class Game {
    this() {
        _window = new Window("Chess", sfVector2u(500, 500));
        _chessboard = new Chessboard(_window.windowSize);
    }

    void update() {
        _window.update();
    }

    void render() {
        _window.beginDraw();
        _chessboard.render(_window.renderWindow);
        drawPawns();
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        void drawPawns() {
            Pawn pawn = new Pawn();
            sfSprite* pawnSprite = ChessSpriteLoader.load(pawn, _chessboard.squareSize);

            for (int i = 0; i < 8; ++i) {
                pawnSprite.sfSprite_setPosition(sfVector2f(i * _chessboard.squareSize, _chessboard.squareSize));
                _window.renderWindow.sfRenderWindowExt_draw(pawnSprite);
            }
        }

        Window _window;
        Chessboard _chessboard;
    }
}