<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>发布点评</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-comment.js"></script>

<script type="text/javascript">
	var moldId = '${moldId}';
	var type = '${type}';
	var userId = '${sessionScope.terminalUser.userId}';
	var chooseCount = 9;	//可上传数
	
	//发表评论
	function addComment(){
		if (userId ==null || userId == '') {
            window.location.href = "${path}/muser/login.do";
        }else{
        	var commentRemark = $("#commentRemark").val();
    		if(commentRemark.trim()==""){
    			dialogAlert('评论提示', '评论内容不能为空！');
    			return;
    		}
    		if(commentRemark.length<4){
    			dialogAlert('评论提示', '评论内容不能少于4个字！');
    			return;
    		}
    		
    		//评论图片
    		var commentImgUrl = '';
    		$("#commentImgList li").each(function(index, element) {
    			commentImgUrl += $(element).attr("commentImgUrl") + ";";
    		});
    		if(commentImgUrl.length>0){
    			commentImgUrl = commentImgUrl.substring(0, commentImgUrl.length-1);
    		}
    		
    		var data = {};
    		if(type==1){
    			var commentStar = $("#commentStar").val();
    			if(commentStar==""){
    				dialogAlert('评论提示', '评论星级不能为空！');
    				return;
    			}
    			data = {
    					commentUserId:userId,
    					commentRemark:commentRemark,
    					commentType:type,
    					commentRkId:moldId,
    					commentImgUrl:commentImgUrl,
    					commentStar:commentStar
    					};
    		}else if(type==2){
    			data = {
    					commentUserId:userId,
    					commentRemark:commentRemark,
    					commentType:type,
    					commentRkId:moldId,
    					commentImgUrl:commentImgUrl
    					};
    		}
    		
    		$.post("${path}/wechat/addComment.do",data, function(data) {
    			if(data.status==0){
    				if(type==1){
    					window.location.href="${path}/wechatVenue/venueDetailIndex.do?venueId="+moldId+"&type=fromComment";
    				}else if(type==2){
    					window.location.href="${path}/wechatActivity/preActivityDetail.do?activityId="+moldId+"&type=fromComment";
    				}
    			}else if(data.status==10107){
    				dialogAlert('评论提示', '超过5次评论！');
    			}else if(data.status==10108){
    				dialogAlert('评论提示', '该评论中存在着敏感词！');
    			}else if(data.status==1){
    				dialogAlert('评论提示', '评论添加失败！');
    			}
    		},"json");
        }
	}
	
	//上传图片
	function uploadImg(){
		//判断是否是微信浏览器打开
        if (!is_weixin()) {
            dialogAlert('系统提示', '请用微信浏览器打开！');
            return;
        }
		
		if (userId ==null || userId == '') {
            window.location.href = "${path}/muser/login.do";
        }
		
		chooseCount = 9 - $(".add-comment-list li").length;
		
		wx.chooseImage({
			count: chooseCount,	// 默认9
	    	sizeType: ['compressed'],	// 指定是原图还是压缩图，默认二者都有
		    success: function (res) {
		        var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
		        syncUpload(localIds);
		    }
		});
	}
	
	//上传多张图片，需要将之前并行上传改成串行。
	function syncUpload(localIds){
		var localId = localIds.pop();
		wx.uploadImage({
		    localId: localId,
		    isShowProgressTips: 1, // 默认为1，显示进度提示
		    success: function (res) {
                var serverId = res.serverId; // 返回图片的服务器端ID
                $.post("${path}/wechat/wcUpload.do",{mediaId:serverId,userId:userId,uploadType:0}, function(data) {
                	if(data!=1){
                		var imgUrl = getIndexImgUrl(getImgUrl(data),"_150_150");
                		$("#commentImgList").append("<li commentImgUrl='"+getImgUrl(data)+"'>" +
						                			    "<img src='"+imgUrl+"' ontouchstart='previewImage(\""+getImgUrl(data)+"\");' height='155' width='155'>" +
						                			    "<span class='rm-comment'></span>" +
						                			"</li>");
                		imgButton();	//判断图片按钮是否显示
                		
                		//删除按钮
                		$(".rm-comment").on("touchstart", function() {
                			$(this).parent('li').remove();
                			imgButton();
                		})
                		
                		//其他对serverId做处理的代码
                        if(localIds.length > 0){
        					syncUpload(localIds);
                        }
                	}else{
                		dialogAlert('系统提示', '上传失败！');
                	}
                },"json");
            }
		});
	}
	
	//图片预览
	function previewImage(url){
		wx.previewImage({
		    current: url, // 当前显示图片的http链接
		    urls: [url]
		});
	}
	
	//判断图片按钮是否显示
	function imgButton(){
		var clnum = $(".add-comment-list li");
		if (clnum.length >= 9) {
			$(".add-comment-button").hide();
		} else {
			$(".add-comment-button").show();
		}
	}
</script>

<style>
	html,body,.main{height:100%}
	.content {padding: 0;padding-top: 100px;}
</style>

</head>
<body>
	<input id="userId" type="hidden" value="${sessionScope.terminalUser.userId}"/>
	<div class="main">
		<div class="header">
			<div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">添加评论</span>
				<span class="index-top-4" onclick="addComment();">发布</span>
			</div>
		</div>
		<div class="content">
			<textarea class="add-comment" placeholder="请留下您的评论" id="commentRemark" maxlength="500"></textarea>
			<div class="add-comment-list">
				<ul id="commentImgList"></ul>
				<div class="add-comment-button" ontouchstart="uploadImg();">
					<img src="${path}/STATIC/wechat/image/add-comment.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
</body>
<script>
	//判断是否是微信浏览器打开
	if (is_weixin()) {
		
	    //通过config接口注入权限验证配置
	    wx.config({
	        debug: false,
	        appId: '${sign.appId}',
	        timestamp: '${sign.timestamp}',
	        nonceStr: '${sign.nonceStr}',
	        signature: '${sign.signature}',
	        jsApiList: ['chooseImage','uploadImage','previewImage']
	    });
	}else{
		$(".add-comment-button").addClass("uploadClass");
		$(".add-comment-button").attr("ontouchstart","");
	}
	
	//判断是否显示星级
	if(type==1){
		$("#commentStarDiv").show();
	}
</script>
</html>