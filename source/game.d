module game;

import window;
import bindbc.sfml;
import guichessboard;
import oop;
import sfmlextensions;
import guichesspiece;

class Game {
    this() {
        _window = new Window("Chess", sfVector2u(500, 500));
        initGuiChessboard();
    }

    void update() {
        _window.update();
        _guiChessboard.update(_window.renderWindow, _window.event);
    }

    void render() {
        _window.beginDraw();
        _guiChessboard.render(_window.renderWindow);
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        void initGuiChessboard() {
            _guiChessboard = new GUIChessboard(_window.windowSize);
        }

        Window _window;
        GUIChessboard _guiChessboard;
    }
}