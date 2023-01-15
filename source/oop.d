module oop;

import bindbc.sfml;
import std.algorithm.searching : any;

enum ChessPieceColor {
    black, white
}

class ChessboardOrganizer {
    this(Chessboard chessboard) {
        _chessboard = chessboard;
    }

    void organizePieces() {
        organizePawns();
        organizeKnights();
        organizeBishops();
        organizeRooks();
        organizeQueens();
        organizeKings();
    }

    private {
        void organizePawns() {
            for (int i = 0; i < 16; ++i) {
                ChessPiece pawn = new Pawn();

                if (i <= 7) {
                    pawn.boardPosition = sfVector2i(i, 1);
                    pawn.color = ChessPieceColor.black;
                } else {
                    pawn.boardPosition = sfVector2i(i - 8, 6);
                    pawn.color = ChessPieceColor.white;
                }

                _chessboard.addChessPiece(pawn);
            }
        }

        void organizeKnights() {
            for (int i = 0; i < 4; ++i) {
                ChessPiece knight = new Knight();

                if (i <= 1) {
                    if (i == 0) {
                        knight.boardPosition = sfVector2i(1, 0);
                    } else {
                        knight.boardPosition = sfVector2i(6, 0);
                    }
                    knight.color = ChessPieceColor.black;
                } else {
                    if (i == 2) {
                        knight.boardPosition = sfVector2i(1, 7);
                    } else {
                        knight.boardPosition = sfVector2i(6, 7);
                    }
                    knight.color = ChessPieceColor.white;
                }

                _chessboard.addChessPiece(knight);
            }
        }

        void organizeBishops() {
            for (int i = 0; i < 4; ++i) {
                ChessPiece bishop = new Bishop();

                if (i <= 1) {
                    if (i == 0) {
                        bishop.boardPosition = sfVector2i(2, 0);
                    } else {
                        bishop.boardPosition = sfVector2i(5, 0);
                    }
                    bishop.color = ChessPieceColor.black;
                } else {
                    if (i == 2) {
                        bishop.boardPosition = sfVector2i(2, 7);
                    } else {
                        bishop.boardPosition = sfVector2i(5, 7);
                    }
                    bishop.color = ChessPieceColor.white;
                }

                _chessboard.addChessPiece(bishop);
            }
        }

        void organizeRooks() {
            for (int i = 0; i < 4; ++i) {
                ChessPiece rook = new Rook();

                if (i <= 1) {
                    if (i == 0) {
                        rook.boardPosition = sfVector2i(0, 0);
                    } else {
                        rook.boardPosition = sfVector2i(7, 0);
                    }
                    rook.color = ChessPieceColor.black;
                } else {
                    if (i == 2) {
                        rook.boardPosition = sfVector2i(0, 7);
                    } else {
                        rook.boardPosition = sfVector2i(7, 7);
                    }
                    rook.color = ChessPieceColor.white;
                }

                _chessboard.addChessPiece(rook);
            }
        }

        void organizeQueens() {
            for (int i = 0; i < 2; ++i) {
                ChessPiece queen = new Queen();

                if (i == 0) {
                    queen.color = ChessPieceColor.black;
                    queen.boardPosition = sfVector2i(3, 0);
                } else {
                    queen.color = ChessPieceColor.white;
                    queen.boardPosition = sfVector2i(3, 7);
                }

                _chessboard.addChessPiece(queen);
            }
        }

        void organizeKings() {
            for (int i = 0; i < 2; ++i) {
                ChessPiece king = new King();

                if (i == 0) {
                    king.color = ChessPieceColor.black;
                    king.boardPosition = sfVector2i(4, 0);
                } else {
                    king.color = ChessPieceColor.white;
                    king.boardPosition = sfVector2i(4, 7);
                }

                _chessboard.addChessPiece(king);
            }
        }

        Chessboard _chessboard;
    }
}

class Chessboard {
    this() {
        ChessboardOrganizer chessboardOrganizer = new ChessboardOrganizer(this);
        chessboardOrganizer.organizePieces();

        assert(_chessPieces.length == 32, "_chessPieces has invalid length");
    }

    void addChessPiece(ChessPiece chessPiece) {
        _chessPieces ~= chessPiece;
    }

    void moveChessPiece(sfVector2i boardPosition, sfVector2i newBoardPosition) {
        foreach (ChessPiece chessPiece; _chessPieces) {
            if (chessPiece.boardPosition == boardPosition) {
                chessPiece.boardPosition = sfVector2i(newBoardPosition.x, newBoardPosition.y);
                break;
            }
        }
    }

    @property {
        ChessPiece[] chessPieces() {
            return _chessPieces;
        }
    }

    private {
        ChessPiece[] _chessPieces;
    }
}

abstract class ChessPiece {
    abstract {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard);
    }

    @property {
        ChessPieceColor color() {
            return _color;
        }

        sfVector2i boardPosition() {
            return _boardPosition;
        }

        void color(ChessPieceColor color) {
            _color = color;
        }

        void boardPosition(sfVector2i boardPosition) {
            assert(boardPosition.x <= 7 && boardPosition.x >= 0, "Invalid x position");
            assert(boardPosition.y <= 7 && boardPosition.y >= 0, "Invalid y position");

            _boardPosition = boardPosition;
        }
    }

    private {
        ChessPieceColor _color;
        sfVector2i _boardPosition;
    }
}

abstract class ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        _chessboard = chessboard;
        _chessPiece = chessPiece;
    }

    protected abstract RouteContainer getPossibleBoardRoutes();

    sfVector2i[] getPossibleBoardPositions() {
        return filterBoardPositions(getPossibleBoardRoutes().finalizeToBoardPositions());
    }

    private {
        struct Route {
            sfVector2i[] boardPositions;
        }

        struct RouteContainer {
            Route[] routes;

            sfVector2i[] finalizeToBoardPositions() {
                sfVector2i[] boardPositions;

                foreach (Route route; routes) {
                    foreach (sfVector2i boardPosition; route.boardPositions) {
                        boardPositions ~= boardPosition;
                    }
                }

                return boardPositions;
            }
        }

        sfVector2i leftX(int moveBy = 1) {
            assert(moveBy >= 1, "Invalid moveBy");

            if (_chessPiece.color == ChessPieceColor.black) {
                return sfVector2i(_chessPiece.boardPosition.x + moveBy, _chessPiece.boardPosition.y);
            }
            return sfVector2i(_chessPiece.boardPosition.x - moveBy, _chessPiece.boardPosition.y);
        }

        sfVector2i rightX(int moveBy = 1) {
            assert(moveBy >= 1, "Invalid moveBy");

            if (_chessPiece.color == ChessPieceColor.black) {
                return sfVector2i(_chessPiece.boardPosition.x - moveBy, _chessPiece.boardPosition.y);
            }
            return sfVector2i(_chessPiece.boardPosition.x + moveBy, _chessPiece.boardPosition.y);
        }

        sfVector2i forwardY(int moveBy = 1) {
            assert(moveBy >= 1, "Invalid moveBy");

            if (_chessPiece.color == ChessPieceColor.black) {
                return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y + moveBy);
            }
            return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y - moveBy);
        }

        sfVector2i backY(int moveBy = 1) {
            assert(moveBy >= 1, "Invalid moveBy");

            if (_chessPiece.color == ChessPieceColor.black) {
                return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y - moveBy);
            }
            return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y + moveBy);
        }

        sfVector2i[] filterBoardPositions(sfVector2i[] boardPositions) {
            sfVector2i[] filteredBoardPositions;

            foreach (sfVector2i boardPosition; boardPositions) {
                if (boardPosition.x >= 0 && boardPosition.x <= 7 && boardPosition.y >= 0 && boardPosition.y <= 7 && !_chessboard.chessPieces.any!(chessPiece => chessPiece.boardPosition == boardPosition)) {
                    filteredBoardPositions ~= boardPosition;
                }
            }

            return filteredBoardPositions;
        }

        Chessboard _chessboard;
        ChessPiece _chessPiece;
    }

    private @property {
        int relativeY() {
            if (_chessPiece.color == ChessPieceColor.black) {
                return _chessPiece.boardPosition.y;
            }
            return 7 - _chessPiece.boardPosition.y;
        }
    }
}

class PawnBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route route;
        route.boardPositions ~= forwardY(1);

        if (relativeY == 1) {
            route.boardPositions ~= forwardY(2);
        }

        return RouteContainer([route]);
    }
}

class RookBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[4] routes;

        for (int i = 1; i <= 7; ++i) {
            routes[0].boardPositions ~= sfVector2i(leftX(i).x, _chessPiece.boardPosition.y);
            routes[1].boardPositions ~= sfVector2i(rightX(i).x, _chessPiece.boardPosition.y);
            routes[2].boardPositions ~= sfVector2i(_chessPiece.boardPosition.x, forwardY(i).y);
            routes[3].boardPositions ~= sfVector2i(_chessPiece.boardPosition.x, backY(i).y);
        }

        return RouteContainer(routes.dup);
    }
}

class KnightBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[4] routes;

        routes[0].boardPositions ~= sfVector2i(leftX(1).x, forwardY(2).y);
        routes[1].boardPositions ~= sfVector2i(rightX(1).x, forwardY(2).y);
        routes[2].boardPositions ~= sfVector2i(leftX(2).x, forwardY(1).y);
        routes[3].boardPositions ~= sfVector2i(rightX(2).x, forwardY(1).y);

        return RouteContainer(routes.dup);
    }
}

class BishopBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[4] routes;

        for (int i = 1; i <= 7; ++i) {
            routes[0].boardPositions ~= sfVector2i(leftX(i).x, forwardY(i).y);
            routes[1].boardPositions ~= sfVector2i(rightX(i).x, backY(i).y);
            routes[2].boardPositions ~= sfVector2i(leftX(i).x, backY(i).y);
            routes[3].boardPositions ~= sfVector2i(rightX(i).x, forwardY(i).y);
        }

        return RouteContainer(routes.dup);
    }
}

class QueenBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
        rookBoardPositionHandler = new RookBoardPositionHandler(_chessboard, _chessPiece);
        bishopBoardPositionHandler = new BishopBoardPositionHandler(_chessboard, _chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[] routes;

        routes ~= rookBoardPositionHandler.getPossibleBoardRoutes().routes;
        routes ~= bishopBoardPositionHandler.getPossibleBoardRoutes().routes;

        return RouteContainer(routes);
    }

    private {
        ChessboardPositionHandler rookBoardPositionHandler;
        ChessboardPositionHandler bishopBoardPositionHandler;
    }
}

class KingBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[] routes;

        routes ~= Route([sfVector2i(leftX(1).x, _chessPiece.boardPosition.y)]);
        routes ~= Route([sfVector2i(rightX(1).x, _chessPiece.boardPosition.y)]);
        routes ~= Route([sfVector2i(_chessPiece.boardPosition.x, forwardY(1).y)]);
        routes ~= Route([sfVector2i(_chessPiece.boardPosition.x, backY(1).y)]);
        routes ~= Route([sfVector2i(leftX(1).x, forwardY(1).y)]);
        routes ~= Route([sfVector2i(rightX(1).x, backY(1).y)]);
        routes ~= Route([sfVector2i(leftX(1).x, backY(1).y)]);
        routes ~= Route([sfVector2i(rightX(1).x, forwardY(1).y)]);

        return RouteContainer(routes);
    }
}

class Pawn : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new PawnBoardPositionHandler(chessboard, this);
        }
    }
}


class Rook : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new RookBoardPositionHandler(chessboard, this);
        }
    }
}

class Knight : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new KnightBoardPositionHandler(chessboard, this);
        }
    }
}

class Bishop : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new BishopBoardPositionHandler(chessboard, this);
        }
    }
}

class Queen : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new QueenBoardPositionHandler(chessboard, this);
        }
    }
}

class King : ChessPiece {
    override {
        ChessboardPositionHandler getBoardPositionHandler(Chessboard chessboard) {
            return new KingBoardPositionHandler(chessboard, this);
        }
    }
}
