package;

import picotron.Picotron;

class Ball {
	public var x:Float;
	public var y:Float;
	public var xVel:Float;
	public var yVel:Float;
	public var canMove:Bool = false;

	public static final ballHeight = 10;
	public static final ballWidth = 10;
	public static final maxYVel = 7;

	static final ballSpeedEasy = 6;
	static final ballSpeedMedium = 6.5;
	static final ballSpeedHard = 7;

	public function new(x:Float, y:Float, xVel:Float, yVel:Float) {
		this.x = x;
		this.y = y;
		this.xVel = xVel;
		this.yVel = yVel;
	}

	public static function getBallSpeed() {
		return switch (Main.dificulty) {
			case EASY:
				ballSpeedEasy;
			case MEDIUM:
				ballSpeedMedium;
			case _: ballSpeedHard;
		}
	}

	public function resetPos() {
		x = (GameInfo.windowWidth / 2) - (Ball.ballWidth / 2);
		y = (GameInfo.windowHeight / 2) - (Ball.ballHeight / 2);
		// shrug, dunno why i need these offsets but meh.
		// x -= 3;
		// y -= 4;
	}

	public function draw() {
		Picotron.spr(2, x, y);
	}

	public function isOutOfBounds() {
		return x + Ball.ballWidth < 0 || x > GameInfo.windowWidth;
	}

	function isAbleToCollide(plrIndex:Int, plrY:Float):Bool {
		var doColAtY = switch (plrIndex) {
			case 1: x < Player.playerWidth;
			case 2: x + Ball.ballWidth > GameInfo.windowWidth - Player.playerWidth;
			case _: false;
		}
		// use ints. as the players move using floats and we dont want it to *look* like they'll get it and just end up not getting it.
		var intY = Std.int(y);
		var intPlrY = Std.int(plrY);
		return (doColAtY && (intY > intPlrY && intY < intPlrY + Player.playerHeight)) && !isOutOfBounds();
	}

	public function update() {
		if (this.canMove) {
			this.x += this.xVel;
			this.y += this.yVel;
			if (this.y + Ball.ballHeight > GameInfo.windowHeight || this.y < 0) {
				this.yVel = -this.yVel;
				Picotron.sfx(0);
			}
			var players:Array<Player> = Main.getPlayers();
			for (player in players) {
				if (isAbleToCollide(player.player, player.y)) {
					var shouldActuallyChangeSpeed = true;
					switch (player.player) {
						case 1:
							shouldActuallyChangeSpeed = (xVel < 0);
						case _:
							shouldActuallyChangeSpeed = (xVel > 0);
					}
					if (shouldActuallyChangeSpeed) {
						xVel = -xVel;
						yVel += player.curYSpeed;
						// if ~ no y vel, give it y vel.
						if (Math.ceil(yVel) == 0 || Math.floor(yVel) == 0) {
							yVel = (Math.ceil(Picotron.rnd(2)) == 1 ? 1 : -1) * 3;
						}
						if (yVel > maxYVel) {
							yVel = maxYVel;
						} else if (yVel < -maxYVel) {
							yVel = -maxYVel;
						}
						Picotron.sfx(1);
					}
				}
			}
		}
	}
}
