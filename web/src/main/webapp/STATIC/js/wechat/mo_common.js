// JavaScript Document
/**nav**/
$(function(){
	 $("#mo_nav a").click(function(){
		 if($(this).hasClass("hovernav")){
			 $(this).removeClass("hovernav");
			 }
			 else{
			 $(this).addClass("hovernav");
		    }
		})
	})
/**love**/
$(function() {
	$("body").on("click", ".in-zan", function () {
		if ($(this).hasClass("in-zaned")) {
			$(this).removeClass("in-zaned");
		} else {
			$(this).addClass("in-zaned");
		}
	})
});
/**剪纸**/
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
	$("#paper_word").on("click",".command",function() {
		var command_block = "command_box_0_" + $(this).attr("tip");
		var obj = $("." + command_block);
		if (obj.is(":visible")) {
		  obj.hide();
		} else {
			obj.show();
		}
		if ($(".grid").length > 0) {
			$('#paper_word').BlocksIt();
		}
	});
$("#paper_word").on("click",".btn-publish",function(){
	  $(this).parent().hide();
	  if($(".grid").length>0){
			$('#paper_word').BlocksIt();
			}
	 })	
});
//瀑布流
$(function(){
	$(window).scroll(function() {
		var container = $('#paper_word');
		if(container.length > 0) {
			var length = $(".grid").length;
			if (scroll_bottom && length < 20) {
				for (var i = 0; i < 3; i++) {
					var new_div = $('<div class="grid">\
					<div class="imgholder">\
					   <a href="#" class="imgs"><img src="image/index_12.png" /></a>\
						<div class="info">\
							<div class="info-top">\
								<p>徐汇区历史底蕴深厚，文化资源丰富，是中西文化的交汇地、近代海派文化的发源地，坐落着百余处优秀历史建筑，那些重要地标、景点、经典建筑、城市景观、道路河道和风光等待你</p>\
								<div class="on-button clearfix">\
								  <a href="javascript：void(0)" class="del fl">删除</a>\
								  <a href="#" class="command fl" tip="0">添加评论</a>\
								  <span class="on-zan fr"></span>\
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
	   var length=$("#paper_word").find(".grid").length;
	   var offtop=$("#paper_word").find(".grid").eq(length-1).offset().top;
	   var sc_all=con_height-height;
	   var scroll_top=$(document).scrollTop();
	   return (scroll_top+parseInt(height)>offtop) ? true : false;
	}
});
