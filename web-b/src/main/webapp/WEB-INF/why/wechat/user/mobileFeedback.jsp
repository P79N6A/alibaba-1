<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- <title>帮助与反馈</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-feedBack.js"></script>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';
		var chooseCount = 3;	//可上传数

        $(function(){

        	imgButton();	//显示添加按钮

            $(".radius5").on("focus", function(){
                window.scroll(0,0);
            });
            
    	});
        
        function submitFeed() {
        	if (userId ==null || userId == '') {
                window.location.href = "${path}/muser/login.do?type=${path}/wechatUser/preFeedBack.do";
                return;
            }
        	
            var feedContent = $("#feedContent").val();
            if(feedContent.trim()==""){
                dialogAlert('系统提示', '反馈意见不能为空！');
                return ;
            }
            
            //图片
            var feedImgUrl = '';
    		$(".fack_block .upimg ul li").each(function(index, element) {
    			feedImgUrl += $(element).attr("feedImgUrl") + ";";
    		});
    		if(feedImgUrl.length>0){
    			feedImgUrl = feedImgUrl.substring(0, feedImgUrl.length-1);
    		}
            $.post("${path}/wechatUser/addWechatFeedBack.do",{feedContent:feedContent,userId:userId,feedImgUrl:feedImgUrl}, function(data) {
                if(data.status==0){
                    dialogAlert('系统提示', '感谢您的宝贵意见！');
                    emptyHtml();
                }else{
                    dialogAlert('系统提示', '反馈失败！');
                }
            },"json");
        }

        //上传图片
    	function uploadImg(){
    		//判断是否是微信浏览器打开
            if (!is_weixin()) {
                dialogAlert('系统提示', '请用微信浏览器打开！');
                return;
            }
        	
    		if (userId ==null || userId == '') {
    			window.location.href = "${path}/muser/login.do?type=${path}/wechatUser/preFeedBack.do";
                return;
            }
    		
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
                    		$(".fack_block .upimg ul").append("<li feedImgUrl='"+getImgUrl(data)+"'>" +
    					                			    "<div class='pict'><img src='"+imgUrl+"' ontouchstart='previewImage(\""+getImgUrl(data)+"\");'></div>" +
    					                			    "<a class='m_close'><img src='../STATIC/wx/image/mobile_close.png'></a>" +
    					                			"</li>");
                    		chooseCount--;
                    		imgButton();	//判断图片按钮是否显示
                    		
                    		/**删除图片**/
                    		$(".fack_block .upimg ul").on('touchstart','li .m_close',function(){
	                  			  $(this).parent().remove();
	                  			  imgButton();
	                  			  chooseCount++;
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
    	
    	//清空页面
    	function emptyHtml(){
    		$("#feedContent").val('');
    		$(".fack_block .upimg ul").html('');
    		chooseCount = 3;
			imgButton();
			
			if (!is_weixin()) {
				uploader.reset();
			}
    	}
    </script>
</head>
<body>
	<input id="userId" type="hidden" value="${sessionScope.terminalUser.userId}"/>
	<div class="common_container">
	     <div class="use_help"><a href="${path}/wechat/help.do">使用帮助</a></div>
	     <div class="fack_block">
	       <div class="title">欢迎留下宝贵意见</div>
	       <textarea class="radius5" placeholder="您遇到什么问题，或有什么功能建议，欢迎您提给我们，谢谢！" id="feedContent" name="feedContent" style="border: 1px  solid"></textarea>
	       <div class="upimg clearfix" style="margin:0px 0px 20px;">
				<ul class="clearfix"></ul>
				<div class="upload_btn" ontouchstart="uploadImg();" style="margin-top:30px;">
				  <a><img src="../STATIC/wx/image/photo.png" width="50" height="41"/></a>
				</div>
		   </div>
	       <button type="button" class="radius5" onclick="submitFeed()">提交</button>
	       <p class="tip">您提交的建议已反馈、谢谢您的支持！</p>
	     </div>
	</div>
	<script type="text/javascript">
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
			$(".upload_btn").addClass("uploadClass");
			$(".upload_btn").attr("ontouchstart","");
			
		    // Web Uploader实例
		    var uploader;
		}
	</script>
</body>
</html>