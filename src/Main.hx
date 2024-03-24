package;

import lua.Math;
import picotron.Window;
import picotron.Picotron;

class Main {
	static function main() {
		new Main();
	}

	public static var player1:Player;
	public static var player2:Player;
	public static var ball:Ball;

	var plr1Hits:Int = 0;
	var plr2Hits:Int = 0;
	var isFlashingToPressButton:Bool = true;

	public static function getPlayers() {
		return [player1, player2];
	}

	public function new() {
		Picotron._update = Update;
		Picotron._draw = Draw;
		Picotron._init = Init;
		Window.makeWindow(GameInfo.windowWidth, GameInfo.windowHeight, "PicoPong");
	}

	function Init() {
		ball = makeBall(false);
		player1 = new Player(0, 0, true, 1);
		player1.resetYPos();
		player2 = new Player(GameInfo.windowWidth - Player.playerWidth, 0, false, 2);
		player2.resetYPos();
		ball.resetPos();
	}

	function makeEverythingMovable() {
		player1.canMove = true;
		player2.canMove = true;
		ball.canMove = true;
	}

	function makeEverythingImmovable() {
		player1.canMove = false;
		player2.canMove = false;
		ball.canMove = false;
	}

	function Draw() {
		Picotron.cls(0);
		for (y in 0...(Std.int(GameInfo.windowHeight / 16))) {
			for (x in 0...(Std.int(GameInfo.windowWidth / 16))) {
				if (x == Std.int((GameInfo.windowWidth / 16) / 2)) {
					Picotron.spr(19, x * 16, y * 16);
				} else {
					Picotron.spr(18, x * 16, y * 16);
				}
			}
		}
		// Picotron.map(1, 1);
		if (player1 != null) {
			player1.draw();
		}
		if (player2 != null) {
			player2.draw();
		}
		if (ball != null) {
			ball.draw();
		}
		drawHitsCounter(0, 0, plr1Hits);
		// position it to the right of the screen minus the amount of characters being rendered.
		drawHitsCounter(GameInfo.windowWidth - (Std.string(plr2Hits).length * 16), 0, plr2Hits);
		if (isFlashingToPressButton) {
			if ((Picotron.t() * 10) % 20 <= 10) {
				var toPlayText = "PRESS Z TO PLAY";
				var toPlayTextLength = toPlayText.length * 5;
				var textX:Float = (GameInfo.windowWidth / 2) - (toPlayTextLength / 2);
				Picotron.rectfill(textX - 2, 0, textX + toPlayTextLength + 2, 8 + 1, 0);
				Picotron.print(toPlayText, textX, 1);
			}
		}
	}

	function drawHitsCounter(x:Int, y:Int, num:Int) {
		var numSplit:Array<String> = Std.string(num).split("");
		for (i in 0...numSplit.length) {
			var num = numSplit[i];
			var counterX = x + (16 * i);
			Picotron.rectfill(x, y, x + ((i + 1) * 16), 16, 0);
			Picotron.spr(8 + Std.parseInt(num), counterX, y);
		}
	}

	function makeBall(playerGoaled:Bool) {
		return new Ball(0, 0, (playerGoaled ? Ball.ballSpeed : -Ball.ballSpeed) * (1 + Picotron.rnd(.05)), 0);
	}

	function Update() {
		if (isFlashingToPressButton && Picotron.keyp("z")) {
			isFlashingToPressButton = false;
			makeEverythingMovable();
		}
		if (player1 != null) {
			player1.update();
		}
		if (player2 != null) {
			player2.update();
		}
		if (ball != null) {
			ball.update();
			Picotron.print(GameInfo.windowWidth - (ball.x + Ball.ballWidth), 0, 0, 7);
		}
		if (ball.isOutOfBounds() && ball.canMove) {
			makeEverythingImmovable();
			var playerGoaled = (ball.x > GameInfo.windowWidth);
			if (!playerGoaled) {
				plr2Hits++;
				Picotron.sfx(3);
			} else {
				plr1Hits++;
				Picotron.sfx(2);
			}
			player1.resetYPos();
			player2.resetYPos();
			ball = makeBall(playerGoaled);
			ball.resetPos();
			isFlashingToPressButton = true;
			// makeEverythingMovable();
		}
	}
}
