<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>资源库</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
  	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	
<style type="text/css">
html, body {background-color: #f6f6f6;}
.zykWhite {width: 1200px;margin: 0 auto;padding: 1px 0;background-color: #fff;}
.zykTit {width: 100%;height: 62px;margin-top: 58px;}
.zykTit img {display: block;margin: 0 auto;}
.zykPicList-tsg a, .zykPicList-whg, .zykPicList-bwg {position: relative;overflow: hidden;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px; }
.zykPicList-tsg {width: 1016px;margin: 0 auto;margin-top: 80px;}
.zykPicList-tsg a {display: block;width: 248px; height: 150px;float: left; margin-bottom: 4px;margin-right: 6px;}
.zykPicList-tsg a img {display: block;width: 100%;height: 100%;}
.zykPicList-whg {width: 1010px;margin: 0 auto; margin-top: 60px;}
.zykPicList-whg a {display: block;width: 100%;height: 150px;}
.zykPicList-whg-2 {width: 1020px;margin: 0 auto; margin-top: 60px;}
.zykPicList-whg-2 a {width: 500px;height: 150px;float: left;margin-right: 10px;}
.zykPicList-tsg a img {display: block;width: 100%;height: 100%;}
.zykPicList-bwg {width: 870px;margin: 0 auto;margin-top: 50px;}
.zykPicList-bwg a {display: block;float: left;width: 290px;}
.zykPicList-bwg a img {display: block;width: 180px;height: 205px;margin: 0 auto;}
.zykPicList-bwg a span {display: block;font-size: 18px;color: #ffffff;text-align: center;margin-top: 22px;}
</style>
</head>
<body>
     <div class="header">
		<%@include file="../header.jsp" %>
	</div>
	<div class="zykWhite" style="height: 584px;background: url(${path}/STATIC/image/child/zykBg1.png) no-repeat center;margin-top: 20px;">
		<div class="zykTit"><img src="${path}/STATIC/image/child/zykTit1.png" /></div>
		<div class="zykPicList-tsg clearfix">
			<a href="http://www.fsunionlib.com.cn/reader/index.aspx" target="_blank"><img src="${path}/STATIC/image/child/zykPic1.jpg" /></a>
			<a href="http://www.fslib.com.cn/com/CardGuidLine/DisplayCardGuid.aspx" target="_blank"><img src="${path}/STATIC/image/child/zykPic2.jpg" /></a>
			<a href="http://202.105.30.26:8088/opac/servlet/opac.go?cmdACT=mylibrary.index&libcode=unionlib" target="_blank"><img src="${path}/STATIC/image/child/zykPic3.jpg" /></a>
			<a href="http://www.fslib.com.cn/CPS/InFoManage/MoreInfo.aspx" target="_blank"><img src="${path}/STATIC/image/child/zykPic4.jpg" /></a>
			<a href="http://202.105.30.18:88/questiondb/index.aspx" target="_blank"><img src="${path}/STATIC/image/child/zykPic5.jpg" /></a>
			<a href="http://202.105.30.8:9880/fslibbook/genealogy/default.html" target="_blank" style="width: 375px;"><img src="${path}/STATIC/image/child/zykPic6.jpg" /></a>
			<a href="http://202.105.30.18:8888/dataunion/datas.aspx" target="_blank" style="width: 375px;"><img src="${path}/STATIC/image/child/zykPic7.jpg" /></a>
		</div>
	</div>
	<div class="zykWhite" style="padding-bottom: 80px;">
		<div class="zykTit"><img src="${path}/STATIC/image/child/zykTit2.png" /></div>
		<div class="zykPicList-whg-2 clearfix">
	      <a href="http://www.fsswhg.com/zyk/index" target="_blank"><img src="${path}/STATIC/image/child/zykPic8.jpg" /></a>
		  <a href="http://www.fsswhg.com/zyk/qikan" target="_blank"><img src="${path}/STATIC/image/child/zykPic8-1.jpg" /></a>
	    </div>
	</div>
	<div class="zykWhite" style="padding-bottom: 100px;background-color: #ae5442;">
		<div class="zykTit"><img src="${path}/STATIC/image/child/zykTit3.png" /></div>
		<div class="zykPicList-bwg clearfix">
			<a href="http://www.foshanmuseum.com/swgq/web.html" target="_blank"><img src="${path}/STATIC/image/child/zykPic9.png" /><span>佛山市博物馆文物网络高清展示平台</span></a>
			<a href="http://www.fszumiao.com/zumiao/web/digital_zumiao/index.html?lmbh=32#search" target="_blank"><img src="${path}/STATIC/image/child/zykPic10.png" /><span>数字祖庙</span></a>
			<a href="http://www.expoon.com/19998/?lmbh=104#search" target="_blank"><img src="${path}/STATIC/image/child/zykPic11.png" /><span>佛山祖庙历史文化陈列全景展厅</span></a>
		</div>
	</div>
	<div class="zykWhite" style="padding-bottom: 80px;">
		<div class="zykTit"><img src="${path}/STATIC/image/child/zykTit4.png" /></div>
		<div class="zykPicList-whg clearfix">
			<a href="http://www.fsdam.org/" target="_blank"><img src="${path}/STATIC/image/child/zykPic12.png" /></a>
		</div>
	</div>
  <%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
<script type="text/javascript">
$(function(){
	 $("#resourceIndex").addClass('cur').siblings().removeClass('cur');
 });
 </script>
</html>