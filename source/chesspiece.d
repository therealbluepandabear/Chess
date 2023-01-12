module chesspiece;

import bindbc.sfml;

enum ChessPieceColor {
    black, white
}

final class ChessSpriteLoader {
    static {
        sfSprite* load(ChessPiece chessPiece, float size) {
            string path = "assets/";
            if (typeid(chessPiece) == typeid(Pawn)) {
                path ~= "black_pawn.png";
            } else if (typeid(chessPiece) == typeid(Rook)) {
                path ~= "black_rook.png";
            } else if (typeid(chessPiece) == typeid(King)) {
                path ~= "black_king.png";
            } else if (typeid(chessPiece) == typeid(Queen)) {
                path ~= "black_queen.png";
            } else if (typeid(chessPiece) == typeid(Knight)) {
                path ~= "black_knight.png";
            } else if (typeid(chessPiece) == typeid(Bishop)) {
                path ~= "black_bishop.png";
            }

            import std.string;
            sfTexture* pawnTexture = sfTexture_createFromFile(toStringz(path), null);
            sfSprite* pawnSprite = sfSprite_create();

            import sfmlextensions;
            sfVector2f bounds = sfVector2fExt_splat(size);
            pawnSprite.sfSprite_setScale(sfVector2f(bounds.x / pawnTexture.sfTexture_getSize().x, bounds.y / pawnTexture.sfTexture_getSize().y));
            pawnSprite.sfSprite_setTexture(pawnTexture, 0);
            pawnSprite.sfSprite_setPosition(sfVector2f(chessPiece.boardPosition.x * size, chessPiece.boardPosition.y * size));

            return pawnSprite;
        }
    }
}

abstract class ChessPiece {
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

}

class Rook : ChessPiece {

}

class Knight : ChessPiece {

}

class Bishop : ChessPiece {

}

class Queen : ChessPiece {

}

class King : ChessPiece {

}
