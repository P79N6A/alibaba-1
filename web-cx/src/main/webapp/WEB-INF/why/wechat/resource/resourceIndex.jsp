<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>资源库</title>
  <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
    
	<style>
		html, body {background-color: #f3f3f3;}
		.zykWhite {background-color: #fff;margin-bottom: 20px;padding: 32px 0;}
		.zykTit {font-size: 28px;color: #c04027;text-align: center;margin-bottom: 25px;}
		.zykPicListWc {width: 700px;overflow: hidden;margin: 0 auto;}
		.zykPicList {width: 712px;}
		.zykPicList a {display: block;float: left;width: 700px;height: 200px;position: relative;overflow: hidden;-webkit-border-radius: 4px;-moz-border-radius: 4px;border-radius: 4px; margin-bottom: 12px;margin-right: 12px;}
		.zykPicList a img {display: block;width: 100%;height: 100%;}
		.zykPicList a.ban {width: 344px;}
	</style>
</head>
<body>
<div style="width: 750px;margin: 0 auto;">
	<div class="zykWhite" style="margin-top: 20px;">
		<div class="zykTit">网上图书馆</div>
		<div class="zykPicListWc">
			<div class="zykPicList clearfix">
				<a class="ban" href="http://www.fsunionlib.com.cn/reader/index.aspx" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic1.jpg" /></a>
				<a class="ban" href="http://www.fslib.com.cn/com/CardGuidLine/DisplayCardGuid.aspx" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic2.jpg" /></a>
				<a class="ban" href="http://202.105.30.26:8088/opac/servlet/opac.go?cmdACT=mylibrary.index&libcode=unionlib" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic3.jpg" /></a>
				<a class="ban" href="http://www.fslib.com.cn/CPS/InFoManage/MoreInfo.aspx" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic4.jpg" /></a>
				<a class="ban" href="http://202.105.30.18:88/questiondb/index.aspx" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic5.jpg" /></a>
				<a class="ban" href="http://202.105.30.8:9880/fslibbook/genealogy/default.html" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic6.jpg" /></a>
				<a href="http://202.105.30.18:8888/dataunion/datas.aspx" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic7.jpg" /></a>
			</div>
		</div>
	</div>
	<div class="zykWhite">
		<div class="zykTit">数字文化馆</div>
		<div class="zykPicListWc">
			<div class="zykPicList clearfix">
				<a href="http://www.fsswhg.com/zyk/index" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic8.png" /></a>
			    <a href="http://www.fsswhg.com/zyk/qikan" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic8-1.png" /></a>
      </div>
    </div>
  </div>
			    
			</div>
		</div>
	</div>
	<div class="zykWhite">
		<div class="zykTit">数字博物馆</div>
		<div class="zykPicListWc">
			<div class="zykPicList clearfix">
				<a href="http://www.foshanmuseum.com/swgq/web.html" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic9.jpg" /></a>
				<a href="http://www.fszumiao.com/zumiao/web/digital_zumiao/index.html?lmbh=32#search" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic10.jpg" /></a>
				<a href="http://www.expoon.com/19998/?lmbh=104#search" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic11.jpg" /></a>
			</div>
		</div>
	</div>
	<div class="zykWhite">
		<div class="zykTit">数字美术馆</div>
		<div class="zykPicListWc">
			<div class="zykPicList clearfix">
				<a href="http://www.fsdam.org/" target="_blank"><img src="${path}/STATIC/wechat/image/zykPic12.jpg" /></a>
			</div>
		</div>
	</div>
</div>
</body>
</html>