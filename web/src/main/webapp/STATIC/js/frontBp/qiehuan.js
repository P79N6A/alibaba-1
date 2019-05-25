// JavaScript Document
;(function($){
		
		$.fn.extend({
			"qiehuan":function(options){
				var defaults = {
					way:'slide',//slide:滑动，fade:渐隐渐现
					num:6,//默认小图显示个数
					btns:true,//左右按钮是否需要
					auto:3500,//自动切换时间
					animation:1000//切换一个需要的时间	
				}
				var canshu = $.extend(defaults,options);
				return this.each(function(){
					var lenDa = $(this).find('.datu ul li').length,
						lenDd = $(this).find('.xtu dl dd').length,
						widthD = $(this).find('.datu  ul li').outerWidth(true),
						widthX = $(this).find('.xtu dl dd').outerWidth(true),
						dl =$(this).find('.xtu dl'),
						dd = $(this).find('.xtu dl dd'),
						daul = $(this).find('.datu ul'),
						dali = $(this).find('.datu ul li'),
						way = options.way,
						auto = options.auto,
						animation = options.animation,
						btns = options.btns,
						num = options.num,
						num2 = Math.ceil(options.num/2),
						prev = $(this).find('.prev'),
						next = $(this).find('.next'),
						dt = options.dt;
					dl.css('width',lenDd*widthX);
					var margin = widthX-$(this).find('.xtu dl dd').outerWidth();
					$(this).find('.xtu').css('width',num*widthX-margin);
					var index = 0;
					
					if(btns==false){
						prev.hide();
						next.hide();	
					}
					
					if(way =="slide"){
						daul.css('left',-widthD);
						if(dt==true){
							dl.append("<dt></dt>");	
						}
						function change(){
							var nowCurrent = dl.find('dd.current').index();
							dd.eq(index).addClass('current').siblings().removeClass('current');
							if (index < num2) {
								dl.stop(true, true).animate({ 'left': '0' }, animation)
							} else if (index + num2 < lenDd) {
								dl.stop(true, true).animate({ 'left': -(index - num2 + 1) * widthX }, animation)
							}else if(lenDd<num){
								dl.stop(true, true).animate({ 'left': '0' }, animation);
							}
							else {
								dl.stop(true, true).animate({ 'left': -(lenDd - num) * widthX }, animation)
							}
							if(nowCurrent<index){
								dali.eq(index).css({'display':'block','left':widthD});
								daul.stop(true,false).animate({
									'left':-widthD
								},animation,function(){
									daul.css('left','0px');
									dali.eq(index).css('left','0px').siblings().css('display','none');
								});
							}else{
								dali.eq(index).css({'display':'block','left':-widthD});
								daul.stop(true,false).animate({
									'left':widthD
								},animation,function(){
									daul.css('left','0px');
									dali.eq(index).css('left','0px').siblings().css('display','none');
								});
							}
							var left = dl.find('dd.current').position().left;
							dl.find('dt').stop(true,true).animate({
								'left':left
							},animation);
						}
						dd.bind('click',function(){
							index = $(this).index();
							change();
						});
						dd.eq(0).trigger('click');
						
						next.click(function(){
							index++;
							if(index==lenDd){
								index=0;
							}	
							change();
						});
						prev.click(function(){
							index--;
							if(index==-1){
								index=lenDd-1;
							}	
							change();
						});
						var timer = setInterval(function(){
							index++;
							if(index==lenDd){
								index=0;
							}	
							change();
						},auto);
						
						$(this).hover(function(){
							clearInterval(timer);
						},function(){
							index = dl.find('dd.current').index();
							timer = setInterval(function(){
								index++;
								if(index==lenDd){
									index=0;
								}	
								change();
							},auto);
						});
						
					}
					if(way=="fade"){
						if(dt==true){
							dl.append("<dt></dt>");	
						}
						function change2(){
							dd.eq(index).addClass('current').siblings().removeClass('current');
							if (index < num2) {
								dl.stop(true, true).animate({ 'left': '0' }, animation)
							} else if (index + num2 < lenDd) {
								dl.stop(true, true).animate({ 'left': -(index - num2 + 1) * widthX }, animation)
							}else if(lenDd<num){
								dl.stop(true, true).animate({ 'left': '0' }, animation);
							}
							else {
								dl.stop(true, true).animate({ 'left': -(lenDd - num) * widthX }, animation)
							}
							dali.eq(index).stop(true,true).fadeIn(animation).siblings().stop(true,true).fadeOut(animation);	
							var left = dl.find('dd.current').position().left;
							dl.find('dt').stop(true,true).animate({
								'left':left
							},animation);
						}
						dd.bind('click',function(){
							index = $(this).index();
							change2();
						});
						dd.eq(0).trigger('click');
						next.click(function(){
							index++;
							if(index==lenDd){
								index=0;
							}	
							change2();
						});
						var timer = setInterval(function(){
							index++;
							if(index==lenDd){
								index=0;
							}	
							change2();
						},auto);
						prev.hover(function(){
							clearInterval(timer);
						},function(){
							index = dl.find('dd.current').index();
							timer = setInterval(function(){
								index++;
								if(index==lenDd){
									index=0;
								}	
								change2();
							},auto);
						});
						next.hover(function(){
							clearInterval(timer);
						},function(){
							index = dl.find('dd.current').index();
							timer = setInterval(function(){
								index++;
								if(index==lenDd){
									index=0;
								}	
								change2();
							},auto);
						});
						prev.click(function(){
							index--;
							if(index==-1){
								index=lenDd-1;
							}	
							change2();
						});
						
						
						
					}
					//alert(options.animation)
				});
			}		
		});
		
	})(jQuery)