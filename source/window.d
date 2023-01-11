module window;

import bindbc.sfml;
import std.stdio;
import std.string;

class Window {
    this() {
        setup("Chess", sfVector2u(500, 500));
    }

    this(string title, sfVector2u size) {
        setup(title, size);
    }

    ~this() {
        destroy();
    }

    void beginDraw() {
        _renderWindow.sfRenderWindow_clear(sfBlack);
    }

    void endDraw() {
        _renderWindow.sfRenderWindow_display();
    }

    void update() {
        while (_renderWindow.sfRenderWindow_pollEvent(&_event)) {
            if (_event.type == sfEventType.sfEvtClosed) {
                _isDone = true;
            }
        }
    }

    void toggleFullscreen() {
        destroy();
        create();
    }

    @property {
        bool isDone() {
            return _isDone;
        }

        sfRenderWindow* renderWindow() {
            return _renderWindow;
        }

        sfEvent event() {
            return _event;
        }
    }

    private {
        void setup(string title, sfVector2u size) {
            _windowTitle = title;
            _windowSize = size;
            _isDone = false;
            create();
        }

        void destroy() {
            _renderWindow.sfRenderWindow_close();
        }

        void create() {
            _renderWindow = sfRenderWindow_create(sfVideoMode(_windowSize.x, _windowSize.y, 32), toStringz(_windowTitle), sfWindowStyle.sfDefaultStyle, null);
            _renderWindow.sfRenderWindow_setVerticalSyncEnabled(true);
        }

        sfRenderWindow* _renderWindow;
        sfVector2u _windowSize;
        string _windowTitle;
        bool _isDone;
        sfEvent _event;
    }
}
