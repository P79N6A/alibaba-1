<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel='stylesheet' href='${path}/STATIC/css/reset.css'/>
    <link rel='stylesheet' href='${path}/STATIC/css/culture-publisher.css'/>
    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
		var copyText = "模板一";	
    	var activityId = '${activityId}';
    	var publisherId = '${cmsActivityPublisher.publisherId}';
    	var activity;
    	var userId = '${sessionScope.user.userId}';
    	var otherHtml = '';		//自定义模板
    	var publisherEditor;	//文本编辑器
		
        $(function () {
    		var winH = parseInt($(window).height()-259);
        	publisherEditor = CKEDITOR.replace('modelMain',{height:winH,toolbar:[
						['SelectAll','Maximize','-','Source','-','NewPage','Preview'],
						['Cut','Copy','Paste','PasteText','PasteFromWord'],
						['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
						['Undo','Redo','-','Find','Replace','-','RemoveFormat'],
						['Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton'],
						'/',
						['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
						['Image','Flash','Table','HorizontalRule','Smiley','SpecialChar'],
						['Link','Unlink','Anchor'],
						['Styles','Font','FontSize','BGColor']
        	]});
        	
        	//获取活动信息
        	$.post("${path}/activityPublisher/activityDetail.do", {activityId: activityId}, function (data) {
                if (data.status == 0) {
                	activity = data.data[0];
                }
        	}, "json");
        	
            $("input[name=template-radio]").change(function() {
       			loadHtml($(this).val());
       			copyText = $(this).parent().find("span").text();
        	});
            
        	loadHtml(1);
        });
    	
        //加载模板
        function loadHtml(type){
        	$("#hideDiv").empty();
        	var activityIconUrl = getIndexImgUrl(activity.activityIconUrl, "_750_500");
        	var activityTime = activity.activityStartTime.replace("-",".").replace("-",".");
            if (activity.activityEndTime.length != 0&&activity.activityStartTime!=activity.activityEndTime) {
            	activityTime += "&nbsp;-&nbsp;"+activity.activityEndTime.replace("-",".").replace("-",".");
            }
        	if(type == 1){	//模板一
        		$("#hideDiv").html("<section style='font-family: \"微软雅黑\";width: 345px;margin: auto;'>" +
					        			"<section style='width: 100%;text-align: center;margin: auto;'>" +
					        				<%--"<img src='${basePath}/STATIC/image/publisher/keep-why.png' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +--%>
					        				"<img src='"+activityIconUrl+"' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +
					        				"<img src='${basePath}/STATIC/image/publisher/line1.png' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +
					        				"<section style='width: 100%;margin: 0px auto;position: relative;background: url(${basePath}/STATIC/image/publisher/mc-1.png)no-repeat top center;background-size: 100%;'>" +
					        					"<p style='text-align: center;font-size: 1.4em;color: #fff;padding: 0.1em 0 0;margin:0;line-height:1.5em'>"+activity.activityName+"</p>" +
					        				"</section>" +
					        				"<section style='padding:10px;margin-bottom: 35px;border-bottom: 1px solid #aaa;border-left: 1px solid #aaa;border-right: 1px solid #aaa;'>" +
						        				"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon1.png' style='margin-right: 1em;width:1em;'/>活动日期："+activityTime+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon2.png' style='margin-right: 1em;width:1em;'/>活动时间："+activity.timeQuantum+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon3.png' style='margin-right: 1em;width:1em;'/>活动地点："+activity.activitySite+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon4.png' style='margin-right: 1em;width:1em;'/>活动地址："+activity.activityAddress+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon5.png' style='margin-right: 1em;width:1em;'/>参与方式：点击页面下方“阅读原文”抢票</p>" +
					        				"</section>" +
					        				"<img src='${basePath}/STATIC/image/publisher/line2.png' style='width: 100%;margin:0 auto 14px;'/>" +
					        				"<section id='activityMemo' style='text-align: left;width: 100%;margin:0 auto 20px;font-size:1em;line-height:2em;color:#7c7c7c;'>"+activity.activityMemo+"</section>" +
					        				<%--"<img src='${basePath}/STATIC/image/publisher/namecard.jpg' style='width: 100%;'/>" +--%>
					        			"</section>" +
					        			"<section class='model-footer' style='width: 100%;padding-left:0.2em;margin: auto;'>" +
					        				<%--"<img src='${basePath}/STATIC/image/publisher/arrow1.png' style='width:9em;'/>" +--%>
					        			"</section>" +
        							"</section>");
        		formatStyle("activityMemo");
        	}else if(type == 2){	//模板二
        		$("#hideDiv").html("<section style='font-family: \"微软雅黑\";width: 345px;margin: auto;'>" +
							        	"<section style='width: 100%;text-align: center;margin: auto;'>" +
								        	<%--"<img src='${basePath}/STATIC/image/publisher/keep-why.png' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +--%>
					        				"<img src='"+activityIconUrl+"' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +
											"<img src='${basePath}/STATIC/image/publisher/line2-1.png' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;' />" +
											"<section style='width: 100%;margin: 0px auto;position: relative;background: url(${basePath}/STATIC/image/publisher/mc-2.png)no-repeat top center;background-size: 100%;'>" +
												"<p style='text-align: center;font-size: 1.4em;color: #fff;padding: 1.6em 0 0;margin:0;line-height:1.5em;color:#5ba8ff'>"+activity.activityName+"</p>" +
											"</section>" +
											"<section style='padding:10px;margin-bottom: 35px;border-bottom: 1px solid #5ba8ff;border-left: 1px solid #5ba8ff;border-right: 1px solid #5ba8ff;'>" +
						        				"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon1.png' style='margin-right: 1em;width:1em;'/>活动日期："+activityTime+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon2.png' style='margin-right: 1em;width:1em;'/>活动时间："+activity.timeQuantum+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon3.png' style='margin-right: 1em;width:1em;'/>活动地点："+activity.activitySite+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon4.png' style='margin-right: 1em;width:1em;'/>活动地址："+activity.activityAddress+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon5.png' style='margin-right: 1em;width:1em;'/>参与方式：点击页面下方“阅读原文”抢票</p>" +
					        				"</section>" +
											"<img src='${basePath}/STATIC/image/publisher/line2-2.png' style='width: 100%;margin:0 auto 14px;'/>" +
											"<section id='activityMemo' style='text-align: left;width: 100%;margin:0 auto 20px;font-size:1em;line-height:2em;color:#7c7c7c;'>"+activity.activityMemo+"</section>" +
											<%--"<img src='${basePath}/STATIC/image/publisher/namecard.jpg' style='width: 100%;'/>" +--%>
										"</section>" +
										"<section class='model-footer' style='width: 100%;padding-left:0.2em;margin: auto;'>" +
											<%--"<img src='${basePath}/STATIC/image/publisher/arrow2.png' style='width:9em;'/>" +--%>
										"</section>" +
        						   "</section>");
        		formatStyle("activityMemo");
	        }else if(type == 3){
	        	$("#hideDiv").html("<section style='font-family: \"微软雅黑\";width: 345px;margin: auto;'>" +
								        "<section style='width: 100%;text-align: center;margin: auto;'>" +
									        <%--"<img src='${basePath}/STATIC/image/publisher/keep-why.png' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +--%>
					        				"<img src='"+activityIconUrl+"' style='width: 100%;display: block;margin: auto;margin-bottom: 35px;'/>" +
											"<img src='${basePath}/STATIC/image/publisher/line3-1.png' style='width: 50%;display: block;margin: auto;margin-bottom: 35px;'/>" +
											"<section style='width: 100%;margin: 0px auto;position: relative;background: url(${basePath}/STATIC/image/publisher/mc-3.png)no-repeat top center;background-size: 100%;'>" +
												"<p style='text-align: center;font-size: 1.4em;color: #fff;padding: 0.1em 0 1.8em;margin:0;line-height:1.5em'>"+activity.activityName+"</p>" +
											"</section>" +
											"<section style='padding:10px;margin-bottom: 35px;border-bottom: 1px solid #6e769b;border-left: 1px solid #6e769b;border-right: 1px solid #6e769b;border-bottom-left-radius: 15px;border-bottom-right-radius: 15px;'>" +
						        				"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon1.png' style='margin-right: 1em;width:1em;'/>活动日期："+activityTime+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon2.png' style='margin-right: 1em;width:1em;'/>活动时间："+activity.timeQuantum+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon3.png' style='margin-right: 1em;width:1em;'/>活动地点："+activity.activitySite+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon4.png' style='margin-right: 1em;width:1em;'/>活动地址："+activity.activityAddress+"</p>" +
					        					"<p style='text-align: left;margin:0.6em 0em;line-height:1.6em;font-size:1em;'>&emsp;&emsp;<img src='${basePath}/STATIC/image/publisher/icon5.png' style='margin-right: 1em;width:1em;'/>参与方式：点击页面下方“阅读原文”抢票</p>" +
					        				"</section>" +
											"<img src='${basePath}/STATIC/image/publisher/line3-2.png' style='width: 100%;margin:0 auto 14px;'/>" +
											"<section id='activityMemo' style='text-align: left;width: 100%;margin:0 auto 20px;font-size:1em;line-height:2em;color:#7c7c7c;'>"+activity.activityMemo+"</section>" +
											<%--"<img src='${basePath}/STATIC/image/publisher/namecard.jpg' style='width: 100%;'/>" +--%>
										"</section>" +
										"<section class='model-footer' style='width: 100%;padding-left:0.2em;margin: auto;'>" +
											<%--"<img src='${basePath}/STATIC/image/publisher/arrow3.png' style='width:15em;'/>" +--%>
										"</section>" +
	        	                   "</section>");
	        	formatStyle("activityMemo");
        	}else if(type == 4){
        		if(otherHtml!=''){
        			$("#hideDiv").html(otherHtml);
        		}else{
        			$("#hideDiv").html($("#templateContent").val());
        		}
        	}
    		publisherEditor.setData($("#hideDiv").html());
        }
        
        //保存活动万能发布器模板
        function saveTemplate(){
        	if (userId == null || userId == '') {
                window.location.href = '${path}/admin.do';
                return;
            }
        	//修改value值
        	$(".inputText").each(function () {
        		$(this).attr("value",$(this).val());
        	});
        	var data = {
        			publisherId: publisherId,
        			activityId: activityId,
        			templateCreateUser: userId,
        			templateContent: publisherEditor.getData()
                };
        	$.post("${path}/activityPublisher/saveOrUpdateActivityPublisher.do", data, function (data) {
                if (data.code == 200) {
                	dialogAlert("提示", "保存成功！");
                	publisherId = data.publisherId;
                	if($("#radioUl li").length==3){
                		$("#radioUl").append("<li><input type='radio' name='template-radio' value='4'/><span>已保存的样式</span></li>");
                	}
                	otherHtml = publisherEditor.getData();
                	$("input[name=template-radio]").change(function() {
               			loadHtml($(this).val());
               			copyText = $(this).parent().find("span").text();
                	});
                	$("input[name=template-radio]").removeAttr("checked");
                	$("input[name=template-radio][value=4]").prop("checked","checked");
                }
        	}, "json");
        }
        
      	//富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
                var $this = $(this);
                $this.removeAttr("style").attr({"width": "100%"});
                $this.css("display", "block");
            });
            $cont.find("p,span,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "1em",
                    "line-height": "2em",
                    "font-family": "Microsoft YaHei"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }
        
    </script>

</head>

<body>
	<!-- 模板选择 -->
	<div class="model-head" style="font-family: '微软雅黑';">
		<p>更多模版</p>
		<ul id="radioUl" style="margin-top: 5px;">
			<li><input type="radio" name="template-radio" checked="checked" value="1"/><span>模版一</span></li>
			<li><input type="radio" name="template-radio" value="2"/><span>模版二</span></li>
			<li><input type="radio" name="template-radio" value="3"/><span>模版三</span></li>
			<c:if test="${cmsActivityPublisher!=null}">
				<li><input type="radio" name="template-radio" value="4"/><span>已保存的样式</span></li>
				<input id="templateContent" type="hidden" value="<c:out value='${cmsActivityPublisher.templateContent}' escapeXml='true'/>"/>
			</c:if>
		</ul>
		<div style="clear: both;"></div>
	</div>
	<!-- 模板HTML -->
	<textarea class="model-main" name="modelMain" style="padding-bottom: 78px;"></textarea>
	<!-- 隐藏DIV，用于样式重置 -->
	<div id="hideDiv" style="display: none;"></div>
	<!-- 底部按钮 -->
	<div class="form-table form_table_btn" style="position: fixed; bottom: 0; width: 100%; padding: 20px 0 30px; background: #ffffff;border: 1px solid #ccc;">
	    <input class="btn-publish" type="button" onclick="saveTemplate()" value="保存"/>
	    <input class="btn-save" type="button" onclick="$('body', parent.document).find('#DialogBySHFLayer,#DialogBySHF').remove();" value="取消"/>
	</div>
</body>
</html>