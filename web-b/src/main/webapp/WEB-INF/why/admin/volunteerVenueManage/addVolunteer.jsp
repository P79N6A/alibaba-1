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
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        function save(){
        	
        	var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*400)的图片，再提交！",function(){
                });
                return;
            }
        	
        	$.post("${path}/volunteerVenueManage/saveVolunteer.do", $("#volunteerForm").serialize(),function(data){
        		if(data == "success"){
        			dialogConfirm("提示","保存成功！",function(){
                        window.location.href="${path}/volunteerVenueManage/volunteerVenueManageIndex.do";        				
        			})
        		}else if(data == "login"){
        			
               	    dialogAlert('提示', '请先登录！', function () {
               			window.location.href = "${path}/login.do";
                   	 });
        		}else{
        			dialogConfrim("提示","保存失败！");
        		}
        	})
        }
        
        //图片上传和回显
        $(function () {
        	var type=$("#uploadType").val();
        	var userCounty = $("#userCounty").val();
        	$("#file").uploadify({
        		'formData':{'uploadType':type,type:4,userCounty:userCounty},//传静态参数
        		swf:'${path}/STATIC/js/uploadify.swf',
        		uploader:'${path}/upload/uploadFile.do;jsessionid='+$("#sessionId").val(), //后台处理的请求
        		buttonText:'选择',//上传按钮的文字
        		'fileSizeLimit':'2MB',
        		'buttonClass':"upload-btn",//按钮的样式
        		queueSizeLimit:1, //   default 999
        		'method': 'post',//和后台交互的方式：post/get
        		queueID:'fileContainer',
        		fileObjName:'file', //后台接受参数名称
        		fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
        		'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
        		'multi':false, //是否支持多个附近同时上传
        		height:42,//选择文件按钮的高度
        		width:100,//选择文件按钮的宽度
        		'debug':false,//debug模式开/关，打开后会显示debug时的信息
        		'dataType':'json',
        		removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
        		onUploadSuccess:function (file, data, response) {
        			var json = $.parseJSON(data);
        			var url=json.data;
        			var hiddenImgUrl = url;
        			$("#btnContainer").show();
        			var initWidth = parseInt(json.initWidth);
        			var initHeigth = parseInt(json.initHeigth);
        			if(initWidth<750 || initHeigth<400){
        				dialogAlert("提示","请上传尺寸不小于750*400(px)的图片",function(){
        				});
        				$("#isCutImg").val("N");
        				return;
        			}
        			/* $("#imgHeadPrev").html(getImgHtml(getImgUrl(url))); */
        			var cutImageWidth=750;
        			var cutImageHeigth=400;
        			var url =getImgUrl(url);
        			
        			dialog({
    					url: "${path}/att/toCutImgJsp.do",
    					data: {
    						imageUrl: url,
    						initWidth:initWidth,
    						initHeigth:initHeigth,
    						cutImageWidth:cutImageWidth,
    						cutImageHeigth:cutImageHeigth
    					},
    				title: '图片裁剪',
    				fixed: false,
    				onclose: function () {
    					if(this.returnValue){
    						var imgUrl = this.returnValue.imageUrl;
    						var isCutImg = this.returnValue.isCutImg;
    						setTimeout(function(){
    							$("#imgHeadPrev").html(getImgHtml(imgUrl));
    						},0);
    						$("#isCutImg").val(isCutImg);
    						$("#recruitIconUrl").val(getIndexImgUrl(hiddenImgUrl,"_750_400"));
    					}
    				}
    			}).showModal();
        			return false;
        		},
        		onSelect:function () { //插件本身没有单文件上传之后replace的效果
        			var notLast = $('#fileContainer').find('div.uploadify-queue-item').not(':last');
        			notLast.remove();
        			$('#btnContainer').show();
        		},
        		onCancel:function () {
        			$('#btnContainer').hide();
        		}
        	});
        	
        	//初始化获取图片
        	getImg();
        	
        });

        function getImgHtml(imgUrl){
        	if(imgUrl==""){
        		return '<img src="${path}/STATIC/image/defaultImg.png" />';
        	}
        	return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }

        function clearQueue() {
        	$('#file').uploadify('cancel', '*');
        	$('#btnContainer').hide();
        	$("#tuserPicture").val('');
        	$("#imgHeadPrev").html("<img  src='${path}/STATIC/image/defaultImg.png' id='userHeadImg'>");
        }
        function uploadQueue() {
        	$('#file').uploadify('upload','*');
        }

        //编辑后获取图片
        getImg=function(){
        	var imgUrl=$("#recruitIconUrl").val();
        	if(imgUrl == undefined || imgUrl == "" || imgUrl == null){
        		$("#imgHeadPrev").html("<img src='${path}/STATIC/image/defaultImg.png'  id='userHeadImg'>");
        	}else{
        		imgUrl=getImgUrl(imgUrl);
        		$("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
        		removeMsg("pictureLabel");
        	}
        };
    </script>
</head>

<body>
	<form action="${path}/volunteerVenueManage/saveVolunteer.do" id="volunteerForm" method="post">
	    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理  &gt; 志愿者场馆管理  &gt; 新增志愿者
	    </div>
	    <div class="site-title">新增志愿者</div>
	    <input type="hidden" id="isCutImg" value="Y"/>
	    <input type="hidden" name="recruitId" id="recruitId" value="${volunteerRecruit.recruitId }"/> 
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title">志愿者名称：</td>
	                <td class="td-input" id="recruitName"><input type="text" id="recruitName" value="${volunteerRecruit.recruitName }" name="recruitName" class="input-text w510" maxlength="15"/></td>
	            </tr>
	            <tr>
						<td width="100" class="td-title"><span class="red">*</span>封面图：</td>
						<td class="td-upload" id="pictureLabel">
							<table>
								<tr>
									<td>
										<input type="hidden" name="recruitIconUrl" id="recruitIconUrl" value="${volunteerRecruit.recruitIconUrl  }">
										<input type="hidden" name="uploadType" value="Img" id="uploadType" />
										<div class="img-box">
											<div id="imgHeadPrev" class="img"> </div>
										</div>
										<div class="controls-box">
											<div style="height: 46px;">
												<div class="controls" style="float:left;">
													<input type="file" name="file" id="file">
												</div>

												<span class="upload-tip">建议尺寸750px*400px</span>
											</div>
											<div id="fileContainer"></div>
											<div id="btnContainer" style="display: none;">
												<a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
											</div>
										</div>
									</td>
									<td class="td-input" id="topicIconLabel"></td>
								</tr>
							</table>
						</td>
				</tr>
	            <tr>
	                <td width="100" class="td-title">
						年龄要求：</td>
	                <td class="td-input" id="label1">
	                	<input type="text" id="ageRequirement" value="${volunteerRecruit.ageRequirement }" name="ageRequirement" maxlength="10" class="input-text w510"/>
	                </td>
	            </tr>
	            <tr>
					<td width="100" class="td-title">学历要求：</td>
					<td class="td-input" id="label2">
						<input type="text" id="educationRequirement" value="${volunteerRecruit.educationRequirement }" name="educationRequirement" class="input-text w510" maxlength="10"/>
					</td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">招募条件：</td>
		                <td class="td-input">
		                    <div class="editor-box">
		                        <textarea name="recruitCondition" rows="4" class="textareaBox" style="width: 500px;resize: none">${volunteerRecruit.recruitCondition }</textarea>
		                    </div>
		                </td>
		        </tr>
		        <tr>
	                <td width="100" class="td-title">志愿者权益：</td>
		                <td class="td-input">
		                    <div class="editor-box">
		                        <textarea name="recruitInterest" rows="4" class="textareaBox" style="width: 500px;resize: none">${volunteerRecruit.recruitInterest }</textarea>
		                    </div>
		                </td>
		        </tr>
		        <tr>
	                <td width="100" class="td-title">团队简介：</td>
		                <td class="td-input">
		                    <div class="editor-box">
		                        <textarea name="teamIntroduce" rows="4" class="textareaBox" style="width: 500px;resize: none">${volunteerRecruit.teamIntroduce }</textarea>
		                    </div>
		                </td>
		        </tr>
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input class="btn-publish" type="button" onclick="save()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>