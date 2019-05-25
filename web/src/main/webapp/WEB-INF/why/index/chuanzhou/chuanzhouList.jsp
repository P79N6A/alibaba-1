<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>人文安康</title>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script  src="${path}/STATIC/js/dialog-min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/frontpage.css">
    <script type="text/javascript" src="${path}/STATIC/js/page.min.js"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <!--移动端版本兼容 -->
    <script type="text/javascript">
	    var phoneWidth = parseInt(window.screen.width);
	    var phoneScale = phoneWidth / 1200;
	    var ua = navigator.userAgent;            //浏览器类型
	    if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
	        var version = parseFloat(RegExp.$1); //安卓系统的版本号
	        if (version > 2.3) {
	            document.write('<meta name="viewport" content="width=1200, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
	        } else {
	            document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
	        }
	    } else {
	        document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
	    }

	    $(function(){
	        var tagCode = '${parentTagCode}' ;
	        if(tagCode != '') {
                $("#"+tagCode).addClass('cur').siblings().removeClass('cur');
                if(tagCode=='YSJS'){
                    $("#pageName").html("所在位置：艺术鉴赏");
				}
                if(tagCode=='feiyi'){
                    $("#pageName").html("所在位置：文化非遗");
                }
            }else {
                $("#whfy").addClass('cur').siblings().removeClass('cur');
            }
			//设置人文安康标题栏选中
            $("#rwsq").addClass('cur').siblings().removeClass('cur');
			//分页
			kkpager.generPageHtml({
			    pno :$("#pages").val() ,
			    //总页码
			    total :$("#countpage").val(),
			    //总数据条数
			    totalRecords :$("#total").val(),
			    mode : 'click',
			    click: function (n) {
			        this.selectPage(n);
			        $("#pages").val(n);
			        formSub('#form');
			        return false;
			    }
			});

	    })

	    function formSub(formName){
			$(formName).submit();
		}
    </script>
    <!--移动端版本兼容 end -->
</head>
<body>
<div class="header">
   <!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
<div class="main clearfix">
	<!-- 导航 -->
	<ul class="tabs">
		<c:forEach items="${parentTagList }" var="parentTag">
             <c:if test="${parentTag.tagName!='最新资讯' && parentTag.tagName!='今日安康'}">
				 <li data-code="${parentTag.tagCode }"<c:if test="${parentTag.tagCode==parentTagInfo.tagCode }">class="active"</c:if>><a href="##">${parentTag.tagName }</a></li>
		     </c:if>
		</c:forEach>
		<li id="WSSF"><a href="javascript:void(0)">网上书房</a></li>
	</ul>
	<!-- 列表 -->
	<div class="content">
		<!-- 今日佛山 -->
		<div class="cultures">
			<ul id="tag" class="nav clearfix">
				<c:forEach items="${childTagList }" var="childTag">
					<li data-code="${childTag.tagCode }"<c:if test="${childTag.tagCode==infoTagCode }">class="cur"</c:if>>${childTag.tagName }</li>
				</c:forEach>
			</ul>
			<ul id="detail" class="list clearfix">
				<c:forEach items="${infoList }" var="info">
					<li>
			            <a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}" class="img"><img src="${info.beipiaoinfoHomepage }" width="280" height="185"></a>
			            <div class="conp">
			                <h5><a href="${path}/beipiaoInfo/bpInfoDetail.do?infoId=${info.beipiaoinfoId}">${info.beipiaoinfoTitle }</a></h5>
			                <p class="p2">${info.beipiaoinfoContent }</p>
			            </div>
			        </li>
				</c:forEach>
		    </ul>
		</div>
		<script type="text/javascript">
			$(".tabs").on("click","li",function(){
				$(this).addClass("active").siblings().removeClass("active");
				if($(this).attr("id")=='WSSF'){
                    $.ajax({
                        type: "post",
                        url: "${path}/zxInformation/listIndex.do?informationModuleId=1c75e1bef46547178b1191b68798e8f6",
                        dataType:"text",
                        success: function(data){
                            $("#tag").empty();
                            var liStr="<li class='cur'>网上书房</li>";
                            $("#tag").append(liStr);
                            $("#detail").empty();
                            $("#detail").append(data);
                        },
                        error:function (data) {
                            alert("error");
                        }
                    });
				}else{
                    window.location.href = "${path}/beipiaoInfo/chuanzhouList.do?parentTagCode="+$(this).attr("data-code");
				}

			})
			$(".nav").on("click","li",function(){
				$(this).addClass("cur").siblings().removeClass("cur");
				window.location.href = "${path}/beipiaoInfo/chuanzhouList.do?infoTagCode="+$(this).attr("data-code");
			})

		</script>
	</div>
</div>
<form action="chuanzhouList.do" id="form" >
	<div id="kkpager" width:750px;margin:10 auto;></div>
    <input type="hidden" id="pages" name="page" value="${page.page}">
    <input type="hidden" name="infoTagCode" value="${infoTagCode }">
    <input type="hidden" id="countpage" value="${page.countPage}">
    <input type="hidden" id="total" value="${page.total}">

</div>
</form>
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>
<script type="text/javascript">
	$(function () {
		jQuery(".bpBannerSlide").slide({mainCell:".bd ul",titCell:'.hd span',effect:"left",autoPlay:true,interTime:3000,delayTime:500});
		var owl = $('.changgOrder').owlCarousel({
		  center: true,
		  loop:true,
		  margin:0,
		  nav:true,
		  autoWidth:true,
		  autoplay:true,
		  autoplayTimeout:3000,
		  autoplayHoverPause:true,
		  items:3,
		  dots:false
		});
	});
</script>