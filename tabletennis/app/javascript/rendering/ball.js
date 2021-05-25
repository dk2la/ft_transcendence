class Ball {
	constructor() {
		this.x = 0;
		this.y = 0;
		this.color = "white";
		this.width = 0;
		this.height = 0;
		this.dx = 0;
		this.dy = 0;
	}

	set_config(data, ConfigCanvas, MyCanvas) {
		this.x = data.x;
		this.y = data.y;
		this.height = data.height;
		this.width = data.width;
	}
}

export default Ball;