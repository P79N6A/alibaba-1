	//判断是否是微信浏览器
	function is_weixin(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			return true;
	 	} else {
			return false;
		}
	}
	
	//HTML5页面音视频在微信和app下自动播放的实现方法
	function autoPlayMusic(id) {   
		/* 自动播放音乐效果，解决浏览器或者APP自动播放问题 */   
		function musicInBrowserHandler() {   
			musicPlay(true,id);   
			document.body.removeEventListener('touchstart', musicInBrowserHandler);   
		}   
		document.body.addEventListener('touchstart', musicInBrowserHandler);   
		/* 自动播放音乐效果，解决微信自动播放问题 */   
		function musicInWeixinHandler() {   
			musicPlay(true,id);   
			document.addEventListener("WeixinJSBridgeReady", function () {   
				musicPlay(true,id);   
			}, false);   
			document.removeEventListener('DOMContentLoaded', musicInWeixinHandler);   
		}   
		document.addEventListener('DOMContentLoaded', musicInWeixinHandler);   
	}
	function musicPlay(isPlay,id) {   
		var media = document.getElementById(id);   
		if (isPlay && media.paused) {   
			media.play();   
		}   
		if (!isPlay && !media.paused) {   
			media.pause();   
		}   
	}  
	
	//图片撑满居中
	(function(a){var b={"boxWidth":0,"boxHeight":0};a.fn.extend({"picFullCentered":function(c){var d=a.extend({},b,c);this.each(function(){if(d.boxWidth&&d.boxHeight){var g=a(this);var f=d.boxWidth/d.boxHeight;var e=new Image();e.onload=function(){var i=e.width;var h=e.height;if(i/h>=f){var l=(d.boxHeight*i)/h;var k=(l-d.boxWidth)/2*(-1);g.css({"width":"auto","height":"100%","position":"absolute","top":"0","left":k})}else{var j=(d.boxWidth*h)/i;var m=(j-d.boxHeight)/2*(-1);g.css({"width":"100%","height":"auto","position":"absolute","top":m,"left":"0"})}};e.src=g.attr("src")}});return this}})})(jQuery);
	
	//点击看大图
	function previewImg(url,urls,Suffix){
		var urlArray = new Array();
		if(urls.indexOf(";")>=0) urlArray=urls.split(";");
		else if(urls.indexOf(",")>=0) urlArray=urls.split(",");
		
		if(Suffix){
			url += Suffix;
			var previewImgs = "";
			$.each(urlArray, function (i, dom) {
				previewImgs += dom+Suffix+";";
			});
			if(urlArray.length>0){
				urls = previewImgs.substring(0,previewImgs.length-1);
			}
		}else{
			var previewImgs = "";
			$.each(urlArray, function (i, dom) {
				previewImgs += dom+";";
			});
			if(urlArray.length>0){
				urls = previewImgs.substring(0,previewImgs.length-1);
			}
		}
		if (is_weixin()) {
			wx.previewImage({
	            current: url, // 当前显示图片的http链接
	            urls: urls.split(";")	 // 需要预览的图片http链接列表
	        });
		}else{
			if(!(/wenhuayun/.test(ua)) || !window.injs || !injs.appPhotoBrowser(url,urls)){	//判断是否存在APP方法
				showSwiperPreview(url, urls);
			}
		}
	}
	
	//swiper图片预览（不可缩放）
	function showSwiperPreview(url, urls) {
	    var imgSrc = urls.split(';');
	    var slideAmount = imgSrc.length;
	    var ele_s1 = $('.roomBigPic .amount .s1');
	    $('.roomBigPic .amount .s2').html(slideAmount);
	    var _index = 0;
	    for(var i =0; i < slideAmount; i++) {
	        if(imgSrc[i] == url) {
	            _index = i;
	        }
	    }

	    if(springSwiperFlag == 0) {
            outSwiper = new Swiper('.roomBigPic .swiper-container', {
                lazyLoading : true,
                lazyLoadingInPrevNext : true,
                observer:true,
                onInit: function(inSwiper){
                    for(var i = 0; i < slideAmount; i++) {
                        inSwiper.appendSlide('<div class="swiper-slide"><img class="swiper-lazy" data-src="' + imgSrc[i] + '"><div class="swiper-lazy-preloader"></div></div>');
                    }

                    inSwiper.slideTo(_index, 0, false);
                    ele_s1.html(inSwiper.activeIndex + 1);
                },
                onSlideChangeEnd: function(inSwiper){
                    ele_s1.html(inSwiper.activeIndex + 1);
                }
            });
            springSwiperFlag = 1;
        } else {
            outSwiper.removeAllSlides();
            for(var i = 0; i < slideAmount; i++) {
                outSwiper.appendSlide('<div class="swiper-slide"><img class="swiper-lazy" data-src="' + imgSrc[i] + '"><div class="swiper-lazy-preloader"></div></div>');
            }
            outSwiper.slideTo(_index, 0, false);
            ele_s1.html(outSwiper.activeIndex + 1);
        }
	    
	    $('.roomBigPic').stop().fadeIn(80);
	}
	
	//初始化swiper Div
	function initSwiper(){
		var zongtxt = '<div class="roomBigPic" style="display:none;"><div class="amount"><span class="s1"></span> / <span class="s2"></span></div><div class="swiper-container"><div class="swiper-wrapper"></div></div></div>';
		$('body').append(zongtxt);
		$(".roomBigPic").on("touchmove",function(){
    		return false;
    	});
    	$(".roomBigPic").on("click",function(){
    		$(this).fadeOut(80);
    	});
	}
	
	//弹出框（自动消失）
	function dialogAlert(title, content){
		$(".ui-popup").remove();	//强制清除弹窗，防止多弹窗不关闭
	    if(top.dialog){
	        dialog = top.dialog;
	    }
	    var d = dialog({
	        width: 500,
	        title:title,
	        content:content,
	        fixed: true
	    });
	    d.show();
	    
	    setTimeout(function(){
			d.removeSlow();
		},1500);
	}
	
	//弹出框（带事件）
	function dialogConfirm(title, content, fn){
		var winW = Math.min(parseInt($(window).width()*0.82), 575);
		var d = dialog({
			width:winW,
			title:title,
			content:content,
			fixed: true,
			button:[{
				value: '确定',
				callback: function () {
					if(fn)  fn();
				},
				autofocus: true
			}]
		});
		d.showModal();
	}
	
	//添加图片尺寸后缀
	function getIndexImgUrl(imgUrl,size){
		var  pos =  imgUrl.lastIndexOf(".");
		var  imgUrlIndex = imgUrl.substr(0,pos)+size+imgUrl.substr(pos);
		return imgUrlIndex;
	}
	
	//图片列表排版
	function imgStyleFormat(className1,className2){
		if(className2){		//图片列表排版
			var plist = $("."+className1+">ul>li");
			for (var i = 0; i < plist.length; i++) {
				var num = plist.eq(i).find("."+className2+">ul>li");
				num.css("float","left");
				if (num.length == 1) {
					num.css("width","540px")
					num.find("img").css("width", "520px")
					num.find("img").css("margin", "10px")
				} else if (num.length > 1 && num.length < 5) {
					num.css("width","280")
					num.css("height","280")
					num.find("img").css("width", "260px")
					num.find("img").css("margin", "10px")
				} else {
					num.css("width","170")
					num.css("height","170")
					num.find("img").css("width", "150px")
					num.find("img").css("margin", "10px")
				}
			}
		}else{	//图片排版（非列表）
			var num = $("."+className1+">ul>li");
			num.css({"float":"left","position":"relative","margin":"5px"});
			if (num.length == 1) {
				num.css("width","550px")
				num.css("height","550px")
				num.find("img").css({"max-height":"550px","max-width":"550px","margin":"auto","position":"absolute","left":"0","right":"0","top":"0","bottom":"0"})
			} else if (num.length > 1 && num.length < 5) {
				num.css("width","270")
				num.css("height","270")
				num.find("img").css({"max-height":"270px","max-width":"270px","margin":"auto","position":"absolute","left":"0","right":"0","top":"0","bottom":"0"})
			} else {
				num.css("width","176")
				num.css("height","176")
				num.find("img").css({"max-height":"176px","max-width":"176px","margin":"auto","position":"absolute","left":"0","right":"0","top":"0","bottom":"0"})
			}
		}
	}
	
	//头像图片未找到时默认图
	function imgNoFind(){
		var img=event.srcElement;
		img.src="../STATIC/wx/image/sh_user_header_icon.png";
		img.onerror=null; //控制不要一直跳动
	}
	
	//下载app弹出框
    function downLoadApp(){
    	if (Date.parse(new Date()) > window.localStorage.getItem("downLoadAppTime")) {
    	    localStorage.removeItem("downLoadApp");    //清除downLoadApp的值
    	}
    	var downLoadAppValue = window.localStorage.getItem("downLoadApp");
    	if($("div").hasClass("downLoadApp")){
    		if (downLoadAppValue==null) {
            	$(".downLoadApp").prepend("<div class='download-fix'>" +
    										"<div class='fix-close'>" +
    											"<img src='../STATIC/wechat/image/close-img.png' />" +
    										"</div>" +
    										"<div class='fix-download'>" +
    											"<a href='http://www.wenhuayun.cn/appdownload/index.html'><img src='../STATIC/wechat/image/download-img.png' /></a>" +
    											"<p>更&nbsp;/&nbsp;多&nbsp;/&nbsp;免&nbsp;/&nbsp;费</p>" +
    											"<p>公&nbsp;/&nbsp;益&nbsp;/&nbsp;活&nbsp;/&nbsp;动</p>" +
    										"</div>" +
    										"<div class='fix-er'>" +
    											"<img src='../STATIC/wechat/image/app-er.png' />" +
    										"</div>" +
    									"</div>");
            	$("html,body").addClass("bg-notouch")
    			$(".fix-close").click(function() {
    				window.localStorage.setItem("downLoadAppTime", Date.parse(new Date())+60*60*24*1000);
    				window.localStorage.setItem("downLoadApp", "1");
    				$("html,body").removeClass("bg-notouch")
    				$(".download-fix").hide()
    			})
    			setTimeout(function() {
    				$(".download-fix").hide()
    				$("html,body").removeClass("bg-notouch")
    			}, 15000)
            }
    	}
    }
    
    //时间格式化
	Date.prototype.format = function(format) {
		var date = {
			"M+": this.getMonth() + 1,
			"d+": this.getDate(),
			"h+": this.getHours(),
			"m+": this.getMinutes(),
			"s+": this.getSeconds(),
			"q+": Math.floor((this.getMonth() + 3) / 3),
			"S+": this.getMilliseconds()
		};
		if (/(y+)/i.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
		}
		for (var k in date) {
			if (new RegExp("(" + k + ")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length == 1
						? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
			}
		}
		return format;
	}
	
	//根据时间戳生成的时间str
	function formatTimestamp(timestamp){
		var date = new Date(timestamp * 1000);   
		var m = date.getMonth() + 1;
		m = m>9?m:"0"+m;
		var d = date.getDate();
		d = d>9?d:"0"+d;
		var h = date.getHours();
		h = h>9?h:"0"+h;
		var M = date.getMinutes();
		M = M>9?M:"0"+M;
		var s = date.getSeconds();
		s = s>9?s:"0"+s;
		var date = (date.getFullYear())+"."+m+"."+d+" "+h+":"+M+":"+s;
		return date;
	}
	
	//泛型时间显示（参数：2016-09-10 12:40:00）
	function formatTimeStr(date,isShowTime) {
		var timestamp = Date.parse(new Date()) / 1000;
		if(date.indexOf(".")>=0){
			time = new Date(Date.parse(date.replace(/\./g, "/")));
		}else{
			time = new Date(Date.parse(date.replace(/-/g, "/")));
		}
		time = time.getTime() / 1000;
		if(timestamp - time < 60 * 60 * 24) {
			if(timestamp - time <= 60){
				return '刚刚';
			}else if(timestamp - time < 3600){
				return parseInt((timestamp - time)/60) + '分钟前';
			}else{
				return parseInt((timestamp - time)/3600) + '小时前';
			}
		}else{
			if(!isShowTime)
				return date.substring(0,10);
			else
				return date;
		}
	}
	
	//选项弹窗
	function TypeChose(arraw, IDname,IDvalue) {
		var m_arraw = arraw;
		
		var chose=$(".Type-chose");
		
		if(chose.length<1)
		{
			$("body").append(
					"<div class=\"Type-chose\" style=\"position: fixed;top: 0;left: 0;bottom: 0;right: 0;width: 100%;height: 100%;z-index: 100;background: url(../STATIC/wechat/image/500.png);\">" +
			"<div style='margin: auto;position: absolute;top: 0;left: 0;bottom: 0;right: 0;z-index: 100;height: 160px;width: 320px;background-color: white;overflow-y: scroll;padding: 40px;font-size: 36px;text-align: center;border: 1px solid #808080;border-radius: 25px;'>" +
			"<ul class='arraw-list'>" +

			"</ul>" +
			"</div>" +
			"</div>"
		)
		
		}else
			chose.show()
			
		$(".arraw-list").html("");
			
		for (var i = 0; i < m_arraw.length; i++) {
				$(".arraw-list").append(
					"<li dictId='"+m_arraw[i].dictId+"'><p>" +
					m_arraw[i].dictName +
					"</p></li>"
				)
			}	
		
		$(".arraw-list > li").click(function() {
			var font = $(this).find("p").text()
			var id=$(this).attr("dictId");
			$("#" + IDvalue).html(font)
			$("#" + IDname).val(id)
			$(".Type-chose").hide()
		})
	}
	
	/*响应式弹窗
	 * title 弹窗标题
	 * content 弹窗内容
	 * func1 按钮1的回调函数
	 * alignment 文字对齐 1居左对齐 2居中对齐(默认选2)
	 * */
	function responseDialog(title, content, func1, alignment) {
		var alignment = arguments[3] ? arguments[3] : 2;
		if(alignment == 1) {
			var align = 'left'
		} else if(alignment == 2) {
			var align = 'center'
		}
		$("body").append(
			'<div class="dialogResponse">' +
			'<div class="dialogResponse-tag">' +
			'<div class="dialogResponse-main">' +
			'<div class="dialogResponse-title">' + title + '</div>' +
			'<div class="dialogResponse-content" style="text-align:' + align + '">' + content + '</div>' +
			'</div>' +
			'</div>' +
			'</div>'
		)
		$(".dialogResponse-tag").append(
			'<div class="dialogResponse-footer clearfix">' +
			'<div class="dialogResponse-btn1">确定</div>' +
			'</div>'
		)
		$(".dialogResponse-btn1").on('click', function() {
			if(func1){
				func1();
			}
			$(".dialogResponse").remove()
		})
	}
	
	//判断访问终端
	var browser={
	    versions:function(){
	        var u = navigator.userAgent, 
	            app = navigator.appVersion;
	        return {
	            trident: u.indexOf('Trident') > -1, //IE内核
	            presto: u.indexOf('Presto') > -1, //opera内核
	            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
	            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//火狐内核
	            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
	            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
	            android: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, //android终端
	            iPhone: u.indexOf('iPhone') > -1 , //是否为iPhone或者QQHD浏览器
	            iPad: u.indexOf('iPad') > -1, //是否iPad
	            webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
	            weixin: u.indexOf('MicroMessenger') > -1, //是否微信 （2015-01-22新增）
	            qq: u.match(/\sQQ/i) == " qq" //是否QQ
	        };
	    }(),
	    language:(navigator.browserLanguage || navigator.language).toLowerCase()
	}
	
	//app获取用户Id
	function getAppUserId(){
		var ua = navigator.userAgent.toLowerCase();	
	  	if (/wenhuayun/.test(ua)) {		//APP端
	  		if(/android/.test(ua)){		//安卓
	  			if(window.injs){	//判断是否存在方法
		  			if(injs.appsdk_UserIsLogin()){
		      			userId = JSON.parse(injs.appsdk_getUserInfo()).userId.length>0?JSON.parse(injs.appsdk_getUserInfo()).userId:JSON.parse(injs.appsdk_getUserInfo()).userid;
		  			}else{
	  					userId = '';
	  				}
	  			}
	  		}else{		//ios
	  			if(window.injs){	//判断是否存在方法
	  				if(injs.userIsLogin()){
	  	      			userId = JSON.parse(injs.getUserInfo()).userId;
	  				}else{
	  					userId = '';
	  				}
	  			}else{
	  				if( typeof appsdk_UserIsLogin === 'function' ){	//存在且是function
		  				if(appsdk_UserIsLogin()){
		  	      			userId = JSON.parse(appsdk_getUserInfo()).userId.length>0?JSON.parse(appsdk_getUserInfo()).userId:JSON.parse(appsdk_getUserInfo()).userid;
		  				}else{
		  					userId = '';
		  				}
		  			}
	  			}
	  		}
	  	}
	}
	
	//app获取用户坐标
	function getAppUserLocation(){
		var ua = navigator.userAgent.toLowerCase();	
	  	if (/wenhuayun/.test(ua)) {		//APP端
  			if(window.injs){	//判断是否存在方法
	  			if(injs.userIsLogin()){
	      			latitude = JSON.parse(injs.getUserInfo()).userLat;
	      			longitude = JSON.parse(injs.getUserInfo()).userLon;
	  			}else{
	  				latitude = 31.22;
	  		        longitude = 121.48;
  				}
  			}
	  	}
	}
	
	//设置H5title或APPtitle
	function setTitle(){
		if($(document).attr("title").length==0){
			$(document).attr("title","安康文化云");
		}else{
			if (/wenhuayun/.test(ua)) {		//APP端
				if(window.injs){	//判断是否存在方法
					injs.changeNavTitle(decodeURIComponent($(document).attr("title"))); 
				}
			}
		}
	}
	
	//APP获取分享信息
	function getShareInfo(){
		var shareJson = {title:appShareTitle,desc:appShareDesc,imgUrl:appShareImgUrl,link:appShareLink};
		return JSON.stringify(shareJson);
	}
	
	