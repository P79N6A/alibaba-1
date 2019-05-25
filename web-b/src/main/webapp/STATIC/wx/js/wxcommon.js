// JavaScript Document
/**btn bg添加**/
	$(function(){
		/**time**/
		 $(".time_list ul li").on('click','a',function(){
			  $(this).parent().addClass("hoverit").siblings().removeClass("hoverit");
			 })
	 })
//活动详情collect
	$(function(){
	    $(".love a").click(function(){
			  if($(this).hasClass("collect")){
				  $(this).removeClass("collect");
				  }
			  else{
				  $(this).addClass("collect");
				  }
			})
	  })
  /*首页头部搜索筛选*/
  	 $(function(){
	$(".city_btn").click(function(){
		$(".city_list").hide();
		  var city_list=$(this).siblings(".city_list");
		  if(city_list.is(":visible")){
			  city_list.hide();
			  }
		  else{
			  city_list.show();
		  }
		  	return false;
		})
	$(".city_list  a").click(function(){
		 var txt=$(this).html();
		 $(this).parent().siblings("#city_input").val(txt)
		 $(this).parent(".city_list").hide();
		})
	
	})
	/**venue_top**/
	 $(function(){
	$(".city_btn").click(function(){
		$(".city_list").hide();
		  var city_list=$(this).siblings(".city_list");
		  if(city_list.is(":visible")){
			  city_list.hide();
			  }
		  else{
			  city_list.show();
		  }
		  	return false;
		})
	$(".city_list  a").click(function(){
		 var txt=$(this).html();
		 $(this).parent().siblings(".city_inputs").val(txt)
		 $(this).parent(".city_list").hide();
		})
	
	})
	$(document).click(function(){
		$(".city_list").hide();
		})
	/**首页foot**/
	$(function(){
		//one
		 $(".index_foot .if_one").click(function(){
			  if($(this).hasClass("hoverone")){
				  $(this).removeClass("hoverone");
				  }
				  else{
			      $(this).addClass("hoverone");  
					  }
			 })
	   //two
			  $(".index_foot .if_two").click(function(){
			  if($(this).hasClass("hovertwo")){
				  $(this).removeClass("hovertwo");
				  }
				  else{
			      $(this).addClass("hovertwo");  
					  }
			 })
	  //three
	   $(".index_foot .if_three").click(function(){
			  if($(this).hasClass("hoverthree")){
				  $(this).removeClass("hoverthree");
				  }
				  else{
			      $(this).addClass("hoverthree");  
					  }
			 })
		
	 })
	//tab title底线
	$(function(){
		$(".switch_title a").click(function(){
			 if($(this).hasClass("line")){
				 $(this).removeClass("line");
				 }
				 else{
				 $(this).addClass("line");
					 }
			})
		})
	//场馆详情bg切换
			$(function(){
		$(".venue_datail_list .title a").click(function(){
			 if($(this).hasClass("hoverblue")){
				$(this).removeClass("hoverblue");
				 }
				 else{
				$(this).addClass(" hoverblue");
					 }
			})
		})
	/**搜索**/	
	/**详情页的最大高度**/
	$(function(){
		var h=$(".cgd_con").height();
		if(h<510){
			$(".venue_vivid .cg_detail .bottom_arrow").hide();
			}
		if(h>510){
			$(".cgd_con").css({"height":"510px","overflow":"hidden"});
			$(".cgd_con").addClass("on"); 
			}
		$(".venue_vivid .cg_detail .bottom_arrow").click(function(){
			if($(".cgd_con").hasClass("on")){
				$(".cgd_con").removeClass("on");
				$(".cgd_con").css({"height":h,"overflow":"hidden"});
				}	 
			 else{
				 $(".cgd_con").addClass("on");
				$(".cgd_con").css({"height":"510px","overflow":"hidden"}); 
				 }
			})
			/*展开，收起*/
           $('.venue_vivid .cg_detail').on('click', '.bottom_arrow', function(){
             if($(this).hasClass('pack')){
             $(this).removeClass('pack');
             }
			 else
			 {
            $(this).addClass('pack');
             }
            });	
		})
	/**场馆详情**/	
	$(function(){
		var h1=$(".adl_con").height();
		if(h1<500){
			$(".ad_listcon .last_page").hide();
			}
		if(h1>500){
			$(".adl_con").css({"height":"500px","overflow":"hidden"});
			$(".adl_con").addClass("on"); 
			}
		$(".ad_listcon .last_page").click(function(){
			
			
			if($(".adl_con").hasClass("on")){
				$(".adl_con").removeClass("on");
				$(".adl_con").css({"height":h1,"overflow":"hidden",});
				}	 
			 else{
				 $(".adl_con").addClass("on");
				 $(".adl_con").css({"height":"500px","overflow":"hidden"}); 
				 }
			})
				/*展开，收起*/
           $('.ad_listcon').on('click', '.last_page', function(){
             if($(this).hasClass('fold')){
             $(this).removeClass('fold');
             }
			 else
			 {
            $(this).addClass('fold');
             }
            });	
		})	
		
/**开启页面**/
$(function() {
    /**age**/
    $("#age input[type=radio]").on("click", function () {
        $(this).parent().find("input[type=radio]").prop("checked", false);
        $(this).parents("#age").find("label").removeClass("selected");
        $(this).prop("checked", true).parent().addClass("selected");
    });
    /**sex**/
    $("#sex input[type=radio]").on("click", function () {
        $(this).parent().find("input[type=radio]").prop("checked", false);
        $(this).parents("#sex").find("label").removeClass("selected");
        $(this).prop("checked", true).parent().addClass("selected");
    });

});
/**分类选择**/
$(function() {
    $("body").on("click", "#open_two .list li", function () {
        if ($(this).hasClass("spans")) {
            $(this).removeClass("spans");
        } else {
            $(this).addClass("spans");
        }
    })
});
/**收藏1.29**/
$(function(){
	 $("body").on("click",'.M-in-head .M-in-banner a',function(){
		   if($(this).hasClass("collectit")){
			   $(this).removeClass("collectit");
			   }
			else{
			   $(this).addClass("collectit");
				}
		 })
	})
//首页滑屏选中
$(function(){
	$(".swiper-slide").on('click','a',function(){
		if($(this).hasClass("select_it")){
			   $(this).removeClass("select_it");
			   }
			else{
			   $(this).addClass("select_it");
				}
		 })
	})
/**tab 切换**/	
$(function() {
   $(".swiper-slide").on('click','a',function(){
		  var tips=$(this).attr("tip");
		  $(this).addClass("select_it").siblings().removeClass("select_it");
		  $(tips).show().siblings().hide();
		
		})
})
/**朝代和类别**/
$(function(){
	$(".genre").click(function(e){
		$(this).siblings().removeClass("top_arrow");
		$(this).siblings().removeClass("choosebg");
		e.stopPropagation();
		$(this).addClass("choosebg").siblings().removeClass("choosebg");
		$(".genre_list").toggle();
		if($(".genre_list").is(":visible")){
			$(".genre").addClass("top_arrow");
		}
		else{
			$(".genre").removeClass("top_arrow");
		}
	})
	$(".genre_list a").click(function(e){
		var txt=$(this).html();
		var names=$(this).attr("data-id");
		$(this).parent().siblings(".genre").attr("value",names);
		/*$(this).parent().siblings(".genre").html(txt);*/
		/*$(this).parent().siblings(".genre").attr("data-id",names);*/
		$(this).addClass("hover_red").siblings().removeClass("hover_red");
		$(this).parent(".genre_list").hide();
	})
	$(".dynasty").click(function(e){
		$(this).siblings().removeClass("top_arrow");
		$(this).siblings().removeClass("choosebg");
		e.stopPropagation();
		$(this).addClass("choosebg").siblings().removeClass("choosebg");
		$(".dynasty_list").toggle();
		if($(".dynasty_list").is(":visible")){
			$(".dynasty").addClass("top_arrow");
		}
		else{
			$(".dynasty").removeClass("top_arrow");
		}
	})
	$(".dynasty_list a").click(function(e){
		var txt=$(this).html();
		var names=$(this).attr("data-id");
		$(this).parent().siblings(".dynasty").attr("value",names);
		/*$(this).parent().siblings(".genre").html(txt);*/
		/*$(this).parent().siblings(".genre").attr("data-id",names);*/
		$(this).addClass("hover_red").siblings().removeClass("hover_red");
		$(this).parent(".dynasty_list").hide();
	})
	$(document).click(function(e){
		e.stopPropagation();
		$(".dynasty_list").hide();
		$(".genre_list").hide();
	})
})