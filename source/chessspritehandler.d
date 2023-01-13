module chessspritehandler;

import bindbc.sfml;
import oop;
import sfmlextensions;

final class ChessSpriteHandler {
    static {
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

            chessPieceSprite.sfSprite_setScale(sfVector2f(size / chessPieceTexture.sfTexture_getSize().x, size / chessPieceTexture.sfTexture_getSize().y));
            chessPieceSprite.sfSprite_setTexture(chessPieceTexture, 0);
            chessPieceSprite.sfSprite_setPosition(sfVector2f(chessPiece.boardPosition.x * size, chessPiece.boardPosition.y * size));

            return chessPieceSprite;
        }

        void refreshPosition(ref sfSprite* chessPieceSprite, ChessPiece chessPiece) {
            float size = chessPieceSprite.sfSpriteExt_getSize().x;
            chessPieceSprite.sfSprite_setPosition(sfVector2f(chessPiece.boardPosition.x * size, chessPiece.boardPosition.y * size));
        }
    }
}

