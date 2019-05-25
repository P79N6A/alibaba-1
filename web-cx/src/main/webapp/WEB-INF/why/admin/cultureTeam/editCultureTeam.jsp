<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

	<!--阿里上传-->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/aliImage/style.css" />
	<script type="text/javascript" src="${path}/STATIC/aliImage/uuid.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/crypto.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/hmac.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/sha1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/base64.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/plupload.full.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/aliImage/upload-img.js"></script>
	
    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	var worksNum = 0;
    	
		var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
          	//加载街镇
            loadTown();

          	selectModel();
            
          	aliUploadImg('cultureTeamFamilyWebupload', getCultureTeamFamily, 100, true, 'H5');
          	aliUploadImg('cultureTeamAddressUrlWebupload', getCultureTeamAddressUrl, 100, true, 'H5');
          	aliUploadImg('cultureTeamPrizeWebupload', getCultureTeamPrize, 100, true, 'H5');
          	aliUploadImg('cultureTeamMediaWebupload', getCultureTeamMedia, 100, true, 'H5');
          	
        });
        
      	//全家福回调
        function getCultureTeamFamily(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='cultureTeamFamily' value='"+filePath+"'/>");
		}
      	
      	//地址照片回调
        function getCultureTeamAddressUrl(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='cultureTeamAddressUrl' value='"+filePath+"'/>");
		}
      	
      	//所获奖项回调
        function getCultureTeamPrize(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' name='cultureTeamPrize' value='"+filePath+"'/>");
		}
      	
      	//媒体宣传回调
        function getCultureTeamMedia(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' id='cultureTeamMediaLabel' name='cultureTeamMedia' value='"+filePath+"'/>");
		}
      	
      	//作品原稿回调
        function getWorksManuscript(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' id='worksManuscriptLabel' name='worksManuscript' value='"+filePath+"'/>");
		}
      	
      	//作品舞台回调
        function getWorksStage(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#"+file.id).append("<input type='hidden' id='worksStageLabel' name='worksStage' value='"+filePath+"'/>");
		}
        
        //添加作品
        function addWorks(){
        	worksNum += 1;
        	$("#cultureTeamWorks").append("<table width='100%' class='form-table cultureTeamWorks'>" +
								        	"<tr><td class='cultureTeamWorksTitle'><img src='${path}/STATIC/image/remove.png' width='30' height='30' onclick='removeWorks($(this));'>作品"+worksNum+"：</td></tr>" +
									        "<tr>" +
								                "<td width='100' class='td-title'>作品名称：</td>" +
								                "<td class='td-input' id='worksNamesLabel'><input type='text' id='worksNames' name='worksNames' class='input-text w510' maxlength='30'/></td>" +
								            "</tr>" +
									        "<tr>" +
												"<td class='td-title'>作品原稿图片：</td>" +
												"<td>" +
													"<div class='whyUploadVedio worksManuscriptDiv' id='worksManuscript"+worksNum+"Webupload'>" +
														"<div class='clearfix'>" +
															"<div id='container2' style='float: left;overflow: hidden;margin: 10px 10px 10px 0;'>" +
																"<a id='selectfiles2' class='selectFiles btn'>选择文件（剧本、乐谱等）</a>" +
															"</div>" +
															"<div id='ossfile2' style='width: 250px;float: left;' class='clearfix'>你的浏览器不支持flash,Silverlight或者HTML5！</div>" +
														"</div>" +
													"</div>" +
												"</td>" +
											"</tr>" +
											"<tr>" +
												"<td class='td-title'>作品舞台照片：</td>" +
												"<td>" +
													"<div class='whyUploadVedio worksStageDiv' id='worksStage"+worksNum+"Webupload'>" +
														"<div class='clearfix'>" +
															"<div id='container2' style='float: left;overflow: hidden;margin: 10px 10px 10px 0;'>" +
																"<a id='selectfiles2' class='selectFiles btn'>选择文件（至少含背景、舞台观众三个角度）</a>" +
															"</div>" +
															"<div id='ossfile2' style='width: 250px;float: left;' class='clearfix'>你的浏览器不支持flash,Silverlight或者HTML5！</div>" +
														"</div>" +
													"</div>" +
												"</td>" +
											"</tr>" +
								        "</table>");
        	
        	aliUploadImg('worksManuscript'+worksNum+'Webupload', getWorksManuscript, 100, true, 'H5');
          	aliUploadImg('worksStage'+worksNum+'Webupload', getWorksStage, 100, true, 'H5');
        }
        
      	//删除作品
        function removeWorks($this){
        	if(worksNum > 0){
        		worksNum -= 1;
        		$this.parents("table").remove();
        	}
        }
    	
    	function loadTown(){
    		var townData = {townList:['唐镇文广服务中心','书院镇文化服务中心','塘桥社区文化活动中心','三林镇文广服务中心','潍坊社区文化活动中心','高行镇文化服务中心','南汇新城镇文化服务中心','万祥镇文化服务中心',
    		                          '周浦镇文化服务中心','宣桥镇文化服务中心','大团镇文化服务中心','金桥镇文广服务中心','祝桥镇文化服务中心','沪东新村街道文化服务中心','北蔡镇文化服务中心','东明社区文化活动中心','康桥镇文化服务中心','南码头路街道文化活动中心',
    		                          '上钢新村街道文化活动中心','高东镇文化服务中心','洋泾社区文化活动中心','航头镇文化服务中心','周家渡街道文化中心','浦兴社区文化活动中心','曹路镇文化服务中心','花木社区文化活动中心','泥城镇文化服务中心',
    		                          '川沙新镇文化服务中心','新场镇文化服务中心','陆家嘴金融城文化中心','高桥镇社区文化中心','合庆镇文广服务中心','张江镇文广服务中心','金杨社区文化活动中心','老港镇文化服务中心','惠南镇文化服务中心',
    		                          '浦东文化馆','浦南文化馆','浦东新区龚路中心小学','浦东新区文化艺术指导中心','浦东新区机关党工委','武警上海市浦东新区支队三大队','上海海事大学','共青团上海张江高科技园区工作委员会','上海浦东新区陆家嘴金融城沁一合唱团','昌硕科技(上海)有限公司','浦东新区老龄文化艺术团','金海文化艺术中心','上海小喜鹊合唱团','上海优美时刻琴行']};
            var ulHtml = '';
            $.each(townData.townList,function(i,dom){
            	ulHtml += '<li data-option="'+dom+'" style="width:100%;">'+dom+'</li>';
            })
            $('#cultureTeamTownUl').html(ulHtml);
    	}
    	
    	//删除图片
    	function removeImg($this){
    		$this.parent("div[name=aliFile]").remove();
    	}
    	
    	function saveCultureTeam(){
    		$("#saveBut").attr("onclick","");
    		var cultureTeamTown=$('#cultureTeamTown').val();
    		var cultureTeamName=$('#cultureTeamName').val();
    		var cultureTeamCount=$('#cultureTeamCount').val();
    		var cultureTeamType=$('#cultureTeamType').val();
    		var cultureTeamRule=$('#cultureTeamRule').val();
    		var cultureTeamAddress=$('#cultureTeamAddress').val();
    		var cultureTeamIntro=$('#cultureTeamIntro').val();
    		var cultureTeamContent=$('#cultureTeamContent').val();
    		
    		//作品原稿
    		var worksManuscripts = [];
    		$("#cultureTeamWorks table").each(function(){
    			var worksManuscript = [];
   				$(this).find(".worksManuscriptDiv div[name=aliFile]").each(function(){
       				worksManuscript.push($(this).find("input").val());
       			});
    			worksManuscripts.push(worksManuscript.join(";"));
    		});
    		$("#worksManuscripts").val(worksManuscripts.join(","));
    		
    		//作品舞台
    		var worksStages = [];
    		$("#cultureTeamWorks table").each(function(){
    			var worksStage = [];
   				$(this).find(".worksStageDiv div[name=aliFile]").each(function(){
       				worksStage.push($(this).find("input").val());
       			});
    			worksStages.push(worksStage.join(";"));
    		});
    		$("#worksStages").val(worksStages.join(","));
    		
    	  	//保存活动信息
    	    $.post("${path}/cultureTeam/saveOrUpdateCultureTeam.do", $("#cultureTeamForm").serialize(),function(data) {
   	            if(data == "200") {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="${path}/cultureTeam/cultureTeamIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","saveCultureTeam();");
   	            }
   	     	},"json");
    	}

    </script>
    
    <style type="text/css">
		li {
			margin-top: 20px;
			width: 100px;
			height: 100px;
			float: left;
			margin-right: 20px;
			position: relative;
		}
		li .ct-img-img {
			width: 155px;
			height: 100px;
		}
		li .ct-img-remove {
			cursor: pointer;
			position: absolute;
			right: 0px;
			top: 0px;
			width: 30px;
			height: 30px;
		}
		li:nth-last-child(2) {
			margin-right: 0;
		}
		.cultureTeamTitle{
			font-weight: bolder;
			font-size: 18px;
			line-height: 30px;
			background-color: #d9d9d9;
			padding-left: 10px;
		}
		.cultureTeamWorksTitle{
			font-weight: bold;
			font-size: 14px;
			line-height: 30px;
		}
		.cultureTeamWorksTitle>img{
			margin-right: 10px;
		}
		.aliFileImg{max-height: 80px;max-width: 80px;left: 0;right: 0;top: 0;bottom: 0;margin: auto;position:absolute;}
	</style>
</head>

<body>
	<form id="cultureTeamForm" method="post">
		<input type="hidden" name="cultureTeamId" value="${cultureTeam.cultureTeamId}"/>
		<input type="hidden" id="worksManuscripts" name="worksManuscripts"/>
		<input type="hidden" id="worksStages" name="worksStages"/>
	    <div class="site">
	        <em>您现在所在的位置：</em>浦东文化社团评选 &gt;团队编辑
	    </div>
	    <div class="site-title">编辑团队</div>
	    <div class="main-publish">
	    	<div class="cultureTeamTitle">团队信息：</div>
	        <table width="100%" class="form-table">
        		<tr>
		            <td class="td-title">所属街镇：</td>
		            <td class="td-input search" id="cultureTeamTownLabel">
		                <div class="select-box w135" style="margin-left: 0;width: 250px;">
		                    <input type="hidden" name="cultureTeamTown" id="cultureTeamTown" value="${cultureTeam.cultureTeamTown}" />
		                    <div id="cultureTeamTownDiv" class="select-text" data-value="" style="width: 210px;background-position: 230px 19px;text-align: center;">—— 请选择 ——</div>
		                    <ul class="select-option" id="cultureTeamTownUl" style="width: 250px;"></ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
	                <td width="100" class="td-title">团队名称：</td>
	                <td class="td-input" id="cultureTeamNameLabel"><input type="text" id="cultureTeamName" name="cultureTeamName" value="${cultureTeam.cultureTeamName}" class="input-text w510" maxlength="150"/></td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">团队人数：</td>
	                <td class="td-input" id="cultureTeamCountLabel"><input type="text" id="cultureTeamCount" name="cultureTeamCount" value="${cultureTeam.cultureTeamCount}" class="input-text w310" maxlength="5"/></td>
	            </tr>
	            <tr>
		            <td class="td-title">所属门类：</td>
		            <td class="td-input search" id="cultureTeamTypeLabel">
		                <div class="select-box w135" style="margin-left: 0;">
		                    <input type="hidden" name="cultureTeamType" id="cultureTeamType" value="${cultureTeam.cultureTeamType}"/>
		                    <div id="cultureTeamTypeDiv" class="select-text" data-value="">-请选择-</div>
		                    <ul class="select-option" id="cultureTeamTypeUl">
		                    	<li data-option="1">舞蹈</li>
		                    	<li data-option="2">音乐</li>
		                    	<li data-option="3">戏剧</li>
		                    	<li data-option="6">曲艺</li>
		                    	<li data-option="4">美书影</li>
		                    	<li data-option="5">综合</li>
		                    </ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
					<td class="td-title">全家福：</td>
					<td>
						<div class="whyUploadVedio" id="cultureTeamFamilyWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div style="width: 1000px;float: left;" class="clearfix">
									<c:if test="${not empty cultureTeam.cultureTeamFamily}">
										<c:set var="items" value="${fn:split(cultureTeam.cultureTeamFamily, ',')}"></c:set>
										<c:forEach items="${items}" var="dom" varStatus="i">
											<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
												<img class="aliFileImg" src="${dom}">
												<input type="hidden" name="cultureTeamFamily" value="${dom}">
												<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">作品信息：</div>
	        <div id="cultureTeamWorks">
	        	<c:forEach items="${worksList}" var="dom" varStatus="i">
			        <table width="100%" class="form-table cultureTeamWorks">
			        	<tr><td class="cultureTeamWorksTitle"><img src="${path}/STATIC/image/remove.png"  width="30" height="30" onclick="removeWorks($(this));">作品${i.index+1}：</td></tr>
				        <tr>
			                <td width="100" class="td-title">作品名称：</td>
			                <td class="td-input" id="worksNamesLabel"><input type="text" id="worksNames" name="worksNames" value="${dom.worksName}" class="input-text w510" maxlength="30"/></td>
			            </tr>
				        <tr>
							<td class="td-title">作品原稿图片：</td>
							<td>
								<div class="whyUploadVedio worksManuscriptDiv" id="worksManuscript${i.index+1}Webupload">
									<div class="clearfix">
										<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
											<a id="selectfiles2" class="selectFiles btn">选择文件（剧本、乐谱等）</a>
										</div>
										<div style="width: 1000px;float: left;" class="clearfix">
											<c:set var="items" value="${fn:split(dom.worksManuscript, ';')}"></c:set>
											<c:forEach items="${items}" var="worksManuscript" varStatus="i">
												<c:if test="${not empty worksManuscript}">
													<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
														<img class="aliFileImg" src="${worksManuscript}">
														<input type="hidden" name="worksManuscript" value="${worksManuscript}">
														<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
													</div>
												</c:if>
											</c:forEach>
											
											<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
										</div>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="td-title">作品舞台照片：</td>
							<td>
								<div class="whyUploadVedio worksStageDiv" id="worksStage${i.index+1}Webupload">
									<div class="clearfix">
										<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
											<a id="selectfiles2" class="selectFiles btn">选择文件（至少含背景、舞台观众三个角度）</a>
										</div>
										<div style="width: 1000px;float: left;" class="clearfix">
											<c:set var="items" value="${fn:split(dom.worksStage, ';')}"></c:set>
											<c:forEach items="${items}" var="worksStage" varStatus="i">
												<c:if test="${not empty worksStage}">
													<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
														<img class="aliFileImg" src="${worksStage}">
														<input type="hidden" name="worksStage" value="${worksStage}">
														<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
													</div>
												</c:if>
											</c:forEach>
											
											<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
										</div>
									</div>
								</div>
							</td>
						</tr>
			        </table>
			        
			        <script>
			        	worksNum += 1;
				        aliUploadImg('worksManuscript'+worksNum+'Webupload', getWorksManuscript, 100, true, 'H5');
			          	aliUploadImg('worksStage'+worksNum+'Webupload', getWorksStage, 100, true, 'H5');
			        </script>
				</c:forEach>
		    </div>
	        <div style="padding:20px 0px;">
	        	<img src="${path}/STATIC/image/add.png" width="30" height="30" onclick="addWorks();">
	        </div>
	        
	        <div class="cultureTeamTitle">活动场所：</div>
	        <table width="100%" class="form-table">
		        <tr>
	                <td width="100" class="td-title">地址：</td>
	                <td class="td-input" id="cultureTeamAddressLabel"><input type="text" id="cultureTeamAddress" name="cultureTeamAddress" value="${cultureTeam.cultureTeamAddress}" class="input-text w510" maxlength="150"/></td>
	            </tr>
		        <tr>
					<td class="td-title">照片：</td>
					<td>
						<div class="whyUploadVedio" id="cultureTeamAddressUrlWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div style="width: 1000px;float: left;" class="clearfix">
									<c:if test="${not empty cultureTeam.cultureTeamAddressUrl}">
										<c:set var="items" value="${fn:split(cultureTeam.cultureTeamAddressUrl, ',')}"></c:set>
										<c:forEach items="${items}" var="dom" varStatus="i">
											<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
												<img class="aliFileImg" src="${dom}">
												<input type="hidden" name="cultureTeamAddressUrl" value="${dom}">
												<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">所获奖项：</div>
	        <table width="100%" class="form-table">
		        <tr>
		        	<td width="100" class="td-title"></td>
					<td>
						<div class="whyUploadVedio" id="cultureTeamPrizeWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div style="width: 1000px;float: left;" class="clearfix">
									<c:if test="${not empty cultureTeam.cultureTeamPrize}">
										<c:set var="items" value="${fn:split(cultureTeam.cultureTeamPrize, ',')}"></c:set>
										<c:forEach items="${items}" var="dom" varStatus="i">
											<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
												<img class="aliFileImg" src="${dom}">
												<input type="hidden" name="cultureTeamPrize" value="${dom}">
												<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">媒体宣传：</div>
	        <table width="100%" class="form-table">
		        <tr>
		        	<td width="100" class="td-title"></td>
					<td>
						<div class="whyUploadVedio" id="cultureTeamMediaWebupload">
							<div class="clearfix">
								<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
									<a id="selectfiles2" class="selectFiles btn">选择文件</a>
								</div>
								<div style="width: 1000px;float: left;" class="clearfix">
									<c:if test="${not empty cultureTeam.cultureTeamMedia}">
										<c:set var="items" value="${fn:split(cultureTeam.cultureTeamMedia, ',')}"></c:set>
										<c:forEach items="${items}" var="dom" varStatus="i">
											<div name="aliFile" style="margin: 10px;float: left;position: relative;width: 80px;height: 80px;">
												<img class="aliFileImg" src="${dom}">
												<input type="hidden" name="cultureTeamMedia" value="${dom}">
												<img class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
											</div>
										</c:forEach>
									</c:if>
									
									<div id="ossfile2" style="width: 250px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
								</div>
							</div>
						</div>
					</td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">团队简介及主要艺术成果：</div>
	        <table width="100%" class="form-table">
		        <tr>
		        	<td width="100" class="td-title"></td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="cultureTeamIntro" name="cultureTeamIntro" rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none">${cultureTeam.cultureTeamIntro}</textarea>
	                        <span class="upload-tip" style="color:#596988" id="cultureTeamIntroLabel">（0~2000个字以内）</span>
	                    </div>
	                </td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">社会活动情况影响及品牌创新情况阐述：</div>
	        <table width="100%" class="form-table">
		        <tr>
		        	<td width="100" class="td-title"></td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="cultureTeamContent" name="cultureTeamContent" rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none">${cultureTeam.cultureTeamContent}</textarea>
	                        <span class="upload-tip" style="color:#596988" id="cultureTeamContentLabel">（0~2000个字以内）</span>
	                    </div>
	                </td>
				</tr>
	        </table>
	        
	        <div class="cultureTeamTitle">团队管理制度及议事制度：</div>
	        <table width="100%" class="form-table">
		        <tr>
		        	<td width="100" class="td-title"></td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="cultureTeamRule" name="cultureTeamRule" rows="5" class="textareaBox"  maxlength="2000" style="width: 500px;resize: none">${cultureTeam.cultureTeamRule}</textarea>
	                        <span class="upload-tip" style="color:#596988" id="cultureTeamRuleLabel">（0~2000个字以内）</span>
	                    </div>
	                </td>
				</tr>
	        </table>
		    
		    <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="saveCultureTeam()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>