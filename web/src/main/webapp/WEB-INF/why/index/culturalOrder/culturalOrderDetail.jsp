<%@ page import="org.apache.commons.lang3.StringUtils ,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/culture.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/style.css" />
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/styleChild.css" />
	<script type="text/javascript" src="${path}/STATIC/js/laydate/laydate.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/layer/layer.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
	
	<title>安康文化云</title>
	<style type="text/css">
		html, body {background-color: #f6f6f6;}
	</style>
	
	<script type="text/javascript">
		var culturalOrderId = '${culturalOrder.culturalOrderId}';
		var userId = '${sessionScope.terminalUser.userId}';
		var dateEventArr = new Array();
		var calendarMarks = new Array();
		var culturalOrderLargeType = '${culturalOrder.culturalOrderLargeType}';
		$(function () {
			$("#culturalOrderIndex").addClass('cur').siblings().removeClass('cur');
			if(culturalOrderId != null && culturalOrderId != ''){
				loadOrderEventsAndCalendar(culturalOrderId);
				loadOrderOrders(culturalOrderId);
			}
			loadCommentList();
			var Img = $("#uploadType").val();
            $("#file").uploadify({
                'formData': {
                    'uploadType': Img,
                    'type': 10,
                    'userMobileNo': $("#userMobileNo").val()
                },//传静态参数
                swf: '${path}/STATIC/js/uploadify.swf',
                uploader: '${path}/upload/frontUploadFile.do;jsessionid=${pageContext.session.id}',
                buttonText: '<a class="shangchuan" style="margin:0;"><h4><font>添加图片</font></h4></a>',
                'buttonClass': "upload-btn",
                /*queueSizeLimit:3,*/
                fileSizeLimit: "2MB",
                'method': 'post',
                queueID: 'fileContainer',
                fileObjName: 'file',
                'fileTypeDesc': '支持jpg、png、gif格式的图片',
                'fileTypeExts': '*.gif; *.jpg; *.png',
                'auto': true,
                'multi': true, //是否支持多个附近同时上传
                height: 21,
                width: 85,
                'debug': false,
                'dataType': 'json',
                'removeCompleted': true,
                onUploadSuccess: function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url = json.data;

                    $("#headImgUrl").val($("#headImgUrl").val() + url + ";");
                    getHeadImg(url);

                    if ($("#headImgUrl").val().split(";").length > 3) {
                        $("#file").hide();
                        $(".comment_message").show();
                    }
                },
                onSelect: function (file) {

                },
                onDialogOpen: function () {

                },
                onQueueComplete: function (queueData) {
                    if ('${sessionScope.terminalUser}' == null || '${sessionScope.terminalUser}' == '') {
                        dialogAlert("评论提示", "登录之后才能评论");
                    }
                }
            });
            
            /*活动评论图片删除*/
            $(".wimg").on("click", ".sc_img a", function () {
                var url = $(this).parent().attr("data-url");
                var allUrl = $("#headImgUrl").val();
                var newUrl = allUrl.replace(url + ";", "");
                $("#headImgUrl").val(newUrl);

                $(this).parent().remove();
                if ($("#headImgUrl").val().split(";").length <= 3) {
                    $("#file").show();
                    $(".comment_message").hide();
                }
            });
            $(".wimg").on({
                mouseover: function () {
                    $(this).find("a").show();
                },
                mouseout: function () {
                    $(this).find("a").hide();
                }
            }, ".sc_img");
			
			//分享代码 start
			window._bd_share_config = {
	                  "common": {
	                    "bdSnsKey": {},
	                    "bdText": "",
	                    "bdMini": "2",
	                    "bdMiniList": false,
	                    "bdPic": "",
	                    "bdStyle": "0",
	                    "bdSize": "16",
	                    "onAfterClick":function shareIntegral(cmd){
                   		$.ajax({
                     		type: 'post',  
                   			url : "/resourceStatistics/addNum.do",  
                   			dataType : 'json',  
                   			data: {relateId: $("#infoId").val(),type:"2"},
                   			success : function(result) {
                   			} 
                   		});
               			}
	                  },
	                  "share": {}
	                };
	                with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
		});
	
		function showListByLargeType(largeType){
			window.location.href = "${path}/culturalOrder/showCulturalOrderIndexByLargeType.do?largeType=" + largeType;
		}
		
		function loadOrderEventsAndCalendar(orderId){
			$.post("${path}/culturalOrderEvent/culturalOrderEventList.do", {culturalOrderId : orderId,userId:userId}, function (result) {
       			var rsObj = jQuery.parseJSON(result);
	            $("#periodDiv").append(rsObj.periodStr);
	            data = rsObj.list;
	            var dateArr = new Array();
	            
	            for(var i in data){
	            	if(!dateArr.hasOwnProperty(data[i].culturalOrderEventDateStr)){
	            		dateArr[data[i].culturalOrderEventDateStr] = new Array();	
	            	}
	            	dateArr[data[i].culturalOrderEventDateStr].push(data[i]);
	            }
	            dateEventArr = dateArr;
	            for(var key in dateArr){
	            	var day = key.split('-');
                 	var dayStr = "";
                 	if(day[2].indexOf('0') == 0){
                 		dayStr = day[2].substr(1,1);
                 	}else{
                 		dayStr = day[2];
                 	}
                 	
                 	if(userId == ''){
                 		/* calendarMarks[key] = "<span class='optional' onclick='bmTablePop(" + key + ");'>" + dayStr + "<br/>可选</span>"; */
	                 	var ifFull = 0;
		            	for(var n in dateArr[key]){
		            		if (dateArr[key][n].usedTicketNum == dateArr[key][n].eventTicketNum){
		            			ifFull++;
		            		}
		            	}
		            	if (ifFull == dateArr[key].length){
		            		calendarMarks[key] = "<span class='full' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>已满</span>";
		            	} else {
		            		var d_1 = new Date(dateArr[key][dateArr[key].length-1].culturalOrderEventDateStr +" "+ dateArr[key][dateArr[key].length-1].culturalOrderEventTime.substr(6,5)+":00").getTime();
							var d_2 = new Date().getTime(); 
							console.log(dateArr[key][dateArr[key].length-1].culturalOrderEventDateStr);
		            		if(d_2>d_1){
		            			calendarMarks[key] = "<span class='full' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>已过期</span>";
		            		}else{
		            			calendarMarks[key] = "<span class='optional' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>可选</span>";
		            		}
		            	}
                 	}else{
	                 	//判断每个时段是否都有预约
	                 	var hasntOrderedNumber = 0;
	                 	var ifFull = 0;
		            	for(var n in dateArr[key]){
		            		if(dateArr[key][n].userHasOrder == '' || dateArr[key][n].userHasOrder == null || dateArr[key][n].userHasOrder == 0){
		            			hasntOrderedNumber++;
		            		}
		            		if (dateArr[key][n].usedTicketNum == dateArr[key][n].eventTicketNum){
		            			ifFull++;
		            		}
		            	}
		            	if (hasntOrderedNumber != dateArr[key].length){
		            		calendarMarks[key] = "<span class='selected' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>已选</span>";
		            	} else if (ifFull == dateArr[key].length){
		            		calendarMarks[key] = "<span class='full' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>已满</span>";
		            	} else {
		            		var d_1 = new Date(dateArr[key][dateArr[key].length-1].culturalOrderEventDateStr +" "+ dateArr[key][dateArr[key].length-1].culturalOrderEventTime.substr(6,5)+":00").getTime();
							var d_2 = new Date().getTime(); 
							console.log(dateArr[key][dateArr[key].length-1].culturalOrderEventDateStr);
		            		if(d_2>d_1){
		            			calendarMarks[key] = "<span class='full' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>已过期</span>";
		            		}else{
		            			calendarMarks[key] = "<span class='optional' onclick='bmTablePop(\"" + key + "\");'>" + dayStr + "<br/>可选</span>";
		            		}
		            	}
		            	
                 	}
	            }
	            
	            laydate.render({
					elem: '#calendarBody',
					position: 'static',
					showBottom: false,
					theme: 'order',
					mark: calendarMarks
				});
        	}, "json");
		}
		
		function loadOrderOrders(orderId){
			$.post("${path}/culturalOrderOrder/culturalOrderOrderList.do", {culturalOrderId : orderId}, function (result) {
       			var rsObj = jQuery.parseJSON(result);
	            var data = rsObj.list;
        		var str = "";
        		$.each(data, function (i, dom) {
        			if(i <= 7){
        				str += '<li class="clearfix">';
                        str += '  <a class="char" href="javascript:void(0);">' + dom.userName + '</a>';
                        str += '  <div class="time">下单时间：' + getDate(new Date(dom.createTime)) + '</div>';
                        str += '</li>';
        			}else{
        				return false;
        			}
        		});
        		$("#orderRecordsUl").append(str);
        	}, "json");
		}
		
		/* 我要报名-报名表格 */
		function bmTablePop(date) {
			if(userId == ''){
				dialogAlert("系统提示", "登录之后才能报名");
                return;
			}else{
				var tableHtml =	'<table class="orderdetTable">';
				tableHtml += 	'<tr>';
				tableHtml +=	'	<th width="25%">可选时段</th>';
				tableHtml +=	'	<th width="25%">剩余名额</th>';
				tableHtml +=	'	<th width="25%">总名额</th>';
				tableHtml +=	'	<th width="25%">操 作</th>';
				tableHtml +=	'</tr>';
				for(var d in dateEventArr){
					if(date == d){
						for(var index in dateEventArr[d]){
							tableHtml +=	'<tr>';
							tableHtml +=		'<td>' + dateEventArr[d][index].culturalOrderEventTime + '</td>';
							tableHtml +=		'<td>' + (dateEventArr[d][index].eventTicketNum - dateEventArr[d][index].usedTicketNum) + '</td>';
							tableHtml +=		'<td>' + dateEventArr[d][index].eventTicketNum + '</td>';
							if(dateEventArr[d][index].userHasOrder){
								tableHtml +=		'<td><a class="ybm" href="javascript:void(0);">已报名</a></td>';
							}else{
								//计较时间
								var d_1 = new Date(dateEventArr[d][index].culturalOrderEventDateStr +" "+ dateEventArr[d][index].culturalOrderEventTime.substr(6,5)+":00").getTime();
								var d_2 = new Date().getTime(); 
								if(dateEventArr[d][index].usedTicketNum == dateEventArr[d][index].eventTicketNum){
									tableHtml +=		'<td><a class="meym" href="javascript:void(0);">我要报名</a></td>';
								}else if(d_2>=d_1){
									tableHtml +=		'<td><a class="meym" href="javascript:void(0);">已过期</a></td>';
								}else{
									tableHtml +=		'<td><a class="wybm" href="javascript:void(0);" onclick="bmFormPop(\'' + culturalOrderId + '\',\'' + dateEventArr[d][index].culturalOrderEventId + '\',\'' + d + '\',\'' + dateEventArr[d][index].culturalOrderEventTime + '\',\'' + dateEventArr[d][index].eventTicketNum + '\',\'' + dateEventArr[d][index].usedTicketNum + '\')">我要报名</a></td>';
								}
							}
							tableHtml +=	'</tr>';
						}
					}
				}
				tableHtml += '</table>';
				layer.open({
					type: 1,
					title: false,
					closeBtn: 0,
					shade: 0.01,
					shadeClose: true,
					resize: false,
					area: ['520px', 'auto'],
					content: tableHtml
				});
			}
		}
		
		/* 我要报名弹窗 */
		function bmFormPop(culturalOrderId, culturalOrderEventId, culturalOrderEventDate, culturalOrderEventTime, eventTicketNum, usedTicketNum) {
			layer.close(layer.index);
			layer.open({
				type: 2,
				title: '我要报名',
				closeBtn: 1,
				shade: 0.01,
				shadeClose: true,
				resize: false,
				area: ['600px', '570px'],
				content: ['${path}/culturalOrderOrder/preAddUserOrder.do?culturalOrderId=' + culturalOrderId + '&culturalOrderEventId=' + culturalOrderEventId + '&culturalOrderEventDate=' + culturalOrderEventDate + '&culturalOrderEventTime=' + culturalOrderEventTime + '&eventTicketNum=' + eventTicketNum + '&usedTicketNum=' + usedTicketNum]
			});
		}
		
		function getDate(date){
    		var resultDate = "";
    		if((date.getMonth + 1) < 10){
    			resultDate = date.getFullYear() + '-0' + (date.getMonth() + 1); 
    		}else{
    			resultDate = date.getFullYear() + '-' + (date.getMonth() + 1); 
    		}
    		
    		if(date.getDate() < 10){
    			resultDate = resultDate + '-0' + date.getDate();
    		}else{
    			resultDate = resultDate + '-' + date.getDate();
    		}
    		
    		return resultDate;
    	}
		
		function addComment() {
            if (userId == null || userId == '') {
                dialogAlert("评论提示", "登录之后才能评论");
                return;
            }
            var status = '${sessionScope.terminalUser.commentStatus}';
            if (parseInt(status) == 2) {
                dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
                return;
            }
            var commentRemark = $("#commentRemark").val();
            if (commentRemark == undefined || $.trim(commentRemark) == "") {
                dialogAlert("评论提示", "输入评论内容");
                return;
            }

            if(commentRemark.length<4){
	        	dialogAlert("提示", '评论内容不能少于4个字！', function () {
	            	});
	            return;
	        }
            
            var headImgUrl = $("#headImgUrl").val();
            if (headImgUrl != "") {
                if (headImgUrl.lastIndexOf(";") == headImgUrl.length - 1) {
                    var url = headImgUrl.substring(0, headImgUrl.lastIndexOf(";"));
                    $("#headImgUrl").val(url);
                }
            }
	
            var data = {
    	            commentUserId:userId,
    	            commentRemark:commentRemark,
    	            commentType:30,
    	            commentRkId:culturalOrderId,
    	            commentImgUrl:$("#headImgUrl").val()
    	        };
            
            $.post("${path}/comment/addComment.do",data, function(data) {
	            if(data=='success'){
	            	dialogAlert("提示", '评论成功!', function () {
	            		window.location.href = "${path}/culturalOrder/culturalOrderDetail.do?culturalOrderId=" + culturalOrderId + "&culturalOrderLargeType=" + culturalOrderLargeType;
	     	        	});
	       	        return;
	            }else if(data == "exceedNumber"){
                    dialogAlert("提示", "当天评论次数最多一次!");
                }else if(data == "failure"){
                    dialogAlert("评论提示","评论内容有敏感词，不能评论!");
                }else{
                    dialogAlert("提示","评论失败，请重试!");
                }
	        },"json");
		}
		
		/**
		 * 加载推荐评论列表
		 */
		function loadCommentList(){
		    $("#comment-list-div ul").html();
		    var activityId = $("#commentRkId").val();
		    var data = {"commentType" : 30,"commentRkId" :activityId};
		    $.post("${path}/culturalOrder/commentList.do",data ,
		        function(data) {
		            var commentHtml = "";
		            if(data != null && data != ""){
		                for(var i=0; i<data.length; i++){
		                    var comment = data[i];
		                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
		                    var commentTime = comment.commentTime.substring(0,16);
		                    var commentUserName = comment.commentUserName;
		                    var userHeadImgUrl = comment.userHeadImgUrl;
		                    var commentImgUrl = comment.commentImgUrl;
		                    var userSex = comment.userSex;

		                    if(userHeadImgUrl != null && userHeadImgUrl !="") {
		                        if(userHeadImgUrl.indexOf("http")==-1){
		                            userHeadImgUrl = getUserImgUrl(userHeadImgUrl);
		                        }
		                    }else{
		                        if(userSex == 1){
		                            userHeadImgUrl = "${path}/STATIC/image/face_boy.png";
		                        }else if(userSex == 2){
		                            userHeadImgUrl = "${path}/STATIC/image/face_girl.png";
		                        }else{
		                            userHeadImgUrl = "${path}/STATIC/image/face_secrecy.png";
		                        }
		                    }
		                    var imgUrl = getCommentImgUrl(commentImgUrl);
		                    commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='60' height='60'/></a>" +
		                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+""+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
		                }
		                //当评论大于10条时，显示 更多... 按钮
		                 if(data.length==10){
		                    $("#moreComment").show();
		                };
		            }else{
		                $("#moreComment").hide();
		            }
		            $("#comment-list-div ul").html(commentHtml);
		            //loadCommentListPics();
		        }).success(function () {
		            var localUrl = top.location.href;
		            var divCulturalOrderComment = document.getElementById("divCulturalOrderComment");
		            if(localUrl.indexOf("collect_info.jsp") == -1){
		                $("#divCulturalOrderComment").show();
		                //starts(".comment-list .start",18);
		            }else{
		                $("#divCulturalOrderComment").css('display','none');
		                $("#divCulturalOrderComment").html("");
		                $("#divCulturalOrderComment").hide();
		            }
		        });
		}
		
		/**
		 * 加载更多评论
		 */
		function loadMoreComment(){
		    var pageNum = parseInt($("#commentPageNum").val())+1;
		    $("#commentPageNum").val(pageNum)
		    var activityId = $("#commentRkId").val();
		    var rdata = {"commentType" : 30,"commentRkId" :activityId, "pageNum" :pageNum};
		    $.post("${path}/culturalOrder/commentList.do",rdata ,
		        function(data) {
		            var commentHtml = "";
		            if(data != null && data != ""){
		                for(var i=0; i<data.length; i++){
		                    var comment = data[i];
		                    var commentRemark = comment.commentRemark.replace(/</g,'&lt;').replace(/>/g,'&gt;');
		                    var commentTime = comment.commentTime.substring(0,16);
		                    var commentUserName = comment.commentUserName;
		                    var userHeadImgUrl = comment.userHeadImgUrl;
		                    var commentImgUrl = comment.commentImgUrl;
		                    var userSex = comment.userSex;

		                    if(userHeadImgUrl != null && userHeadImgUrl !="") {
		                        if(userHeadImgUrl.indexOf("http")==-1){
		                            userHeadImgUrl = getUserImgUrl(userHeadImgUrl);
		                        }
		                    }else{
		                        if(userSex == 1){
		                            userHeadImgUrl = "${path}/STATIC/image/face_boy.png";
		                        }else if(userSex == 2){
		                            userHeadImgUrl = "${path}/STATIC/image/face_girl.png";
		                        }else{
		                            userHeadImgUrl = "${path}/STATIC/image/face_secrecy.png";
		                        }
		                    }
		                    var imgUrl = getCommentImgUrl(commentImgUrl);
		                    commentHtml = commentHtml + "<li><a class='img fl'><img src='"+userHeadImgUrl+"' width='50' height='50'/></a>" +
		                    "<div class='info fr'><h4><a>"+commentUserName+"</a><em>"+commentTime+"</em></h4>"+""+"<p>"+commentRemark+"</p>"+imgUrl+"</div></li>";
		                }
		            }else{
		                $("#moreComment").removeAttr("onclick");
		                $("#moreComment").html("没有更多了!");
		                return;
		            }
		            $("#comment-list-div ul").append(commentHtml);
		            //starts(".comment-list .start",18);

		            //loadCommentListPics();
		        });
		}
		
		//点击收藏
        function addCollect() {
            if (userId == null || userId == "") {
                dialogAlert("提示", "登录之后才能收藏");
                return;
            }
            var orderId = '${culturalOrder.culturalOrderId}';
            if($('#collectSpan').hasClass('cur')){
                $.ajax({
                    type: 'POST',
                    data: {
                    	userId: userId,
                    	relateId: orderId,
                    	type : 30
                    },
                    dataType:"json",
                    url: "${path}/wechat/wcDelCollect.do",//请求的action路径
                    success: function (data) { //请求成功后处理函数。
                        if(data.status == 0){
                        	$("#collectSpan").removeClass("cur");
                        	var collectNum = $('#collectSpan').html();
                        	collectNum = Number(collectNum) - 1;
                        	if (collectNum<0){
                        		collectNum = 0;
                        	}
                        	$("#collectSpan").html(collectNum);
                        	$(".likeCount").text(collectNum);
                        }
                    }
                });
            }else{
            	 $.ajax({
                     type: 'POST',
                     data: {
                     	userId: userId,
                     	relateId: orderId,
                     	type : 30
                     },
                     dataType:"json",
                     url: "${path}/wechat/wcCollect.do",//请求的action路径
                     success: function (data) { //请求成功后处理函数。
                         if(data.status == 0){
                        	 $("#collectSpan").addClass("cur");
                         	var collectNum = $('#collectSpan').html();
                         	collectNum = Number(collectNum) + 1;
                         	$("#collectSpan").html(collectNum);
                         	$(".likeCount").text(collectNum);
                         }
                     }
                 });
            }
        }
		
		function getCommentImgUrl(commentImgUrl){
		    if(commentImgUrl == undefined || commentImgUrl == "" || commentImgUrl == null){
		        return "";
		    }
		    var allUrl = commentImgUrl.split(";");
		    var imgDiv = "<div class='wk'><div class='pld_img_list'>";
		    for(var i=0;i<allUrl.length;i++){
		        if(allUrl[i] == undefined || allUrl[i] == "" || allUrl[i] == null){
		            continue;
		        }
		        commentImgUrl = getImgUrl(allUrl[i]);
		        commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
		        imgDiv = imgDiv + "<div class='pld_img fl'><img src='"+commentImgUrl+"' onload='fixImage(this, 75, 50)'/></div>";
		    }
		    imgDiv = imgDiv + "</div><div class='after_img'><div class='do'><a href='javascript:void(0)' class='shouqi'>" +
		    "<span><img src='${path}/STATIC/image/shouqi.png' width='8' height='11' /></span>收起</a><a href='#' target='_blank' class='yuantu'>" +
		    "<span><img src='${path}/STATIC/image/fangda.png' width='11' height='11'/></span>原图</a></div><img src='' class='fd_img'/></div></div>";
		    return imgDiv;
		}
		
		function getUserImgUrl(userHeadImgUrl){
		    return getIndexImgUrl(getImgUrl(userHeadImgUrl), "_300_300");
		}
		
		function getHeadImg(url) {
            var imgUrl = getImgUrl(url);
            imgUrl = getIndexImgUrl(imgUrl, "_300_300");
            $("#imgHeadPrev").append("<div class='sc_img fl' data-url='" + url + "'><img onload='fixImage(this, 100, 100)' src='" + imgUrl + "'><a href='javascript:;'></a></div>");
            $("#btnContainer").hide();
            $("#fileContainer").hide();
        }
	</script>
</head>
<body>
<%
    String userMobileNo = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (StringUtils.isNotBlank(terminalUser.getUserMobileNo())) {
            userMobileNo = terminalUser.getUserMobileNo();
        } else {
            userMobileNo = "0000000";
        }
    }
%>
<input type="hidden" id="userMobileNo" value="<%=userMobileNo%>"/>
<div class="fsMain">
	<!-- start 头部  -->
	<div class="header">
		<%@include file="../header.jsp" %>
	</div>
	<!-- end 头部  -->

	<div class="crumb"><i></i>您所在的位置2：
		<c:if test="${culturalOrder.culturalOrderLargeType == 1}">
			<a href="javascript:void(0);" onclick="showListByLargeType(1)">我要参与 </a> &gt; 详情
		</c:if>
		<c:if test="${culturalOrder.culturalOrderLargeType == 2}">
			<a href="javascript:void(0);" onclick="showListByLargeType(2)">我要邀请 </a> &gt; 详情
		</c:if>
	</div>
	<div class="detail-content">
		<div class="detail-left fl">
			<div class="the_one">
				<div class="a_time">
	                <div class="time"> <fmt:formatDate type="both" value="${culturalOrder.createTime}" /> / 收藏：
	                	<span class="likeCount">
	                		<c:if test="${not empty culturalOrder.collectCount}">
	                			${culturalOrder.collectCount}
	                		</c:if>
	                	</span>
	                </div>
	            </div>
			</div>
			<div class="orderDetTopTU clearfix">
				<div class="pic"><img src="${culturalOrder.culturalOrderImg}"></div>
				<div class="char">
					<div class="tit"><c:out value="${culturalOrder.culturalOrderName}"></c:out></div>
					<div class="wen">服务类型：<c:out value="${culturalOrder.culturalOrderTypeName}"></c:out></div>
					<c:if test="${culturalOrder.culturalOrderLargeType == 2}">
						<div class="wen">服务对象：
						<c:choose>
							<c:when test="${culturalOrder.culturalOrderDemandLimit == 1}">个人</c:when>
							<c:otherwise>机构</c:otherwise>
						</c:choose>
						</div>
					</c:if>
					<div class="wen">服务日期：
						<c:choose>
							<c:when test="${culturalOrder.startDateStr == culturalOrder.endDateStr}">
								<c:out value="${culturalOrder.startDateStr}"></c:out>
							</c:when>
							<c:otherwise>
								<c:out value="${culturalOrder.startDateStr}"></c:out> 至 <c:out value="${culturalOrder.endDateStr}"></c:out>
							</c:otherwise>
						</c:choose>
					</div>
					<c:if test="${culturalOrder.culturalOrderLargeType == 1}">
						<div class="wen" id="periodDiv">服务时段：</div>
						<div class="wen">服务地址：<c:out value="${culturalOrder.culturalOrderAddress}"></c:out></div>
						<div class="wen">参与人数限制：${culturalOrder.totalTicketNum}</div>
					</c:if>
					<c:if test="${culturalOrder.culturalOrderLargeType == 2}">
						<div class="wen">联系电话：<c:out value="${culturalOrder.culturalOrderLinkno}"></c:out></div>
						<div class="wen">联系人：<c:out value="${culturalOrder.culturalOrderLinkman}"></c:out></div>
					</c:if>
				</div>
				<div class="state">
					<c:if test="${culturalOrder.userCollect == 1}">
	            		<span class="shoucang_lm cur" onclick="addCollect()" id="collectSpan">${culturalOrder.collectCount}</span>
	            	</c:if>
	            	<c:if test="${empty culturalOrder.userCollect or culturalOrder.userCollect == 0}">
	            		<span class="shoucang_lm" onclick="addCollect()" id="collectSpan">${culturalOrder.collectCount}</span>
	            	</c:if>
					<span class="bdsharebuttonbox" style="padding-left: 0;">
						 <a class="share_lm" data-cmd="more" style="padding-left: 40px;"></a>
					</span>
						
	            </div>

			</div>
			<div class="orderDetTopFuwu">
				<div class="biaoTit">服务详情</div>
				<div class="odContent">
					<p><c:out escapeXml="false" value="${culturalOrder.culturalOrderServiceDetail}"></c:out></p>
				</div>
				<div class="calendarWrap" id="calendarBody"></div>
				
			</div>
			<div class="the_two">
            	<div class="comment mt20 clearfix" id="divCulturalOrderComment" style="display: block;">
                	<a name="comment"></a>
                	<div class="comment-tit">
                   		<h3>我要评论</h3><span id="commentCount">${commentCount}条评论</span>
	                </div>
	                <form id="commentForm">
	                	<input type="hidden" id="commentRkId" name="commentRkId" value="${culturalOrder.culturalOrderId}"/>
	                    <textarea class="text" name="commentRemark" id="commentRemark" maxLength="200"></textarea>
	                    <div class="tips">
	                        <div class="fl wimg">
	                            <input type="hidden" name="commentImgUrl" id="headImgUrl" value=""/>
	                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
	                            <div id="imgHeadPrev" style="position: relative; overflow: hidden;  float: left;">
	                            </div>
	                            <div style="float: left; margin-top: 0px;">
	                                <div>
	                                    <input type="file" name="file" id="file"/>
	                                </div>
	                                <div class="comment_message" style="display: none">(最多三张图片)</div>
	                                <div id="fileContainer" style="display: none;"></div>
	                                <div id="btnContainer" style="display: none;"></div>
                            	</div>
                        	</div>
	                        <div class="fr r_p">
	                            <p style="color:#999999;">文明上网理性发言，请遵守新闻评论服务协议</p>
	                            <input type="button" class="btn" value="发表评论" id="commentButton" onclick="addComment()"/>
	                        </div>
	                        <div class="clear"></div>
	                    </div>
	                </form>
	                <div class="comment-list" id="comment-list-div">
	                    <ul>
	                    </ul>
	                    <c:if test="${commentCount > 10}">
	                        <input type="hidden" id="commentPageNum" value="1"/>
	                        <a class="load-more" onclick="loadMoreComment()" id="moreComment"
	                           style="display: none;">查看更多...</a>
	                    </c:if>
	                </div>
            	</div>
        	</div>
		</div>
		<div class="detail_right fr">
			<div class="unionIntroZuo">
				<div class="tit">服务记录</div>
				<ul class="unionNewsList detailNewsList clearfix" id="orderRecordsUl">
				</ul>
			</div>
			<div class="unionIntroZuo">
				<div class="tit">报名须知</div>
				<div class="cont">
					<c:out value="${culturalOrder.culturalOrderMustKnow}"></c:out>
				</div>
			</div>
		</div>
	</div>

	<!-- start 底部 -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
	<!-- end 底部 -->
	
</div>
</body>

</html>
