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
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/cropper.min.css" type="text/css" />
    <link rel="stylesheet" href="${path}/STATIC/js/ossjs/ImgCropping.css" type="text/css" />
<script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/cropper.min.js"></script>
<script type="text/javascript">
	$(function () {
		//模块标签单选
		tagSelectSingle("TypeLabel");
		
		//展示形式单选
		tagSelectSingle("showTypeLabel");
		
		//初始化展示形式
		$("#showPic").click();
		
		//页面初始化时加载富文本编辑器
		var editor = CKEDITOR.replace('beipiaoinfoDetails');
		
		//查找出管理员所属最高部门
		var userDeptid = $("#publisherName").val();
		$.post("${path}/beipiaoInfo/queryDeptName.do",{
			userDeptId:userDeptid},function(data){
			 	$("#publisherNameval").val(data);
		})
          
        //切换展示形式 
        $(".showType").click(function(){
			if(this.id=="showPic"){
				$("#showVideoType").attr("style","display:none");
				$("#showPicType").removeAttr("style");
				$("#beipiaoinfoVideo").removeAttr("name");
				$("#beipiaoinfoImages").attr("name","beipiaoinfoImages");
				$("#beipiaoinfoShowtype").val("0");
				$("#spanred").removeAttr("style");
			}
			if(this.id=="showVideo"){
				$("#showPicType").attr("style","display:none");
				$("#showVideoType").removeAttr("style");
				$("#beipiaoinfoImages").removeAttr("name");
				$("#beipiaoinfoVideo").attr("name","beipiaoinfoVideo");
				$("#beipiaoinfoShowtype").val("1");
				$("#spanred").attr("style","display:none");
			}
        });
		
		//初始化父标签
        var _module = '${module}' ;
        if(_module != '' && _module != 'WHZX') {
            var pid = '${bpinfo.tagId}' ;
            if(pid != '') {
                var tagName = '${bpinfo.tagName}' ;
                var tagHtml = '' ;
                tagHtml += '<a id="'+pid+'" class="tagType" onclick="setParentId(\''
                    + pid + '\')">' + tagName
                    + '</a>';
                $("#TypeLabel").html(tagHtml);
                tagSelectSingle("TypeLabel");
                setParentId(pid) ;
                $('#moduleso').hide();
            }
        } else {
            $.post("${path}/beipiaoInfoTag/queryParentTag.do", function (data) {
                $("#module").val("WHZX");
                var list = eval(data);
                var tagHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var cl = '';
                    cl = 'class="cur"';
                    if(_module!='' && _module == 'YSJS') {
                        if(tagName == '艺术鉴赏') {
                            tagHtml += '<a id="'+tagId+'" class="tagType" onclick="setParentId(\''
                                + tagId + '\')">' + tagName
                                + '</a>';
                        }
                    } else {
                        if(tagName == '艺术鉴赏' || tagName == '影视天地' || tagName == '文化创意') {
                            continue;
                        }
                        tagHtml += '<a id="'+tagId+'" class="tagType" onclick="setParentId(\''
                            + tagId + '\')">' + tagName
                            + '</a>';
                    }
                }
                $("#TypeLabel").html(tagHtml);
                tagSelectSingle("TypeLabel");
            });
        }

	});
      
	//父标签的点击事件
	function setParentId(id){
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
                var module = obj.tagCode
                cl = 'class="cur"';
                tagHtml += '<a id="'+tagId+'" class="tagType" onclick="setChildId(\''
                        + tagId + '\',\''+module+'\')">' + tagName
                        + '</a>';
            }
            $("#childTypeLabel").html(tagHtml);
            $("#childTag").val("");
            $("#beipiaoinfoTag").val("");
            tagSelectSingle("childTypeLabel");
		});
	}
	
	//子标签的点击事件
	function setChildId(id,module){
		$("#childTag").val(id);
		$("#beipiaoinfoTag").val(id);
//		$("#module").val(module);
	}
  

    //上传封面回调函数
     function uploadImgCallbackHomepage(up, file, info) {
      	$('#'+file.id).append("<input type='hidden' id='beipiaoinfoHomepage' name='beipiaoinfoHomepage' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
      	//alert($("#beipiaoinfoHomepage").val());  
    }  
    //上传图片集回调函数
    function uploadImgCallbackImages(up, file, info) {
     		$('#'+file.id).append("<input type='hidden' name='beipiaoinfoImage' value='http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info+"'/>");
     		//alert($("#beipiaoinfoImages").val());
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
    	//alert($("#beipiaoinfoVideo").val());  MP4、flv、avi、wmv
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
                   dialogAlert("提示","发布成功！",function(){
                	   if("${backPath}"){
                   			window.location.href = "${backPath}beipiaoInfo/infoList.do?module=${module}";
	                   }else{
                 			window.location.href = "${path}/beipiaoInfo/infoList.do?module=${module}";
	                   }
                   });
			   }else if (data =="nologin"){
				   dialogConfirm("提示", "请先登录！", function(){
             		  window.location.href = "${path}/login.do";
                   });
			   }else {
				   dialogConfirm("提示", "上架失败！")
			   }
		});
    }
</script>
</head>
<style>
	div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){position:relative!important;max-width:750px!important;max-height:500px!important;}
	#webuploadhomepage div[name=aliFile] img:nth-child(1){max-width:750px;max-height:500px;}
	#webuploadhomepage div[name=aliFile]{width:750px!important;max-width:500px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
	#webuploadimages div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
	#webuploadimages div[name=aliFile]{width:560px!important;max-width:420px!important;}
</style>

<body>
    <div class="site">
        <em>您现在所在的位置：</em>动态资讯 &gt; 发布动态资讯 
    </div>
    <!--图片裁剪框 start-->
    <div style="display: none" class="tailoring-container">
        <div class="black-cloth" onclick="closeTailor(this)"></div>
        <div class="tailoring-content" style="margin-left: 20%;">
            <div class="tailoring-content-one">
                <%--<label title="上传图片" for="chooseImg" class="l-btn choose-btn">
                    <input type="file" accept="image/jpg,image/jpeg,image/png" name="file" id="chooseCjImg" class="hidden" onchange="selectImg(this)">
                    选择图片
                </label>--%>
                <div class="close-tailoring"  onclick="closeTailor(this)">×</div>
            </div>
            <div class="tailoring-content-two">
                <div class="tailoring-box-parcel">
                    <img id="tailoringImg">
                </div>
                <div class="preview-box-parcel">
                    <p>图片预览：</p>
                    <div class="square previewImg"></div>
                    <%--<div class="circular previewImg"></div>--%>
                </div>
            </div>
            <div class="tailoring-content-three">
                <button class="l-btn cropper-reset-btn">复位</button>
                <button class="l-btn cropper-rotate-btn">旋转</button>
                <button class="l-btn cropper-scaleX-btn">换向</button>
                <button class="l-btn sureCut" id="sureCut">确定</button>
            </div>
        </div>
    </div>
    <script>
        var cjImgFile="";
        var cjImgName="";
        var cjImgKey="";
        function selectImg(file) {
            if (!file.files || !file.files[0]){
                return;
            }
            cjImgFile=file.files[0];
            cjImgName=file.files[0].name;
            suffix = get_suffix_img(cjImgName);
            calculate_object_name_img(cjImgName);
            cjImgKey="beipiao/"+g_object_name;
            var reader = new FileReader();
            reader.onload = function (evt) {
                var replaceSrc = evt.target.result;
                //更换cropper的图片
                $('#tailoringImg').cropper('replace', replaceSrc,false);//默认false，适应高度，不失真
                $(".tailoring-container").toggle();
            }
            reader.readAsDataURL(file.files[0]);
        }
        //cropper图片裁剪
        $('#tailoringImg').cropper({
            aspectRatio: 3/2,//默认比例
            preview: '.previewImg',//预览视图
            guides: false,  //裁剪框的虚线(九宫格)
            autoCropArea: 1,  //0-1之间的数值，定义自动剪裁区域的大小，默认0.8
            movable: false, //是否允许移动图片
            dragCrop: true,  //是否允许移除当前的剪裁框，并通过拖动来新建一个剪裁框区域
            movable: true,  //是否允许移动剪裁框
            resizable: true,  //是否允许改变裁剪框的大小
            zoomable: false,  //是否允许缩放图片大小
            mouseWheelZoom: true,  //是否允许通过鼠标滚轮来缩放图片
            touchDragZoom: true,  //是否允许通过触摸移动来缩放图片
            rotatable: true,  //是否允许旋转图片
            crop: function(e) {
                // 输出结果数据裁剪图像。
                //console.log(e);
            }
        });
        //旋转
        $(".cropper-rotate-btn").on("click",function () {
            $('#tailoringImg').cropper("rotate", 45);
        });
        //复位
        $(".cropper-reset-btn").on("click",function () {
            $('#tailoringImg').cropper("reset");
        });
        //换向
        var flagX = true;
        $(".cropper-scaleX-btn").on("click",function () {
            if(flagX){
                $('#tailoringImg').cropper("scaleX", -1);
                flagX = false;
            }else{
                $('#tailoringImg').cropper("scaleX", 1);
                flagX = true;
            }
            flagX != flagX;
        });
        //裁剪后的处理
        $("#sureCut").on("click",function () {
            if ($("#tailoringImg").attr("src") == null ){
                return false;
            }else{
                var cas = $('#tailoringImg').cropper('getCroppedCanvas');//获取被裁剪后的canvas
                var base64url = cas.toDataURL(); //转换为base64地址形式
                $("#finalImg").prop("src",base64url);//显示为图片的形式
                var file=dataURLtoBlob(base64url);
                uploadFile(file);
                //关闭裁剪框
                closeTailor();
            }
        });
        function dataURLtoBlob(dataurl) {
            var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
                bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
            while (n--) {
                u8arr[n] = bstr.charCodeAt(n);
            }
            return new Blob([u8arr], {type: mime});
        }
        function uploadFile(file) {
            //var file=$("#file")[0].files[0];
            if(file==null)
                return;
            var formData=new FormData();
            formData.append('name',cjImgName);
            formData.append('key',cjImgKey);
            formData.append('policy',policyBase64);
            formData.append('OSSAccessKeyId',accessid);
            formData.append('success_action_status','200');
            formData.append('signature',signature);
            formData.append('file',file);
            //var url=serverUrl+"uploadPic";
            $.ajax({
                url:'http://culturecloud.img-cn-hangzhou.aliyuncs.com/',
                type:'POST',
                cache:false,
                data:formData,
                processData:false,
                contentType:false,
                success:function(res){
                    $("#fmImg img").attr("src",host+cjImgKey);
                    $("#beipiaoinfoHomepage").val(host+cjImgKey);
                },
                error:function(res){
                    alert("上传失败");
                }
            });
        }
            //关闭裁剪框
        function closeTailor() {
            $(".tailoring-container").toggle();
        }
    </script>
    <div class="site-title">发布动态资讯 </div>
    <div class="main-publish">
    	<form id="infoForm" method="post">
            <input type="hidden" id="module" name="module" value="${module}"/>
    		<table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>标题：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td class="td-input" id = "titleLabel">
                    <input id="beipiaoinfoTitle" name="beipiaoinfoTitle" type="text" class="input-text w510" maxlength="20"/>
                    <span class="error-msg"></span>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>封面：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td class="td-upload" id="homepageLabel">
                    <div id="fmImg" style="width:300px;height:200px"><img style="width:100%;height:100%;" src=""></div>
                    <input type="file" accept="image/jpg,image/jpeg,image/png" name="file" id="chooseImg" class="hidden" onchange="selectImg(this)">
                <%--<table>
                    <tr>
                        <td>
                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
	                            <div class="whyUploadVedio" id="webuploadhomepage">
									<div style="width: 700px;">
										<div id="ossfile2"></div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC;">选择封面</a>
                                            <input type="file" accept="image/jpg,image/jpeg,image/png" name="file" id="chooseImg" class="hidden" onchange="selectImg(this)">
                                            选择图片
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
                </table>--%>
              </td>
            </tr>
            
            <tr id="moduleso">
                <td width="100" class="td-title"><span class="red">*</span>所属模块：</td>
                <td class="td-tag" id ="parentLabel">
                    <input type="hidden" id="parentTag" name="parentTag" value=""/>
                    <dl>
                        <dd id="TypeLabel">
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
                	<input type="hidden" value ="${user.userDeptId}" name="publisherName" id="publisherName"/> 
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
										<div id="ossfile2"></div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC;">上传图片</a>
											<pre style="font-size: 14px;color: #999;line-height: 25px;">Tip：最多可上传6张图片，建议尺寸<span style="color:red">560*420像素</span>，格式为jpg、jpeg、png、gif，建议大小不超过<span style="color:red">2M</span></pre>
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
										<div id="ossfile2"></div>
										<div id="container2" style="clear:both;">
											<a id="selectfiles2" href="javascript:void(0);" class='btn' style="width: 120px;background-color: #1882FC;">上传视频</a>
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
                    <textarea id="beipiaoinfoContent" name="beipiaoinfoContent" rows="8" class="textareaBox" style="width: 500px;resize: none"></textarea>
                </div>
            </td>
        	</tr>
        	
            <tr>
                <td width="100" class="td-title"><span class="red" id="spanred" >*</span>详细描述：</td>
                <td class="td-content" id="beipiaoinfoDetailsLabel">
                    <div class="editor-box">
                        <textarea name="beipiaoinfoDetails" id="beipiaoinfoDetails"></textarea>
                    </div>
                </td>
            </tr>
            
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">

                    <input type="hidden" name="beipiaoinfoHomepage" id ="beipiaoinfoHomepage" val=""/>
                	<input type="hidden" name="beipiaoinfoTag" id ="beipiaoinfoTag" val=""/>
                	<input type="hidden" name="beipiaoinfoShowtype" id="beipiaoinfoShowtype" value="0"/>
                	<input type="hidden" id="beipiaoinfoImages" name="beipiaoinfoImages"/>
                    <input type="hidden" id="beipiaoinfoStatus" name="beipiaoinfoStatus" value="0"/>
					<input id="btnPublish" class="btn-publish" type="button" onclick="addInfo()" value="保存并发布"/>
                </td>
            </tr>
        </table>
    	</form>
    </div>

</body>
</html>