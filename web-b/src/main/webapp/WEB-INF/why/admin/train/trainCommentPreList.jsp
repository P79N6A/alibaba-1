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
            var activityName = $('#activityName').val();
            if (activityName != undefined && activityName == '输入名称') {
                $('#activityName').val("");
            }

            /*            $.post("

            ${path}/activity/exportActivityExcel.do",$("#activityForm").serialize(), function(rsData) {
             });*/
            location.href = "${path}/activity/exportActivityExcel.do?" + $("#activityForm").serialize();
        }

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

        $(function () {
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${train.page}',
                total: '${train.countPage}',
                totalRecords: '${train.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityForm');
                    return false;
                }
            });
        });

        function downTrain(id,flag) {
            if(flag==0){
                var showText = "您确定要下架该培训吗？";
            }else{
                var showText = "该培训已产生用户报名订单，下架后将取消该" +
                    "活动下所有订单并给订单用户发送培训撤销信" +
                    "息。您确定撤销该培训吗？";
            }
            dialogConfirm("提示", showText, removeParent);
            function removeParent() {
                $.post("${path}/train/save.do", {"id": id,trainStatus:2}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '该培训已下架至草稿箱', function () {
                            formSub('#activityForm');
                        });
                    } else {
                        dialogAlert('提示', data.data);
                    }
                });
            }
        }

        function upTrain(id) {
            var showText = "您确定要上架该培训吗？";
            dialogConfirm("提示", showText, removeParent);

            function removeParent() {
                $.post("${path}/train/save.do", {"id": id,trainStatus:1}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '上架成功', function () {
                            formSub('#activityForm');
                        });
                    } else {
                        dialogAlert('提示', data.data);
                    }
                });
            }
        }

        function delTrain(id) {
            var showText = "删除后不可恢复！您确定要删除该培训吗？";
            dialogConfirm("提示", showText, removeParent);

            function removeParent() {
                $.post("${path}/train/save.do", {"id": id,isDelete:0}, function (data) {
                    data = JSON.parse(data);
                    if ('200' == data.status) {
                        dialogAlert('提示', '删除成功', function () {
                            formSub('#activityForm');
                        });
                    } else {
                        dialogAlert('提示', data.msg);
                    }
                });
            }
        }





        //还原
        function returnBack(id) {
            dialogConfirm("还原活动", "您确定要还原该活动吗？", removeParent);

            function removeParent() {
                $.post("${path}/activity/returnActivity.do", {"id": id}, function (rsData) {
                    if (rsData == 'success') {
                        location.href = "${path}/activity/activityIndex.do?activityIsDel=${activity.activityIsDel}&activityState=${activity.activityState}";
                    } else {
                        dialogAlert("提示", "操作失败：" + rsData);
                    }
                });
            }
        }

        function changeLeftMenu() {
            $("#left", parent.document.body).attr("src", "${path}/activityLeft.do")
        }

        //提交表单
        function formSub(formName) {
            $(formName).submit();
        }

        //全选或全不选
        function selectActivityIds() {
            $("#list-table :checkbox").each(function () {
                if ($("#checkAll").attr("checked")) {
                    $(this).attr("checked", true);
                } else {
                    $(this).attr("checked", false);
                }
            });
        }

        $(function () {
            loadTrainType();
            selectModel();
            /*$("#trainTagUl").html('<li data-option="">培训标签</li>'+html);*/
            $('#trainTypeUl').on("mousedown","li",function(){
                var tagId = $("#activityType").val();
                loadTrainTag(tagId);
            });
        });

        //推荐
        function recommendActivityById(activityId) {
            var activityRecommend = $("#" + activityId).val();
            var showText = "推荐成功!";
            var tempValue = activityRecommend;
            if (activityRecommend == "Y") {
                tempValue = "N";

            } else {
                tempValue = "Y";
                showText = "取消推荐成功!";
            }
            $.post("${path}/activity/recommendActivity.do", {
                "activityRecommend": activityRecommend,
                "activityId": activityId
            }, function (rsData) {
                if (rsData == 'success') {
                    dialogAlert("提示", showText, function () {
                        // location.href= "${path}/activity/activityIndex.do?" + $("#activityForm").serialize();
                        location.reload();
                    });

                } else {
                    dialogAlert("提示", "推荐失败：" + rsData);
                }
            });
        }

        /**
         * 发布活动
         */
        function publishActivity(activityId) {
            var html = "您确定要发布该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/activity/publishActivity.do", {"activityId": activityId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/activity/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    }
                    else if (data != null && data == 'event') {

                        dialogAlert("提示", "发布失败，请完善活动信息！");
                    }
                    else {
                        dialogAlert("提示", "发布失败，系统错误！");
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


        function copyActivity(id) {

            $.post("${path}/activity/copyActivity.do", {"activityId": id}, function (data) {

                var result = data.result;

                if (result == 'success') {

                    var activityId = data.activityId;

                    dialogCopyConfirm("提示", "本活动已经复制进“草稿箱”，请至草稿箱编辑后进行发布。", function () {
                        window.location.href = "../activity/preEditActivity.do?id=" + activityId
                    });
                }
            });
        }

        /**
         * 推荐活动
         */
        function recommendActivity(activityId) {
            var html = "您确定要推荐该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/recommendActivity.do", {"activityId": activityId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/activity/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    } else {
                        dialogConfirm("提示", "活动已被推荐", function () {
                            window.location.href = "${path}/activity/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        })
                    }
                });
            })
        }

        /**
         * 取消推荐活动
         */
        function cancelRecommendActivity(recommendId) {
            var html = "您确定要取消推荐该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/cancelRecommendActivity.do", {"recommendId": recommendId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/activity/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                    } else {
                        dialogConfirm("提示", "活动信息异常", function () {
                            window.location.href = "${path}/activity/activityIndex.do?activityState=${activity.activityState}&activityIsDel=${activity.activityIsDel}";
                        })
                    }
                });
            })
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

        function toEditRatingsInfo(id) {
            dialog({
                url: '${path}/activity/toEditRatingsInfo.do?type=activity&activityId=' + id,
                title: '评级',
                width: 520,
                height: 240,
                fixed: true

            }).showModal();
            return false;

        }

        //万能发布器
        function preActivityPublisher(activityId) {
            var userId = '${sessionScope.user.userId}';
            if (userId == null || userId == '') {
                window.location.href = '${path}/admin.do';
                return;
            }
            var winH = parseInt($(window).height() * 0.95);
            $.DialogBySHF.Dialog({
                Width: 860,
                Height: winH,
                URL: '../activityPublisher/preActivityPublisher.do?activityId=' + activityId
            });
        }

        function loadTrainType() {
            var html = "";
            var nowType = '${train.trainType}'
            $.post("../tag/getChildTagByType.do?code=TRAIN_TYPE", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    if(nowType != null && nowType == obj.tagId){
                        $("#trainTypeDiv").html(obj.tagName);
                        loadTrainTag(obj.tagId);
                    }
                    html += '<li id="li" data-option="' + obj.tagId + '">' + obj.tagName + '</li>';
                }
                $("#trainTypeUl").html('<li data-option="">培训类型</li>' + html);

            });

            /*           var html = "";
                       $.post("../tag/getTagSubByTagId.do", {},function (data) {
                          var html = "";
                          var list = eval(data);
                          for (var i = 0; i < list.length; i++) {
                              var obj = list[i];
                              html += '<li data-option="'+obj.tagSubId+'">' + obj.tagName + '</li>';
                          }
                          $("#trainTagUl").html('<li data-option="">培训标签</li>'+html);
                          //selectModel();
                       });*/
        }

/*        $(".typeUl").on('click','typeUl2',function(tagId){
            var html = "";
            $("#trainTagUl").html("");
            $.post("${path}/tag/getTagSubByTagId.do?tagId="+tagId,function (data) {
                var html = "";
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html += '<li data-option="'+obj.tagSubId+'">' + obj.tagName + '</li>';
                }
                $("#trainTagUl").html('<li data-option="">培训标签</li>'+html);
                //selectModel();
            });
        });*/
        //父标签的点击事件
        function setParentId(id) {
            $("#trainTagUl").html("");
            $.post("${path}/tag/getTagSubByTagId.do", {"tagId": id},
                function (data) {
                    var list = eval(data);
                    var tagHtml = '';
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var tagId = obj.tagSubId;
                        var tagName = obj.tagName;
                        tagHtml += '<li value="'+obj.tagId+'" id="' + tagName + '" class="tagType">' + tagName
                            + '</li>';
                    }
                    $("#trainTagUl").html(tagHtml);

                });
        }

       function loadTrainTag(){
           var html = "";
           var tagId = $("#trainType").val();
           var commonTagList = [<c:forEach items="${tagSubList}" var="tagSub">
               {tagName:'${tagSub.tagName}',tagSubId:'${tagSub.tagSubId}'},
               </c:forEach>];
           for(var i in commonTagList){
               var cmsTagSub = commonTagList[i];
               var nowTagSub = '${train.trainTag}';
               if(nowTagSub != null && nowTagSub == cmsTagSub.tagName){
                   $("#trainTagDiv").html(cmsTagSub.tagName);
               }
               html += '<li data-option="'+cmsTagSub.tagName+'">' + cmsTagSub.tagName + '</li>';
           }
           $.post("${path}/tag/getTagSubByTagId.do?tagId="+tagId,function (data) {
               var list = eval(data);
               for (var i = 0; i < list.length; i++) {
                   var obj = list[i];
                   html += '<li data-option="'+obj.tagName+'">' + obj.tagName + '</li>';
               }
               $("#trainTagUl").html('<li data-option="">培训标签</li>'+html);
               //   selectModel();
           });
       }

    </script>
    <style type="text/css">
        .ui-dialog-title, .ui-dialog-content textarea {
            font-family: Microsoft YaHei;
        }

        .ui-dialog-header {
            border-color: #9b9b9b;
        }

        .ui-dialog-close {
            display: none;
        }

        .ui-dialog-title {
            color: #F23330;
            font-size: 20px;
            text-align: center;
        }

        .ui-dialog-content {
        }

        .ui-dialog-body {
        }
    </style>
</head>
<body>
<form id="activityForm" action="" method="post">
    <input type="hidden" name="trainStatus" id="trainStatus" value="${train.trainStatus}"/>
    <div class="site">
        <em>您现在所在的位置：</em>培训管理
        <c:if test="${train.trainStatus == 1}">
            &gt; 培训列表
        </c:if>
        <c:if test="${train.trainStatus == 2}">
            &gt; 草稿箱
        </c:if>
    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="trainTitle" name="trainTitle" value="${train.trainTitle}"
                          placeholder="输入培训名称" class="input-text"/>
        </div>
        <%--<div class="select-box w135">
            <input type="hidden" id="venueType" name="venueType" value="${train.venueType}" />
            <div id="venueTypeDiv" class="select-text" data-value="1">全部场馆</div>
            <ul class="select-option" id="venueTypeUl">
                <li  data-option="">全部场馆</li>
                <li  data-option="2">区级自建</li>
                <li  data-option="408f451ea4b941b286ed1481146a719a">文化馆</li>
                <li  data-option="4b8251860c9642a9920dc936c83e7c52">图书馆</li>
                <li  data-option="502471342134497ca686d6dc2c03cba1">美术馆</li>
                <li  data-option="8300e5c3a1444c7d8788824e9a0dcc86">综合文化站</li>
                <li  data-option="fbb6986440d741d982a2365f28d5f078">博物馆</li>
            </ul>
        </div>--%>
        <div class="select-box w135">
            <input type="hidden" id="trainType" name="trainType" value="${train.trainType}"
             onchange="loadTrainTag();"/>
                <div id="trainTypeDiv" class="select-text" data-value="">培训类型</div>
            <ul class="select-option" id="trainTypeUl">
            </ul>
        </div>

        <div class="select-box w135" >
            <input type="hidden" id="trainTag" name="trainTag" value="${train.trainTag}"/>
            <div id="trainTagDiv" class="select-text" data-value="">培训标签</div>
            <ul class="select-option" id="trainTagUl">
            </ul>
        </div>

        <div class="select-box w135">
            <input type="hidden" value="${train.trainField}" name="trainField"
                   id="trainField"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${train.trainField == '1'}">
                        单场
                    </c:when>
                    <c:when test="${train.trainField == '2'}">
                        多场
                    </c:when>
                    <c:otherwise>
                        场次
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="">场次</li>
                <li data-option="1">单场</li>
                <li data-option="2">多场</li>
            </ul>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">培训名称</th>
                <th>区域</th>
                <th>所属类型</th>
                <th>场次</th>
                <th>操作人</th>
                <th>评论数量</th>
                <th>操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${trainList}" var="o" varStatus="i">
                <tr>
                    <td>${i.index+1}</td>
                    <td class="title">${o.trainTitle}</td>
                    <td>${o.trainArea}</td>
                    <td>${o.typeName}</td>
                    <td>${o.trainField==1?'单场':'多场'}</td>
                    <td>${o.userName}</td>
                    <td>${o.trainCommentCount}</td>
                    <td><fmt:formatDate value="${o.updateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
                        <a target="main" href="${path}/train/allComment.do?commentRkId=${o.id}">全部评论</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty trainList}">
                <tr>
                    <td colspan="10"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty trainList}">
            <input type="hidden" id="page" name="page" value="${train.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>