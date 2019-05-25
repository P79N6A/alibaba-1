$(document).ready(function(){
	/*导航当前样式*/
	var webUrlStr = window.location.href.split("/");
	var webUrl = webUrlStr[webUrlStr.length-1];

	if(webUrl.indexOf("?")>0){
		webUrl=webUrl.split("?")[0];
	}
	//前台页面导航样式
	$(function(){
		$('.hp_nav ul li').each(function(){
			if($(this).attr("data-url") == webUrl){
				$(this).addClass('cur').siblings().removeClass('cur');
			}
		});
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
	/*头部搜索筛选*/
	/*$header.find(".sim-select h3").click(function (e) {
	    e.stopPropagation();
	    var $this = $(this);
	    var $parent = $this.parent();
	    var $ul = $this.siblings(".sim-ul-flt");
	    $ul.toggle();
	    $ul.find("a").click(function () {
	        var selVal = $(this).attr("data-val");
	        $this.find("span").text(selVal);
	    });
	});
	$(document).click(function () {
	    var $header = $(".hp_nav");
	    $header.find(".site-txt").removeClass("show");
	    $header.find(".sim-ul-flt").hide();
	    $(".link").hide();
	});*/
});