// JavaScript Document
/**btn bg添加**/
	$(function(){
		/**time**/
		 $(".time_list ul#ul1 ").on('click','a',function(){
			  $(".time_list ul li a").removeClass();
			  $(this).addClass("hoverit");
			 })
	   /**状态**/
	    $(".vs_status ul#ul2").on('click','a',function(){
			  $(".vs_status ul li a").removeClass();
			  $(this).addClass("status");
			 })
	 /**位置**/
	   $(".position_list ul#ul3 ").on('click','a',function(){
			  $(".position_list ul li a").removeClass();
			  $(this).addClass("position");
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
		
	/**场馆详情页下拉收起**/
	function venueXL(){
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
				$(".cgd_con").css({"height":"auto","overflow":"auto"});
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
		}
	
	/**活动详情下拉收起**/	
	function activityXL(){
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
		}
	
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
		
	//判断是否是微信浏览器
	function is_weixin(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			return true;
	 	} else {
			return false;
		}
	}
	
	//弹出框
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