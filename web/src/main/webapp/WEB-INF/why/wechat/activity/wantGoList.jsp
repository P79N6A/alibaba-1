<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>我想去</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/iscroll.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/scrollLoadData.js"></script>

    <script type="text/javascript">
        var activityId = '${activityId}';

        $(function () {
            loadData(0, 20);
        });

        function loadData(index, pagesize) {
            pageSize = pagesize;
            startIndex = index;
            var data = {
                activityId: activityId,
                pageIndex: startIndex,
                pageNum: pageSize
            };
            $.post("${path}/wechatActivity/wcActivityUserWantgoList.do", data, function (data) {
                if(data.data.length>0){
                    isScroll=true;
                }else{
                    isScroll=false;
                    pullUpEl.className = 'none';
                    pullUpEl.querySelector('.pullUpLabel').innerHTML = '没有结果了';
                }

                if (startIndex == 0) {  //如果是第一页
                    setTimeout(function () {
                        if (data.status == 0) {
                            var str = "";
                            $.each(data.data, function (i, dom) {
                                str += "<li>";
                                var userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl,"_72_72");
                                str += "<img src='" + userHeadImgUrl + "' width='60' height='60'>";
                                str += "<span>" + dom.userName + "</span>";
                                if (dom.userSex == 1) {
                                    str += "<em> 男</em>";
                                }
                                if (dom.userSex == 2) {
                                    str += "<em> 女</em>";
                                }
                                str += "</li>";

                            }); $("#user-list").append(str);
                        }
                        myScroll.refresh();
                    }, 0);
                    $("html,body").animate({scrollTop: 0}, 200);
                } else {
                    setTimeout(function () {
                        if (data.status == 0) {
                            var str = "";
                            $.each(data.data, function (i, dom) {
                                str += "<li>";
                                var userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl,"_72_72");
                                str += "<img src='" + userHeadImgUrl + "' width='60' height='60'>";
                                str += "<span>" + dom.userName + "</span>";
                                if (dom.userSex == 1) {
                                    str += "<em> 男</em>";
                                }
                                if (dom.userSex == 2) {
                                    str += "<em> 女</em>";
                                }
                                str += "</li>";

                            });$("#user-list").append(str);
                        }
                        myScroll.refresh();
                    }, 500);
                }
                if (isScroll) {
                    startIndex += pageSize;
                }
            }, "json");
        }
        //初始化绑定iScroll控件
        document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
        document.addEventListener('DOMContentLoaded', function(){
            loaded();
        }, false);
    </script>

</head>
<body class="body_scroll">
<div id="wrapper" class="userList_wrapper">
    <div id="scroller">
        <ul class="user-list" id="user-list">
        </ul>
        <div id="pullUp">
            <span class="pullUpIcon"></span><span class="pullUpLabel">上拉加载更多...</span>
        </div>
    </div>
</div>
</body>
</html>