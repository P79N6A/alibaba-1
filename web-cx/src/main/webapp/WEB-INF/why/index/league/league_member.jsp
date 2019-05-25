<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>佛山文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
    <style type="text/css">
        html, body {height: 100%}
    </style>

</head>
<body>
	 <div class="unionHub">
		 <div class="ShuLine" style="top: 0; left: 1px;"></div>
		 <div class="ShuLine" style="top: 0; left: 3px;"></div>
		 <div class="ShuLine" style="top: 0; left: 6px;"></div>
		 <div class="ShuLine" style="top: 0; left: 9px;"></div>
		 <div class="ShuLine" style="top: 0; right: 1px;"></div>
		 <div class="ShuLine" style="top: 0; right: 3px;"></div>
		 <div class="ShuLine" style="top: 0; right: 6px;"></div>
		 <div class="ShuLine" style="top: 0; right: 9px;"></div>
		 <div class="ShuZhong"></div>

		 <a href="javascript:history.back(-1)" style="font-size: 14px;color: #666;padding: 10px; position: absolute;left: 40px;top: 20px;">&lt;返回</a>


		 <div class="clearfix" style="height: 100%;">
			 <div style="width: 50%;float: left;height: 100%;">
				 <div class="unionHubTit">${param.typeName}</div>
				 <div style="width: 420px;margin: 0 auto; height: 711px;overflow: auto;">
					 <ul class="unionHubZsList">
						 <c:forEach items="${list}" var="obj" varStatus="i">
							 <li id="${obj.id}" data-name="${obj.title}" class="clearfix ${i.index==0?'cur':''}">
								 <div class="pic"><img src="${obj.logo}"></div>
								 <div class="char"><p>${obj.title}</p></div>
							 </li>
						 </c:forEach>
					 </ul>
				 </div>
			 </div>
			 <div style="width: 50%;float: left;">
				 <div class="unionHubTit" id="leagueName"></div>
				 <div class="unionListWrap" style="width: 460px;">
					 <ul class="unionUlList clearfix" style="width: 480px;">
					 </ul>
					 <div id="kkpager" style="padding:0"></div>
				 </div>

			 </div>
		 </div>
	 </div>
</body>
<script type="text/javascript">
$(function(){
    $('.unionHubZsList .pic img').picFullCentered({'boxWidth' : 78,'boxHeight' : 78});
     showAdvertPicture();
	 $("#leagueIndex").addClass('cur').siblings().removeClass('cur');
	 loadLeagueMember('',1);

	 $('.unionHubZsList li').on('click',function () {
         $(this).addClass('cur').siblings().removeClass('cur');
		 var leagueId = $(this).attr("id");
		 $('#leagueName').html( $(this).attr("data-name"));
         loadLeagueMember(leagueId,1);
     })
 });

var tmpId = '';
function loadLeagueMember(leagueId,page) {
    if(!leagueId){
        $('#leagueName').html('${list[0].title}');
        leagueId = '${list[0].id}';
	}
	var html = '';
    $.post("${path}/member/leagueMember.do?version=" + new Date().getTime(),{leagueId:leagueId,page:page,rows:6}, function (data) {
        data = JSON.parse(data);
        var list = data.list;
        var member = data.member;
        if (list.length > 0) {
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
				var image = obj.images.split(',')[0];
				html+='<li class="qyItem" style="height: 236px;" onclick="toMemberIndex(\''+obj.id+'\')">\n' +
                    ' <div class="pic">\n' +
                    '<img src="'+image+'">\n' +
                    '</div>\n' +
                    '<div class="char">\n' +
                    '<p class="name">'+obj.memberName+'</p>\n' +
                    '<p class="info">'+obj.introduction+'</p>\n' +
                    '</div>\n' +
                    '</li>';
            }
        }
        $('.unionListWrap .unionUlList').html(html);
        //分页
        kkpager.generPageHtml({
            pagerid:'kkpager',
            pno : member.page,
            total : member.countPage,
            totalRecords :  member.total,
            mode : 'click',//默认值是link，可选link或者click
            isShowFirstPageBtn	: true, //是否显示首页按钮
            isShowLastPageBtn	: true, //是否显示尾页按钮
            isShowPrePageBtn	: true, //是否显示上一页按钮
            isShowNextPageBtn	: true, //是否显示下一页按钮
            isShowTotalPage 	: false, //是否显示总页数
            isShowCurrPage		: false,//是否显示当前页
            isShowTotalRecords 	: false, //是否显示总记录数
            isGoPage 			: false,	//是否显示页码跳转输入框
            click : function(n){
                //this.selectPage(n);
                loadLeagueMember(leagueId,n);
                return false;
            }
        });
    });
}

function toMemberIndex(id){
    var leagueName = $("#leagueName").html();
    window.location.href='${path}/member/memberIndex.do?leagueName='+leagueName+'&id='+id;
}
// 显示轮播图
function showAdvertPicture() {
    $.post("${path}/beipiaoInfo/bpCarouselList.do?carouselType=2&version=" + new Date().getTime(), '', function (data) {
        if (data != undefined && data != null && data != "" && data.length > 0) {
            getAdvertHtml(data);
            /* start banner */
            jQuery(".unionScroll").slide({
                mainCell:".bd ul",
                autoPage:true,
                effect: "top",
                autoPlay: false,
                interTime: 3000,
                delayTime: 500,
                vis: 4,
                trigger: "click",
                pnLoop: false
            });
            $('.unionScroll .picList').on('click', 'li', function () {
                $(this).addClass('on').siblings().removeClass('on');
                $('.unionBigPic .img').attr('src', $(this).find('img').attr('src'));
                $('.unionBigPic a').attr("href", $(this).find('img').attr('data-uri'));
            });
            /* end banner */
        }
    });
}

// 拼接轮播图
function getAdvertHtml(data) {
    var imgUrl = "";
    var connectUrl = "";
    var li = "";
    var span = "";
	if(data.length>=0){
        for (var i in data) {
            imgUrl = data[i].carouselImage;
            connectUrl = data[i].carouselUrl.split(',')[0];
            if(i==0){
                $('.unionBigPic a').attr("href",connectUrl);
                $(".unionBigPic a").html('<img  data-uri="'+connectUrl+'" class="img" src="'+data[0].carouselImage+'">');
                li += "<li class='on'><div class=\"pic\"><img data-uri=\""+connectUrl+"\" src='" + imgUrl + "'/></div></li>";
			}else{
                li += "<li><div class=\"pic\"><img data-uri=\""+connectUrl+"\"  src='" + imgUrl + "'/></div></li>";
			}
        }
	}
    $(".picList").html(li);
}
 </script>
</html>