<%@page import="org.apache.http.HttpRequest"%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
<%@include file="/WEB-INF/why/common/limit.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>文化云</title>
<!-- 导入头部文件 start -->
<link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
<link rel="stylesheet" href="${path}/STATIC/css/whyupload.css" type="text/css"/>
<!--文本编辑框 end-->
<script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
<script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
<!-- dialog start -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/admin/venue/addVenue.js?version=20151120"></script>
<%-- add   version   避免上传js浏览器缓存 --%>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/admin/jiazhouInfo/addjiazhouInfo.js"></script>
<link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
<script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
<script type="text/javascript">
	$(function () {
		//设置ajx请求为同步
		$.ajaxSetup({
			  async: false
			  });
        //模块标签单选
        tagSelectSingle("venueTypeLabel");
        //展示形式单选
        tagSelectSingle("showTypeLabel");
		//初始化展示形式
		if($("#beipiaoinfoShowtype").val()=='0'){
			$("#showPic").click();
			showPic();
	  	}
		if($("#beipiaoinfoShowtype").val()=='1'){
			$("#showVideo").click();
			showVideo();
	  	}
		//页面初始化时加载富文本编辑器
		var editor = CKEDITOR.replace('beipiaoinfoDetails');
		//查找出管理员所属最高部门
		var userDeptid = $("#publisherName").val();
		$.post("${path}/beipiaoInfo/queryDeptName.do",{userDeptId:userDeptid},function(data){
			$("#publisherNameval").val(data);
		});
		//切换展示形式 
		$(".showType").click(function(){
			if(this.id=="showPic"){
				showPic();
		 	}
		 	if(this.id=="showVideo"){
		 		showVideo();
		 	}
		});

        //初始化父标签
        var _module = '${bpInfoTag.module}' ;
        /*debugger;
        if(_module != '' && _module != 'WHZX') {
            var pid = '${bpInfoTag.tagId}' ;
            if(pid != '') {
                var tagName = '${bpInfoTag.tagName}' ;
                var tagHtml = '' ;
                tagHtml += '<a id="'+pid+'" class="tagType" onclick="setParentId(\''
                    + pid + '\')">' + tagName
                    + '</a>';
                $("#TypeLabel").html(tagHtml);
                tagSelectSingle("TypeLabel");
                setParentId(pid) ;
                $('#moduleso').hide();
            }
        } else {*/
            $.post("${path}/beipiaoInfoTag/queryTagsByModule.do",{module:_module}, function (data) {
                var list = eval(data);
                var tagHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    tagHtml += '<a id="'+tagId+'" data-id="'
                        + tagId + '">' + tagName
                        + '</a>';
                }
                $("#parentTypeLabel").html(tagHtml);
                tagSelectSingle("parentTypeLabel");
                if(_module != '' && _module != 'WHZX') {
                    $('#moduleso').hide();
                }
            });
        // }
		//初始化父标签

			
		//动态给父标签添加点击事件
		$(document).on("click","#parentTypeLabel a",function(){
			var id = $(this).attr("data-id");
			$("#childTagTr").removeAttr("style");
    		$("#parentTag").val(id);
    		$.post("${path}/beipiaoInfoTag/queryChildTag.do",{"parentId":id},
        			function(data){
        			var list = eval(data);
                    var tagHtml = '';
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var tagId = obj.tagId;
                        var tagName = obj.tagName;
                        var cl = '';
                        cl = 'class="cur"';
                        tagHtml += '<a id="'+tagId+'" data-id="'
                                + tagId + '">' + tagName
                                + '</a>';
                    }
                    $("#childTypeLabel").html(tagHtml);
                    $("#childTag").val("");
                    $("#beipiaoinfoTag").val("");
                    tagSelectSingle("childTypeLabel");
        		});
		});
		//页面加载完成后初始化父标签
		$("#${bpInfo.parentTagInfo}").click();
		//动态给子标签添加点击事件
		$(document).on("click","#childTypeLabel a",function(){
			var id = $(this).attr("data-id");
			$("#childTag").val(id);
    		$("#beipiaoinfoTag").val(id);
		});
		//页面加载完成后初始化子标签
		$("#${bpInfo.beipiaoinfoTag}").click();
	});
    	
		function showPic(){
			$("#showVideoType").attr("style","display:none");
			$("#showPicType").removeAttr("style");
			$("#beipiaoinfoVideo").removeAttr("name");
			$("#beipiaoinfoImages").attr("name","beipiaoinfoImages");
			$("#beipiaoinfoShowtype").val("0");
			$("#spanred").removeAttr("style");
		}
	      
		function showVideo(){
			$("#showPicType").attr("style","display:none");
	 		$("#showVideoType").removeAttr("style");
	 		$("#beipiaoinfoImages").removeAttr("name");
	 		$("#beipiaoinfoVideo").attr("name","beipiaoinfoVideo");
	 		$("#beipiaoinfoShowtype").val("1");
	 		$("#spanred").attr("style","display:none");
		}
	      
		//删除图片
		function remove(data){
			data.parentNode.remove();
		}

		//上传封面回调函数
		function uploadImgCallbackHomepage(up, file, info) {
			$('#'+file.id).append("<input type='hidden' id='beipiaoinfoHomepage' name='beipiaoinfoHomepage' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
		}  
		//上传图片集回调函数
		function uploadImgCallbackImages(up, file, info) {
			$('#'+file.id).append("<input type='hidden' name='beipiaoinfoImage' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
		}
		//上传视频回调函数
		function uploadImgCallbackVideo(up, file, info){
			$('#'+file.id).append("<video controls style='width:220px;height:220px;' src='http://culturecloud.img-cn-hangzhou.aliyuncs.com/"
					+ info+"'></video><input type='hidden' id='beipiaoinfoVideo' name='beipiaoinfoVideo' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
			//视频全名
			var video = $("#beipiaoinfoVideo").val();
			//视频后缀名开始的下标
			var point = video.lastIndexOf(".");
			//视频后缀
			var type = video.substr(point);
			if(type!=".mp4"){ 
				dialogAlert("提示", "请上传正确的视频格式！");
		           $("#beipiaoinfoVideo").parent().remove();
		    } 
			//alert($("#beipiaoinfoVideo").val());  
		}
		    
	    //前端校验数据
	    function addInfo(){
	    	var images = document.getElementsByName("beipiaoinfoImage");
	    	for (var i = 0, j = images.length; i < j; i++){
	    		if(i==0){
	    			$("#beipiaoinfoImages").val($("#beipiaoinfoImages").val()+images[i].value);
	    		}else{
	    			$("#beipiaoinfoImages").val($("#beipiaoinfoImages").val()+";"+images[i].value);
	    		}
	    	}
	    	
	    	$('#beipiaoinfoDetails').val(CKEDITOR.instances.beipiaoinfoDetails.getData());
	    	var parentTag = $("#parentTag").val();
	    	var childTag = $("#childTag").val();
	    	var beipiaoinfoTitle = $("#beipiaoinfoTitle").val();
	    	var beipiaoinfoHomepage = $("#beipiaoinfoHomepage").val();
	    	var beipiaoinfoImages = $("#beipiaoinfoImages").val();
	    	var beipiaoinfoContent = $("#beipiaoinfoContent").val();
	    	var beipiaoinfoVideo = $("#beipiaoinfoVideo").val();
	    	var beipiaoinfoDetails = CKEDITOR.instances.beipiaoinfoDetails.getData();
	    	
	    	if (beipiaoinfoTitle == undefined || beipiaoinfoTitle == "") {
	            removeMsg("titleLabel");
	            appendMsg("titleLabel", "标题不能为空!");
	            $("#titleLabel").focus();
	            window.location.hash="#titleLabel";
	            return;
	        } else {
	            removeMsg("titleLabel");
	        }
	    	
	    	if (beipiaoinfoHomepage == undefined || beipiaoinfoHomepage == "") {
	            removeMsg("homepageLabel");
	            appendMsg("homepageLabel", "封面不能为空!");
	            $('#homepageLabel').focus();
	            window.location.hash="#homepageLabel";
	            return;
	        } else {
	            removeMsg("homepageLabel");
	        }
	    	
	    	if (parentTag == undefined || parentTag == "") {
	            removeMsg("parentLabel");
	            appendMsg("parentLabel", "模块不能为空!");
	            $('#parentLabel').focus();
	            window.location.hash="#parentLabel";
	            return;
	        } else {
	            removeMsg("parentLabel");
	        }
	    	
	    	if (childTag == undefined || childTag == "") {
	            removeMsg("childLabel");
	            appendMsg("childLabel", "标签不能为空!");
	            $('#childLabel').focus();
	            window.location.hash="#childLabel";
	            return;
	        } else {
	            removeMsg("childLabel");
	        }
	    	
	    	if (beipiaoinfoContent == undefined || beipiaoinfoContent == "") {
	            removeMsg("contentLabel");
	            appendMsg("contentLabel", "简介不能为空!");
	            $('#contentLabel').focus();
	            window.location.hash="#contentLabel";
	            return;
	        } else {
	            removeMsg("contentLabel");
	        }
	    	
	    	//0表示展示形式为图片，需要校验图片和详情信息
	    	if($("#beipiaoinfoShowtype").val()==0){
	    		if (beipiaoinfoImages == undefined || beipiaoinfoImages == "") {
		            removeMsg("imagesLabel");
		            appendMsg("imagesLabel", "图片集不能为空!");
		            $('#imagesLabel').focus();
		            window.location.hash="#imagesLabel";
		            return;
		        } else {
		            removeMsg("imagesLabel");
		        }
	    		if (beipiaoinfoDetails == undefined || beipiaoinfoDetails == "") {
		            removeMsg("beipiaoinfoDetailsLabel");
		            appendMsg("beipiaoinfoDetailsLabel", "详情信息不能为空!");
		            $('#beipiaoinfoDetailsLabel').focus();
		            window.location.hash="#beipiaoinfoDetailsLabel";
		            return;
		        } else {
		            removeMsg("beipiaoinfoDetailsLabel");
		        }
	    	}
	    	//1表示展示形式为视频，需要校验视频信息
	    	if($("#beipiaoinfoShowtype").val()==1){
	    		if (beipiaoinfoVideo == undefined || beipiaoinfoVideo == "") {
		            removeMsg("videoLabel");
		            appendMsg("videoLabel", "视频不能为空!");
		            $('#videoLabel').focus();
		            window.location.hash="#videoLabel";
		            return;
		        } else {
		            removeMsg("videoLabel");
		        }
	    	}
	    	
	    	$.post("${path}/beipiaoInfo/addInfo.do",$('#infoForm').serialize(),function(data){
	    		if (data != null && data == 'success') {
                    dialogAlert("提示","编辑成功！",function(){
                    	if("${backPath}"){
                   			window.location.href = "${backPath}beipiaoInfo/infoList.do?module=${bpInfoTag.module}";
	                   }else{
	                	   window.location.href = "${path}/beipiaoInfo/infoList.do?module=${bpInfoTag.module}";
	                   }
                    });
 			   }else if (data =="nologin"){
 				   dialogConfirm("提示", "请先登录！", function(){
              		  window.location.href = "${path}/login.do";
	                   });
 			   }else {
 				   dialogConfirm("提示", "编辑失败！")
 			   }
           	});
	    }
	    
	    function reload(){
	    	var id = $("#beipiaoinfoId").val()
	    	window.location.href="${path}/beipiaoInfo/preEditInfo.do?infoId="+id;
	    }
	    
	    function returnList(){
	    	window.location.href="${path}/beipiaoInfo/infoList.do";
	    }
	</script>
</head>
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){position:relative!important;max-width:750px!important;max-height:450px!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){max-width:750px;max-height:450px;}
	#webuploadhomepage div[name=aliFile]{width:750px!important;max-width:450px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
	#webuploadimages div[name=aliFile]{width:560px!important;max-width:420px!important;}
	#webuploadvideo div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
	#webuploadvideo div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
	#webuploadvideo div[name=aliFile]{width:560px!important;max-width:420px!important;}
</style>
<body>
    <div class="site">
        <em>您现在所在的位置：</em>动态资讯 &gt; 编辑动态资讯 
    </div>
    <div class="site-title">发布动态资讯 </div>
    <div class="main-publish">
    	<form id="infoForm" method="post">
    		<table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td class="td-input" id = "titleLabel">
                    <input id="beipiaoinfoTitle" name="beipiaoinfoTitle" type="text" class="input-text w510" maxlength="20" value="${bpInfo.beipiaoinfoTitle }"/>
                    <span class="error-msg"></span>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>封面：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td class="td-upload" id="homepageLabel">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webuploadhomepage">
									<div style="width: 700px;">
										<div id="ossfile2">
											<div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
												<img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${bpInfo.beipiaoinfoHomepage }"><br>
												<img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px">
												<input id="beipiaoinfoHomepage" name="beipiaoinfoHomepage" value="${bpInfo.beipiaoinfoHomepage }" type="hidden">
											</div>
										</div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC;">选择封面</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：可上传1张图片，建议尺寸<span style="color:red">750*500像素</span>，格式为jpg、jpeg、png、gif，大小不超过<span style="color:red">2M</span></pre>
										</div>
										<script type="text/javascript">
												// 图片
												aliUploadImg('webuploadhomepage', uploadImgCallbackHomepage, 1, true, 'beipiao');
										</script> 
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>
            
            <tr id="moduleso">
                <td width="100" class="td-title"><span class="red">*</span>所属模块：</td>
                <td class="td-tag" id ="parentLabel">
                    <input type="hidden" id="parentTag" name="parentTag" value="${bpInfo.parentTagInfo }"/>
                    <dl>
                        <dd id="parentTypeLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            
            <tr id ="childTagTr" style="display: none">
                <td width="100" class="td-title"><span class="red">*</span>子模块：&nbsp;&nbsp;&nbsp;</td>
                <td class="td-tag" id ="childLabel">
                    <input type="hidden" id="childTag" name="childTag" value=""/>
                    <dl>
                        <dd id="childTypeLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>发布者：&nbsp;&nbsp;&nbsp;</td>
                <td class="td-input" id="publisherNameLabel">
                	<input type="hidden" value ="${bpInfo.publisherName }" name="publisherName" id="publisherName"/> 
                    <input id="publisherNameval" type="text" class="input-text w210" maxlength="20" readonly="readonly"/>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>展示形式：</td>
                <td class="td-tag">
                    <dl>
                        <dd id="showTypeLabel">
                        	<a id="showPic" class="showType" style="width: 50px; text-align: center">图片</a>
                        	<a id="showVideo" class="showType" style="width: 50px; text-align: center">视频</a>
                        </dd>
                    </dl>
                </td>
            </tr>
            
            <tr id ="showPicType" >
            	<td width="100" class="td-title"><span class="red">*</span>图片集：&nbsp;&nbsp;&nbsp;</td>
            	<td class="td-upload" id="imagesLabel">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webuploadimages">
									<div style="width: 700px;">
										<div id="ossfile2">
											<c:if test="${bpInfo.beipiaoinfoImages!=''}">
												<c:set value="${ fn:split(bpInfo.beipiaoinfoImages, ';') }" var="urls" />
												<c:if test="${not fn:contains(bpInfo.beipiaoinfoImages,';')}">
													<div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
														<img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${bpInfo.beipiaoinfoImages}"/><br/>
														<img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px"/>
														<input id="beipiaoinfoImage" name="beipiaoinfoImage" value="${bpInfo.beipiaoinfoImages}" type="hidden"/>
													</div>
												</c:if>
												<c:if test="${fn:contains(bpInfo.beipiaoinfoImages,';')}">
													<c:forEach items="${urls}" var="s">
														<div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
															<img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${s}"/><br/>
															<img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px"/>
															<input id="beipiaoinfoImage" name="beipiaoinfoImage" value="${s }" type="hidden"/>
														</div>
													</c:forEach>
												</c:if>
											</c:if>
										</div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC">上传图片</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：最多可上传6张图片，建议尺寸<span style="color:red">560*420像素</span>，格式为jpg、jpeg、png、gif，大小不超过<span style="color:red">2M</span></pre>
										</div>
										<script type="text/javascript">
												// 图片
												aliUploadImg('webuploadimages', uploadImgCallbackImages, 6, true, 'beipiao');
										</script> 
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>
            <tr id ="showVideoType" style="display: none">
            	<td width="100" class="td-title"><span class="red">*</span>视频：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            	<td class="td-upload" id="videoLabel">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webuploadvideo">
									<div style="width: 700px;">
										<div id="ossfile2">
											<c:if test="${bpInfo.beipiaoinfoVideo!=null && bpInfo.beipiaoinfoVideo != '' }">
												<div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
													<img style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${bpInfo.beipiaoinfoVideo }"><br>
													<div class="progress">
														<div class="progress-bar" style="width: 200px;" aria-valuenow="100"></div>
													</div>
													<img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px;z-index:10;">
													<video controls style='width:400px;height:300px;' src='${bpInfo.beipiaoinfoVideo }'></video>
													<input id="beipiaoinfoVideo" name="beipiaoinfoVideo" value="${bpInfo.beipiaoinfoVideo }" type="hidden">
												</div>
											</c:if>
										</div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC">上传视频</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：<span style="color:red">仅支持MP4</span></pre>
										</div>
										<script type="text/javascript">
												// 视频
												aliUploadFiles('webuploadvideo', uploadImgCallbackVideo, 1, true, 'beipiao');
										</script> 
									</div>
								</div>
							</div>
                        </td>
                    </tr>
                </table>
              </td>
            </tr>
            <tr>
            <td width="100" class="td-title"><span class="red">*</span>简介：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td class="td-input" id="contentLabel">
                <div class="editor-box">
                    <textarea id="beipiaoinfoContent" name="beipiaoinfoContent" rows="8"
                    		  class="textareaBox" style="width: 500px;resize: none">${bpInfo.beipiaoinfoContent }</textarea>
                </div>
            </td>
        	</tr>
        	
            <tr>
                <td width="100" class="td-title"><span class="red" id="spanred" >*</span>详细描述：</td>
                <td class="td-content" id="beipiaoinfoDetailsLabel">
                    <div class="editor-box">
                        <textarea name="beipiaoinfoDetails" id="beipiaoinfoDetails">${bpInfo.beipiaoinfoDetails }</textarea>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                	<input type="hidden" name="beipiaoinfoId" id="beipiaoinfoId" value="${bpInfo.beipiaoinfoId }"/>
                	<input type="hidden" name="beipiaoinfoShowtype" id="beipiaoinfoShowtype"  value="${bpInfo.beipiaoinfoShowtype }"/>
                	<input type="hidden" id="beipiaoinfoImages" name="beipiaoinfoImages"/>
                    <input type="hidden" id="beipiaoinfoTag" name="beipiaoinfoTag" />
					<input id="btnPublish" class="btn-save" type="button" onclick="addInfo()" style="width: 120px" value="编辑并保存"/>
					<input class="btn-publish" type="button" onclick="reload();" value="重置"/>
					<input class="btn-publish" type="button" onclick="returnList();" value="返回" style="background-color:#C0C0C0 "/>
                </td>
            </tr>
        </table>
    	</form>
    </div>
</body>
</html>