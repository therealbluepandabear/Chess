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
            }

            import std.string;
            sfTexture* pawnTexture = sfTexture_createFromFile(toStringz(path), null);
            sfSprite* pawnSprite = sfSprite_create();

            import sfmlextensions;
            sfVector2f bounds = sfVector2fExt_splat(size);
            pawnSprite.sfSprite_setScale(sfVector2f(bounds.x / pawnTexture.sfTexture_getSize().x, bounds.y / pawnTexture.sfTexture_getSize().y));
            pawnSprite.sfSprite_setTexture(pawnTexture, 0);

            return pawnSprite;
        }
    }
}

abstract class ChessPiece {
    @property {
        ChessPieceColor color() {
            return _color;
        }

        sfVector2i position() {
            return _position;
        }

        void color(ChessPieceColor color) {
            _color = color;
        }

        void position(sfVector2i position) {
            assert(position.x <= 7 && position.x >= 0, "Invalid x position");
            assert(position.y <= 7 && position.y >= 0, "Invalid y position");

            _position = position;
        }
    }

    private {
        ChessPieceColor _color;
        sfVector2i _position;
    }
}

class Pawn : ChessPiece {

}

