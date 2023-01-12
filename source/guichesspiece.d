module guichesspiece;

import bindbc.sfml;
import oop;
import sfmlextensions;

class GUIChessPiece {
    this(ChessPiece chessPiece, float size) {
        _chessPiece = chessPiece;
        _chessSprite = ChessSpriteLoader.load(chessPiece, size);
    }

    void update(sfRenderWindow* renderWindow, sfEvent event) {
        sfVector2i mousePosition = sfMouse_getPositionRenderWindow(renderWindow);

        if (isMousePositionInBounds(mousePosition)) {
            if (event.type == sfEventType.sfEvtMouseButtonPressed) {
                _executeClick = true;
            } else if (event.type == sfEventType.sfEvtMouseButtonReleased && _executeClick) {
                onClick(renderWindow);
                _executeClick = false;
            }
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_chessSprite);
    }

    private {
        void onClick(sfRenderWindow* renderWindow) {

        }

        bool isMousePositionInBounds(sfVector2i mousePosition) {
            return (mousePosition.x >= _chessSprite.sfSprite_getPosition().x &&
                    mousePosition.x <= _chessSprite.sfSprite_getPosition().x + _chessSprite.sfSpriteExt_getSize().x &&
                    mousePosition.y >= _chessSprite.sfSprite_getPosition().y &&
                    mousePosition.y <= _chessSprite.sfSprite_getPosition().y + _chessSprite.sfSpriteExt_getSize().y);
        }

        ChessPiece _chessPiece;
        sfSprite* _chessSprite;
        bool _executeClick;
    }
}
