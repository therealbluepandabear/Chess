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
        return getPossibleBoardRoutes().finalizeToBoardPositions();
    }

    private {
        struct Route {
            sfVector2i[] boardPositions;
        }

        struct RouteContainer {
            ChessboardPositionHandler outer;
            Route[] routes;

            sfVector2i[] finalizeToBoardPositions() {
                sfVector2i[] boardPositions;

                foreach (Route route; routes) {
                    foreach (sfVector2i boardPosition; route.boardPositions) {
                        if (boardPosition.x >= 0 && boardPosition.x <= 7 &&
                            boardPosition.y >= 0 && boardPosition.y <= 7 &&
                            !outer._chessboard.chessPieces.any!(chessPiece => chessPiece.boardPosition == boardPosition)) {
                            boardPositions ~= boardPosition;
                        }
                    }
                }

                return boardPositions;
            }
        }

        RouteContainer createRouteContainer(Route[] routes...) {
            return RouteContainer(this, routes);
        }

        enum MoveType {
            forward, back, left, right
        }

        sfVector2i getMovedPosition(MoveType moveType, int moveBy) {
            assert(moveBy >= 1, "Invalid moveBy");

            if (_chessPiece.color == ChessPieceColor.black) {
                if (moveType == MoveType.right || moveType == MoveType.back) {
                    moveBy = -moveBy;
                }

                if (moveType == MoveType.left || moveType == MoveType.right) {
                    return sfVector2i(_chessPiece.boardPosition.x + moveBy, _chessPiece.boardPosition.y);
                }

                return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y + moveBy);
            }

            if (moveType == MoveType.left || moveType == MoveType.forward) {
                moveBy = -moveBy;
            }

            if (moveType == MoveType.left || moveType == MoveType.right) {
                return sfVector2i(_chessPiece.boardPosition.x + moveBy, _chessPiece.boardPosition.y);
            }

            return sfVector2i(_chessPiece.boardPosition.x, _chessPiece.boardPosition.y + moveBy);
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
        route.boardPositions ~= getMovedPosition(MoveType.forward, 1);

        if (relativeY == 1) {
            route.boardPositions ~=  getMovedPosition(MoveType.forward, 2);
        }

        return createRouteContainer(route);
    }
}

class RookBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[4] routes;

        for (int i = 1; i <= 7; ++i) {
            routes[0].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, i).x, _chessPiece.boardPosition.y);
            routes[1].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, i).x, _chessPiece.boardPosition.y);
            routes[2].boardPositions ~= sfVector2i(_chessPiece.boardPosition.x, getMovedPosition(MoveType.forward, i).y);
            routes[3].boardPositions ~= sfVector2i(_chessPiece.boardPosition.x, getMovedPosition(MoveType.back, i).y);
        }

        return createRouteContainer(routes.dup);
    }
}

class KnightBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[8] routes;

        routes[0].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, 1).x, getMovedPosition(MoveType.forward, 2).y);
        routes[1].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, 1).x, getMovedPosition(MoveType.forward, 2).y);
        routes[2].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, 2).x, getMovedPosition(MoveType.forward, 1).y);
        routes[3].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, 2).x, getMovedPosition(MoveType.forward, 1).y);
        routes[4].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, 1).x, getMovedPosition(MoveType.back, 2).y);
        routes[5].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, 1).x, getMovedPosition(MoveType.back, 2).y);
        routes[6].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, 2).x, getMovedPosition(MoveType.back, 1).y);
        routes[7].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, 2).x, getMovedPosition(MoveType.back, 1).y);

        return createRouteContainer(routes.dup);
    }
}

class BishopBoardPositionHandler : ChessboardPositionHandler {
    this(Chessboard chessboard, ChessPiece chessPiece) {
        super(chessboard, chessPiece);
    }

    protected override RouteContainer getPossibleBoardRoutes() {
        Route[4] routes;

        for (int i = 1; i <= 7; ++i) {
            routes[0].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, i).x, getMovedPosition(MoveType.forward, i).y);
            routes[1].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, i).x, getMovedPosition(MoveType.back, i).y);
            routes[2].boardPositions ~= sfVector2i(getMovedPosition(MoveType.left, i).x, getMovedPosition(MoveType.back, i).y);
            routes[3].boardPositions ~= sfVector2i(getMovedPosition(MoveType.right, i).x, getMovedPosition(MoveType.forward, i).y);
        }

        return createRouteContainer(routes.dup);
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

        return createRouteContainer(routes);
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

        routes ~= Route([sfVector2i(getMovedPosition(MoveType.left, 1).x, _chessPiece.boardPosition.y)]);
        routes ~= Route([sfVector2i(getMovedPosition(MoveType.right, 1).x, _chessPiece.boardPosition.y)]);
        routes ~= Route([sfVector2i(_chessPiece.boardPosition.x, getMovedPosition(MoveType.forward, 1).y)]);
        routes ~= Route([sfVector2i(_chessPiece.boardPosition.x, getMovedPosition(MoveType.back, 1).y)]);
        routes ~= Route([sfVector2i(getMovedPosition(MoveType.left, 1).x, getMovedPosition(MoveType.forward, 1).y)]);
        routes ~= Route([sfVector2i(getMovedPosition(MoveType.right, 1).x, getMovedPosition(MoveType.back, 1).y)]);
        routes ~= Route([sfVector2i(getMovedPosition(MoveType.left, 1).x, getMovedPosition(MoveType.back, 1).y)]);
        routes ~= Route([sfVector2i(getMovedPosition(MoveType.right, 1).x, getMovedPosition(MoveType.forward, 1).y)]);

        return createRouteContainer(routes);
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
