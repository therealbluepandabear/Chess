module oop;

import bindbc.sfml;

enum ChessPieceColor {
    black, white
}

final class ChessSpriteLoader {
    static {
        sfTexture* chessPieceTexture;
        sfSprite* chessPieceSprite;

        sfSprite* load(ChessPiece chessPiece, float size) {
            string path = "assets/";
            if (typeid(chessPiece) == typeid(Pawn)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_pawn.png";
                } else {
                    path ~= "white_pawn.png";
                }
            } else if (typeid(chessPiece) == typeid(Rook)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_rook.png";
                } else {
                    path ~= "white_rook.png";
                }
            } else if (typeid(chessPiece) == typeid(King)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_king.png";
                } else {
                    path ~= "white_king.png";
                }
            } else if (typeid(chessPiece) == typeid(Queen)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_queen.png";
                } else {
                    path ~= "white_queen.png";
                }
            } else if (typeid(chessPiece) == typeid(Knight)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_knight.png";
                } else {
                    path ~= "white_knight.png";
                }
            } else if (typeid(chessPiece) == typeid(Bishop)) {
                if (chessPiece.color == ChessPieceColor.black) {
                    path ~= "black_bishop.png";
                } else {
                    path ~= "white_bishop.png";
                }
            }

            import std.string;
            sfTexture* chessPieceTexture = sfTexture_createFromFile(toStringz(path), null);
            sfSprite* chessPieceSprite = sfSprite_create();

            import sfmlextensions;
            chessPieceSprite.sfSprite_setScale(sfVector2f(size / chessPieceTexture.sfTexture_getSize().x, size / chessPieceTexture.sfTexture_getSize().y));
            chessPieceSprite.sfSprite_setTexture(chessPieceTexture, 0);
            chessPieceSprite.sfSprite_setPosition(sfVector2f(chessPiece.boardPosition.x * size, chessPiece.boardPosition.y * size));

            return chessPieceSprite;
        }
    }
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
        sfVector2i[] possibleBoardMoves(Chessboard chessboard);
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

class Pawn : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}

class Rook : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}

class Knight : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}

class Bishop : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}

class Queen : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}

class King : ChessPiece {
    override {
        sfVector2i[] possibleBoardMoves(Chessboard chessboard) {
            return [];
        }
    }
}
