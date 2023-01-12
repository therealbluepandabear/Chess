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

        initPieces();
    }

    void update() {
        _window.update();
    }

    void render() {
        _window.beginDraw();
        _chessboard.render(_window.renderWindow);
        foreach (sfSprite* pieceSprite; _pieces) {
            _window.renderWindow.sfRenderWindowExt_draw(pieceSprite);
        }
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        void initPieces() {
            Pawn pawn = new Pawn();
            for (int i = 0; i < 8; ++i) {
                pawn.boardPosition = sfVector2i(i, 1);
                _pieces ~= ChessSpriteLoader.load(pawn, _chessboard.squareSize);
            }

            Rook rook = new Rook();
            for (int i = 0; i < 2; ++i) {
                if (i == 0) {
                    rook.boardPosition(sfVector2i(0, 0));
                } else {
                    rook.boardPosition(sfVector2i(7, 0));
                }
                _pieces ~= ChessSpriteLoader.load(rook, _chessboard.squareSize);
            }
        }

        Window _window;
        Chessboard _chessboard;
        sfSprite*[] _pieces;
    }
}