package;

import picotron.Picotron;

class Player {
	public var x:Float = 0;
	public var y:Float = 0;
	public var isPlayer:Bool;
	public var player:Int;
	public var canMove:Bool = false;
	public var curYSpeed:Float = 0;

	public static final playerHeight:Float = 32;
	public static final playerWidth:Float = 10;
	public static final playerSpeed:Float = 8;
	public static final cpuPlayerSpeed:Float = 6;

	public function new(x:Float, y:Float, isPlayer:Bool, player:Int) {
		this.x = x;
		this.y = y;
		this.isPlayer = isPlayer;
		this.player = player;
	}

	public function draw() {
		Picotron.spr(1, x, y);
	}

	function tryMoveOnY(yMovement:Float) {
		y += yMovement;
		if (y < 0) {
			y = 0;
			curYSpeed = 0;
		}
		if (y + Player.playerHeight > GameInfo.windowHeight) {
			y = GameInfo.windowHeight - Player.playerHeight;
			curYSpeed = 0;
		}
	}

	public function resetYPos() {
		y = (GameInfo.windowHeight / 2) - (Player.playerHeight / 2);
	}

	public function update() {
		if (canMove) {
			if (isPlayer) {
				var isUpPressed = Picotron.key("w");
				var isDownPressed = Picotron.key("s");
				if (isUpPressed) {
					tryMoveOnY(-playerSpeed);
					curYSpeed = -playerSpeed;
				}
				if (isDownPressed) {
					tryMoveOnY(playerSpeed);
					curYSpeed = playerSpeed;
				}

				if (!isUpPressed && !isDownPressed) {
					curYSpeed = 0;
				}
			} else {
				var dif = (y + (Player.playerHeight / 2)) - if (Main.ball.xVel < 0) {
					(GameInfo.windowHeight / 2) - (Player.playerHeight / 2);
				} else {
					Main.ball.y;
				};
				var difNeeded = Player.playerHeight / 5;
				if (dif > difNeeded || dif < -difNeeded) {
					var toMove:Float = if (dif < 0) {
						Player.cpuPlayerSpeed;
					} else {
						-Player.cpuPlayerSpeed;
					}
					tryMoveOnY(toMove);
				}
			}
		}
	}
}
