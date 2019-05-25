<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>馆藏详情</title> -->

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css">
    		
    		
    		
    <script type="text/javascript" src="${path}/STATIC/wechat/js/wechat.js"></script>
  
    <script type="text/javascript" src="${path}/STATIC/wx/js/wxcommon.js"></script>
  

    <script src="${path}/STATIC/wechat/js/voice/audio.min.js"></script>
    
    <script>
    
    
		$(function() {
			var list1Len = $(".list1>li").length;
			var list1Width = $(".list1>li").width() + 20;
			list1Width = list1Len * list1Width - 20;
			$(".list1").css("width", list1Width);

			var list2Len = $(".list2>li").length;
			var list2Width = $(".list1>li").width() + 20;
			list2Width = list2Len * list2Width - 20;
			$(".list2").css("width", list2Width);

			//赞 按钮 点击事件
			$(".artDis-love").click(function() {
				/**if($(this).hasClass("love-on")) {
					$(this).find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love.png")
					$(this).removeClass("love-on")
				} else {
					$(this).find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png")
					$(this).addClass("love-on")
				}**/
				addWantGo();
			})
		})
	</script>
    
    <script type="text/javascript">
      
	    var title;
		var desc="来佛山文化云一起参与艺术赏鉴，发现文化之美";
		var imgUrl='${basePath}/STATIC/wx/image/share_120.png'
        var antiqueId = '${antiqueId}';
        var isWifi = true;
        
        $(function () {
            $.post("${path}/wechatAntique/antiqueAppDetail.do", {
                antiqueId: antiqueId,
                userId:userId
            }, function (data) {
                if (data.status == 0) {
                	
                	title="我正在佛山文化云上欣赏“"+data.data[0].antiqueName+"”";

        			//分享文案
        	    	appShareTitle = title;
        	    	appShareDesc = desc;
        	    	appShareImgUrl = imgUrl;
                	
                	if(window.injs){	//判断是否存在方法
            			injs.changeNavTitle(data.data[0].antiqueName);
                        appShareTitle = title;
                        appShareDesc = desc;
                        appShareImgUrl = imgUrl;
                        appShareLink = '${basePath}/wechatAntique/preAntiqueDetail.do?antiqueId=${antiqueId}';
            			injs.setAppShareButtonStatus(true);
                	
            		}else{
            			$(document).attr("title",data.data[0].antiqueName);
            		}
                	
            		var antiqueVideoUrl=data.data[0].antiqueVideoUrl;
            		
            		//判断是否是微信浏览器打开
            		if (is_weixin()) {
            			//通过config接口注入权限验证配置
            			wx.config({
            				debug: false,
            				appId: '${sign.appId}',
            				timestamp: '${sign.timestamp}',
            				nonceStr: '${sign.nonceStr}',
            				signature: '${sign.signature}',
            				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone','getNetworkType']
            			});
            			wx.ready(function () {
            				wx.onMenuShareAppMessage({
            					title: title,
            					desc: desc,
            					imgUrl: imgUrl
            				});
            				wx.onMenuShareTimeline({
            					title: title,
            					imgUrl: imgUrl
            				});
            				wx.onMenuShareQQ({
            					title: title,
            					desc: desc,
            					imgUrl: imgUrl
            				});
            				wx.onMenuShareWeibo({
            					title: title,
            					desc: desc,
            					imgUrl: imgUrl
            				});
            				wx.onMenuShareQZone({
            					title: title,
            					desc: desc,
            					imgUrl: imgUrl
            				});
            				wx.getNetworkType({
   	    		        	    success: function (res) {
   	    		        	        var networkType = res.networkType; // 返回网络类型2g，3g，4g，wifi
   	    		        	        if(networkType!='wifi'){
   	    		        	        	isWifi = false;
   	    		        	        	if(antiqueVideoUrl){
   	    		        	        		dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
   	    		        	        	}
   	    		        	        }
   	    		        	    }   
   	    		        	});
            			});
            		}else{
    					//APP判断网络
    					if(window.injs){
    						if(injs.currentNetworkState()!=1){
    							isWifi = false;
		        	        	if(antiqueVideoUrl){
		        	        		dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
		        	        	}
    						}
    					}
    				}
            		
            		$("#antiqueName").html(data.data[0].antiqueName)
            		
            		var antiqueImgUrl=getIndexImgUrl(data.data[0].antiqueImgUrl, "_750_500");
            		
            		if(antiqueVideoUrl){
    					$(".artTopPh").append("<video id='assnVideo' src='"+antiqueVideoUrl+"' poster='"+antiqueImgUrl+"' style='width:750px;height:531px;' controls webkit-playsinline></video>" 
    										  );
    					
    					$("#antiqueImgUrl").hide();
    					
    					$('#assnVideo').on('play', function() {
   							if(!isWifi){
   								dialogAlert("提示", "您的流量正在燃烧哟~~");
   							}
   						});
    				}else{
    					$("#antiqueImgUrl").attr("src",antiqueImgUrl);
    				}
                	
                
                	
                	var antiqueSpectfication=data.data[0].antiqueSpectfication;
                	
                	if(antiqueSpectfication)
                	{
                		$("#antiqueSpectfication").html(antiqueSpectfication);
                		
                		$("#antiqueSpectfication").show();
                	}
                	
                	var isWantGo=data.data[0].isWantGo;
                	
                	if(isWantGo>0)
                	{
                		$(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
    					$(".artDis-love").addClass("love-on");
                	}
                	
                	var antiqueDynastyName=data.data[0].antiqueDynastyName;
                	
                	if(antiqueDynastyName)
                	{
                		$("#antiqueDynastyName").html(antiqueDynastyName);

                		$("#antiqueDynastyName").show();
                	}
                	
                	 var antiqueRemark = data.data[0].antiqueRemark;
                	 /*解决后台换行在前台显示问题*/
                	 var antique = antiqueRemark.replace(/\r\n/g,"<br/>")
                	 $(".artDisLT").append(antique);
                	 
                	 var wantCount=data.data[0].wantCount;
                	 
                	 if(wantCount>0)
                	 
                	 $(".loveNum").text(wantCount);
                	 
                	 if (data.data[0].antiqueVoiceUrl.length > 0) {
	                    	$("#venueVoiceDiv").show();
	                   //  document.getElementById("div").style.display="";
	                     $("#venueVoice").attr("src", data.data[0].antiqueVoiceUrl);
	                     
	                     audiojs.events.ready(function() {
	                 		audiojs.createAll();
	                 	});
	                 }
                	 
                	 var venueName =data.data[0].venueName;
                	 
                	 if(venueName){
                		 
                		 $("#venueName").html(venueName);
                		 $("#venueName").show();
                	 }
                	
                  /**  dataForm.antiqueSpectfication = data.data[0].antiqueSpectfication;
                    dataForm.antiqueRemark = data.data[0].antiqueRemark;
                    dataForm.antiqueImgUrl = data.data[0].antiqueImgUrl;
                    dataForm.antiqueName = data.data[0].antiqueName;
                    dataForm.antiqueTime = data.data[0].antiqueTime;
                    dataForm.antiqueId = data.data[0].antiqueId;
                    dataForm.venueName = data.data[0].venueName;
                    if (data.data[0].antiqueVoiceUrl.length > 0) {
//                        	$("#venueVoiceDiv").show();
                        document.getElementById("div").style.display="";
                        $("#venueVoice").attr("data-href", data.data[0].antiqueVoiceUrl);
                    }
                    **/
                }

            }, "json").success(function () {
                formatStyle("antiqueMemo");
            })
            
            $(".artDis-share").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			})
			
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
         
        });
        
        //点赞（我想去）
        function addWantGo() {
            if (userId == null || userId == '') {
            	//判断登陆
	        	publicLogin("${basePath}wechatAntique/preAntiqueDetail.do?antiqueId="+antiqueId);
            }else{
            	$.post("${path}/wechatUser/addUserWantgo.do", {
            		relateId: antiqueId,
                    userId: userId,
                    type: 5
                }, function (data) {
                    if (data.status == 0) {
                    	$(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love-on.png");
    					$(".artDis-love").addClass("love-on");
    					var num = $(".loveNum").text();
    					if(!num)
    						$(".loveNum").text(1);
    					else
    						$(".loveNum").text(eval(num)+1);
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
                        	relateId: antiqueId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                            	$(".artDis-love").find("img").attr("src", "${path}/STATIC/wxStatic/image/feiyi/love.png");
            					$(".artDis-love").removeClass("love-on");
            					var num = $(".loveNum").text();
            					if(num)
            					{
            						if(eval(num)==1)
            						{
            							$(".loveNum").text('');
            						}
            						else
            							$(".loveNum").text(eval(num)-1);
            					}
            					
                            }
                        }, "json");
                    }
                }, "json");
            }
        }

        //富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
            	var $this = $(this);
            	$this.css({"max-width": "710px"});
            });
            $cont.find("p,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "line-height": "44px",
                    "color": "#7C7C7C",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("span").each(function () {
                var $this = $(this);
                $this.css({
                	"font-size": "24px",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("a").each(function () {
                var $this = $(this);
                $this.css({
                	"text-decoration": "underline",
                	"color": "#7C7C7C"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }

    </script>

</head>

<body>
<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="artDisMain">
			<div class="content" style="padding-bottom: 70px;">
				<div class="artTopPh" style="background-color:#000">
					<img  id="antiqueImgUrl" src="" style="max-height: 500px;max-width: 750px;display:block;margin:auto;" />
					<div id="venueName" class="artTopPhTag" style="display: none;"></div>
				</div>
				<div class="artDetailTitle">
					<p id="antiqueName"></p>
					<ul>
						<li id="antiqueSpectfication" style="display: none;"></li>
						<li id="antiqueDynastyName" style="display: none;"></li>
						<div style="clear: both;"></div>
					</ul>
					<div style="clear: both;"></div>
				</div>

				<div id="venueVoiceDiv" style="margin: 0 30px 20px;display: none;">
					<p style="float: left;font-size: 24px;color: #262626;margin-right: 20px;margin-left: 5px;line-height: 56px;">听解说</p>
					<audio id="venueVoice" src="" preload="auto"></audio>
					<div style="clear: both;"></div>
				</div>
				

				<!-- <div class="artPhoto"  style="margin-top: 20px;">
					<p>图片</p>
					<div class="artPhotoListDiv">
						<ul class="artPhotoList list1">
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<div style="clear: both;"></div>
						</ul>
					</div>
				</div>
				<div class="artPhoto">
					<p>图片</p>
					<div class="artPhotoListDiv">
						<ul class="artPhotoList list2">
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<li>
								<img src="image/tsph.jpg" />
							</li>
							<div style="clear: both;"></div>
						</ul>
					</div>
				</div>
				 -->
				<div class="artDis" style="border-top: 15px solid #eee;" >
					<p class="artDisTitle">简介</p>
					<p class="artDisLT" id="antiqueMemo">
					
					</p>
				</div>
			</div>

			<!--借用非遗底部按钮样式-->
			<div class="artFooter">
				<div class="artDis-btn">
					<div class="artDis-share">
						<p><img src="${path}/STATIC/wxStatic/image/feiyi/keep.png" alt="" style="vertical-align: middle;margin-right: 10px;" /><span>分享</span></p>
					</div>
					<div class="artDis-love">
						<p><img src="${path}/STATIC/wxStatic/image/feiyi/love.png" alt="" style="vertical-align: middle;margin-right: 10px;" /><span>赞</span><span class="loveNum"></span></p>
					</div>

					<div style="clear: both;"></div>
				</div>
			</div>
		</div>
</body>
</html>