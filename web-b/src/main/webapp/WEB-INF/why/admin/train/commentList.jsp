<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

	<title>文化安康云</title>
	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/limit.jsp"%>
	 <script type="text/javascript"
	src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
		seajs.use([ '${path}/STATIC/js/dialogBack/src/dialog-plus' ], function(
				dialog) {
			window.dialog = dialog;
		});
	</script>

	<script type="text/javascript">
		$(function(){
			kkpager.generPageHtml({
				pno : '${page.page}',
				total : '${page.countPage}',
				totalRecords :  '${page.total}',
				mode : 'click',//默认值是link，可选link或者click
				click : function(n){
					this.selectPage(n);
					$("#page").val(n);
					doSearchUser('#terminalUserForm');
					return false;
				}
			});
			selectModel();
            //当不是全选时取消全选按钮
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

        //** 日期控件
        $(function () {
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
        });

        function pickedStartFunc() {
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }

        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function doSearchUser(){
            $("#trainCommentForm").submit();
        }
        //全选全不选
        function selectAll(allEle) {
            if($(allEle).is(':checked')) {
                $('input[name="subcheck"]').prop("checked",true);
            } else {
                $('input[name="subcheck"]').prop("checked",false);
            }
        }
		 
		function severalDelete(){
            var subcheck=document.getElementsByName('subcheck');
            var commentId='';
            for(var i=0; i<subcheck.length; i++){
                if(subcheck[i].checked){
                    commentId+=subcheck[i].value+","; //如果选中，将value添加到变量中
                }
            }
            if(!commentId){
                dialogAlert("提示","请选择要删除的评论！")
			}else{
                dialogConfirm("提示","确定删除这些评论吗？",function(){
                    $.post("${path}/comment/deleteComment.do", {commentId: commentId}, function (data) {
                        if (data == "success") {
                            dialogConfirm("提示", "删除成功！",function(){
                                $('#trainCommentForm').submit();
                            });
                        } else {
                            dialogAlert('提示', "删除失败！");
                        }
                    });
                });
			}
		}
        function serveralRecommend(){
            var subcheck=document.getElementsByName('subcheck');
            var commentId='';
            for(var i=0; i<subcheck.length; i++){
                if(subcheck[i].checked){
                    commentId+=subcheck[i].value+","; //如果选中，将value添加到变量中
                }
            }
            if(!commentId){
                dialogAlert("提示","请选择要推荐的评论！")
			}else{
                dialogConfirm("提示","确定推荐这些评论吗？",function(){
                    $.post("${path}/comment/commentTopTrue.do", {commentId: commentId}, function (data) {
                        if (data == "success") {
                            dialogConfirm("提示", "推荐成功！",function(){
                                $('#trainCommentForm').submit();
                            });
                        } else {
                            dialogAlert('提示', "推荐失败！");
                        }
                    });
                });
			}
        }
        function recommendComment(commentId) {
            dialogConfirm("提示","确定推荐评论吗？",function(){
                $.post("${path}/comment/commentTopTrue.do", {commentId: commentId}, function (data) {
                    if (data == "success") {
                        dialogConfirm("提示", "推荐成功！",function(){
                            $('#trainCommentForm').submit();
                        });
                    } else {
                        dialogAlert('提示', "推荐失败！");
                    }
                });
            });
        }
        function cancelRecommend(commentId) {
            dialogConfirm("提示","确定取消推荐些评论吗？",function(){
                $.post("${path}/comment/commentTopFalse.do", {commentId: commentId}, function (data) {
                    if (data == "success") {
                        dialogConfirm("提示", "取消推荐成功！",function(){
                            $('#trainCommentForm').submit();
                        });
                    } else {
                        dialogAlert('提示', "取消推荐失败！");
                    }
                });
            });
        }
        function deleteComment(commentId) {
            dialogConfirm("提示","确定删除评论吗？",function(){
                $.post("${path}/comment/deleteComment.do", {commentId: commentId}, function (data) {
                    if (data == "success") {
                        dialogConfirm("提示", "删除成功！",function(){
                            $('#trainCommentForm').submit();
                        });
                    } else {
                        dialogAlert('提示', "删除失败！");
                    }
                });
            });
        }

        function viewComment(commentId) {
			window.location.href = "${path}/comment/viewComment.do?commentId="+commentId;
        }
			
	</script>
</head>
<body>

<div class="site">
	<em>您现在所在的位置：</em>培训管理 &gt;评论管理
</div>
<form action="" id="trainCommentForm" method="post">
	<div class="search">
<%--		<div class="select-box w135">
			<input type="hidden" id="commentIsTop" name="commentIsTop" value="${comment.commentIsTop}" />
			<div class="select-text" data-value="" id="commentTypeDiv">全部状态</div>
			<ul class="select-option">
				<li data-option="">全部状态</li>
				<li data-option="0">未推荐</li>
				<li data-option="1">已推荐</li>
			</ul>
		</div>--%>
		<div class="form-table" style="float: left;">
			<div class="td-time" style="margin-top: 0px;">
				<div class="start w240" style="margin-left: 8px;">
					<span class="text">开始日期</span>
					<input type="hidden" id="startDateHidden"/>
					<input type="text" id="activityStartTime" name="commentStartTime"
						   value="" readonly/>
					<i class="data-btn start-btn"></i>
				</div>
				<span class="txt" style="line-height: 42px;">至</span>
				<div class="end w240">
					<span class="text">结束日期</span>
					<input type="hidden" id="endDateHidden"/>
					<input type="text" id="activityEndTime" name="commentEndTime" value=""
						   readonly/>
					<i class="data-btn end-btn"></i>
				</div>
			</div>
		</div>
		<div class="select-btn" style="width: marign-left:10px;"><input type="button" value="搜索" onclick="$('#page').val(1);doSearchUser('#trainCommentForm')"/></div>
		<%--<div class="select-btn" style="width: marign-left:10px;"><input type="button" onclick="severalDelete();" id="cloudBtn"  value="批量删除" /></div>
		<div class="select-btn" style="width: marign-left:10px;"><input type="button" onclick="serveralRecommend();" id="cloudBtn2"  value="批量推荐" /></div>--%>

		<div style="clear: both"></div>
	</div>
	<div class="main-content">
		<table width="100%">
			<thead>
			<tr>
				<%--<th ><input type="checkbox" name="SelectAll" onclick="selectAll(this);" value="全选"/>全选 </th>--%>
				<th width="300">ID</th>
				<th>评论内容</th>
				<th>评论人</th>
				<%--<th>状态</th>--%>
				<th>评论时间</th>
				<th>管理</th>
			</tr>
			</thead>
			<tbody id="list-table">
			<%int i=0;%>
			<c:if test="${null != commentList}">
				<c:forEach items="${commentList}" var="dataList" varStatus="status">
					<%i++;%>
					<tr>
						<%--<td><input type="checkbox" name="subcheck"  value="${dataList.commentId}" /></td>--%>
						<td><%=i%></td>
						<td>${dataList.commentRemark}</td>
						<td>${dataList.commentUserName}</td>
						<%--<c:if test="${dataList.commentIsTop == 0}"><td>未推荐</td></c:if>
						<c:if test="${dataList.commentIsTop == 1}"><td>已推荐</td></c:if>--%>
						<td><fmt:formatDate value="${dataList.commentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td>
							<%--<c:choose>
								<c:when test="${dataList.commentIsTop == 0}">
								<a href="javaScript:recommendComment('${dataList.commentId}')" target="main">推荐</a> |
								</c:when>
								<c:otherwise>
								<a href="javaScript:cancelRecommend('${dataList.commentId}')" target="main">取消推荐</a> |
								</c:otherwise>
							</c:choose>--%>
							<a href="javaScript:deleteComment('${dataList.commentId}')" target="main">删除</a> |
							<a href="javaScript:viewComment('${dataList.commentId}')" target="main">查看</a>
						</td>
					</tr>
				</c:forEach>
			</c:if>
			<c:if test="${empty commentList}">
				<tr>
					<td colspan="9"> <h4 style="color:#DC590C">暂无数据!</h4></td>
				</tr>
			</c:if>
			</tbody>
		</table>
		<c:if test="${not empty commentList}">
			<input type="hidden" id="page" name="page" value="${page.page}" />
			<div id="kkpager"></div>
		</c:if>
	</div>
</form>
</body>
</html>