<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>市场采集列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
	
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    
	    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	        window.dialog = dialog;
	    });
    
        $(function () {
        	//活动类型
            $.post("${path}/tag/getChildTagByType.do",{'code' : 'ACTIVITY_TYPE'},function(data) {
            	if (data.length>0) {
    	            var ulHtml = '';
    	            $.each(data,function(i,dom){
    	            	ulHtml += '<li data-option="'+dom.tagId+'">'+dom.tagName+'</li>';
    	            })
    	            $('#gatherTagUl').html(ulHtml);
    	        }
    		},"json");
        	
        	//评级类别
            $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'RATINGS_INFO'},function(data) {
            	if (data.length>0) {
    	            var ulHtml = '';
    	            $.each(data,function(i,dom){
    	            	ulHtml += '<li data-option="'+dom.dictId+'">'+dom.dictName+'</li>';
    	            })
    	            $('#gatherGradeUl').html(ulHtml);
    	        }
    		},"json");
        	
            selectModel();
        	
            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            });
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'endDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'startDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedendFunc
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
                    formSub('#gatherForm');
                    return false;
                }
            });
        });
        
        function pickedStartFunc() {
            $dp.$('gatherStartDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('gatherEndDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        
      	//提交表单
        function formSub(formName) {
        	var gatherName = $('#gatherName').val();
            if (gatherName != undefined && gatherName == '输入名称') {
                $('#gatherName').val("");
            }
            $(formName).submit();
        }

        //删除
        function deleteGather(gatherId) {
            dialogConfirm("提示", "确定删除该内容？", function(){
            	$.post("${path}/gather/deleteGather.do", {gatherId: gatherId}, function (data) {
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
        
      	//上/下架
        function editGatherStatus(gatherId,gatherStatus) {
      		var text =  gatherStatus==1?"上架":"下架";
            dialogConfirm("提示", "确定"+text+"该内容？", function(){
            	$.post("${path}/gather/saveOrUpdateGather.do", {gatherId: gatherId,gatherStatus: gatherStatus}, function (data) {
                    if (data == "200") {
                    	dialogConfirm("提示", text+"成功！", function(){
                    		formSub('#gatherForm');
                    	})
                    } else {
                        dialogAlert('提示', text+"失败！");
                    }
                });
            });
        }
      	
      	//评级
        function editGatherGrade(gatherId) {
        	dialog({
                url: '${path}/activity/toEditRatingsInfo.do?type=gather&activityId='+gatherId,
                title: '评级',
                width: 520,
                height: 240,
                fixed: true
            }).showModal();
            return false;
        }
    </script>
</head>
<body>
<form id="gatherForm" action="" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>运维管理 &gt; 市场采集管理
    </div>
    <div class="search">
	    <div class="search-box">
	        <input type="text" id="gatherName" name="gatherName" value="${gather.gatherName}" data-val="输入名称" class="input-text"/>
	    </div>
	    <div class="select-box w135">
       		<input type="hidden" id="gatherTag" name="gatherTag" value="${gather.gatherTag}"/>
            <div id="gatherTagDiv" class="select-text" data-value="">类型</div>
            <ul class="select-option" id="gatherTagUl"></ul>
        </div>
	    <div class="select-box w135">
       		<input type="hidden" id="gatherType" name="gatherType" value="${gather.gatherType}"/>
            <div id="gatherTypeDiv" class="select-text" data-value="">标签</div>
            <ul class="select-option">
            	<li data-option="0">热映影片</li>
            	<li data-option="1">舞台演出</li>
            	<li data-option="2">美术展览</li>
            	<li data-option="3">音乐会</li>
            	<li data-option="4">演唱会</li>
            	<li data-option="5">舞蹈</li>
            	<li data-option="6">话剧歌剧</li>
            	<li data-option="7">戏曲曲艺</li>
            	<li data-option="8">儿童剧</li>
            	<li data-option="9">杂技魔术</li>
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" id="gatherGrade" name="gatherGrade" value="${gather.gatherGrade}"/>
            <div id="userAreaDiv" class="select-text" data-value="">评级</div>
            <ul class="select-option" id="gatherGradeUl"></ul>
        </div>
        <div class="select-box w135">
       		<input type="hidden" id="sortType" name="sortType" value="${gather.sortType}"/>
            <div id="videoTypeDiv" class="select-text" data-value="">排序</div>
            <ul class="select-option">
            	<li data-option="1">创建时间</li>
            	<li data-option="2">更新时间</li>
            	<li data-option="3">开始时间</li>
            	<li data-option="4">结束时间</li>
            </ul>
        </div>
        <div class="form-table" style="float: left;">
            <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text">开始日期</span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="gatherStartDate" name="gatherStartDate" value="${gather.gatherStartDate}" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="gatherEndDate" name="gatherEndDate" value="${gather.gatherEndDate}" readonly/>
                    <i class="data-btn end-btn"></i>
                </div>
            </div>
        </div>
	    <div class="select-btn">
	        <input type="button" onclick="$('#page').val(1);formSub('#gatherForm');" value="搜索"/>
	    </div>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/gather/preAddGather.do">新建采集活动</a>
	    </div>
	</div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th class="title">名称</th>
                <th width="120">类型</th>
                <th width="120">标签</th>
                <th width="100">评级</th>
                <th width="120">开始时间</th>
                <th width="120">结束时间</th>
                <th width="120">创建人</th>
                <th width="120">创建时间</th>
                <th width="120">更新人</th>
                <th width="120">更新时间</th>
                <th width="100">状态</th>
                <th width="140">管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="dom">
                <%i++;%>
                <tr>
                    <td><%=i%></td>
                    <td class="title">${dom.gatherName}</td>
                    <td>${dom.gatherTag}</td>
                    <td>
						<c:if test="${dom.gatherType == 0}">热映影片</c:if>
		            	<c:if test="${dom.gatherType == 1}">舞台演出</c:if>
		            	<c:if test="${dom.gatherType == 2}">美术展览</c:if>
		            	<c:if test="${dom.gatherType == 3}">音乐会</c:if>
		            	<c:if test="${dom.gatherType == 4}">演唱会</c:if>
		            	<c:if test="${dom.gatherType == 5}">舞蹈</c:if>
		            	<c:if test="${dom.gatherType == 6}">话剧歌剧</c:if>
		            	<c:if test="${dom.gatherType == 7}">戏曲曲艺</c:if>
		            	<c:if test="${dom.gatherType == 8}">儿童剧</c:if>
		            	<c:if test="${dom.gatherType == 9}">杂技魔术</c:if>
					</td>
                    <td>
                    	<c:if test="${not empty dom.gatherGrade}">${dom.gatherGrade}</c:if>
                    	<c:if test="${empty dom.gatherGrade}">暂无评级</c:if>
                    </td>
                    <td>${dom.gatherStartDate}</td>
                    <td>${dom.gatherEndDate}</td>
                    <td>${dom.gatherCreateUser}</td>
                    <td><fmt:formatDate value="${dom.gatherCreateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${dom.gatherUpdateUser}</td>
                    <td><fmt:formatDate value="${dom.gatherUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                    	<c:if test="${dom.gatherStatus == 1}">已上架</c:if>
                    	<c:if test="${dom.gatherStatus == 0}">未上架</c:if>
                    </td>
                    <td>
                    	<c:if test="${dom.gatherStatus == 1}"><a target="main" href="javascript:editGatherStatus('${dom.gatherId}',0)">下架</a></c:if>
                    	<c:if test="${dom.gatherStatus == 0}"><a target="main" href="javascript:editGatherStatus('${dom.gatherId}',1)">上架</a></c:if>
                    	 | <a target="main" href="javascript:editGatherGrade('${dom.gatherId}')">评级</a>
                    	 | <a target="main" href="${path}/gather/preEditGather.do?gatherId=${dom.gatherId}">编辑</a>
                    	 | <a target="main" href="javascript:deleteGather('${dom.gatherId}');" style="color: red;font-weight: bold;">删除</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="12"><h4 style="color:#DC590C">暂无数据!</h4></td>
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
</body>
</html>
