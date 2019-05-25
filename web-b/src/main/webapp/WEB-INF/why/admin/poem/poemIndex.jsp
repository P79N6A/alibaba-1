<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>每日一诗列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
        	
        	$(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'dateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    minDate: '2017-05-01',
                    doubleCalendar: true,
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedDateFunc
                })
            })
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#poemForm');
                    return false;
                }
            });
        	 
        });
        
        function pickedDateFunc() {
            $dp.$('poemDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        
      	//提交表单
        function formSub(formName) {
        	var poemTitle = $('#poemTitle').val();
            if (poemTitle != undefined && poemTitle == '输入诗标题') {
                $('#poemTitle').val("");
            }
        	var lectorName = $('#lectorName').val();
            if (lectorName != undefined && lectorName == '输入讲师名') {
                $('#lectorName').val("");
            }
            $(formName).submit();
        }
      	
      	//刷票弹窗
    	function shuapiaoOpen(id,name) {
    		$("#shuapiaoName").html(name);
    		$("#wantGoCount").val("");
    	    $('.shapiaoBack').show();
    	    
    	    $(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWantGo('"+id+"','"+name+"');");
    	}

    	//刷票
        function brushWantGo(poemId,poemTitle){
      		var wantGoCount = $("#wantGoCount").val();
      		if(!isNaN(wantGoCount)){
      			if(wantGoCount<=100 && wantGoCount>=20){
      				dialogConfirm("提示", "确定为"+poemTitle+"刷赞"+wantGoCount+"个？",function(r){
      					$(".shapiaoDiv .shuapiaoBtn").attr("onclick","");
      	            	$.post("${path}/poem/brushWantGo.do", {poemId: poemId,count:wantGoCount}, function (data) {
      	                    if (data == "200") {
      	                    	$('.shapiaoBack').hide();
      	                    	dialogAlert('提示', "刷赞成功！");
      	                    } else {
      	                    	$(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWantGo('"+poemId+"','"+poemTitle+"');");
      	                        dialogAlert('提示', "刷赞失败！");
      	                    }
      	                });
      	        	});
      			}else{
      				dialogAlert('提示', "输入范围在20到100！");
      			}
      		}else{
      			dialogAlert('提示', "输入非数字格式！");
      		}
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
     	
    	$(function () {
    	    $('.shanchuL,.shapiaoDiv').bind('click',function (evt) {
    	        setStopPropagation(evt);
    	    });
    	});
    </script>
    
    <style>
    	/*刷票*/
	    .shapiaoBack {width: 100%;height: 100%;position: fixed;left: 0;top: 0;background-color: rgba(0,0,0,0.9);overflow: hidden;z-index: 99;}
	    .shapiaoDiv {width: 340px;  margin: auto;background-color: #fff;padding: 34px;height: 200px;position: absolute;top: 0;bottom: 0;left: 0;right: 0;line-height: 54px;font-size: 16px;}
	    .shapiaoDiv .shuapiaoBtn {display: block; width: 200px;height: 50px;line-height: 50px;overflow: hidden;background-color: #374E65;font-size: 20px;color: #fff;text-align: center;border: none;margin: 0 auto;margin-top: 20px;
	        -webkit-border-radius: 5px;-moz-border-radius: 5px;-o-border-radius: 5px;border-radius: 5px;
	    }
    </style>
</head>

<body>
	<form id="poemForm" action="" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 每日一诗管理 &gt; 每日一诗列表
	    </div>
	    <div class="search">
		    <div class="search-box">
		        <input type="text" id="poemTitle" name="poemTitle" value="${entity.poemTitle}" data-val="输入诗标题" class="input-text"/>
		    </div>
		    <div class="search-box">
		        <input type="text" id="lectorName" name="lectorName" value="${entity.lectorName}" data-val="输入讲师名" class="input-text"/>
		    </div>
		    <div class="form-table" style="float: left;">
	            <div class="td-time" style="margin-top: 0px;">
	                <div class="start w240" style="margin-left: 8px;">
	                    <span class="text">日期：</span>
	                    <input type="hidden" id="dateHidden"/>
	                    <input type="text" id="poemDate" name="poemDate" value='${entity.poemDate}' readonly/>
	                    <i class="data-btn start-btn"></i>
	                </div>
	            </div>
	        </div>
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button"  onclick="$('#page').val(1);formSub('#poemForm');" value="搜索"/>
		    </div>
		</div>
		<div class="search menage">
		    <h2>每日一诗列表</h2>
		    <div class="menage-box">
		        <a class="btn-add" href="${path}/poem/preAddPoem.do">新增每日一诗</a>
		    </div>
		</div>
	    <div class="main-content">
	        <table width="100%">
	            <thead>
	            <tr>
	                <th width="50">ID</th>
	                <th width="100">日期</th>
	                <th width="100">诗标题</th>
	                <th width="150">诗作者</th>
	                <th class="title">内容</th>
	                <th width="100">讲解人</th>
	                <th width="100">创建人</th>
	                <th width="100">创建时间</th>
	                <th width="100">管理</th>
	            </tr>
	            </thead>
	            <tbody>
	            <%int i = 0;%>
	            <c:forEach items="${list}" var="dom">
	                <%i++;%>
	                <tr>
	                    <td><%=i%></td>
	                    <td>${dom.poemDate}</td>
	                    <td>${dom.poemTitle}</td>
	                    <td>${dom.poemAuthor}</td>
	                    <td class="title">${dom.poemContent}</td>
	                    <td>${dom.lectorName}</td>
	                    <td>${dom.createUser}</td>
	                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
	                    <td>
	                    	<a target="main" href="${path}/poem/preEditPoem.do?poemId=${dom.poemId}">编辑</a>
	                    	 | <a target="main" href="javascript:shuapiaoOpen('${dom.poemId}','${dom.poemTitle}');">刷票</a>
	                    </td>
	                </tr>
	            </c:forEach>
	            <c:if test="${empty list}">
	                <tr>
	                    <td colspan="9"><h4 style="color:#DC590C">暂无数据!</h4></td>
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
	
	<!-- 刷票界面 -->	
	<div class="shapiaoBack" style="display:none;" onclick="$(this).hide();">
        <div class="shapiaoDiv">
        	<strong>标题：</strong><span id="shuapiaoName"></span><br/>
        	<strong>刷票数：</strong><input id="wantGoCount" type="text" maxlength="3"/><span style="color: red;">（20到100）</span>
            <input class="shuapiaoBtn" type="button" value="开始刷票">
        </div>
    </div>
</body>
</html>
