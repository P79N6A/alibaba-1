/**
 * Created by minh on 2015/12/31.
 */

/*点赞*/
/*$(function() {
	$(".in-zan").click(function () {
		if ($(this).hasClass("in-zaned")) {
			$(this).removeClass("in-zaned");
		} else {
			$(this).addClass("in-zaned");
		}
	})
});*/
/*打开详情页*/
/*function showDetail(url, fn){
    $("html").css({overflow:"hidden"});
    var $body = $('body');
    if(window.top!=window.self && (window.parent.location.href.indexOf("get-tickets.html")==-1 && window.parent.location.href.indexOf("collect_info.jsp")==-1)){  *//*如果有父窗口时，在当前iframe里面直接打开页面*//*
        location.href = url;
    }else {
        var bodyBg = $('<div id="body_bg" style="display: none;"><img src="images/loading.gif"></div>').appendTo($body);
        $("#body_bg").fadeIn();
		$("#body_bg").addClass("opacity50");
        var layerDiv = $('<div id="layer-bg"><a class="close-btn" id="close-detail-btn"></a></div>').css({"display": "none"}).appendTo($body);
        layerDiv.append('<div id="pop_layer"><iframe style="background-color:transparent;" allowtransparency="true" id="show_login" frameborder="0" scrolling="yes" width="100%" height="100%" ></iframe></div>');

        iframeLoad(url);
    }
    *//*关闭详情窗口*//*
    $("#layer-bg").on("click", "#close-detail-btn", function(){
		if(fn){
			fn();
		}
        $("#body_bg").remove();
        $("#layer-bg").remove();
        $("html").css({overflow:"auto"});
    });
}*/
/*iframe 加载事件*/
/*function iframeLoad( url){
    var oIframe = document.getElementById("show_login");
    oIframe.onload = oIframe.onreadystatechange = iframeLoadSuccess;
    oIframe.src = url;
}*/
/*判断iframe是否加载完成，加载完成之后iframe显示*/
/*function iframeLoadSuccess(){
    var oIframe = document.getElementById("show_login");
    if (!oIframe.readyState || oIframe.readyState == "complete") {
        $('#layer-bg').css('display', 'block');
        oIframe.style.display = 'block';
        $("#body_bg").empty();
        iframeHeight("show_login");
    }
}*/
/*获取iframe的高度*/
/*function iframeHeight(){
    var oIframe = document.getElementById("show_login");
    var subWeb = document.frames ? document.frames["show_login"].document : oIframe.contentDocument;
    if(oIframe != null && subWeb != null) {
        if(subWeb.body.clientHeight < $(window).height()) {
            oIframe.height = subWeb.body.clientHeight;
            setPopupTop("pop_layer", subWeb.body.clientHeight);
        }
    }
}*/


function showDetail(url,h,fn){
	$("html").css({overflow:"hidden"});
	var $body = $('body');
	if(window.top!=window.self && (window.parent.location.href.indexOf("get-tickets.html")==-1 && window.parent.location.href.indexOf("collect_info.jsp")==-1)){  /*如果有父窗口时，在当前iframe里面直接打开页面*/
		location.href = url;
	}else {
		var bodyBg = $('<div id="body_bg" style="display: none;"><img src="../STATIC/mcshow/image/loading.gif"></div>').appendTo($body);
		$("#body_bg").fadeIn();
		$("#body_bg").addClass("opacity50");
		var layerDiv = $('<div id="layer-bg"><a class="close-btn" id="close-detail-btn"></a></div>').css({"display": "none"}).appendTo($body);
		layerDiv.append('<div id="pop_layer"><iframe style="background-color:transparent;" allowtransparency="true" id="show_login" frameborder="0" scrolling="yes" width="100%" height="100%" ></iframe></div>');

		iframeLoad(url,h);
	}
	/*关闭详情窗口*/
	$("#layer-bg").on("click", "#close-detail-btn", function(){
		if(fn){
			fn();
		}
		$("#body_bg").remove();
		$("#layer-bg").remove();
		$("html").css({overflow:"auto"});
	});
}
/*iframe 加载事件*/
function iframeLoad( url,h){
	var oIframe = document.getElementById("show_login");
	oIframe.onload = oIframe.onreadystatechange =function(){
		iframeLoadSuccess(h);
	}
	oIframe.src = url;
}
/*判断iframe是否加载完成，加载完成之后iframe显示*/
function iframeLoadSuccess(h){
	var oIframe = document.getElementById("show_login");
	if (!oIframe.readyState || oIframe.readyState == "complete") {
		$('#layer-bg').css('display', 'block');
		oIframe.style.display = 'block';
		$("#body_bg").empty();
		//iframeHeight("show_login");
		$("#pop_layer").height(h);
		$("#show_login").height(h);
	}
}


/*父窗口页面跳转*/
function parentPageJump(url){
    parent.window.location.href = url;
}
/*设置弹出框的位置*/
function setPopupTop(cId, idHeight){
    var obj = $('#'+cId);
    obj.css('height', idHeight);
    var objTop = parseInt(($(window).height() - $(obj).height())/2);
    var objLeft = parseInt(($(window).width() - $(obj).width())/2);
    if(objTop > 0){
        obj.css('padding-top', objTop);
    }else{
        obj.css('padding-top', '0px');
    }
    if(objLeft > 0){
        obj.css('left', objLeft);
    }else{
        obj.css('left', '0px');
    }
}

/*$(function() {
	$(".in-zan").click(function () {
		if ($(this).hasClass("love")) {
			$(this).removeClass("love");
		} else {
			$(this).addClass("love");
		}
	})
});*/
//详情页  切换图片
/*function slide_define(obj){
	var ul_c=obj.find("ul");
	var ul_li_c=ul_c.find("li");
	var len=ul_c.children("li").length;
	var pre_btn=obj.find(".pre_img");
	var next_btn=obj.find(".next_img");
	var now;
	pre_btn.click(function() {
		var n = now_show() + 1;
		if (n == 1) {
			//alert("已经是第一张！")
		} else {
			ul_li_c.eq(parseInt(now_show() - 1)).addClass("on").siblings("li").removeClass("on");
		}
	});
	 next_btn.click(function() {
		 var n = now_show() + 1;
		 if (n == len) {
			 //alert("已经最后一张！")
		 } else {
			 ul_li_c.eq(parseInt(now_show() + 1)).addClass("on").siblings("li").removeClass("on");
		 }
	 });
	 function now_show() {
		 for (i = 0; i < len; i++) {
			 var li = ul_li_c[i];
			 if ($(li).hasClass("on")) {
				 now = i;
			 }
		 }
		 return now;
	 }
}*/
function slide_define(obj){
	var ul_c=obj.find("ul");
	var ul_li_c=ul_c.find("li");
	var len=ul_c.children("li").length;
	var pre_btn=obj.find(".pre_img");
	var next_btn=obj.find(".next_img");
	var now;
	pre_btn.click(function() {
		//alert($(window,window.parent.document).height());
		var n = now_show() + 1;
		if (n == 1) {
			//alert("已经是第一张！")
		} else {
			var h=parseInt(ul_li_c.eq(parseInt(now_show() - 1)).find("img").height());
			if(h<530){
				h=530;
			}
			ul_c.css("height",h);
			ul_li_c.eq(parseInt(now_show() - 1)).addClass("on").siblings("li").removeClass("on");
		}
	});
	next_btn.click(function() {
		var n = now_show() + 1;
		if (n == len) {
			//alert("已经最后一张！")
		} else {
			var h=parseInt(ul_li_c.eq(parseInt(now_show()  + 1)).find("img").height());
			if(h<530){
				h=530;
			}
			ul_c.css("height",h);
			ul_li_c.eq(parseInt(now_show() + 1)).addClass("on").siblings("li").removeClass("on");
		}
	});
	function now_show() {
		for (i = 0; i < len; i++) {
			var li = ul_li_c[i];
			if ($(li).hasClass("on")) {
				now = i;
			}
		}
		return now;
	}
}
/** 发表评论**/
/*$(function(){
	$(".command_parent").on("click",".command",function() {
		var command_block = "command_box_0_" + $(this).attr("tip");
		var obj = $("." + command_block);
		if (obj.is(":visible")) {
		  obj.hide();
		} else {
			obj.show();
		}
		if ($(".grid").length > 0) {
			$('#container').BlocksIt();
		}
	});
$(".command_parent").on("click",".btn-publish",function(){
	  $(this).parent().hide();
	  if($(".grid").length>0){
			$('#container').BlocksIt();
			}
	 })	
});*/
//瀑布流
/*
$(function(){
	$(window).scroll(function() {
		var container = $('#container');
		if(container.length > 0) {
			var length = $(".grid").length;
			if (scroll_bottom && length < 20) {
				for (var i = 0; i < 3; i++) {
					var new_div = $('<div class="grid">\
					<div class="imgholder">\
						<a href="#" class="imgs"><img src="image/index_15.jpg" /></a>\
						<div class="info">\
							<div class="info-top">\
								<p>徐汇区历史底蕴深厚，文化资源丰富，是中西文化的交汇地、近代海派文化的发源地，坐落着百余处优秀历史建筑，那些重要地标、景点、经典建筑、城市景观、道路河道和风光等待你</p>\
								<div class="in-button">\
								  <span class="in-zan"></span>\
								  <a href="#" class="command" tip="0">添加评论</a>\
								</div>\
							</div>\
						</div>\
					</div>\
				</div>');
					container.append(new_div);
				}
			}
			setTimeout(function () {
				container.BlocksIt();
			}, 200);
		}
	});
   function scroll_bottom(){
	   var height=$(window).height();
	   var con_height=$(document).height();
	   var length=$("#container").find(".grid").length;
	   var offtop=$("#container").find(".grid").eq(length-1).offset().top;
	   var sc_all=con_height-height;
	   var scroll_top=$(document).scrollTop();
	   return (scroll_top+parseInt(height)>offtop) ? true : false;
	}
});
*/

function dialogAlert(title, content, fn){
    if(top.dialog){
        dialog = top.dialog;
    }
    var d = dialog({
        width: 500,
        title:title,
        content:content,
        fixed: true,
        okValue: '确 定',
        ok: function () {
            if(fn)  fn();
        }
    });
    d.showModal();
}
