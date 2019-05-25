<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="UTF-8">
	<title>文化社团</title>
	<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpCulture.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bzStyle.css">
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
	 <script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
	 <script type="text/javascript" src="${path}/STATIC/js/cutimg.js"></script>
	<style type="text/css">
		html{height: 100%;}
		body{background-color: #ededed;height: 100%;}
		.qyListWrap .tagWrap {height:21px;overflow: hidden;}
	</style>
	<script type="text/javascript">
	var userId = '${sessionScope.terminalUser.userId}';
	$(function () {
        $("#pageName").html("所在位置：文化社团");
        $("#toAssnList").addClass('cur').siblings().removeClass('cur');
        $("#searchVal").val($("#searchAssnName").val());

        $("#searchSltSpan").html("社团");
        $("#queryType").val("社团");

    })
	 //跳转到社团详情页
    function toAssnDetail(assnId){
    	location.href='${path}/frontAssn/toAssnDetail.do?assnId='+assnId;  	
    }
	 function loadData(){
		 var searchAssnName=$("#searchAssnName").val();
		 var reqPage=$("#reqPage").val();
		 var countPage = $("#countpage").val();
		 var recruitStatus = $(".selWrap").find("li[class='cur']").attr("data-option");
		 $("#assn_content").load("${path}/frontAssn/assnListLoad.do",{recruitStatus:recruitStatus,countPage:countPage,page:reqPage,assnName:searchAssnName},function(responseTxt,statusTxt){
			 $('#assn_content li .assn').picFullCentered({'boxWidth':'280','boxHeight':'185'});
			 //分页
		        kkpager.generPageHtml({
		            pno :$("#pages").val() ,
		            //总页码
		            total :$("#countpage").val(),
		            //总数据条数
		            totalRecords :$("#total").val(),
		            mode : 'click',
		            click : function(n){
		                this.selectPage(n);
		                $("#reqPage").val(n);

		                loadData();
		                return false;
		            }
		        });
		        if(statusTxt=="success"){
		        	var countPage = $("#countpage").val();
		        	$("#nowPage").text($("#reqPage").val());
					$("#allPage").text(countPage);
		        }
		        setScreen();
		    })
/* 		   $.post("${path}/frontAssn/getAssnList.do",{recruitStatus:recruitStatus}, function (data) {
	   			if(data.status == 1){
	   				$.each(data.data, function (i, dom) {
	   					var tagHtml = ""
	   					var tagList = dom.assnTag.split(",");
	   					$.each(tagList, function (i, tag) {
	   						tagHtml += "<span>"+tag+"</span>"
	   					});
	   					var assnImgUrl = dom.assnImgUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnImgUrl),"_750_500"):(dom.assnImgUrl+"@800w");					
	   					$("#assnUl").append("<li class='qyItem' onclick='toAssnDetail(\""+dom.assnId+"\")'>" +
					            				"<div class='img'>"	+
					            					"<img src='"+assnImgUrl+"' width='280' height='185'>"+
					            					"<div class='flower'>"+(eval(dom.assnFlowerInit)+eval(dom.flowerCount))+"</div>"+
					            				"</div>"+
					            				"<div class='qyInfo'>"+
					            					"<p class='name'>"+dom.assnName+"</p>"+
					            					"<div class='tagWrap'>"+tagHtml+"</div>"+
					            					"<p class='info'>"+dom.assnIntroduce+"</p>"+
					            				"</div>"+				            				
						        				"</li>");
	           		});
	       		}
	       	}, "json"); */
	 }
	 //社团入驻
	 function applyAssn(){
    	if (userId == null || userId == "") {
        	dialogAlert("提示", '登录之后才能入驻', function () {
            		
            	});
            return;
        }else{
     		$("#applyAssnBut").attr("onclick","");
 	        var assnName=$('#assnName').val();
 	        var assnLinkman = $("#assnLinkman").val();
 	        var assnPhone = $("#assnPhone").val();
 	        var assnType = $("#assnTypeUl").find("option:selected").attr("tagid");
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
 	        
 	     	//社团类型
 	        if(assnType==undefined||assnType==""){
 	        	$("#applyAssnBut").attr("onclick","applyAssn();");
 	        	dialogAlert('系统提示',"请选择社团类型！");
 	            $('#assnType').focus();
 	            return;
 	        }else{
 	        	$("#assnType").val(assnType);
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
 	         	     	        
 	      	//社团简介
 	        if(assnIntroduce==undefined||assnIntroduce.trim()==""){
 	        	$("#applyAssnBut").attr("onclick","applyAssn();");
 	        	dialogAlert('系统提示',"社团简介为必填！");
 	            $('#assnIntroduce').focus();
 	            return;
 	        }else{
 	            if(assnIntroduce.length>1000){
 	            	$("#applyAssnBut").attr("onclick","applyAssn();");
 	            	dialogAlert('系统提示',"社团简介只能输入1000字以内！");
 	                $('#assnIntroduce').focus();
 	                return false;
 	            }
 	        }
 	      	
 	      	$("#createTuser").val(userId);
 	      	$("#updateTuser").val(userId);
 	      	
 	        //保存申请信息
 	        $.post("${path}/frontAssn/applyAssociation.do", $("#associationApplyForm").serialize(),function(data) {
                 if (data!=null&&data=='success') {
                	 dialogAlert("提示", "申请完成！", function () {
                 		window.location.href = '${path}/frontAssn/toAssnList.do';
 	     	        	});
                 }else{
                 	$("#applyAssnBut").attr("onclick","applyAssn();");
                 	dialogAlert('系统提示', '申请失败！');
                 }
 	        },"json");
     	}
	    }
	 function setScreen(){
		    var $content = $("#assn-content");
		    if($content.length > 0) {
		        $content.removeAttr("style");
		        var contentH = $content.outerHeight();
		        var otherH = $("#header").outerHeight() + $("#in-footer").outerHeight();
		        var screenConH = $(window).height() - otherH;
		        if (contentH < screenConH) {
		            $content.css({"height": screenConH});
		        }
		    }
		}
	   $(function(){
		   loadData();
		   
			//加载社团类别
	        $.post("${path}/tag/getChildTagByType.do",{code:"ASSOCIATION_TYPE"}, function (data) {
	            if (data != '' && data != null) {
	                var list = eval(data);
	                var ulHtml = '';
	                for (var i = 0; i < list.length; i++) {
	                    var dict = list[i];
	                    ulHtml += '<option tagid="' + dict.tagId + '">'+ dict.tagName + '</option>';
	                }
	                $('#assnTypeUl').append(ulHtml);
	                
	            }
	        },"json");
			
	    })
		$(function () {
			$(".selWrap").on("click","li",function(){
				$("#assnUl").html("");
				$(this).addClass("cur").siblings().removeClass("cur");
				$("#reqPage").val(1);
				loadData();
				/* if($(this).attr("id")=="open"){
					loadData(1);
				}else{
					loadData();
				} */
			});
			$(".joinBtn").click(function(){
				if (userId == null || userId == "") {
		        	dialogAlert("提示", '登录之后才能入驻', function () {
		            		window.location.href='${path}/muser/login.do?type=${path}/frontAssn/toAssnList.do';
		            	});
		            return;
		        }else{
		        	$(".mask").show();
		        	}								
			})
			$(".mask").click(function(){
				$(this).hide();
			});
			$(".joinWrap").click(function(e){
				window.event? window.event.cancelBubble = true : e.stopPropagation();
			});
			$(".fqBtn").click(function(){
				dialogConfirm("提示", "是否放弃申请？", function(){
					$(".mask").hide();
				});					
				
			});
		});
	   $(function(){		   
		   $(".hp_nav ul li").on('click', 'a', function () {
		        $(this).parent().addClass("cur").siblings().removeClass("cur");
		    });
	    })
	</script>
</head>
<body>
<div class="header">
   <!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/header.jsp" %>
</div>
	<div class="qyMain" id="assn-content">
		<input type="hidden" name="searchAssnName" id="searchAssnName" value="${searchAssnName}"/>
		<!-- 筛选 -->
		<div class="filterWrap clearfix">
			<div class="typeTag">招募状态：</div>
			<ul class="selWrap clearfix" style="width: 954px;">
				<li class="cur" data-option="">全部</li>
				<li id="open" data-option="1">招募中</li>
			</ul>
			<span class="joinBtn">社团入驻</span>
		</div> 
		<!-- <img src="../image/qyJoin.png" class="qyJoin"> -->
		<!-- 列表 -->
		<div id="assn_content"></div>
		<input type="hidden" id="reqPage"  value="1">
		
	</div>
	<div class="mask" style="display: none">
		<form id="associationApplyForm">
		<input id="createTuser" name="createTuser" type="hidden" value=""/>
		<input id="updateTuser" name="updateTuser" type="hidden" value=""/>
			<div class="joinWrap">
				<p class="title">社团入驻</p>
				<div class="information clearfix">
					<label>名&emsp;&emsp;称</label>
					<input type="text" id="assnName" name="assnName" placeholder="请输入名称"/>
				</div>
				<div class="information clearfix">
					<label>性&emsp;&emsp;质</label>
					<select id="assnTypeUl">
						<option>请选择类型</option>
					</select>
					<input id="assnType" name="assnType" type="hidden"/>
				</div>
				<div class="information clearfix">
					<label>联&nbsp;&nbsp;系&nbsp;&nbsp;人</label>
					<input type="text" id="assnLinkman" name="assnLinkman" placeholder="请输入联系人" maxlength="20"/>
				</div>
				<div class="information clearfix">
					<label>电&emsp;&emsp;话</label>
					<input type="text" id="assnPhone" name="assnPhone" maxlength="11" placeholder="请输入电话"/>
				</div>
				<div class="information clearfix">
					<label>社团简介</label>
					<textarea name="assnIntroduce" id="assnIntroduce"  maxlength="1000" placeholder="请输入简介"></textarea>
				</div>
				<div class="btnWrap"><span class="fqBtn"><i>放弃</i></span><span onclick="applyAssn()"><i>提交</i></span></div>
				<p class="warn">如果你的社团也对加入文化云感兴趣，请提交相关信息，我们的工作人员会尽快与你联系</p>
			</div>
		</form>
	</div>
<div class="footer">
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
</body>
</html>