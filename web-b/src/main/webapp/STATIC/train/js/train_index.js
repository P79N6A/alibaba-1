/**
 * Created by minh on 2015/6/8.
 */
 $(function(){
	//文本
	$(".input_style").focus(function(){
		var txt_val=$(this).val();
		
		if(txt_val==this.defaultValue){
			   $(this).val("");
			   $(this).css("border","1px solid #CCCCCC");
			}
		})
    $(".input_style").blur(function(){
		 var txt_val=$(this).val();
		if(txt_val==""){
			   $(this).val(this.defaultValue);
			   $(this).css("border","1px solid #ff0000");
			}
		})
  
    
	
 })
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
    /*input-text 页面加载的时候判断文本框是否有值*/
    /*$inputText.each(function(){
        if($(this).val() == ''){
            $(this).parent().addClass("showPlaceholder");
        }else{
            $(this).parent().removeClass("showPlaceholder");
        }
    });*/
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
                $search.find(".prop-attrs:gt(1)").css('display', 'none');
            }else{
				$search.find(".prop-attrs:gt(0)").css('display', 'none');
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
/*下拉列表框*/
function selectModel(fn) {
    var $box = $('div.select-box');
    var $option = $('ul.select-option', $box);
    var $txt = $('div.select-text', $box);
    var speed = 10;
    var zindex = 3;
    /*
     * 当机某个下拉列表时，显示当前下拉列表的下拉列表框
     * 并隐藏页面中其他下拉列表
     */
    $txt.click(function(e) {
        $option.not($(this).siblings('ul.select-option')).slideUp(speed, function() {
            int($(this));
        });
        zindex++;
        $(this).parent().css('zIndex', zindex);
        $(this).siblings('ul.select-option').slideToggle(speed, function() {
            int($(this));
        });
        return false;
    });
    //点击选择，关闭其他下拉
    /*
     * 为每个下拉列表框中的选项设置默认选中标识 data-selected
     * 点击下拉列表框中的选项时，将选项的 data-option 属性的属性值赋给下拉列表的 data-value 属性，并改变默认选中标识 data-selected
     * 为选项添加 mouseover 事件
     */
    $option.find('li')
        .each(function(index, element) {
            if ($(this).hasClass('seleced')) {
                $(this).addClass('data-selected');
            }
        });
    $option.on({
        mousedown: function(){
            //赋值操作
            $(this).parent().siblings('div.select-text').text($(this).text()).attr('data-value', $(this).attr('data-option'));
            $(this).parent().siblings('input').val( $(this).attr('data-option'));
            $option.slideUp(speed, function() {
                int($(this));
            });
            $(this).addClass('seleced data-selected').siblings('li').removeClass('seleced data-selected');
			if($(this).parent().hasClass("fn_option")){
				  if(fn){
					  fn();
					 }
				}
            return false;
        },
        mouseover: function(){
            $(this).addClass('seleced').siblings('li').removeClass('seleced');
        }
    },"li");
    //点击文档，隐藏所有下拉
    $(document).click(function(e) {
        $option.slideUp(speed, function() {
            int($(this));
        });
    });
    //初始化默认选择
    function int(obj) {
        obj.find('li.data-selected').addClass('seleced').siblings('li').removeClass('seleced');
    }
}

$(function() {
    /**nav**/
    $(".hp_nav ul li").on('click', 'a', function () {
        $(this).parent().addClass("h_nav").siblings().removeClass("h_nav");
    });
    /**code**/
    $(".top_method ul .weixin").hover(function () {
        $(this).find(".ewm_code").toggle();
    });
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
    /*头部搜索筛选*/
    $header.find(".sim-select h3").click(function (e) {
        e.stopPropagation();
        var $this = $(this);
        var $parent = $this.parent();
        var $ul = $this.siblings(".sim-ul-flt");
        $ul.toggle();
        $ul.find("a").click(function () {
            var selVal = $(this).attr("data-val");
            var selTxt = $(this).text();
            $this.find("span").text(selTxt);
            $parent.siblings("input.sim-select-val").val(selVal);
        });
    });
});