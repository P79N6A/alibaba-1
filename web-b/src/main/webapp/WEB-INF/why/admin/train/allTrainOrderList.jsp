<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
    <script type="text/javascript">
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        function exportExcel() {
            location.href = "${path}/train/exportTrainOrderExcel.do?" + $("#fm").serialize();
        }
        function exportWord() {
            location.href = "${path}/train/exportTrainOrderWord2.do?" + $("#fm").serialize();
        }
        function sendStartMessage() {
            dialogConfirm("提示","确定要给当前筛选的人发送开课通知吗？",function () {
                $.post("${path}/train/sendStartMessage.do?"+$("#fm").serialize(),function (data) {
                    data = JSON.parse(data)
                    if(data.status == "400"){
                        publicLogin();
                    }else if(data.status=="200"){
                        dialogAlert("提示","短信发送成功!");
                        formSub('#fm');
                    }else{
                        dialogAlert("提示","短信发送失败!");
                        formSub('#fm');
                    }
                });
            })
            /*location.href = "${path}/train/sendStartMessage.do?" + $("#fm").serialize();*/
        }



        function pickedStartFunc() {
            $dp.$('activityStartTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }

        function pickedendFunc() {
            $dp.$('activityEndTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }

        $(function () {
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${order.page}',
                total: '${order.countPage}',
                totalRecords: '${order.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#fm');
                    return false;
                }
            });
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


        function changeLeftMenu() {
            $("#left", parent.document.body).attr("src", "${path}/activityLeft.do")
        }

        //提交表单
        function formSub(formName) {
            $(formName).submit();
        }

        $(function () {
            selectModel();
        });



        /**
         * 发布活动
         */
            function checkOrder(id,state) {
            var maxPeople = '${train.maxPeople}'
            if(maxPeople != null && maxPeople > 0){
                var surplusPeoples = '${train.maxPeople-train.admissionsPeoples}';
                console.log('${train.maxPeople==train.admissionsPeoples}');
                if(state==1 && ${train.maxPeople==train.admissionsPeoples}){
                    dialogAlert('提示', '已达到培训最大录取人数，无法再审核通过！');
                    return;
                }
            }
            var html = "您确定要审核该订单吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/train/saveOrder.do", {"id": id,state:state}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '操作成功', function () {
                            formSub('#fm');
                        });
                    } else {
                        dialogAlert('提示', data.msg, function () {
                            formSub('#fm');
                        });
                    }
                });
            })
        }

        function dialogCopyConfirm(title, content, fn) {
            var d = dialog({
                width: 440,
                title: title,
                content: content,
                fixed: true,
                button: [{
                    value: '直接前往发布',
                    callback: function () {
                        if (fn) fn();
                        //this.content('你同意了');
                        //return false;
                    },
                    autofocus: true
                }, {
                    value: '关闭'
                }]
            });
            d.showModal();
        }




        //查询活动中存在的活动类型
        $(function () {

            var venueProvince = '${user.userProvince}';
            var venueCity = '${user.userCity}';
            var venueArea = '${user.userCounty}';
            var ulHtml = "<li data-option=''>全部区县</li>";
            var divText = "全部区县";
            var loc = new Location();
            var a = new Array();
            var defaultAreaId = $("#activityArea").val();
            a = loc.find('0,' + venueProvince.split(",")[0]);
            $.each(a, function (k, v) {
                var Id = k;
                if (Id == venueCity.split(",")[0]) {
                    var Text = v;
                    ulHtml += '<li data-option="' + Id + '">'
                        + Text
                        + '</li>';
                    if (defaultAreaId == Id) {
                        divText = Text;
                    }
                }
            })
            a = loc.find('0,' + venueProvince.split(",")[0] + ',' + venueCity.split(",")[0]);
            $.each(a, function (k, v) {
                var area = a[k];
                var areaId = k;
                var areaText = v;
                ulHtml += '<li data-option="' + areaId + '">'
                    + areaText
                    + '</li>';
                if (defaultAreaId == areaId) {
                    divText = areaText;
                }
            })
            $("#areaDiv").html(divText)
            $("#areaUl").append(ulHtml);

            var activityType = $('#activityType').val();
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function (data) {
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">全部类型</li>';
                    for (var i = 0; i < list.length; i++) {
                        var dict = list[i];
                        ulHtml += '<li data-option="' + dict.tagId + '">' + dict.tagName + '</li>';
                        if (activityType != '' && dict.tagId == activityType) {
                            $('#activityTypeDiv').html(dict.tagName);
                        }
                    }
                    $('#activityUl').html(ulHtml);
                }
            }).success(function () {
                //selectModel();
            });
        });


        function loadTrainType(){
            var html = "";
            $.post("../tag/getChildTagByType.do?code=TRAIN_TYPE", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html += '<li onclick="loadTrainTag(\''+obj.tagId+'\')" value="'+obj.tagId+'">' + obj.tagName + '</li>';
                }
                $("#trainTypeUl").html('<li data-option="">培训类型</li>'+html);
            });

            /*  var html = "";
              $.post("../tag/getCommonTag.do?type=7", function (data) {
                  var html = "";
                  var list = eval(data);
                  for (var i = 0; i < list.length; i++) {
                      var obj = list[i];
                      html += '<li data-option="'+obj.tagSubId+'">' + obj.tagName + '</li>';
                  }
                  $("#trainTypeUl").html('<li data-option="">培训类型</li>'+html);
                  //selectModel();
              });*/
        }


        //全选或全不选
        function selectTrainOrderIds(state) {
            $("#list-table :checkbox").each(function () {
                if ($('#all').prop('checked')) {
                    $(this).prop("checked", true);
                } else {
                    $(this).prop("checked", false);
                }
            });
        }

        function checkAllOrder(state){
            var ids = "";
            $("#list-table :checkbox").each(function () {
                var checked=$(this).prop("checked");
                if(checked)   ids+=$(this).val()+",";
            });
            if(!ids){
                dialogAlert("提示","请选择需要审核的数据！");
            }else{
                ids = ids.substr(0,ids.length-1);
                var maxPeople = '${train.maxPeople}';
                if(maxPeople != null && maxPeople > 0){
                    var surplusPeoples = '${train.maxPeople-train.admissionsPeoples}';
                    if(state==1){
                        if(ids.split(',').length>surplusPeoples){
                            dialogAlert("提示","所选数量大于最大录取人数，请重新选择！<br>剩余录取"+surplusPeoples+"人!");
                            return;
                        }
                    }
                }
                dialogConfirm("提示", "您确定要批量审核所选订单吗？", function () {
                    $.post("${path}/train/saveOrder.do", {"ids": ids,state:state}, function (data) {
                        data = JSON.parse(data);
                        if ('200' == data.status) {
                            dialogAlert('提示', '操作成功', function () {
                                formSub('#fm');
                            });
                        } else {
                            dialogAlert('提示', data.msg, function () {
                                formSub('#fm');
                            });
                        }
                    });
                });
            }
        }
    </script>

</head>
<body>
<form id="fm" action="${path}/train/allTrainOrderList.do" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>培训管理&gt; 报名管理
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="trainTitle" name="orderNum" value="${order.orderNum}"
                          placeholder="输入订单号" class="input-text"/>
        </div>
        <div class="search-box">
            <i></i><input type="text" id="phoneNum" name="phoneNum" value="${order.phoneNum}"
                          placeholder="请输入报名人手机号" class="input-text"/>
        </div>
        <div class="search-box">
            <i></i><input type="text" id="idCard" name="idCard" value="${order.idCard}"
                          placeholder="请输入报名人身份证号" class="input-text"/>
        </div>

        <div class="select-box w135">
            <input type="hidden" value="${order.state}" name="state"
                   id="state"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${order.state == '1'}">
                        已录取
                    </c:when>
                    <c:when test="${order.state == '2'}">
                        退订
                    </c:when>
                    <c:when test="${order.state == '3'}">
                        审核中
                    </c:when>
                    <c:when test="${order.state == '4'}">
                        审核不通过
                    </c:when>
                    <c:otherwise>
                        报名状态
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">报名状态</li>
                <li data-option="1">已录取</li>
                <li data-option="2">退订</li>
                <li data-option="3">审核中</li>
                <li data-option="4">审核不通过</li>
            </ul>
        </div>
        <div class="select-box w135">
            <input type="hidden" value="${order.sex}" name="sex"
                   id="sex"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${order.sex == '1'}">
                        男
                    </c:when>
                    <c:otherwise>
                        女
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">性别</li>
                <li data-option="1">男</li>
                <li data-option="2">女</li>
            </ul>
        </div>
        <div class="form-table" style="float: left;">
            <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text">开始日期</span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="activityStartTime" name="orderStartTime"
                           value="${order.orderStartTime}" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <span class="txt" style="line-height: 42px;">至</span>
                <div class="end w240">
                    <span class="text">结束日期</span>
                    <input type="hidden" id="endDateHidden"/>
                    <input type="text" id="activityEndTime" name="orderEndTime" value="${order.orderEndTime}"
                           readonly/>
                    <i class="data-btn end-btn"></i>
                </div>
        </div>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#fm');" value="搜索"/>
        </div>
        <div class="select-btn" style="width: 250px;margin-left: 20px;">
            <input type="button" onclick="checkAllOrder(1)" value="批量通过" style="background-color:#17a15a"/>
            <input type="button" onclick="checkAllOrder(4)" value="批量不通过" style="background-color:#ed3838"/>
        </div>
        <div class="search menage">
                <%--<div class="menage-box">
                    <a class="btn-add" href="javascript:exportWord()">导出报名表</a>
                </div>--%>
            <div class="menage-box">
                <a class="btn-add" href="javascript:exportExcel()">导出名单</a>
            </div>
            <div class="menage-box">
                <a class="btn-add" href="javascript:sendStartMessage()">发送开课通知</a>
            </div>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th><input type="checkbox" name="checkAll" id="all" onclick="selectTrainOrderIds()" />全选 </th>
                <th class="title">订单号</th>
                <th>姓名</th>
                <th>手机号</th>
                <th>身份证号</th>
                <th>性别</th>
                <th>报名时间</th>
                <th>状态</th>
                <th>备注</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody id="list-table">
            <c:forEach items="${list}" var="o">
                <tr>
                    <td>
                        <c:if test="${o.state==3}">
                            <input type="checkbox"  name="orderId"  value="${o.id}" />
                        </c:if>
                    </td>
                    <td class="title">${o.orderNum}</td>
                    <td>${o.name}</td>
                    <td>${o.phoneNum}</td>
                    <td>${fn:substring(o.idCard,0,14)}***</td>
                    <%--<td>${o.birthday}</td>--%>
                    <td>${o.sex==1?'男':'女'}</td>
                    <td><fmt:formatDate value="${o.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${o.state==1?'已录取':o.state==2?'已退订':o.state==3?'待审核':'已拒绝'}</td>
                    <td title="${o.trainRemark}">
                        <c:if test="${not empty o.trainRemark}">
                            <c:out value="${fn:substring(o.trainRemark,0,10)}...."/></td>
                        </c:if>
                    <td>
                        <c:if test="${o.state==3}">
                            <a target="main" href="javascript:checkOrder('${o.id}',1)">通过</a> |

                            <a target="main" href="javascript:checkOrder('${o.id}',4)">拒绝</a> |
                        </c:if>
                        <c:if test="${o.state!=2}">
                            <a target="main" href="javascript:checkOrder('${o.id}',2)">取消报名</a>
                        </c:if>
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
            <input type="hidden" id="page" name="page" value="${order.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>