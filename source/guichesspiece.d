module guichesspiece;

import bindbc.sfml;
import chesspiece;

class GUIChessPiece {
    this(ChessPiece chessPiece, float size) {
        _chessPiece = chessPiece;
        _chessSprite = ChessSpriteLoader.load(chessPiece, size);
    }

    void render(sfRenderWindow* renderWindow) {
        import sfmlextensions;
        renderWindow.sfRenderWindowExt_draw(_chessSprite);
    }

    private {
        ChessPiece _chessPiece;
        sfSprite* _chessSprite;
    }
}
