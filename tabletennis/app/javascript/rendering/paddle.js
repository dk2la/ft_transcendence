
class Paddle {
	constructor() {
		this.x = 0;
		this.y = 0;
		this.width = 0;
		this.height = 0;
		this.color = "white";
	}

	set_config(data, configCanvas, MyCanvas) {
		this.x = data.x;
		this.y = data.y;
		this.width = data.width;
		this.height = data.height;
	}
}

export default Paddle;