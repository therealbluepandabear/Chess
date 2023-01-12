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

        initPawns();
    }

    void update() {
        _window.update();
    }

    void render() {
        _window.beginDraw();
        _chessboard.render(_window.renderWindow);
        foreach (sfSprite* pawnSprite; _pawns) {
            _window.renderWindow.sfRenderWindowExt_draw(pawnSprite);
        }
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        void initPawns() {
            Pawn pawn = new Pawn();
            sfSprite* pawnSprite = ChessSpriteLoader.load(pawn, _chessboard.squareSize);

            for (int i = 0; i < 8; ++i) {
                pawn.boardPosition = sfVector2i(i, 1);
                _pawns ~= ChessSpriteLoader.load(pawn, _chessboard.squareSize);
            }
        }

        Window _window;
        Chessboard _chessboard;
        sfSprite*[] _pawns;
    }
}