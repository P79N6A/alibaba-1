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
	    var type = '${league.type}'
		//模块标签单选
		tagSelectSingle("TypeLabel");

		//初始化父标签
        $.post("../tag/getChildTagByType.do?code=LEAGUE_TYPE", function (data) {
            var html ="";
            var list = eval(data);
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                html += '<a id="'+obj.tagId+'" style="width: 56px; text-align: center">' + obj.tagName + '</a>';
            }
            $("#TypeLabel").append(html);
            $("#"+type).addClass("cur");

            $('#TypeLabel').find('a').click(function() {
                $('#TypeLabel').find('a').removeClass('cur');
                $(this).addClass('cur');
                $("#type").val($(this).attr("id"));
            });

        });

	});

  

    //上传封面回调函数
     function uploadImgCallbackHomepage(up, file, info) {
      	$('#'+file.id).append("<input type='hidden' id='logo' name='logo' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
      	//alert($("#beipiaoinfoHomepage").val());  
    }  

    //前端校验数据
    function addInfo(){

    	var title = $("#title").val();
    	var logo = $("#logo").val();
    	var type = $("#type").val();
    	var introduction = $("#introduction").val();

    	
    	if (!title) {
            removeMsg("titleLabel");
            appendMsg("titleLabel", "标题不能为空!");
            $("#titleLabel").focus();
            window.location.hash="#titleLabel";
            return;
        } else {
            removeMsg("titleLabel");
        }
    	
    	if (!logo) {
            removeMsg("homepageLabel");
            appendMsg("homepageLabel", "封面不能为空!");
            $('#homepageLabel').focus();
            window.location.hash="#homepageLabel";
            return;
        } else {
            removeMsg("homepageLabel");
        }
    	
    	if (!type) {
            removeMsg("parentLabel");
            appendMsg("parentLabel", "类型不能为空!");
            $('#parentLabel').focus();
            window.location.hash="#parentLabel";
            return;
        } else {
            removeMsg("parentLabel");
        }

    	if (!introduction) {
            removeMsg("contentLabel");
            appendMsg("contentLabel", "简介不能为空!");
            $('#contentLabel').focus();
            window.location.hash="#contentLabel";
            return;
        } else {
            removeMsg("contentLabel");
        }
    	
    	$.post("${path}/league/save.do",$('#infoForm').serialize(),function(data){
    	    data = JSON.parse(data)
    		if (data.status==200) {
                   dialogAlert("提示","保存成功！",function(){
                 		window.location.href = "${path}/league/list.do";
                   });
			   }else if (data.status==400){
				   dialogConfirm("提示", "请先登录！", function(){
             		  window.location.href = "${path}/login.do";
                   });
			   }else {
				   dialogConfirm("提示", data.data)
			   }
		});
    }
</script>
</head>
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){position:relative!important;max-width:485px!important;max-height:400px!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){max-width:750px;max-height:500px;}
	#webuploadhomepage div[name=aliFile]{width:750px!important;max-width:500px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
	#webuploadimages div[name=aliFile]{width:560px!important;max-width:420px!important;}
</style>
<body>
    <div class="site">
        <em>您现在所在的位置：</em>文化联盟 &gt; 新增
    </div>
    <div class="site-title">新增文化联盟</div>
    <div class="main-publish">
    	<form id="infoForm" method="post">
    		<table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
                <td class="td-input" id = "titleLabel">
                    <input id="title" name="title" type="text" class="input-text w510" maxlength="20" value="${league.title}"/>
                    <input name="id" type="hidden" class="input-text w510" maxlength="20" value="${league.id}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>LOGO：</td>
                <td class="td-upload" id="homepageLabel">
                <table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webuploadhomepage">
									<div style="width: 700px;">
										<div id="ossfile2">
                                            <c:if test="${not empty league.logo}">
                                            <div name="aliFile" style="position:relative;margin-bottom:5px;margin-right:15px;max-width:130px;display:inline-block;" >
                                                <img style="max-height: 485px;max-width: 400px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" src="${league.logo }"><br>
                                                <img onclick="remove(this);" id="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px">
                                                <input id="logo" name="logo" value="${league.logo}" type="hidden">
                                            </div>
                                            </c:if>
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
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>类型：</td>
                <td class="td-tag" id ="parentLabel">
                    <input type="hidden" id="type" name="type" value="${league.type}"/>
                    <dl>
                        <dd id="TypeLabel">
                        </dd>
                    </dl>
                </td>
            </tr>

            <tr>
            <td width="100" class="td-title"><span class="red">*</span>简介：</td>
            <td class="td-input" id="contentLabel">
                <div class="editor-box">
                    <textarea id="introduction" name="introduction" rows="8" class="textareaBox" style="width: 500px;resize: none">${league.introduction}</textarea>
                </div>
            </td>
        	</tr>
        	
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
					<input id="btnPublish" class="btn-save" type="button" onclick="addInfo()" value="保存"/>
                    <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1)">
                </td>
            </tr>
        </table>
    	</form>
    </div>
</body>
</html>