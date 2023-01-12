module guichessboard;

import bindbc.sfml;
import sfmlextensions;
import oop;
import guichesspiece;

class GUIChessboard {
    this(sfVector2u windowSize) {
        _windowSize = windowSize;
        _squareSize = (cast(float)_windowSize.x) / 8f;
        initChessboardRectangles();

        assert(_chessboardRectangles.length == 64, "_chessboardRectangles has invalid length");
    }

    void render(sfRenderWindow* renderWindow) {
        assert(_guiChessPieces.length == 32, "_guiChessPieces has invalid length");

        foreach (sfRectangleShape* rect; _chessboardRectangles) {
            assert(rect !is null, "rect cannot be null");

            renderWindow.sfRenderWindowExt_draw(rect);
        }

        foreach (GUIChessPiece guiChessPiece; _guiChessPieces) {
            guiChessPiece.render(renderWindow);
        }
    }

    void addChessPiece(ChessPiece chessPiece) {
        _guiChessPieces ~= new GUIChessPiece(chessPiece, _squareSize);
    }

    @property {
        float squareSize() {
            return _squareSize;
        }

        GUIChessPiece[] guiChessPieces() {
            return _guiChessPieces;
        }
    }

    private {
        void initChessboardRectangles() {
            sfColor fillColor;
            sfColor tan = sfColor_fromRGB(210, 180, 140);

            for (float x = 0; x < 8; ++x) {
                for (float y = 0; y < 8; ++y) {
                    if (x % 2 == 0) {
                        if (y % 2 == 0) {
                            fillColor = sfWhite;
                        } else {
                            fillColor = tan;
                        }
                    } else {
                        if (y % 2 != 0) {
                            fillColor = sfWhite;
                        } else {
                            fillColor = tan;
                        }
                    }

                    sfRectangleShape* shape = sfRectangleShape_create();
                    shape.sfRectangleShape_setSize(sfVector2f(_squareSize, _squareSize));
                    shape.sfRectangleShape_setFillColor(fillColor);
                    shape.sfRectangleShape_setPosition(sfVector2f(_squareSize * x, _squareSize * y));

                    _chessboardRectangles ~= shape;
                }
            }
        }

        sfRectangleShape*[] _chessboardRectangles;
        sfVector2u _windowSize;
        float _squareSize;
        GUIChessPiece[] _guiChessPieces;
    }
}