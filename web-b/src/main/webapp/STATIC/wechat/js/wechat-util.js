	//判断是否是微信浏览器
	function is_weixin(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			return true;
	 	} else {
			return false;
		}
	}
	
	//弹出框（自动消失）
	function dialogAlert(title, content, fn){
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
	
	//添加图片尺寸后缀
	function getIndexImgUrl(imgUrl,size){
		var  pos =  imgUrl.lastIndexOf(".");
		var  imgUrlIndex = imgUrl.substr(0,pos)+size+imgUrl.substr(pos);
		return imgUrlIndex;
	}
	
	//评论图片排版
	function commentImgformat(className1,className2){
		var plist = $("."+className1+">ul>li");
		for (var i = 0; i < plist.length; i++) {
			var num = plist.eq(i).find("."+className2+">ul>li")
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
