module guichesspiece;

import bindbc.sfml;
import oop;
import sfmlextensions;
import guichessboard;
import chessspritehandler;

class GUIChessPiece {
    this(ChessPiece chessPiece, float size) {
        _chessPiece = chessPiece;
        _chessSprite = ChessSpriteHandler.load(chessPiece, size);
    }

    void update(GUIChessboard guiChessboard, sfRenderWindow* renderWindow, sfEvent event) {
        sfVector2i mousePosition = sfMouse_getPositionRenderWindow(renderWindow);

        if (isMousePositionInBounds(mousePosition)) {
            if (event.type == sfEventType.sfEvtMouseButtonPressed) {
                _executeClick = true;
            } else if (event.type == sfEventType.sfEvtMouseButtonReleased && _executeClick) {
                onClick(guiChessboard, renderWindow);
                _executeClick = false;
            }
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_chessSprite);
    }

    void refreshPosition() {
        ChessSpriteHandler.refreshPosition(_chessSprite, _chessPiece);
    }

    @property {
        ChessPiece chessPiece() {
            return _chessPiece;
        }
    }

    private {
        void onClick(GUIChessboard guiChessboard, sfRenderWindow* renderWindow) {
            if (chessPiece.color == guiChessboard.turn) {
                guiChessboard.clearBoardPositions();

                if (!guiChessboard.isMoveMode || guiChessboard.selectedGuiChessPiece != this) {
                    ChessboardPositionHandler.MoveInfo routeInfo = _chessPiece.getBoardPositionHandler(guiChessboard.chessboard).getMoveInfo();

                    guiChessboard.addPossibleBoardPositions(routeInfo.possibleBoardPositions);
                    guiChessboard.addCapturableBoardPositions(routeInfo.capturableInfo.keys);
                    guiChessboard.selectedGuiChessPiece = this;
                    guiChessboard.isMoveMode = true;
                } else {
                    guiChessboard.isMoveMode = false;
                }
            }
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
