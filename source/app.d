import bindbc.sfml;
import game;

void main() {
	loadSFML();

	Game game = new Game();

	while (!game.window.isDone()) {
		game.update();
		game.render();
	}
}
