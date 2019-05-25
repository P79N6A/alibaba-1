/**
 * Created by minh on 2015/6/8.
 */
$(function(){
    /*文本框默认值*/
    var $inputText = $('.input-text');
    $inputText.focus(function(){
        if($(this).val() == $(this).attr('data-val')){
            $(this).val('').css('color', '#444444');
        }
    });
    $inputText.blur(function(){
        if($(this).val() == null || $(this).val() == '' || $(this).val() == $(this).attr('data-val')){
            $(this).val($(this).attr('data-val')).removeAttr('style');
        }
    });
    /*cur当前样式*/
    $('.cateList').on('click', 'a', function(){
        $(this).addClass('cur').siblings().removeClass('cur');
    });
    /*密码框提示*/
    $("input.password_input").blur(function(){
        if($(this).val()==""){
            $(this).val("密码：请输入您的密码").removeAttr('style');
            if($(this).attr("type") == "password"){
                $(this).hide();
                $(this).siblings().show();
                $(this).siblings().val($(this).siblings().attr("data-val"));
            }else{
                var pass = $(this).siblings().val();
                if(pass.length<1){
                    $(this).hide();
                    $(this).siblings().show();
                }
            }
        }
    });
    $("input.password_text").focus(function(){
        if($(this).val()== $(this).attr("data-val")){
            $(this).val("");
            if($(this).attr("type")=="text"){
                $(this).hide();
                $(this).siblings().show().css('color', '#444444');
                $(this).siblings().val("");
                $(this).siblings().focus();//加上
            }else{
                var pass = $(this).siblings().val();
                if(pass.length<1){
                    $(this).hide();
                    $(this).show();
                }
            }
        }
    });
    /*搜索项，展开，收起*/
    $('.prop-attrs').on('click', '.av-more', function(){
        if($(this).hasClass('fold')){
            $(this).removeClass('fold').html('展开<b></b>');
            $(this).siblings().removeClass('av-expand').addClass('av-collapse');
        }else{
            $(this).addClass('fold').html('收起<b></b>');
            $(this).siblings().removeClass('av-collapse').addClass('av-expand');
        }
    });
    /*更多选项和收起*/
    $('#search').on('click', '.attr-extra', function(){
        var $search = $("#search");
        if($(this).hasClass('open')){
            $(this).removeClass('open').html('更多选项<b></b>');
            if($search.find(".hot-attrs").length > 0){
                $search.find(".prop-attrs:gt(0)").css('display', 'none');
                //$search.find(".hot-attrs").css('display', 'none');
            }else{
				$search.find(".prop-attrs:gt(0)").css('display', 'none');
                //$search.find(".hot-attrs").css('display', 'none');
            }
        }else{
            $(this).addClass('open').html('收起<b></b>');
            $search.find(".prop-attrs").css('display', 'block');
        }
    });
    /*if($('#search .prop-attrs').length > 2){
        $("#search .search>div:gt(1)").css('display', 'none');
    }else{
        $("#search .advanced").css('display', 'none');
        $("#search .search-btn").css('display', 'none');
    }*/
    /*搜索项*/
    $('.attrValue ul').on('click', 'li', function(){
        $(this).addClass('cur').siblings().removeClass('cur');
    });
    /*馆藏分类-折叠菜单*/
    //$(".recommend-cate dl:gt(0) dd").hide();
    $(".recommend-cate dl dt").click(function(){
        if(!$(this).hasClass("current")){
            $(".recommend-cate dl dd").not($(this).next()).slideToggle();
            $(".recommend-cate dl dt").not($(this).next()).removeClass("current");
            $(this).next().slideToggle();
            $(this).toggleClass("current")
        }
    });
    /*活动收藏*/
    var $userPart = $(".user-part");
    $userPart.on("mouseover", "ul li", function(){
        $(this).find(".close-btn").show();
    });
    $userPart.on("mouseout", "ul li", function(){
        $(this).find(".close-btn").hide();
    });
    /*多选按钮*/
    $(".checkBtn").on("click", "input[type=checkbox]", function(){
        if($(this).parent().hasClass("r_on")){
            $(this).parent().removeClass("r_on").addClass("r_off");
            $(this).prop("checked", false);
        }else{
            $(this).parent().removeClass("r_off").addClass("r_on");
            $(this).prop("checked", true);
        }
    });
    /*场次选择*/
    $(".cate .caption").each(function(){
        var thisVal = $(this).parent().find("option:selected").text();
        if(thisVal != "请选择所属团体") $(this).removeClass("default");
        $(this).text(thisVal);
    });
    $(".room-part1 .cate").on("change", "select", function(){
        var selectVal =  $(this).find("option:selected").text();
        var textDom = $(this).parent().find(".caption");
        if(selectVal == "请选择所属团体"){
            textDom.addClass("default");
        }else {
            textDom.removeClass("default")
        }
        textDom.text(selectVal);
    });
    /*头部切换站点*/
    $("#header .site-name,#header .change-txt").click(function(e){
        e.stopPropagation();
        $(this).siblings(".site-txt").toggleClass("show");
    });
    var $header = $("#header");
    $header.find(".site-list").on("click", "a", function(){
        var $this = $(this);
        var $parent = $this.parents(".change-site");
        $parent.find("span").text($this.attr("data-val"));
    });
    $(document).click(function(){
        var $header = $("#header");
        $header.find(".site-txt").removeClass("show");
        $header.find(".sim-ul-flt").hide();
    });
    /*头部搜索筛选*/
    $header.find(".sim-select h3").click(function(e){
        e.stopPropagation();
        var $this = $(this);
        var $parent = $this.parent();
        var $ul = $this.siblings(".sim-ul-flt");
        $ul.toggle();
        $ul.find("li").click(function(){
            var selVal = $(this).attr("data-val");
            $this.find("span").text(selVal);
            $parent.siblings("input.sim-select-val").val(selVal);
        });
    });
    /*头部登录下拉*/
    $("#header .login-btn,#header .login-menu").on({
        "mouseover": function(){
            var $menuBox = $("#header").find(".login-menu");
            $menuBox.css({"display": "block"});
        },
        "mouseout": function(){
            var $menuBox = $("#header").find(".login-menu");
            $menuBox.css({"display": "none"});
        }
    });
    /*首页猜你喜欢*/
    $("#in-content").on("mouseenter mouseout", ".in-interest li", function(){
        $(this).addClass("on").siblings().removeClass("on");
    });
    /*内容满屏显示*/
    setScreen();
    /*评论评分*/
    setScore();
});

$(window).resize(function(){
    /*内容满屏显示*/
    setScreen();
});

function dialogConfirm(title, content, fn){
    var d = dialog({
        width:440,
        title:title,
        content:content,
        fixed: true,
        button:[{
            value: '确定',
            callback: function () {
                if(fn)  fn();
                //this.content('你同意了');
                //return false;
            },
            autofocus: true
        },{
            value: '取消'
        }]
    });
    d.showModal();
}

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

function dialogTip(title, content){
    if(top.dialog){
        dialog = top.dialog;
    }
    var d = dialog({
        width:400,
        title:title,
        content:content,
        fixed: true
    });
    d.showModal();
}
/*页面内容不够一屏时*/
function setScreen(){
    var $content = $("#register-content");
    if($content.length > 0) {
        $content.removeAttr("style");
        var contentH = $content.outerHeight();
        var otherH = $("#header").outerHeight() + $("#in-footer").outerHeight();
        var screenConH = $(window).height() - otherH;
        if (contentH < screenConH) {
            $content.css({"height": screenConH});
        }
    }
}
/**评论图片展开查看原图**/
/**场馆列表**/
/*$(function() {
    $(".wimg").on("hover", ".sc_img", function(){
        var $this = $(this);
        var $a = $this.find("a");
        if($a.is(":visible")){
            $a.hide();
        }else{
            $a.show();
        }
    });
});*/
$(function() {
    var $commentList = $("#comment-list-div");
    $commentList.on("click", ".pld_img img", function () {
      var $this = $(this);
      var urls = $this.attr("src");
      var $parent = $this.parents(".pld_img_list");
      var $afterImg  = $parent.next();
      $afterImg.children(".fd_img").attr("src", urls);
      $afterImg.find(".yuantu").attr("href", urls);
      $afterImg.show();
  });
    $commentList.on("click", ".shouqi", function () {
      var $this = $(this);
      var $afterImg  = $this.parents(".after_img");
      $afterImg.hide();
  })
});
 /**查看更多评论**/
$(function() {
    var n = 2;
    var i = 0;	//初始显示评论条数，n为索引从0开始
    $("#lrk_listpl>li:gt(" + n + ")").hide();
    function more() {
        for (i = n + 1; i < n + 4; i++) {	//循环三次，显示三条
            $("#lrk_listpl>li:eq(" + i + ")").show();
            if (i == $("#lrk_listpl>li").length) {
                $("#lrk_more3").text("没有更多评论了");
            }
        }
    }
    $("#lrk_more3").click(function () {
        more();
        n = n + 3;	//显示三条，加3
    })
});
/**360点击弹出层**/
function showPanorama(url){
	var htmlStr = '<div class="panorama_bg"></div>'+
			   '<div class="panorama_con">'+
			   '<iframe src="'+ url +'" width="1090" height="570" scrolling="no" frameborder="0"></iframe>'+
			   '<a id="close_btn"></a>'+
			   '</div>';
	 var $panorama = $("#panorama");
	 $panorama.html(htmlStr);
	$panorama.on("click", "#close_btn", function(){
        $panorama.html("").hide();
	});			   
}
$(function() {
    $("#map_display").click(function () {
        $("#panorama").show();
    });
    $("#close_btn").click(function () {
        $("#panorama").hide();
    });
});
/*评论评分*/
function setScore(){
    var num = 0,starW = 0, scoreNum = 0;
    $("#star-score a").each(function(index, element) {
        $(this).click(function(){
            $("#star-score a").removeClass("cur");
            $(this).addClass("cur");
            $(this).css({"width":starW,"left":"0"});
            $("#score-num").text(scoreNum);
            $("#activityScore").val(scoreNum);
        });
        $(this).hover(function(){
            scoreNum = $(this).text();
            num = parseInt(index)+1;
            starW = 28*num;
        });
    });
}
/*评论星级设置*/
function starts(obj,n){
    var $obj = $(obj);
	$obj.each(function(index, element) {
        var num=parseFloat($(this).attr("tip"));
        var width=num*n;
        $(this).children("p").css("width",width);
    });
}
/**视频更多滚动条**/
(function($){
    $(window).load(function(){
        if(document.getElementById("video-list")) {
            $.mCustomScrollbar.defaults.scrollButtons.enable = true; //enable scrolling buttons by default
            $.mCustomScrollbar.defaults.axis = "yx"; //enable 2 axis scrollbars by default
            $("#video-list").mCustomScrollbar();
        }
    });
})(jQuery);
/**活动详情点赞喜欢2016.1.19**/
$(function(){
	 $(".me_vote li").on("click","a",function(){
		   if($(this).hasClass("likeme")){
			 $(this).removeClass("likeme");
			 }
			 else{
			 $(this).addClass("likeme");
			 }
		})
	})
/**实况直击**/
	$(function() {
	$("body").on("click", ".in-zan", function () {
		if ($(this).hasClass("in-zaned")) {
			$(this).removeClass("in-zaned");
		} else {
			$(this).addClass("in-zaned");
		}
	})
});
/**玩家秀**/
$(function() {
	$("body").on("click", ".on-zan", function () {
		if ($(this).hasClass("on-zaned")) {
			$(this).removeClass("on-zaned");
		} else {
			$(this).addClass("on-zaned");
		}
	})
});
/** 发表评论**/
$(function(){
	$("#player_show").on("click",".command",function() {
		var command_block = "command_box_0_" + $(this).attr("tip");
		var obj = $("." + command_block);
		if (obj.is(":visible")) {
		  obj.hide();
		} else {
			obj.show();
		}
		if ($(".grid").length > 0) {
			$('#player_show').BlocksIt();
		}
	});
$("#player_show").on("click",".btn-publish",function(){
	  $(this).parent().hide();
	  if($(".grid").length>0){
			$('#player_show').BlocksIt();
			}
	 })	
});
/**nav**/
$(function() {
    /**nav**/
    $(".hp_nav ul li").on('click', 'a', function () {
        $(this).parent().addClass("h_nav").siblings().removeClass("h_nav");
    });
  /*  /!**code**!/
    $(".top_method ul .weixin").hover(function () {
        $(this).find(".ewm_code").toggle();
    });*/
    /*头部切换站点*/
    var $header = $(".hp_nav");
    $header.find(".site-list").on("click", "a", function () {
        var $this = $(this);
        var $parent = $this.parents(".change-site");
        $parent.find("span").text($this.attr("data-val"));
    });
    $(document).click(function () {
        var $header = $(".hp_nav");
        $header.find(".site-txt").removeClass("show");
        $header.find(".sim-ul-flt").hide();
    });
  /*  /!*头部搜索筛选*!/
    $header.find(".sim-select h3").click(function (e) {
        e.stopPropagation();
        var $this = $(this);
        var $parent = $this.parent();
        var $ul = $this.siblings(".sim-ul-flt");
        $ul.toggle();
        $ul.find("a").click(function () {
            var selVal = $(this).attr("data-val");
            $this.find("span").text(selVal);
            $parent.siblings("input.sim-select-val").val(selVal);
        });
    });*/
});
 /**返回顶部**/
 $(function(){
	 jQuery(document).ready(function($){
	    var offset = 300,
		scroll_top_duration = 700,
		$back_to_top = $('.cd-top');

	$back_to_top.on('click', function(event){
		event.preventDefault();
		$('body,html').animate({
			scrollTop: 0
		 	}, scroll_top_duration
		);
	});
   });
})
 /*首页星期切换*/
$(function() {
   $(".navs a").click(function(){
       alert(0);
		  var tips=$(this).attr("tip");
       alert(1);
       $(this).addClass("curblue").siblings().removeClass("curblue");
       alert(2);
       $(tips).show().siblings().hide();
		
		})
    $(".navs").on("click","a",function(){
		  var objs=$(this);
		  tabs(objs,"curblue")
		})
	$(".navs a.forit").click(function(){
		  $("#t_activity ul").show();
		})
})	

