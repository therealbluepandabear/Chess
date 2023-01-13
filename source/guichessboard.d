module guichessboard;

import bindbc.sfml;
import sfmlextensions;
import oop;
import guichesspiece;
import std.algorithm : canFind;

class GUIChessboard {
    this(sfVector2u windowSize) {
        _windowSize = windowSize;
        _squareSize = (cast(float)_windowSize.x) / 8f;
        _chessboard = new Chessboard();

        initGuiChessPieces();
        initChessboardRectangles();
        initPossibleBoardPositionIndicator();

        assert(_chessboardRectangles.length == 64, "_chessboardRectangles has invalid length");
    }

    void update(sfRenderWindow* renderWindow, sfEvent event) {
        foreach (GUIChessPiece guiChessPiece; _guiChessPieces) {
            guiChessPiece.update(this, renderWindow, event);
        }

        if (_isMoveMode) {
            sfVector2i boardPosition = mousePositionToBoardPosition(sfMouse_getPositionRenderWindow(renderWindow));

            if (boardPosition.x >= 0 && boardPosition.x <= 7 && boardPosition.y >= 0 && boardPosition.y <= 7) {
                if (event.type == sfEventType.sfEvtMouseButtonPressed) {
                    _executeGuiChessPieceClick = true;
                } else if (event.type == sfEventType.sfEvtMouseButtonReleased && _executeGuiChessPieceClick && _possibleBoardPositions.canFind(boardPosition)) {
                    onBoardPositionClick(boardPosition);
                    _executeGuiChessPieceClick = false;
                }
            }
        }
    }

    void render(sfRenderWindow* renderWindow) {
        assert(_guiChessPieces.length == 32, "_guiChessPieces has invalid length");

        foreach (sfRectangleShape* rect; _chessboardRectangles) {
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

    void clearPossibleBoardPositions() {
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

        GUIChessPiece selectedGuiChessPiece() {
            return _selectedGuiChessPiece;
        }

        bool isMoveMode() {
            return _isMoveMode;
        }

        void isMoveMode(bool isMoveMode) {
            _isMoveMode = isMoveMode;
        }

        void selectedGuiChessPiece(GUIChessPiece selectedGuiChessPiece) {
            _selectedGuiChessPiece = selectedGuiChessPiece;
        }
    }

    private {
        sfVector2i mousePositionToBoardPosition(sfVector2i mousePosition) {
            return sfVector2i(cast(int)(mousePosition.x / _squareSize), cast(int)(mousePosition.y / _squareSize));
        }

        void onBoardPositionClick(sfVector2i boardPosition) {
            _chessboard.moveChessPiece(_selectedGuiChessPiece.chessPiece.boardPosition, boardPosition);
            _selectedGuiChessPiece.refreshPosition();
            _possibleBoardPositions = _possibleBoardPositions.init;
        }

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
        GUIChessPiece _selectedGuiChessPiece;
        bool _isMoveMode;
        bool _executeGuiChessPieceClick;
    }
}