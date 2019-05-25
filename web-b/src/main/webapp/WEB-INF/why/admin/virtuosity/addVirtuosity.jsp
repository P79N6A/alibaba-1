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
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        function save(){
        	
        	var isCutImg =$("#isCutImg").val();
            if("N"==isCutImg) {
                dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                });
                return;
            }
        	
        	$.post("${path}/virtuosity/saveVirtuosity.do", $("#virtuosityForm").serialize(),function(data){
        		if(data == "success"){
        			dialogConfirm("提示","保存成功！",function(){
                        window.location.href="${path}/virtuosity/virtuosityIndex.do";        				
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
        			if(initWidth<750 || initHeigth<500){
        				dialogAlert("提示","请上传尺寸不小于750*500(px)的图片",function(){
        				});
        				$("#isCutImg").val("N");
        				return;
        			}
        			/* $("#imgHeadPrev").html(getImgHtml(getImgUrl(url))); */
        			var cutImageWidth=750;
        			var cutImageHeigth=531;
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
    						$("#antiqueImgUrl").val(hiddenImgUrl);
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
        	
        	//加载分类
        	$.post("${path}/antiqueType/queryAntiqueType.do",function(data){
        		$.each(data,function(i,dom){
        			$("#antiqueTypeName").append("<option value='"+dom.antiqueTypeId+"'>"+dom.antiqueTypeName+"</option>")
        		})
        	})
        	//加载朝代
        	$.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=DYNASTY",function(data){
        		var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
        		    $("#dictName").append("<option value='"+dictId+"'>"+dictName+"</option>")
                }
        	})
            //上传视频预览
			$("#whyVideoImg").click(function() {
				if($("#containerImg1").attr("src") != '') {
					document.getElementById('containerImg1').play()
					$(this).hide()
				}
			})
			
			//编辑时视屏的回显
			var antiqueVideoUrl = $("#antiqueVideoUrl").val();
        	if(antiqueVideoUrl){
        		$("#ossfile2").prepend("<div name='aliFile' style='position:relative'><video style='width: 260px;' src='"+antiqueVideoUrl+"' controls=''></video>"+
        				'<img  onclick="aliRemoveVideo(this)" class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />'+
        				"</div>"
        		)
        	}
			
        	
        });
        
        function aliRemoveVideo(rm){
        	rm.parentNode.parentNode.removeChild(rm.parentNode);
        	
        	$("#antiqueVideoUrl").val('')
        }

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
        	var imgUrl=$("#antiqueImgUrl").val();
        	if(imgUrl == undefined || imgUrl == "" || imgUrl == null){
        		$("#imgHeadPrev").html("<img src='${path}/STATIC/image/defaultImg.png'  id='userHeadImg'>");
        	}else{
        		imgUrl=getImgUrl(imgUrl);
        		$("#imgHeadPrev").html("<img style='width:300px; height:200px;' src='"+imgUrl+"'>");
        		removeMsg("pictureLabel");
        	}
        };
        
        //视频回调函数
        function uploadVideoCallBack(up, file, info){
        	var aliVideoUrl = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info; 
        	$("#antiqueVideoUrl").val(aliVideoUrl);
        	$("#ossfile2").html(
        	
        			"<div name='aliFile' style='position:relative'><video style='width: 260px;' src='"+aliVideoUrl+"' controls=''></video>"+
            				'<img  onclick="aliRemoveVideo(this)" class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" />'+
            				"</div>"
        	)
    	}
        
        //初始化
        window.onload = function() { 
    		aliUploadFiles('antiqueVideosCover1Webupload',uploadVideoCallBack,1,true,'H5');
    	}
        
    </script>
    <style type="">
    	.housel {width: 50%;height: 40px;border: none;color: #444444;font-family: \5FAE\8F6F\96C5\9ED1;margin-left: 1%;margin-top: 1px;border: solid 1px #ACB4C3;}
    </style>
</head>

<body>
	<form action="${path}/virtuosity/saveVirtuosity.do" id="virtuosityForm" method="post">
	    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理  &gt; 艺术场馆管理  &gt; 新增艺术鉴赏
	    </div>
	    <div class="site-title">新增艺术鉴赏</div>
	    <input type="hidden" id="isCutImg" value="Y"/>
	    <input type="hidden" name="antiqueId" id="antiqueId" value="${antique.antiqueId }"/> 
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title">鉴赏名称：</td>
	                <td class="td-input"><input type="text" id="antiqueName" value="${antique.antiqueName }" name="antiqueName" class="input-text w510" maxlength="20"/><span style="color:#596988">（20字以内）</span></td>
	            </tr>
	            <tr>
						<td width="100" class="td-title">封面图：</td>
						<td class="td-upload" id="pictureLabel">
							<table>
								<tr>
									<td>
										<input type="hidden" name="antiqueImgUrl" id="antiqueImgUrl" value="${antique.antiqueImgUrl  }">
										<input type="hidden" name="uploadType" value="Img" id="uploadType" />
										<div class="img-box">
											<div id="imgHeadPrev" class="img"> </div>
										</div>
										<div class="controls-box">
											<div style="height: 46px;">
												<div class="controls" style="float:left;">
													<input type="file" name="file" id="file">
												</div>

												<span class="upload-tip">建议尺寸750px*500px</span>
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
	                <td width="100" class="td-title">分类：</td>
	                <td>
	                   <select name="antiqueTypeId" id="antiqueTypeName" class="housel">
	                        <c:if test="${ !empty antique.antiqueSpecification }">
	                           <option value="${antique.antiqueTypeId}">${antique.antiqueSpecification }</option>
	                        </c:if>
	                        <c:if test="${ empty antique.antiqueSpecification }">
	                           <option>----请选择分类----</option>
	                        </c:if>
	                    </select>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">年代：</td>
	                <td>
	                   <select name="antiqueYears" id="dictName" class="housel">
	                       <c:if test="${ !empty antique.dynastyName }">
	                           <option value="${antique.antiqueYears}">${antique.dynastyName }</option>
	                        </c:if>
	                        <c:if test="${ empty antique.dynastyName }">
	                           <option>---请选择年代---</option>
	                        </c:if>
	                    </select>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title">上传视频:</td>
	                <td>
				        <div id="antiqueVideos">
					        <table width="100%" class="form-table assnResVideos">
								<tr>
									<td>
										<div class="whyUploadVedio assnResVideoUrlsDiv" id="antiqueVideosCover1Webupload">
										    <input type="hidden" name="antiqueVideoUrl" id="antiqueVideoUrl" value="${antique.antiqueVideoUrl }"/> 
											<div class="clearfix">
												<div id="container2" style="float: left;overflow: hidden;margin: 10px 10px 10px 0;">
													<a id="selectfiles2" class="selectFiles btn">选择文件</a>
												</div>
												<div id="ossfile2" style="width: 300px;float: left;" class="clearfix">你的浏览器不支持flash,Silverlight或者HTML5！</div>
											</div>
										</div>
									</td>
								</tr>
					        </table>
					    </div>
	                </td>
	            </tr>
		        <tr>
	                <td width="100" class="td-title">简介：</td>
		                <td class="td-input">
		                    <div class="editor-box">
		                        <textarea name="antiqueRemark" rows="4" class="textareaBox" style="width: 500px;resize: none">${antique.antiqueRemark }</textarea>
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