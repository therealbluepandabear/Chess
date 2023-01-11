module game;

import window;
import bindbc.sfml;

class Game {
    this() {
        _window = new Window("Chess", sfVector2u(500, 500));
    }

    void update() {
        _window.update();
    }

    void render() {
        _window.beginDraw();
        _window.endDraw();
    }

    @property {
        Window window() {
            return _window;
        }
    }

    private {
        Window _window;
    }
}