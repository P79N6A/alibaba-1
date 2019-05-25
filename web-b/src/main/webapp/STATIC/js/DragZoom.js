/**
 * Base class of Drag
 * @example:
 * Drag.init( header_element, element );
 */

var DragZoom = {
	cut_div: "cut_div",  //裁减图片外框div
	cut_img: "cut_img",  //裁减图片
	imgdefw: 0,  //图片默认宽度
	imgdefh: 0,  //图片默认高度
	divx: 284, //外框宽度
	divy: 266, //外框高度
	cutx: 120,  //裁减宽度
	cuty: 120,  //裁减高度
	cut_box: "cut_box", //裁切td的id
	offsetx: 0, //图片位置位移x  不可配置，自动获取
	offsety: 0, //图片位置位移y  不可配置，自动获取
	zoom: 1, //缩放比例

	zmin: 0.1, //最小比例
	zmax: 2, //最大比例
	grip_pos: 5, //拖动块位置0-最左 10 最右
	img_grip: "img_grip", //拖动块
	img_track: "img_track", //拖动条
	grip_y: 0, //拖动块y值
	grip_minx: 0, //拖动块x最小值
	grip_maxx: 0, //拖动块x最大值
	grip_minl: 0, //拖动块left的最小值
	cut_pos: "cut_pos", //裁切参数
	obj: null,

	//图片初始化
	imageInit: function(config){
		this.cut_div = DragZoom.$(config.cut_div ? config.cut_div : this.cut_div);
		this.cut_img = DragZoom.$(config.cut_img ? config.cut_img : this.cut_img);
		if(config.imgdefw){ this.imgdefw = config.imgdefw;}
		if(config.imgdefh){ this.imgdefh = config.imgdefh;}
		if(config.cutx){ this.divx = config.cutx + 100;}
		if(config.cuty){ this.divy = config.cuty + 100;}
		if(config.cutx){ this.cutx = config.cutx;}
		if(config.cuty){ this.cuty = config.cuty;}
		this.cut_box = DragZoom.$(config.cut_box ? config.cut_box : this.cut_box);
		this.offsetx = parseInt((this.divx - this.cutx)/2);
		this.offsety = -parseInt((this.divy - this.cuty)/2+this.cuty);
		if(config.offsetx){ this.offsetx = config.offsetx;}
		if(config.offsety){ this.offsety = config.offsety;}
		if(config.zoom){ this.zoom = config.zoom;}
		if(config.zmin){ this.zmin = config.zmin;}
		if(config.zmax){ this.zmax = config.zmax;}
		if(config.grip_pos){ this.grip_pos = config.grip_pos;}
		this.img_grip = DragZoom.$(config.img_grip ? config.img_grip : this.img_grip);
		this.img_track = DragZoom.$(config.img_track ? config.img_track : this.img_track);
		if(config.grip_y){ this.grip_y = config.grip_y;}
		if(config.grip_minx){ this.grip_minx = config.grip_minx;}
		if(config.grip_maxx){ this.grip_maxx = config.grip_maxx;}
		this.cut_pos = DragZoom.$(config.cut_pos ? config.cut_pos : this.cut_pos);

		this.setTable();
	},
	//图片配置
	imageConfig: function(config){
		this.imageInit(config);
		this.imgdefw = this.cut_img.width;
		this.imgdefh = this.cut_img.height;
		this.zoom = 1;
		if((this.imgdefw/this.imgdefh) > (this.cutx/this.cuty)){
			this.zoom = this.zmin = this.cuty / this.imgdefh;
		}else{
			this.zoom = this.zmin = this.cutx / this.imgdefw;
		}

		/*if(this.imgdefw > this.cutx && this.imgdefh > this.cuty){
			this.zoom = this.zmin = this.cutx / this.imgdefw;
			this.cut_img.width = this.cutx;
			this.cut_img.height = Math.round(this.imgdefh * this.zoom);
		}else{
			if((this.imgdefw/this.imgdefh) > (this.cutx/this.cuty)){
				this.zoom = this.zmin = this.cuty / this.imgdefh;
				this.cut_img.height = this.cuty;
			}else{
				this.zoom = this.zmin = this.cutx / this.imgdefw;
				this.cut_img.width = this.cutx;
			}
		}*/

		this.cut_img.style.left = Math.round((this.divx - this.cut_img.width) / 2) + "px";
		this.cut_img.style.top = Math.round((this.divy - this.cut_img.height) / 2) - this.divy + "px";

		if(this.zmin > this.zmax) this.zmax = this.zmin;
		else this.zmax =  this.zmin > 0.25 ? 4.0: 2.0 / Math.sqrt(this.zmin);
		this.grip_pos = 5 * (Math.log(this.zoom * this.zmax) / Math.log(this.zmax));

		this.dragInit(this.cut_div, this.cut_img);
		this.cut_img.onDrag = DragZoom.when_Drag;
		//缩放条初始化
		this.gripInit(DragZoom.obj);
	},

	//图片逐步缩放
	imageResize: function(flag){
		if(flag){
			this.zoom = this.zoom * 1.5;
		}else{
			this.zoom = this.zoom / 1.5;
		}
		if(this.zoom < this.zmin) this.zoom = this.zmin;
		if(this.zoom > this.zmax) this.zoom = this.zmax;
		this.cut_img.width = Math.round(this.imgdefw * this.zoom);
		this.cut_img.height = Math.round(this.imgdefh * this.zoom);
		
		DragZoom.checkCutPos();
		this.grip_pos = 5 * (Math.log(this.zoom * this.zmax) / Math.log(this.zmax));
		this.img_grip.style.left = (this.grip_minx + (this.grip_pos / 10 * (this.grip_maxx - this.grip_minx))) + "px"
	},

	//获得style里面定位
	getStylePos: function(e){
		return {x:parseInt(e.style.left), y:parseInt(e.style.top)};
	},

	//获得绝对定位
	getPosition: function(e){
		var t=e.offsetTop;
		var l=e.offsetLeft;
		while(e=e.offsetParent){
			t+=e.offsetTop;
			l+=e.offsetLeft;
		}
		return {x:l, y:t};
	},

	//检查图片位置
	checkCutPos: function(){
		var imgpos = DragZoom.getStylePos(this.cut_img);

		max_x = Math.max(this.offsetx, this.offsetx + this.cutx - this.cut_img.clientWidth);
		min_x = Math.min(this.offsetx + this.cutx - this.cut_img.clientWidth, this.offsetx);
		if(imgpos.x > max_x) this.cut_img.style.left = max_x + 'px';
		else if(imgpos.x < min_x) this.cut_img.style.left = min_x + 'px';

		max_y = Math.max(this.offsety, this.offsety + this.cuty - this.cut_img.clientHeight);
		min_y = Math.min(this.offsety + this.cuty - this.cut_img.clientHeight, this.offsety);

		if(imgpos.y > max_y) this.cut_img.style.top = max_y + 'px';
		else if(imgpos.y < min_y) this.cut_img.style.top = min_y + 'px';
	},

	//图片拖动时触发
	when_Drag: function(clientX , clientY){
		DragZoom.checkCutPos();
	},

	//获得图片裁减位置
	getCutPos: function(){
		var imgpos = DragZoom.getStylePos(this.cut_img);
		var x = this.offsetx - imgpos.x;
		var y = this.offsety - imgpos.y;
		this.cut_pos.value = x + ',' + y + ',' + this.cut_img.width + ',' + this.cut_img.height;
		//alert(this.cut_pos.value);
		//return true;
	},

	//缩放条拖动时触发
	grip_Drag: function(clientX , clientY){
		var posx = clientX;
		this.style.top = DragZoom.grip_y + "px";
		/*if(clientX < DragZoom.grip_minx){
			this.style.left = DragZoom.grip_minx + "px";
			posx = DragZoom.grip_minx;
		}*/
		if(clientX < DragZoom.grip_minl){
			this.style.left = DragZoom.grip_minl + "px";
			posx = DragZoom.grip_minl;
		}
		if(clientX > DragZoom.grip_maxx){
			this.style.left = DragZoom.grip_maxx + "px";
			posx = DragZoom.grip_maxx;
		}

		DragZoom.grip_pos = (posx - DragZoom.grip_minx) * 10 / (DragZoom.grip_maxx - DragZoom.grip_minx);
		DragZoom.zoom = Math.pow(DragZoom.zmax, DragZoom.grip_pos / 5) / DragZoom.zmax;
		if(DragZoom.zoom < DragZoom.zmin) DragZoom.zoom = DragZoom.zmin;
		if(DragZoom.zoom > DragZoom.zmax) DragZoom.zoom = DragZoom.zmax;
		DragZoom.cut_img.width = Math.round(DragZoom.imgdefw * DragZoom.zoom);
		DragZoom.cut_img.height = Math.round(DragZoom.imgdefh * DragZoom.zoom);

		DragZoom.checkCutPos();
	},

	//缩放条初始化
	gripInit: function(obj){
		track_pos = DragZoom.getPosition(this.img_track);

		this.grip_y = track_pos.y;
		this.grip_minx = track_pos.x + 4;
		this.grip_maxx = track_pos.x + this.img_track.clientWidth - this.img_grip.clientWidth - 5;

		this.img_grip.style.left = (this.grip_minx + (this.grip_pos / 10 * (this.grip_maxx - this.grip_minx))) + "px";
		this.grip_minl = parseFloat((this.grip_minx + (this.grip_pos / 10 * (this.grip_maxx - this.grip_minx))));
		this.img_grip.style.top = this.grip_y + "px";
		this.dragInit(this.img_grip, this.img_grip);
		this.img_grip.onDrag = this.grip_Drag;
	},

	//创建table
	setTable: function(){
		var drag_zoom_box = this.cut_div.parentNode;
		var table = this.cut_div.getElementsByTagName("table")[0];
		drag_zoom_box.style.width = this.cut_div.style.width = table.style.width = this.divx + "px";
		this.cut_div.style.height = table.style.height = this.divy + "px";
		this.cut_box.style.width = this.cutx + "px";
		this.cut_box.style.height = this.cuty + "px";
	},
	$: function(id){
		return document.getElementById(id);
	},

	/**
	 * @param: elementHeader	used to drag..
	 * @param: element			used to follow..
	 */
	dragInit: function(elementHeader, element) {
		// 将 start 绑定到 onmousedown 事件，按下鼠标触发 start
		elementHeader.onmousedown = DragZoom.dragStart;
		// 将 element 存到 header 的 obj 里面，方便 header 拖拽的时候引用
		elementHeader.obj = element;
		// 初始化绝对的坐标，因为不是 position = absolute 所以不会起什么作用，但是防止后面 onDrag 的时候 parse 出错了
		if(isNaN(parseInt(element.style.left))) {
			element.style.left = "0px";
		}
		if(isNaN(parseInt(element.style.top))) {
			element.style.top = "0px";
		}
		// 挂上空 Function，初始化这几个成员，在 Drag.init 被调用后才帮定到实际的函数
		element.onDragStart = new Function();
		element.onDragEnd = new Function();
		element.onDrag = new Function();
	},
	// 开始拖拽的绑定，绑定到鼠标的移动的 event 上
	dragStart: function(event) {
		var element = DragZoom.obj = this.obj;
		// 解决不同浏览器的 event 模型不同的问题
		event = DragZoom.dragFixE(event);
		// 看看是不是左键点击
		if(event.which != 1){
			// 除了左键都不起作用
			return true ;
		}
		// 参照这个函数的解释，挂上开始拖拽的钩子
		element.onDragStart();
		// 记录鼠标坐标
		element.lastMouseX = event.clientX;
		element.lastMouseY = event.clientY;
		// 绑定事件
		document.onmouseup = DragZoom.dragEnd;
		document.onmousemove = DragZoom.drag;
		return false ;
	},
	// Element正在被拖动的函数
	drag: function(event) {
		event = DragZoom.dragFixE(event);
		if(event.which == 0 ) {
			return DragZoom.dragEnd();
		}
		// 正在被拖动的Element
		var element = DragZoom.obj;
		// 鼠标坐标
		var _clientX = event.clientY;
		var _clientY = event.clientX;
		// 如果鼠标没动就什么都不作
		if(element.lastMouseX == _clientY && element.lastMouseY == _clientX) {
			return	false ;
		}
		// 刚才 Element 的坐标
		var _lastX = parseInt(element.style.top);
		var _lastY = parseInt(element.style.left);
		// 新的坐标
		var newX, newY;
		// 计算新的坐标：原先的坐标+鼠标移动的值差
		newX = _lastY + _clientY - element.lastMouseX;
		newY = _lastX + _clientX - element.lastMouseY;
		// 修改 element 的显示坐标
		element.style.left = newX + "px";
		element.style.top = newY + "px";
		// 记录 element 现在的坐标供下一次移动使用
		element.lastMouseX = _clientY;
		element.lastMouseY = _clientX;
		// 参照这个函数的解释，挂接上 Drag 时的钩子
		element.onDrag(newX, newY);
		return false;
	},
	// Element 正在被释放的函数，停止拖拽
	dragEnd: function(event) {
		event = DragZoom.dragFixE(event);
		// 解除事件绑定
		document.onmousemove = null;
		document.onmouseup = null;
		// 先记录下 onDragEnd 的钩子，好移除 obj
		var _onDragEndFuc = DragZoom.obj.onDragEnd();
		// 拖拽完毕，obj 清空
		DragZoom.obj = null ;
		return _onDragEndFuc;
	},
	// 解决不同浏览器的 event 模型不同的问题
	dragFixE: function(ig_) {
		if( typeof ig_ == "undefined" ) {
			ig_ = window.event;
		}
		if( typeof ig_.layerX == "undefined" ) {
			ig_.layerX = ig_.offsetX;
		}
		if( typeof ig_.layerY == "undefined" ) {
			ig_.layerY = ig_.offsetY;
		}
		if( typeof ig_.which == "undefined" ) {
			ig_.which = ig_.button;
		}
		return ig_;
	}
};
