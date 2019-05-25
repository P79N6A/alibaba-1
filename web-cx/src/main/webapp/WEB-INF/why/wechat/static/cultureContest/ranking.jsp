<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>中华优秀传统文化知识大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20170511"/>
	<script src="${path}/STATIC/js/common.js"></script>
	    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/info.css?20160516"/>
<style type="text/css">
html,body {height: 100%;}
</style>
<script type="text/javascript">

$.ajaxSettings.async = false; 	//同步执行ajax
	
	var stageNumber= '${stageNumber}'

	var userGroupType= '${userGroupType}'
	
	$(function() {
		
			if(window.screen.width > 750){
				//PC
				
				$("img").each(function(){
					
					
					var src=$(this).attr("src");
					
					src=src.replace('/tradKnow/','/tradKnowPc/')
					
					$(this).attr("src",src);
				});
				
				/*pc端的js操作*/
			    /*查看更多操作，一行数据是100，这里是加载了两行*/
			    $("span.more").click(function(){
			        console.log($(this).siblings("ul.list").height());
			        $(this).siblings("ul.list").height(function(n,c){
			            return c+200;
			        });

			    });
			    /*我的排名动画操作*/
			    $(".footer").click(function(){
			        if ($(this).hasClass("hid")) {
			            $(this).removeClass("hid");
			            $(this).animate({ 
			                left:'0'
			            }, 1000 );
			        }else{
			            $(this).addClass("hid");
			            $(this).animate({ 
			                left:'-374px'
			            }, 1000 );
			        }
			    });
			}
	
		 $(".menu").on("click","li",function(){
			 
			 if(!$(this).hasClass("off")){
				   $(this).addClass("cur").siblings().removeClass("cur");
			        
			        stageNumber= $(this).attr("stageNumber");
			        
			        loadData();
			 }
		     
		  });
		 
		 $(".tabs").on("click","li",function(){
		        $(this).addClass("cur").siblings().removeClass("cur");
		    });

		     /*组别切换*/
		     $(".rankingList .tabs").on("click","li",function(){
		        var $index = $(this).attr("userGroupType")
		        $('ul.list'+$index).show().siblings(".list").hide();
		     });
		     
		  loadData();
		     
		  $(".list"+userGroupType).show();

	});
	
	function loadData(){
		
		$(".list").html('<div class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>')
		
		for (var i = 1; i < 4; i++)
 		 {
			$.post("${path}/cultureContest/queryTestRanking.do",{stageNumber:stageNumber,userGroupType:i}, function(data) {
				
				$(".list"+i).html('');
				
				var length=data.length
				
				if(length){
					
					$.each(data , function(index , a) {
						
						var number="";
						
						if(index>2){
							number+=(index+1);
						}
						
						var userHeadImgUrl=a.userHeadImgUrl;
						 
						$(".list"+i).append('<li><span>'+number+'</span><img src="'+getHeadImgUrl(userHeadImgUrl)+'" class="photos"><em class="name">'+a.userName+'</em><strong class="score">'+a.answerRightNumber+'分</strong></li>');
					 });
				}
				
			},'json');
		
 		 }
		
		 if (userId) {
			
			 $.post("${path}/cultureContest/queryTestRanking.do",{stageNumber:stageNumber,userId:userId}, function(data) {
					
				 var length=data.length
					
					if(length){
				 
					$("#footer").show();
					
					$("#useRand").html(data[0].rowno)
					
						var userHeadImgUrl=data[0].userHeadImgUrl;
					
					$("#userHead").attr("src",getHeadImgUrl(userHeadImgUrl))
					
					$("#userName").html(data[0].userName)
					
					$("#userScore").html(data[0].answerRightNumber)
				    
					}
					
				},'json');
		}
	}
	
	
	 function getHeadImgUrl(userHeadImgUrl){
			
			//头像
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
		        if(userHeadImgUrl.indexOf("http") == -1){
		        	userHeadImgUrl = getImgUrl(userHeadImgUrl);
		        }
		        if (userHeadImgUrl.indexOf("http")==-1) {
		        	userHeadImgHtml = '../STATIC/wx/image/sh_user_header_icon.png'
		        } else if (userHeadImgUrl.indexOf("/front/") != -1) {
		            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
		            userHeadImgHtml =  imgUrl ;
		        } else {
		        	userHeadImgHtml =  userHeadImgUrl ;
		        }
		    }else{
		    	userHeadImgHtml = "../STATIC/wx/image/sh_user_header_icon.png";
		    }
			
			return userHeadImgHtml;
		}
	
</script>

</head>

<body>
    <div class="tradKnowWap">
        <div class="head"></div>
         <%@include file="head.jsp"%>
        <div class="rank">
            <img src="${path}/STATIC/wxStatic/image/tradKnow/char4.png"/>
            <ul class="menu clearfix">
                <li stageNumber="1" <c:if test="${stageNumber ==1 }">class="cur"</c:if>></li>
                <li stageNumber="2" class="<c:if test="${stageNumber ==2 && stage2==true }">cur</c:if> <c:if test="${empty stage2 }">off</c:if>"></li>
                <li stageNumber="3" class="<c:if test="${stageNumber ==3 && stage3==true }">cur</c:if> <c:if test="${empty stage3 }">off</c:if>"></li>
                <li stageNumber="0" <c:if test="${stageNumber ==0 }">class="cur"</c:if>></li>
            </ul>

            <div class="rankingList">
                <ul class="tabs clearfix">
                	<li userGroupType="1" <c:if test="${userGroupType ==1 }">class="cur"</c:if>>少年组</li>
                    <li userGroupType="2" <c:if test="${userGroupType ==2 }">class="cur"</c:if>>中青年组</li>
                    <li userGroupType="3" <c:if test="${userGroupType ==3 }">class="cur"</c:if>>老年组</li>
                </ul>
                <ul class="list list2" style="display: none;">
                </ul>
                <ul class="list list3" style="display: none;">
                </ul>
                <ul class="list list1" style="display: none;">
                </ul>
                <a href="${path }/wechatStatic/cultureContestIndex.do">  <img src="${path}/STATIC/wxStatic/image/tradKnow/icon19.png" class="again"></a>
                <a href="${path }/wechatStatic/cultureContestQuestions.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon9.png" class="look"></a>
                <a href="${path }/wechatStatic/cultureContestRule.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon20.png" class="lookrole"></a>
            </div>
            
        </div>

    </div>
    
    <div id="footer" class="footer clearfix" style="display: none;">
        <div class="footRand" ><span id="useRand"></span><br/>我的排名</div>
        <div class="footName"><img id="userHead" src="" class="ph"><span class="name" id="userName"></span></div>
        <div class="footScore" id="userScore"></div>
    </div>
</body>


</html>
