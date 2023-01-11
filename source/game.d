module game;

import window;
import bindbc.sfml;
import chessboard;

class Game {
    this() {
        _window = new Window("Chess", sfVector2u(500, 500));
        _chessboard = new Chessboard(_window.windowSize);
    }

    void update() {
        _window.update();
    }

    void render() {
        _window.beginDraw();
        _chessboard.render(_window.renderWindow);
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        Window _window;
        Chessboard _chessboard;
    }
}