<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>我想入驻文化云大咖圈</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
        var assnId = '${assnId}';
        
      	//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '文化云大咖圈，精彩连连看';
        	appShareDesc = '众多活跃文艺团体、匠人济济一堂';
        	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
        	
    		injs.setAppShareButtonStatus(true);
    	}
        
      	//判断是否是微信浏览器打开
        if (is_weixin()) {

            //通过config接口注入权限验证配置
            wx.config({
                debug: false,
                appId: '${sign.appId}',
                timestamp: '${sign.timestamp}',
                nonceStr: '${sign.nonceStr}',
                signature: '${sign.signature}',
                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
            });
            wx.ready(function () {
            	wx.onMenuShareAppMessage({
                    title: "文化云大咖圈，精彩连连看",
                    desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "众多活跃文艺团体、匠人济济一堂",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        
        };
        
        $(function(){
        	//加载社团类别
	        $.post("${path}/tag/getChildTagByType.do",{code:"ASSOCIATION_TYPE"}, function (data) {
	            if (data != '' && data != null) {
	                var list = eval(data);
	                var ulHtml = '';
	                for (var i = 0; i < list.length; i++) {
	                    var dict = list[i];
	                    ulHtml += '<li data-option="' + dict.tagId + '"><p>' + dict.tagName + '</p></li>';
	                }
	                $('#assnTypeUl').html(ulHtml);
	                
	              	//点击菜单选项后，隐藏菜单，并赋值给input
	       			$(".joinwhy-btn-list>ul>li").click(function(e) {
	       				e.stopPropagation();
	       				var c_input = $(this).find("p").text();
	       				$("#communityNature").val(c_input);
	       				$("#assnType").val($(this).attr("data-option"));
	       				$(".joinwhy-btn-list").removeClass("joinwhy-btn-list-show")
	       				$(".joinwhy-btn-list").hide();
	       			})
	            }
	        },"json");
        	
   			//菜单隐藏显示
   			$(".joinwhy-btn").click(function(e) {
				e.stopPropagation();
				if($(".joinwhy-btn-list").hasClass("joinwhy-btn-list-show")) {
					$(".joinwhy-btn>p").text("选择");
					$(".joinwhy-btn-list").hide();
					$(".joinwhy-btn-list").removeClass("joinwhy-btn-list-show")
				} else {
					$(".joinwhy-btn>p").text("取消");
					$(".joinwhy-btn-list").show();
					$(".joinwhy-btn-list").addClass("joinwhy-btn-list-show")
				}
 			})
        })
        
        //保存信息
	    function applyAssn(){
        	if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatAssn/toAssnApply.do");
        	}else{
        		$("#applyAssnBut").attr("onclick","");
    	        var assnName=$('#assnName').val();
    	        var assnLinkman = $("#assnLinkman").val();
    	        var assnPhone = $("#assnPhone").val();
    	        var assnType = $("#assnType").val();
    	        var assnIntroduce = $("#assnIntroduce").val();
    	        
    	        //社团名称
    	        if(assnName==undefined||assnName.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示', '社团名称为必填项！');
    	            $('#assnName').focus();
    	            return;
    	        }else{
    	            if(assnName.length>20){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"社团名称只能输入20字以内！");
    	                $('#assnName').focus();
    	                return false;
    	            }
    	        }
    	        
    	        //社团联系人
    	        if(assnLinkman==undefined||assnLinkman.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            dialogAlert('系统提示',"社团联系人为必填！");
    	            $('#assnLinkman').focus();
    	            return;
    	        }else{
    	            if(assnLinkman.length>20){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"社团联系人只能输入20字以内！");
    	                $('#assnLinkman').focus();
    	                return false;
    	            }
    	        }
    	
    	        //联系电话
    	        if(assnPhone==undefined||assnPhone==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"联系电话为必填项！");
    	            $('#assnPhone').focus();
    	            return;
    	        }
    	        
    	      	//社团类型
    	        if(assnType==undefined||assnType==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"请选择社团类型！");
    	            $('#assnType').focus();
    	            return;
    	        }
    	        
    	      	//社团简介
    	        if(assnIntroduce==undefined||assnIntroduce.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"社团简介为必填！");
    	            $('#assnIntroduce').focus();
    	            return;
    	        }else{
    	            if(assnIntroduce.length>500){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"社团简介只能输入500字以内！");
    	                $('#assnIntroduce').focus();
    	                return false;
    	            }
    	        }
    	      	
    	      	$("#createTuser").val(userId);
    	      	$("#updateTuser").val(userId);
    	      	
    	        //保存申请信息
    	        $.post("${path}/wechatAssn/applyAssociation.do", $("#associationApplyForm").serialize(),function(data) {
                    if (data!=null&&data=='success') {
                    	dialogConfirm('系统提示', "申请完成！",function (r){
                        	if(window.injs){	//判断是否存在方法
                        		injs.accessAppPage(11); 
                        	}else{
                        		location.href = '${path}/wechatAssn/toAssnList.do';
                        	}
                        });
                    }else{
                    	$("#applyAssnBut").attr("onclick","applyAssn();");
                    	dialogAlert('系统提示', '申请失败！');
                    }
    	        },"json");
        	}
	    }
    </script>
    
</head>
<body>
	<form id="associationApplyForm">
		<input id="createTuser" name="createTuser" type="hidden" value=""/>
		<input id="updateTuser" name="updateTuser" type="hidden" value=""/>
		<div class="main">
			<%-- <div class="header">
				<div class="index-top">
					<span class="index-top-5" onclick="history.go(-1);">
						<img src="${path}/STATIC/wechat/image/arrow1.png" />
					</span>
					<span class="index-top-2">我想入驻文化云大咖圈</span>
				</div>
			</div> --%>
			<div class="content padding-bottom0">
				<div class="join-community padding-top20">
					<ul>
						<li>
							<div class="p2-font f-left">
								<p class="w2">名称</p>
							</div>
							<span class="f-left fs30 margin-left10">:</span>
							<div class="f-left">
								<input id="assnName" name="assnName" type="text" placeholder="请输入名称" maxlength="20"/>
							</div>
							<div style="clear: both;"></div>
						</li>
						<li>
							<div class="p2-font f-left">
								<p class="w2">性质</p>
							</div>
							<span class="f-left fs30 margin-left10">:</span>
							<div class="f-left">
								<input id="communityNature" class="w300" type="text" placeholder="请选择类型" readonly="readonly"/>
								<input id="assnType" name="assnType" type="hidden"/>
							</div>
							<div class="f-right joinwhy-btn">
								<p>选择</p>
								<div class="joinwhy-btn-list">
									<ul id="assnTypeUl"></ul>
								</div>
							</div>
							<div style="clear: both;"></div>
						</li>
						<li>
							<div class="p2-font f-left">
								<p class="w3">联系人</p>
							</div>
							<span class="f-left fs30 margin-left10">:</span>
							<div class="f-left" style="width: auto;">
								<input type="text" placeholder="请输入联系人" id="assnLinkman" name="assnLinkman" maxlength="20"/>
							</div>
	
							<div style="clear: both;"></div>
						</li>
						<li>
							<div class="p2-font f-left">
								<p class="w2">电话</p>
							</div>
							<span class="f-left fs30 margin-left10">:</span>
							<div class="f-left">
								<input type="text" placeholder="请输入电话" id="assnPhone" name="assnPhone" maxlength="11"/>
							</div>
							<div style="clear: both;"></div>
						</li>
						<li>
							<div class="p2-font f-left">
								<p class="w2">简介</p>
							</div>
							<span class="f-left fs30 margin-left10">:</span>
							<div class="f-left">
								<textarea placeholder="请输入简介" name="assnIntroduce" id="assnIntroduce"  maxlength="500" style="resize: none;width: 500px;height: 200px;margin-left: 30px;border: none;font-size: 28px;line-height: 50px;"></textarea>
							</div>
							<div style="clear: both;"></div>
						</li>
					</ul>
					<p class="c5e6d98">TIPS：如果你的社团也对加入文化云感兴趣，请提交相关信息，我们的工作人员会尽快与你联系</p>
				</div>
			</div>
			<div class="footer">
				<div id="applyAssnBut" style="border: none;text-align: center;line-height: 100px;" class="w100-pc height100 fs30 bg7279a0 cfff" onclick="applyAssn()">提交</div>
			</div>
		</div>
	</form>
</body>
</html>