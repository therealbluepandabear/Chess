module guichessboard;

import bindbc.sfml;
import sfmlextensions;
import oop;
import guichesspiece;

class GUIChessboard {
    this(sfVector2u windowSize) {
        _windowSize = windowSize;
        _squareSize = (cast(float)_windowSize.x) / 8f;
        _chessboard = new Chessboard();
        _chessboard.connect(&observeChessboard);

        initGuiChessPieces();
        initChessboardRectangles();
        initPossibleBoardPositionIndicator();
        initCapturableBoardPositionIndicator();

        assert(_chessboardRectangles.length == 64, "_chessboardRectangles has invalid length");
    }

    void update(sfRenderWindow* renderWindow, sfEvent event) {
        foreach (GUIChessPiece guiChessPiece; _guiChessPieces) {
            guiChessPiece.update(this, renderWindow, event);
        }

        if (_isMoveMode) {
            sfVector2i boardPosition = mousePositionToBoardPosition(sfMouse_getPositionRenderWindow(renderWindow));

            if (boardPosition.x >= 0 && boardPosition.x <= 7 && boardPosition.y >= 0 && boardPosition.y <= 7) {
                import std.algorithm.searching : canFind;

                if (event.type == sfEventType.sfEvtMouseButtonPressed) {
                    _executeGuiChessPieceClick = true;
                } else if (event.type == sfEventType.sfEvtMouseButtonReleased && _executeGuiChessPieceClick && (_possibleBoardPositions.canFind(boardPosition) || _capturableBoardPositions.canFind(boardPosition))) {
                    onBoardPositionClick(boardPosition);
                    _executeGuiChessPieceClick = false;
                }
            }
        }
    }

    void render(sfRenderWindow* renderWindow) {
        foreach (sfRectangleShape* rect; _chessboardRectangles) {
            renderWindow.sfRenderWindowExt_draw(rect);
        }

        foreach (sfVector2i capturableBoardPosition; _capturableBoardPositions) {
            _capturableBoardPositionIndicator.sfCircleShape_setPosition(sfVector2f(capturableBoardPosition.x * _squareSize + _squareSize / 2 - _capturableBoardPositionIndicator.sfCircleShape_getRadius(), capturableBoardPosition.y * _squareSize + _squareSize / 2 - _capturableBoardPositionIndicator.sfCircleShape_getRadius()));
            renderWindow.sfRenderWindowExt_draw(_capturableBoardPositionIndicator);
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
        _possibleBoardPositions ~= boardPositions;
    }

    void addCapturableBoardPositions(sfVector2i[] boardPositions) {
        _capturableBoardPositions ~= boardPositions;
    }

    void clearBoardPositions() {
        _possibleBoardPositions = _possibleBoardPositions.init;
        _capturableBoardPositions = _capturableBoardPositions.init;
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

        ChessPieceColor turn() {
            return _turn;
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
        void observeChessboard(Chessboard.ChessboardEvent chessboardEvent, ChessPiece chessPiece) {
            import std.algorithm.searching : find;
            import std.algorithm.mutation : remove;

            if (chessboardEvent == Chessboard.ChessboardEvent.chess_piece_moved) {
                ((_guiChessPieces.find!(guiChessPiece => guiChessPiece.chessPiece == chessPiece))[0]).refreshPosition();
            } else if (chessboardEvent == Chessboard.ChessboardEvent.chess_piece_captured) {
                _guiChessPieces = _guiChessPieces.remove!(iterGuiChessPiece => iterGuiChessPiece.chessPiece == chessPiece);
            }
        }

        sfVector2i mousePositionToBoardPosition(sfVector2i mousePosition) {
            return sfVector2i(cast(int)(mousePosition.x / _squareSize), cast(int)(mousePosition.y / _squareSize));
        }

        void onBoardPositionClick(sfVector2i boardPosition) {
            import std.algorithm.searching : canFind;

            if (_chessboard.getChessPiece(boardPosition) !is null) {
                _chessboard.captureChessPiece(boardPosition);
            }

            _chessboard.moveChessPiece(_selectedGuiChessPiece.chessPiece.boardPosition, boardPosition);

            clearBoardPositions();
            nextTurn();
        }

        sfCircleShape* createBoardPositionIndicator(sfColor color, float radius = 10) {
            sfCircleShape* boardPositionIndicator = sfCircleShape_create();
            boardPositionIndicator.sfCircleShape_setRadius(radius);
            boardPositionIndicator.sfCircleShape_setFillColor(color);

            return boardPositionIndicator;
        }

        void initPossibleBoardPositionIndicator() {
            _possibleBoardPositionIndicator = createBoardPositionIndicator(sfGreen);
        }

        void initCapturableBoardPositionIndicator() {
            _capturableBoardPositionIndicator = createBoardPositionIndicator(sfRed, 20);
        }

        void initGuiChessPieces() {
            foreach (ChessPiece chessPiece; _chessboard.chessPieces) {
                _guiChessPieces ~= new GUIChessPiece(chessPiece, _squareSize);
            }
        }

        void nextTurn() {
            if (turn == ChessPieceColor.white) {
                _turn = ChessPieceColor.black;
            } else {
                _turn = ChessPieceColor.white;
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
        sfVector2i[] _capturableBoardPositions;
        sfCircleShape* _possibleBoardPositionIndicator;
        sfCircleShape* _capturableBoardPositionIndicator;
        GUIChessPiece _selectedGuiChessPiece;
        bool _isMoveMode;
        bool _executeGuiChessPieceClick;
        ChessPieceColor _turn = ChessPieceColor.white;
    }
}