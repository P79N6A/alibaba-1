/**
 * Created by minh on 2015/4/20.
 */
$(function(){
    setLayout();
});
$(window).resize(function(){
    setLayout();	
});
function setLayout(){
    var winW = $(window).width();
    var winH = $(window).height();
	//$('body').css({height: winH, width: winW});;
    $('#main-left').css({height: winH});
    $('#main-right').css({height: winH , width: winW });
   // $('#content').css({height: winH - 99, width: winW - 230});
	//$('.content').css({minHeight: winH - 109});
	if(winW > 1201){
		$('#top .nav-bar li').each(function(){
			$(this).css('width', 80).find('a').css('width', 80);
		});
	}else if(winW > 1101 && winW < 1200){
		$('#top .nav-bar li').each(function(){
			$(this).css('width', 70).find('a').css('width', 70);
		});
	}else if(winW > 1025 && winW < 1100){
		$('#top .nav-bar li').each(function(){
			$(this).css('width', 65).find('a').css('width', 65);
		});
	}else{
		$('#top .nav-bar li').each(function(){
			$(this).css('width', 60).find('a').css('width', 60);
		});
	}
}



