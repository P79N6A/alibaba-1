/**
 * Created by minh on 2016/1/1.
 */
//2016 3 3
 $(function(){
	  //高度
	  var h=$(window).height();
      $(".fixSbg").height(h);
	  $(window).resize(function(){
		  var h=$(window).height();
          $(".fixSbg").height(h);
		  })
	 })

/*点赞*/
$(function() {
    $("body").on("click", ".M-in-zan", function () {
        if ($(this).hasClass("M-love")) {
            $(this).removeClass("M-love");
        } else {
            $(this).addClass("M-love");
        }
    })
});
/** 发表评论**/
$(function(){
    $("body").on("click",".M-command",function() {
        var command_block = "M-command_box_" + $(this).attr("tip");
        var obj = $("." + command_block);
        if (obj.is(":visible")) {
            obj.hide();
        } else {
            obj.show();
        }
        if ($(".M-grid").length > 0) {
            $('#M-container').BlocksIt();
        }
    });
    $("body").on("click",".M-btn-publish",function(){
        $(this).parent(".M-form-box").hide();
        if($(".M-grid").length>0){
            $('#M-container').BlocksIt();
        }
    })
});
//瀑布流
$(function(){
    $(window).scroll(function() {
        var container = $('#M-container');
        if(container.length > 0) {
            var length = $(".M-grid").length;
            if (scroll_bottom && length < 20) {
                for (var i = 0; i < 3; i++) {
                    var new_div = $('<div class="M-grid" tip="#pic3">\
                    <div class="M-imgholder">\
                    <a href="#" class="M-imgs"><img src="image/img1.jpg"/></a>\
                    <div class="M-in-button">\
                    <a class="M-command" tip="'+ i +'">添加评论</a>\
                    <span class="M-in-zan"></span>\
                    </div>\
                    <div class="info">\
                    <p class="M-text">徐汇区历史底蕴深，处优秀历史建筑，那些重要地标、景点、经典建筑、城市景观、道路河道待你</p>\
                    <div class="M-author">\
                    <img src="image/portrait-img.jpg" class="radius5" />\
                    <h1>张大春</h1>\
                    <span>2016-01-12</span>\
                    </div>\
                    <div class="M-command-text">\
                    <div class="M-comment">\
                    <form class="M-form-box M-command_box_'+ i +'" action="">\
                    <div class="clearfix">\
                    <div class="portrait"><img src="image/portrait-img.jpg" width="60" height="60" alt=""/></div>\
                    <textarea class="content" placeholder="添加评论"></textarea>\
                    </div>\
                    <a class="btn-publish">发布评论</a>\
                    </form>\
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
        var length=$("#M-container").find(".M-grid").length;
        var offtop=$("#M-container").find(".M-grid").eq(length-1).offset().top;
        var sc_all=con_height-height;
        var scroll_top=$(document).scrollTop();
        return (scroll_top+parseInt(height)>offtop) ? true : false;
    }
});
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
		var $list = $("#open_two .list");
		var $choose = $("#open_two .arrow_choose .all_choose");
		var totalLen = $list.find("li").length;
		if ($(this).hasClass("spans")) {
			$(this).removeClass("spans");
		} else {
			$(this).addClass("spans");
		}
		if ($list.find("li.spans").length == totalLen) {
			$choose.attr({"attr-choose": true});
		} else {
			$choose.attr({"attr-choose": false});
		}
	})
});
/**全选**/
$(function() {
	$("body").on("click", "#M_open .arrow_choose .all_choose", function () {
		var $chooseFlog = $(this).attr("attr-choose");
		if ($chooseFlog == "true") {
			$("#M_open .list li").removeClass("spans");
			$(this).attr({"attr-choose": false});
			$(this).html("全选");
		} else {
			$("#open_two .list li").addClass("spans");
			$(this).attr({"attr-choose": true});
			$(this).html("取消全选");
		}
	});
});
	/**活动详情展开收起**/
	function activityXL(){
		var h=$(".match_con").height();
		if(h<600){
			$(".M_match_chat .last_page").hide();
			}
		if(h>600){
			$(".match_con").css({"height":"600px","overflow":"hidden"});
			$(".match_con").addClass("on"); 
			}
		$(".M_match_chat .last_page").click(function(){
			
			
			if($(".match_con").hasClass("on")){
				$(".match_con").removeClass("on");
				$(".match_con").css({"height":"auto","overflow":"auto"});
				}	 
			 else{
				 $(".match_con").addClass("on");
				 $(".match_con").css({"height":"600px","overflow":"hidden"}); 
				 }
			})
				/*展开，收起*/
           $('.M_match_chat').on('click', '.last_page', function(){
             if($(this).hasClass('fold')){
             $(this).removeClass('fold');
             }
			 else
			 {
            $(this).addClass('fold');
             }
            });	
		}

/**活动详情点赞喜欢2016.1.19**/
$(function(){
	 $(".M_vote_con .list li").on("click","a",function(){
		   if($(this).hasClass("likeme")){
			 $(this).removeClass("likeme");
			 }
			 else{
			 $(this).addClass("likeme");
			 }
		})
	})	
/**订单输入框**/
$(function(){
	 var $text1=$(".M_myorder .search_input input");
	  $text1.focus(function(){		  
		  if($(this).val()=="搜索订单")
		  {
			 $(this).val("");
		  }
		}).blur(function(){
		  if($(this).val()=="")
		  {
			 $(this).val("搜索订单");
		  }
	       }); 		
        })
$(function(){
	 var $text1=$(".M_discuss_bottom input");
	  $text1.focus(function(){		  
		  if($(this).val()=="发表评论")
		  {
			 $(this).val("");
		  }
		}).blur(function(){
		  if($(this).val()=="")
		  {
			 $(this).val("发表评论");
		  }
	       }); 		
        })
$(function(){
	 var $text1=$("#search_head .input_search input");
	  $text1.focus(function(){		  
		  if($(this).val()=="搜索活动")
		  {
			 $(this).val("");
		  }
		}).blur(function(){
		  if($(this).val()=="")
		  {
			 $(this).val("搜索活动");
		  }
	       }); 		
        })
/**活动评论显示隐藏**/
$(function(){
	$(".M_user_love .tit .ld").click(function(){
		 $(".M_user_love .tit .love_discuss").toggle(100);
    });
})
//2016 2 17 MOBILE_START
$(function(){
	  //头部筛选
	  $(".filter").click(function(){
		  if ($(".fixbg").is(":visible")) {
			  $("html").css("overflow", "auto");
			  $(".head_select").css("visibility","hidden");
			  $(".fixbg").hide();
		  } else {
			  $("html").css("overflow", "hidden");
			  $(".head_select").css("visibility","visible");
			  $(".fixbg").show();
		  } 
		  })
		  $(".filter_sure").click(function(){
			  $(".filter").show();
			  $(".filter_sure,.fixbg").hide();
			  $("html").css("overflow", "auto");
			  $(".head_select").css("visibility","hidden");
		  });
	  $(".head_select").on("click","p",function(){
			var input_option=$("#filter_option");
			var txt=$(this).text();
			if(txt=="全部"){
				 if($(this).hasClass("cur")){
					 $(this).removeClass("cur");
				 }else{
					  $(this).addClass("cur").siblings("p").removeClass("cur"); 
						}
			}else{
				if($(this).hasClass("cur")){
					 $(this).removeClass("cur");
				}else{
					  $(this).addClass("cur");	
						}
				 $(this).parent().find("p").filter(":contains('全部')").removeClass("cur");
				}
			var arrs=[];
			var len=$(".head_select p.cur").length;
			if(len>0){
				$(".head_select p.cur").each(function(index, element) {
						var dataOption=$(this).attr("data-option");
						arrs.push(dataOption);
                 });
			     input_option.val(arrs.toString());
				 $(".filter_sure").show();
				 $(".filter").hide();	
		     }else{
				 input_option.val('');
				 $(".filter_sure").hide();
				 $(".filter").show();	
               }
		  })
		 //日期事件筛选
		 $(".dates").on("click","span",function(){
			   $(this).addClass("cur").siblings().removeClass("cur");
			   var y=$(this).attr("year");//年
			   var m=$(this).attr("month");//月
			   if(m<10){
				   m="0"+m;
			   }
			   var d=$(this).attr("day");//日
			   if(d<10){
				   d="0"+d;
			   }
			   $("#time_option").val(y+"-"+m+"-"+d);//获取选择的时间
			   $("#today").html(y+"年"+m+"月"+d+"日");
			   
			   $('#activityList').html('');
			   loadData(0,20);
			 })
	})
	
	//2016 2 19 个人设置 弹出层
 function createDialog(obj,fn) {
	 var h=$(window).height();
	 var txtE = false;
	 var nowTxt = obj.find(".rig").text();
	 var ids = obj.find(".rig").attr("id");
	 var tips = obj.find(".rig").attr("tip");
	 var fixbg = $("<div class='fixbg' style='display:block'></div>");
	 var dialog_set = $("<div class='dialog_set radius5'></div>");
	 var dialog_set_inner = $("<div class='dialog_inner'></div>");
	 var inputs = "";
	 fixbg.height(h);
	 if (tips == "手机号") {
		 inputs = $("<input class='radius5' type='text' maxlength='11' onkeyup=\"this.value=this.value.replace(/\D/g,'')\"/>");
	 } else {
		 inputs = $("<input class='radius5' type='text'\/>");
	 }
	 if (tips) {
		 tips = $("<span class='message'>" + tips + "</span>");
		 txtE = true;
	 }
	 inputs.attr("name", ids);
	 inputs.val(nowTxt);
	 var save_btn = $("<button type='button' class='save radius5'>保存</button>");
	 if (fn) {
		 save_btn.on("click", function () {
			 fn();
		 })
	 }
	 dialog_set_inner.appendTo(dialog_set);
	 if (txtE) {
		 tips.appendTo(dialog_set_inner);
	 }
	 inputs.appendTo(dialog_set_inner);
	 save_btn.appendTo(dialog_set_inner);
	 dialog_set.appendTo($("body"));
	 fixbg.appendTo($("body"));
	 return false;
 }
$(function(){
	$("body").on("click",".fixbg",function(){
            $(".dialog_set").remove();
		    $(".fixbg").remove();
	})
})

//性别选择
$(function(){
	//性别选择
   $(".set_sex").click(function(){
	    var vals=$(this).find(".rig").text();
	    if($(".sex_blocks").is(":visible")){
			$(".sex_blocks").hide();
			$(".fixSbg").hide();
		}else{
			$(".sex_blocks").find("label").each(function(index, element) {
                if($(this).find("span").text()==vals){
					  $(this).addClass("cur").siblings().removeClass("cur");
					}
            });
			$(".sex_blocks").show();
			$(".fixSbg").show();	
		}
		return false;
	})
	
	$(document).click(function(){
		 $(".sex_blocks").hide();
		 $(".fixSbg").hide();
	})
	
})
	
	/**区县选择**/
	$(function(){
		/**time**/
		 $("#time_list ul#ul3").on('click','a',function(){
			  $(this).parent().addClass("hoverit").siblings().removeClass("hoverit");
		 })
	 })
	 
	/**导航页标签全选**/
	$(function() {
	    $("body").on("click", "#open_two .arrow_choose .all_choose", function () {
	    	var $chooseFlog = $(this).attr("attr-choose");
	        if ($chooseFlog == "true") {
	            $("#open_two .list li").removeClass("spans");
				$(this).attr({"attr-choose": false});
	        } else {
	            $("#open_two .list li").addClass("spans");
				$(this).attr({"attr-choose": true});
	        }
	    })
	});

	/**判断图片按钮是否显示**/
	function imgButton(){
		var sum=$(".fack_block .upimg ul li").length;
		if(sum>=3){
			$(".fack_block .upimg .upload_btn").hide();
		}else{
			$(".fack_block .upimg .upload_btn").show();
		}
	}
	
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
	
	function dialogConfirm(title, content, fn){
		var winW = Math.min(parseInt($(window).width()*0.82), 575);
		var d = dialog({
			width:winW,
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
	
	//添加图片尺寸后缀
	function getIndexImgUrl(imgUrl,size){
		var  pos =  imgUrl.lastIndexOf(".");
		var  imgUrlIndex = imgUrl.substr(0,pos)+size+imgUrl.substr(pos);
		return imgUrlIndex;
	}
	
	/**3.21**/
	$(function(){
		$("#groups .g_list").on("click","a",function(){
			$(this).addClass("currblue").siblings().removeClass("currblue");
			})
	    $("#sort").on("click","a",function(){
			$(this).addClass("cur").siblings().removeClass("cur");
			})
	      $("#date_list").find("a").click(function(){
			  if($(this).hasClass("curr")){
				   $(this).removeClass("curr");
				   $("#Brand_data_val").val("");
				 }else{
					$(this).addClass("curr").siblings().removeClass("curr"); 
					
					 }
		   })
		  $("#atatus_list").find("a").click(function(){
			      if($(this).hasClass("curr")){
				   $(this).removeClass("curr");
				   $("#Brand_status_val").val("");
				 }else{
					$(this).addClass("curr").siblings().removeClass("curr"); 
					
					 }
				})
		   $("#week_list").find("a").click(function(){
			       if($(this).hasClass("curr")){
				   $(this).removeClass("curr");
				   $("#Brand_week_val").val("");
				 }else{
					$(this).addClass("curr").siblings().removeClass("curr"); 
					
					 }
				})
	 })
