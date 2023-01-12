module guichessboard;

import bindbc.sfml;
import sfmlextensions;
import oop;
import guichesspiece;
import oop;

class GUIChessboard {
    this(Chessboard chessboard, sfVector2u windowSize) {
        _windowSize = windowSize;
        _squareSize = (cast(float)_windowSize.x) / 8f;
        _chessboard = chessboard;
        initGuiChessPieces();
        initChessboardRectangles();
        initPossibleBoardPositionIndicator();

        assert(_chessboardRectangles.length == 64, "_chessboardRectangles has invalid length");
    }

    void update(sfRenderWindow* renderWindow, sfEvent event) {
        foreach (GUIChessPiece guiChessPiece; _guiChessPieces) {
            guiChessPiece.update(this, renderWindow, event);
        }
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

        foreach (sfVector2i possibleBoardPosition; _possibleBoardPositions) {
            _possibleBoardPositionIndicator.sfCircleShape_setPosition(sfVector2f(possibleBoardPosition.x * _squareSize + _squareSize / 2 - _possibleBoardPositionIndicator.sfCircleShape_getRadius(), possibleBoardPosition.y * _squareSize + _squareSize / 2 - _possibleBoardPositionIndicator.sfCircleShape_getRadius()));
            renderWindow.sfRenderWindowExt_draw(_possibleBoardPositionIndicator);
        }
    }

    void addPossibleBoardPositions(sfVector2i[] boardPositions) {
        foreach (sfVector2i boardPosition; boardPositions) {
            assert(boardPosition.x <= 7 && boardPosition.x >= 0, "Invalid x position");
            assert(boardPosition.y <= 7 && boardPosition.y >= 0, "Invalid y position");

            _possibleBoardPositions ~= boardPosition;
        }
    }

    void clearBoardPositions() {
        _possibleBoardPositions = _possibleBoardPositions.init;
    }

    @property {
        float squareSize() {
            return _squareSize;
        }

        GUIChessPiece[] guiChessPieces() {
            return _guiChessPieces;
        }

        Chessboard chessboard() {
            return _chessboard;
        }
    }

    private {
        void initPossibleBoardPositionIndicator() {
            _possibleBoardPositionIndicator = sfCircleShape_create();
            _possibleBoardPositionIndicator.sfCircleShape_setRadius(10);
            _possibleBoardPositionIndicator.sfCircleShape_setFillColor(sfGreen);
        }

        void initGuiChessPieces() {
            foreach (ChessPiece chessPiece; _chessboard.chessPieces) {
                _guiChessPieces ~= new GUIChessPiece(chessPiece, _squareSize);
            }
        }

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
        Chessboard _chessboard;
        sfVector2i[] _possibleBoardPositions;
        sfCircleShape* _possibleBoardPositionIndicator;
    }
}