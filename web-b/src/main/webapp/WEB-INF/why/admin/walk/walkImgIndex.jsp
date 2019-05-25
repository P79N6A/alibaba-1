<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>行走故事列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
        	
        	selectModel();
        	 //关闭图片预览
  		    $(".imgPreview,.imgPreview>img").click(function() {
  			 	$(".imgPreview").fadeOut("fast");
  			}) 	   
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#walkImgForm');
                    return false;
                }
            });
        	 
          //单选的时候取消全选	 
  		  $('input[name="subcheck"]').click('click', function () {
          	if($(this).is(':checked')) {
          		var sum = 0;
          		$('input[name="subcheck"]').each(function () {
          			if($(this).is(':checked')) {
          				sum++;
          			}
          		});
          		if(sum == $('input[name="subcheck"]').size()) {
          			$('input[name="SelectAll"]').prop("checked",true);
          		}

          	} else {
          		$('input[name="SelectAll"]').prop("checked",false);
          	}
          });
        });
        
      	//提交表单
        function formSub(formName) {
        	var userName = $('#userName').val();
            if (userName != undefined && userName == '输入用户名') {
                $('#userName').val("");
            }
        	var userMobile = $('#userMobile').val();
            if (userMobile != undefined && userMobile == '输入手机号') {
                $('#userMobile').val("");
            }
            $(formName).submit();
        }

        //删除
        function deleteWalkImg(walkImgId) {
        	var walkImgUrls = '';
    		$(".shanchuL ul li").not(".cur").each(function(index, element) {
    			walkImgUrls += $(element).find("img").attr("src") + ";";
    		});
    		if(walkImgUrls.length>0){
    			walkImgUrls = walkImgUrls.substring(0, walkImgUrls.length-1);
    		}
    		var text = "确定删除选中图片？";
    		if($(".shanchuL ul li.cur").length == $(".shanchuL ul li").length){
    			text = "确定删除该作品？";
    		}
            dialogConfirm("提示", text, function(){
            	$.post("${path}/walk/deleteWalkImg.do", {walkImgId: walkImgId, walkImgUrls: walkImgUrls}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", "删除成功！", function(){
                    		location.reload();
                    	})
                    } else {
                        dialogAlert('提示', "删除失败！");
                    }
                });
            });
        }
        
        //点击看大图
        function showPreview(url){
        	$(".imgPreview img").attr("src",url);
        	$(".imgPreview").fadeIn("fast");
        }
        
        //全选和全不选
        function selectAll(allEle) {
        	if($(allEle).is(':checked')) {
        		$('input[name="subcheck"]').prop("checked",true);
        	} else {
        		$('input[name="subcheck"]').prop("checked",false);
        	}
        }
        
        //审核通过
        function checkPass(){
        	dialogConfirm("提示", "确定要审核通过该作品？",function(){
        		var subcheck=document.getElementsByName('subcheck');
            	var walkImgId=''; 
            	for(var i=0; i<subcheck.length; i++){ 
            		if(subcheck[i].checked){
            			walkImgId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
            		}
            	}
            	$.post("${path}/walk/checkPass.do", {walkImgId: walkImgId}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", "审核通过！",function(){
                    		formSub('#walkImgForm');
                    	});
                    } else {
                        dialogAlert('提示', "审核通过失败！");
                    }
                });
        	});
        }
        
        //审核不通过
        function checkNoPass(){
        	dialogConfirm("提示", "确定要审核不通过该作品？",function(){
        		var subcheck=document.getElementsByName('subcheck');
            	var walkImgId=''; 
            	for(var i=0; i<subcheck.length; i++){ 
            		if(subcheck[i].checked)
            			walkImgId+=subcheck[i].value+","; //如果选中，将value添加到变量s中 
            	}
            	$.post("${path}/walk/checkNoPass.do", {walkImgId: walkImgId}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", "审核不通过！",function(){
                    		formSub('#walkImgForm');
                    	});
                    } else {
                        dialogAlert('提示', "审核不通过失败！");
                    }
                });
        	});
        }
        
      	//刷票
        function brushWalkVote(walkImgId,walkImgName){
      		var voteCount = $("#voteCount").val();
      		if(!isNaN(voteCount)){
      			if(voteCount<=1000 && voteCount>0){
      				dialogConfirm("提示", "确定为"+walkImgName+"刷票"+voteCount+"张？",function(r){
      					$(".shapiaoDiv .shuapiaoBtn").attr("onclick","");
      	            	$.post("${path}/walk/brushWalkVote.do", {walkImgId: walkImgId,count:voteCount}, function (data) {
      	                    if (data == "200") {
      	                    	$('.shapiaoBack').hide();
      	                    	dialogAlert('提示', "刷票成功！");
      	                    } else {
      	                    	$(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWalkVote('"+walkImgId+"','"+walkImgName+"');");
      	                        dialogAlert('提示', "刷票失败！");
      	                    }
      	                });
      	        	});
      			}else{
      				dialogAlert('提示', "输入范围在1到1000！");
      			}
      		}else{
      			dialogAlert('提示', "输入非数字格式！");
      		}
        }
    </script>
    
    <style>
    	/*删除图片*/
    	.shanchuL_wc {width: 100%;height: 100%;position: fixed;left: 0;top: 0;background-color: rgba(0,0,0,0.9);overflow: hidden;z-index: 99;}
	    .shanchuL {width: 490px;  margin: 0 auto;background-color: #fff;margin: 0 auto;margin-top: 10%;padding: 30px;height: 70%;overflow: auto;}
	    .shanchuL ul {margin-right: -10px;}
	    .shanchuL ul li {width: 150px;height: 150px;position: relative;overflow: hidden; float: left;background-color: #ddd;margin-right: 10px;margin-bottom: 10px;cursor: pointer;
	        -webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;
	    }
	    .shanchuL ul li img {}
	    .shanchuL ul li .xuan {display: block;width: 32px;height: 32px;background-color: #f00;position: absolute;left: 0;top: 0;z-index: 2;background: url(${path}/STATIC/image/xuanze.png) no-repeat;background-position: -32px 0;}
	    .shanchuL ul li.cur .xuan {background-position: 0 0;}
	    .shanchuL .delete {display: block; width: 200px;height: 50px;line-height: 50px;overflow: hidden;background-color: #374E65;font-size: 20px;color: #fff;text-align: center;border: none;margin: 0 auto;margin-top: 20px;
	        -webkit-border-radius: 5px;-moz-border-radius: 5px;-o-border-radius: 5px;border-radius: 5px;
	    }
	    .shanchuL .allXuan {text-align: right;margin-bottom: 20px;height: 30px;line-height: 30px;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}
	    .shanchuL .allXuan span {display: inline-block;overflow: hidden;background-color: #374E65;font-size: 14px;color: #fff;padding: 2px 14px;cursor: pointer;
	        -webkit-border-radius: 5px;-moz-border-radius: 5px;-o-border-radius: 5px;border-radius: 5px;
	        -webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;
	    }
	    .shanchuL .st {display: block;width: 430px;padding: 0 20px;font-size: 16px;color: #000;margin-bottom: 10px;line-height: 24px;}
	    
	    /*刷票*/
	    .shapiaoBack {width: 100%;height: 100%;position: fixed;left: 0;top: 0;background-color: rgba(0,0,0,0.9);overflow: hidden;z-index: 99;}
	    .shapiaoDiv {width: 340px;  margin: auto;background-color: #fff;padding: 34px;height: 200px;position: absolute;top: 0;bottom: 0;left: 0;right: 0;line-height: 54px;font-size: 16px;}
	    .shapiaoDiv .shuapiaoBtn {display: block; width: 200px;height: 50px;line-height: 50px;overflow: hidden;background-color: #374E65;font-size: 20px;color: #fff;text-align: center;border: none;margin: 0 auto;margin-top: 20px;
	        -webkit-border-radius: 5px;-moz-border-radius: 5px;-o-border-radius: 5px;border-radius: 5px;
	    }
    </style>
</head>

<body>
	<form id="walkImgForm" action="" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 行走故事管理
	    </div>
	    <div class="search">
		    <div class="search-box">
		        <input type="text" id="userName" name="userName" value="${entity.userName}" data-val="输入用户名" class="input-text"/>
		    </div>
		    <div class="search-box">
		        <input type="text" id="userMobile" name="userMobile" value="${entity.userMobile}" data-val="输入手机号" class="input-text"/>
		    </div>
	        <div class="select-box w135">
	            <input type="hidden" value="${entity.walkStatus}" name="walkStatus"
	                   id="walkStatus"/>
	            <div class="select-text" data-value="">
	                <c:choose>
	                    <c:when test="${entity.walkStatus == 0}">
	                        未审核
	                    </c:when>
	                    <c:when test="${entity.walkStatus == 1}">
	                       审核通过
	                    </c:when>
	                    <c:when test="${entity.walkStatus == 2}">
	                        审核不通过
	                    </c:when>
	                    <c:otherwise>
	                        审核状态
	                    </c:otherwise>
	                </c:choose>
	            </div>
	            <ul class="select-option">
	                <li data-option="">审核状态</li>
	                <li data-option="0">未审核</li>
	                <li data-option="1">审核通过</li>
	                <li data-option="2">审核不通过</li>
	            </ul>
	        </div>      
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button"  onclick="$('#page').val(1);formSub('#walkImgForm');" value="搜索"/>
		    </div>
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button" onclick="checkPass();" value="审核通过"/>
		    </div>
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button" onclick="checkNoPass();" value="审核不通过"/>
		    </div>
		</div>
	    <div class="main-content">
	        <table width="100%">
	            <thead>
	            <tr>
	                <th width="30"><input type="checkbox" name="SelectAll"  value="全选" onclick="selectAll(this);"/> </th>
	                <th width="40">ID</th>
	                <th width="160">UUID</th>
	                <th width="70">用户名</th>
	                <th width="70">姓名</th>
	                <th width="80">手机</th>
	                <th width="310">图片</th>
	                <th width="120">作品名</th>
	                <th class="title">描述</th>
	                <th width="70">拍摄时间</th>
	                <th width="70">拍摄地点</th>
	                <th width="70">状态</th>
	                <th width="70">创建时间</th>
	                <th width="70">管理</th>
	            </tr>
	            </thead>
	            <tbody>
	            <%int i = 0;%>
	            <c:forEach items="${list}" var="dom">
	                <%i++;%>
	                <tr>
	                    <td><input name="subcheck" type="checkbox" value="${dom.walkImgId }"/></td>
	                    <td><%=i%></td>
	                    <td>${dom.walkImgId}</td>
	                    <td>${dom.userName}</td>
	                    <td>${dom.userRealName}</td>
	                    <td>${dom.userMobile}</td>
	                    <td style="text-align: left;">
	                    	<c:set var="items" value="${fn:split(dom.walkImgUrl, ';')}"></c:set>
							<c:forEach items="${items}" var="walkImgUrl" varStatus="i">
								<img onclick="showPreview('${walkImgUrl}');" src="${walkImgUrl}@200w" width="100" height="80"></img>
							</c:forEach>
	                    </td>
	                    <td>${dom.walkImgName}</td>
	                    <td class="title">
							<c:if test="${fn:length(dom.walkImgContent)>20 }">  
		                    	${fn:substring(dom.walkImgContent, 0, 20)}...  
		                	</c:if>  
		                	<c:if test="${fn:length(dom.walkImgContent)<=20 }">  
		                    	${dom.walkImgContent}  
		                	</c:if>  
						</td>
	                    <td>${dom.walkImgTime}</td>
	                    <td>${dom.walkImgSite}</td>
	                    <td>
		                    <c:if test="${dom.walkStatus==0 }">
		                    	未审核
		                    </c:if>
		                    <c:if test="${dom.walkStatus==1 }">
		                    	审核通过
		                    </c:if>
		                    <c:if test="${dom.walkStatus==2 }">
		                    	审核不通过
		                    </c:if>
	                    </td>
	                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
	                    <td>
	                    	<a target="main" href="javascript:shanchuOpen('${dom.walkImgUrl}','${dom.walkImgId}','${dom.walkImgName}','${dom.walkImgContent}','${dom.walkImgTime}','${dom.walkImgSite}');">审核</a>
	                    	 | <a target="main" href="javascript:shuapiaoOpen('${dom.walkImgId}','${dom.walkImgName}');">刷票</a>
	                    </td>
	                </tr>
	            </c:forEach>
	            <c:if test="${empty list}">
	                <tr>
	                    <td colspan="11"><h4 style="color:#DC590C">暂无数据!</h4></td>
	                </tr>
	            </c:if>
	            </tbody>
	        </table>
	        <c:if test="${not empty list}">
	            <input type="hidden" id="page" name="page" value="${page.page}"/>
	            <div id="kkpager"></div>
	        </c:if>
	    </div>
	</form>
	<!--点击放大图片imgPreview-->
	<div class="imgPreview" style="width:800px;height:600px;position:fixed;top:0;right:0;bottom:0;left:0;margin:auto;z-index:100;display: none;">
		<img src="" style="max-width:100%;max-height:100%;width:auto;height:auto;position:absolute;top:0;right:0;bottom:0;left:0;margin:auto;"/>
	</div>
	<!-- 删除界面 -->	
	<div class="shanchuL_wc" style="display:none;" onclick="$(this).hide();">
        <div class="shanchuL">
        	<div class="st"><strong>作品名称：</strong><span id="showName"></span></div>
            <div class="st"><strong>背后的故事：</strong><span id="showContent"></span></div>
            <div class="st"><strong>拍摄时间：</strong><span id="showTime"></span></div>
            <div class="st"><strong>拍摄地点：</strong><span id="showSite"></span></div>
        	<div class="allXuan"><span onclick="quanxFun()">全选</span></div>
            <ul class="clearfix"></ul>
            <input class="delete" type="button" value="删除选中图片">
        </div>
    </div>
    <!-- 刷票界面 -->	
	<div class="shapiaoBack" style="display:none;" onclick="$(this).hide();">
        <div class="shapiaoDiv">
        	<strong>作品：</strong><span id="shuapiaoName"></span><br/>
        	<strong>刷票数：</strong><input id="voteCount" type="text" maxlength="4"/><span style="color: red;">（1到1000）</span>
            <input class="shuapiaoBtn" type="button" value="开始刷票">
        </div>
    </div>
</body>

<!-- 删除 -->
<script type="text/javascript">
	//删除弹窗
	function shanchuOpen(srcStr,id,name,content,time,site) {
	    $('#showName').html(name);
	    $('#showContent').html(content.replace(/\r\n/g,"<br/>"));
	    $('#showTime').html(time);
	    $('#showSite').html(site);
	    var srcArr = srcStr.split(';')
	    $('.shanchuL ul').empty();
	    for(var i = 0; i < srcArr.length; i++) {
	        $('.shanchuL ul').append('<li><img src="' +  srcArr[i] + '"><span class="xuan"></span></li>');
	    }
	    $('.shanchuL ul li img').picFullCentered({'boxWidth' : 150,'boxHeight' : 150});
	    $('.shanchuL ul li').on('click',function(){
	    	if($(this).hasClass('cur')) {
	    		$(this).removeClass('cur');
		    } else {
		    	$(this).addClass('cur');
		    }
	    });
	    
	    $(".shanchuL_wc .delete").attr("onclick","deleteWalkImg('"+id+"');");
	    
	    $('.shanchuL_wc').show();
	}
	// 全选
	function quanxFun() {
	    $('.shanchuL ul li').each(function () {
	        $(this).addClass('cur');
	    });
	}
	
	//刷票弹窗
	function shuapiaoOpen(id,name) {
		$("#shuapiaoName").html(name);
		$("#voteCount").val("");
	    $('.shapiaoBack').show();
	    
	    $(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWalkVote('"+id+"','"+name+"');");
	}
	
	// 阻止事件冒泡
	function setStopPropagation(evt) {
	    var e = evt || window.event;
	    if(typeof e.stopPropagation == 'function') {
	        e.stopPropagation();
	    } else {
	        e.cancelBubble = true;
	    }   
	}
	
	// 图片撑满居中
	(function(a){var b={"boxWidth":0,"boxHeight":0};a.fn.extend({"picFullCentered":function(c){var d=a.extend({},b,c);this.each(function(){if(d.boxWidth&&d.boxHeight){var g=a(this);var f=d.boxWidth/d.boxHeight;var e=new Image();e.onload=function(){var i=e.width;var h=e.height;if(i/h>=f){var l=(d.boxHeight*i)/h;var k=(l-d.boxWidth)/2*(-1);g.css({"width":"auto","height":"100%","position":"absolute","top":"0","left":k})}else{var j=(d.boxWidth*h)/i;var m=(j-d.boxHeight)/2*(-1);g.css({"width":"100%","height":"auto","position":"absolute","top":m,"left":"0"})}};e.src=g.attr("src")}});return this}})})(jQuery);
	
	$(function () {
	    $('.shanchuL,.shapiaoDiv').bind('click',function (evt) {
	        setStopPropagation(evt);
	    });
	});
</script>
</html>
