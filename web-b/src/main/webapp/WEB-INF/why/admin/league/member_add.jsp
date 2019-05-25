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

<!--文本编辑框 end-->
<script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
<script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
<!-- dialog start -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>

<%-- add   version   避免上传js浏览器缓存 --%>
<link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
<script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>

<!-- dialog start -->
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

<script type="text/javascript">

    /**
     * Created by cj on 2015/7/2.
     */
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });


    $(function () {
        //获取经纬度
        $('#getMapAddressPoint').on('click', function () {
            var address = $('#address').val();
            dialog({
                url: '${path}/activity/queryMapAddressPoint.do?address=' + encodeURI(encodeURI(address)),
                title: '获取经纬度',
                width: 700,
                fixed: true,
                onclose: function () {
                    if (this.returnValue) {

                        $('#lng').val(this.returnValue.xPoint);
                        $("#lat").val(this.returnValue.yPoint);

                    }
                    //dialog.focus();
                }
            }).showModal();
            return false;
        });

        //上传图片集
        aliUploadImg('productImagesWebupload', getProductImages,6, true, 'fs');

        var leagues = '${member.leagueName}'
        //初始化父标签
        $.post("${path}/league/queryLeagues.do", {rows:1000},function (data) {
            var html ="";
            var list = eval(data);
            for (var i = 0; i < list.length; i++) {
                var obj = list[i];
                if(leagues.indexOf(obj.id)>=0){
                    html += '<a class="cur" id="'+obj.id+'" style="width: auto; text-align: center">' + obj.title + '</a>';
                }else{
                    html += '<a id="'+obj.id+'" style="width: auto; text-align: center">' + obj.title + '</a>';
                }
            }
            $("#TypeLabel").append(html);

            $('#TypeLabel').find('a').click(function() {
                if ($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                } else {
                    $(this).addClass('cur');
                }
            });


        });
	});

    //图片集回调
    function getProductImages(up, file, info) {
        var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        $("#"+file.id).append("<input type='hidden' name='images' value='"+filePath+"'/>");
    }

    //上传封面回调函数
     function uploadImgCallbackHomepage(up, file, info) {

      	$('#'+file.id).append("<input type='hidden' id='logo' name='logo' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
      	//alert($("#beipiaoinfoHomepage").val());  
    }  

    //前端校验数据
    function addInfo(){

    	var memberName = $("#memberName").val();
    	if (!memberName) {
            removeMsg("titleLabel");
            appendMsg("titleLabel", "名称不能为空!");
            $("#titleLabel").focus();
            window.location.hash="#titleLabel";
            return;
        } else {
            removeMsg("titleLabel");
        }

        var leagues = "";
        $("#TypeLabel .cur").each(function () {
            leagues += $(this).attr("id")+","
        })
    	if (!leagues) {
            removeMsg("parentLabel");
            appendMsg("parentLabel", "请选择所属联盟!");
            $('#parentLabel').focus();
            window.location.hash="#parentLabel";
            return;
        } else {
            removeMsg("parentLabel");
        }
        $("#relateIds").val(leagues);

        var address = $("#address").val();
        if (!address) {
            removeMsg("addressLabel");
            appendMsg("addressLabel", "地址不能为空!");
            $("#addressLabel").focus();
            window.location.hash="#addressLabel";
            return;
        } else {
            removeMsg("addressLabel");
        }


        var lon = $("#lng").val();
        var lat = $("#lat").val();

        if(!lon || !lat){
            removeMsg("mapLabel");
            appendMsg("mapLabel", "请选择位置坐标!");
            $("#addressLabel").focus();
            window.location.hash="#mapLabel";
            return;
        } else {
            removeMsg("mapLabel");
        }

        var introduction = $("#introduction").val();
    	if (!introduction) {
            removeMsg("contentLabel");
            appendMsg("contentLabel", "简介不能为空!");
            $('#contentLabel').focus();
            window.location.hash="#contentLabel";
            return;
        } else {
            removeMsg("contentLabel");
        }

        var images = "";
    	$("input[name='images']").each(function () {
            images += $(this).val()+",";
        })
        if (!images) {
            removeMsg("productImagesLabel");
            appendMsg("productImagesLabel", "请至少上传一张照片!");
            $('#productImagesLabel').focus();
            window.location.hash="#productImagesLabel";
            return;
        } else {
            removeMsg("productImagesLabel");
        }

    	$.post("${path}/member/save.do",$('#infoForm').serialize(),function(data){
    	    data = JSON.parse(data)
    		if (data.status==200) {
                   dialogAlert("提示","保存成功！",function(){
                 		window.location.href = "${path}/member/list.do";
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
    .aliRemoveBtn{position: absolute;right: -8px;top: -8px; width: 20px;}
    div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
    #productIconUrlWebupload div[name=aliFile] img:nth-child(1){position:relative!important;max-width:750px!important;max-height:500px!important;}
    #productIconUrlWebupload div[name=aliFile] img:nth-child(1){max-width:750px;max-height:500px;}
    #productIconUrlWebupload div[name=aliFile]{width:750px!important;max-width:500px!important;}
    #productImagesWebupload div[name=aliFile] img:nth-child(1){position:relative!important;max-width:400px!important;max-height:420px!important;}
    #productImagesWebupload div[name=aliFile] img:nth-child(1){max-width:400px;max-height:420px;}
    #productImagesWebupload div[name=aliFile]{width:400px!important;max-width:420px!important;}

</style>
<body>
    <div class="site">
        <em>您现在所在的位置：</em>文化联盟 &gt; 成员新增
    </div>
    <div class="site-title">新增成员</div>
    <div class="main-publish">
    	<form id="infoForm" method="post">
    		<table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>名称：</td>
                <td class="td-input" id = "titleLabel">
                    <input id="memberName" name="memberName" type="text" class="input-text w510" maxlength="30" value="${member.memberName}"/>
                    <input name="id" type="hidden" class="input-text w510" maxlength="20" value="${member.id}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>所属联盟：</td>
                <td class="td-tag" id ="parentLabel">
                    <input type="hidden" id="relateIds" name="relateIds" value="${member.relateIds}"/>
                    <dl>
                        <dd id="TypeLabel">
                        </dd>
                    </dl>
                </td>,
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地址：
                </td>
                <td class="td-input" id="addressLabel">
                    <input id="address" name="address" type="text" class="input-text w510"
                           maxlength="50" placeholder="请输入详细地址" value="${member.address}"/>
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>地图坐标：</td>
                <td class="td-input td-coordinate" id="mapLabel">
                    <span class="txt">X</span>
                    <input value="${member.lng}" id="lng" name="lng" type="text" class="input-text w120" maxlength="15"
                           readonly="">
                    <span class="txt">Y</span>
                    <input value="${member.lat}" id="lat" name="lat" type="text" class="input-text w120" maxlength="15"
                           readonly="">
                    <input type="button" class="upload-btn" id="getMapAddressPoint" value="查询坐标">
                    <span class="error-msg"></span>
                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"><span class="red">*</span>简介：</td>
                <td class="td-input" id="contentLabel">
                    <div class="editor-box">
                        <textarea id="introduction" name="introduction" rows="8" class="textareaBox" style="width: 500px;resize: none">${member.introduction}</textarea>
                    </div>
                </td>
            </tr>


                <tr id="showPicType">
                    <td width="100" class="td-title"><span class="red">*</span>上传照片：</td>
                    <td id="productImagesLabel" class="td-upload">
                        <div class="whyVedioInfoContent" style="margin-top: -10px;">
                            <div class="whyUploadVedio" id="productImagesWebupload">
                                <div style="width: 700px;">
                                    <div id="ossfile2">
                                        <c:choose>
                                            <c:when test="${!empty member.images}">
                                                <c:set value="${ fn:split(member.images,',')}"  var="images"></c:set>
                                                <c:forEach items="${images}" var="image">
                                                    <div name="aliFile" style="position: relative; margin-bottom: 5px; margin-right: 15px; max-width: 130px; display: inline-block;" >
                                                        <img src="${image}" style="max-height: 130px;max-width: 130px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" />
                                                        <br />
                                                        <img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png"/>
                                                        <input type="hidden" value="${image}" name="images"/>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div id="container2" style="clear: both;">
                                        <a id="selectfiles2" class="selectFiles btn">点击上传</a>
                                    </div>

                                </div>
                                <span class="upload-tip">最多上传6张图片,建议尺寸560*420像素，格式为jpg,jpeg,png,gif，建议大小不超过2M</span>
                            </div>
                        </div>
                    </td>
                </tr>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
					<input id="btnPublish" class="btn-save" type="button" onclick="addInfo()" value="保存"/>
                    <input type="button" value="取消" class="btn-publish" style="background-color: #bac2cb;" onclick="javascript:history.back(-1)">
                </td>
            </tr>
        </table>
    	</form>
    </div>
</body>
</html>