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
            ChessPiece pawn = new Pawn();
            for (int i = 0; i < 8; ++i) {
                pawn.boardPosition = sfVector2i(i, 1);
                _pieces ~= ChessSpriteLoader.load(pawn, _chessboard.squareSize);
            }

            ChessPiece rook = new Rook();
            for (int i = 0; i < 2; ++i) {
                if (i == 0) {
                    rook.boardPosition(sfVector2i(0, 0));
                } else {
                    rook.boardPosition(sfVector2i(7, 0));
                }
                _pieces ~= ChessSpriteLoader.load(rook, _chessboard.squareSize);
            }

            ChessPiece king = new King();
            king.boardPosition = sfVector2i(4, 0);
            _pieces ~= ChessSpriteLoader.load(king, _chessboard.squareSize);

            ChessPiece queen = new Queen();
            queen.boardPosition = sfVector2i(3, 0);
            _pieces ~= ChessSpriteLoader.load(queen, _chessboard.squareSize);

            ChessPiece knight = new Knight();
            for (int i = 0; i < 2; ++i) {
                if (i == 0) {
                    knight.boardPosition = sfVector2i(1, 0);
                } else {
                    knight.boardPosition = sfVector2i(6, 0);
                }
                _pieces ~= ChessSpriteLoader.load(knight, _chessboard.squareSize);
            }

            ChessPiece bishop = new Bishop();
            for (int i = 0; i < 2; ++i) {
                if (i == 0) {
                    bishop.boardPosition = sfVector2i(2, 0);
                } else {
                    bishop.boardPosition = sfVector2i(5, 0);
                }
                _pieces ~= ChessSpriteLoader.load(bishop, _chessboard.squareSize);
            }
        }

        Window _window;
        Chessboard _chessboard;
        sfSprite*[] _pieces;
    }
}