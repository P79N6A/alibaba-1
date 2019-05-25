

// 回到顶部
(function(a){a.fn.extend({backTop:function(c){var b=a(document).scrollTop();this.each(function(){var d=a(this);if(b<=a(window).height()){d.hide()}else{d.show()}a(window).bind("scroll",function(){b=a(document).scrollTop();if(b<=a(window).height()){d.hide()}else{d.show()}});d.bind("click",function(){a("html,body").animate({scrollTop:0},400)})});return this}})})(jQuery);


// 导航固定
function navFixed(ele, type, topH) {
    $(document).on(type, function() {
        if($(document).scrollTop() > topH) {
            ele.css({'position':'fixed'});
        } else {
            ele.css({'position':'static'});
        }
    });
}
navFixed($(".allNan"),'touchmove',465);
navFixed($(".allNan"),'scroll',465);

// 图片撑满居中
(function(a){var b={"boxWidth":0,"boxHeight":0};a.fn.extend({"picFullCentered":function(c){var d=a.extend({},b,c);this.each(function(){if(d.boxWidth&&d.boxHeight){var g=a(this);var f=d.boxWidth/d.boxHeight;var e=new Image();e.onload=function(){var i=e.width;var h=e.height;if(i/h>=f){var l=(d.boxHeight*i)/h;var k=(l-d.boxWidth)/2*(-1);g.css({"width":"auto","height":"100%","position":"absolute","top":"0","left":k})}else{var j=(d.boxWidth*h)/i;var m=(j-d.boxHeight)/2*(-1);g.css({"width":"100%","height":"auto","position":"absolute","top":m,"left":"0"})}};e.src=g.attr("src")}});return this}})})(jQuery);