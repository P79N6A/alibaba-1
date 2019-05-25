<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>安康文化云·志愿服务列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
</head>

<body>
<div class="content">
    <div id="container"></div>
    <!-- 加载按钮 -->
    <div class="infinite-scroll-preloader">
        <a href="javascritp:void();" onclick="handleLoadMore()">点击加载更多</a>
    </div>
</div>
<%@include file="/WEB-INF/why/wechat/static/volunteer/menu.jsp" %>

<script>

    // 加载flag
    var loading = false;

    // 每次加载添加多少条目
    var rows = 5;

    // 上次加载的页
    var lastPage = 0;

    //已加载条数
    var loadedRows = 0;

    //总条数
    var totalRows = 0;
    $(function() {
        getList();
    });

    //点击加载更多
    function handleLoadMore(){// 如果正在加载，则退出
        if (loading) return;

        // 重置加载flag
        loading = false;

        if (loadedRows >= totalRows) {
            // 删除加载提示符
            $('.infinite-scroll-preloader').remove();
            $.toast('已全部加载');
            loading = false;
            return;
        }

        // 添加新条目
        getList();
    }

    //获取列表数据
    function getList(){
        var strList = ''
        $.ajax({
            type: 'get',
            url: '/newVolunteerActivity/queryNewVolunteerActivityListJson.do',
            contentType: 'application/json; charset=utf-8',
            data: {page: lastPage++, rows: rows},
            dataType: 'json',
            before: function(){
                $.showPreloader();
            },
            success: function (res) {
                if(res && res.status === 200){
                    var list = res.volunteerActivityList;
                    totalRows = res.page.total;
                    $.each(list, function(index, obj){
                        obj.limitNum = obj.limitNum ? obj.limitNum : 0
                        var time = obj.startTime.substr(0, 16) + '至' + obj.endTime.substr(0, 16)
                        var address = obj.address ? obj.address : '';
                        strList += '<div class="card demo-card-header-pic" onclick="goDetail(\''+ obj.uuid +'\')">';
                        strList += '<div valign="bottom" class="card-header color-white no-border no-padding">';
                        strList += '   <img class="card-cover" src="'+ obj.picUrl +'" alt="'+ obj.name +'">';
                        strList += '</div>';
                        strList += '<div class="card-content">';
                        strList += '    <div class="card-content-inner">';
                        strList += '        <p>'+ obj.name +'</p>';
                        if(obj.recruitmentStatus == 1){
                            strList += '    <p class="color-gray">招募'+ obj.limitNum +'人</p>';
                        }else if(obj.recruitmentStatus == 2){
                            strList += '    <p class="color-gray">停止招募</p>';
                        }
                        if(obj.recruitObjectType == '1'){
                            strList += '    <p class="color-gray">招募类型：个人</p>';
                        }else if(obj.recruitObjectType == '2'){
                            strList += '    <p class="color-gray">招募类型：团队</p>';
                        }else if(obj.recruitObjectType == '1,2'){
                            strList += '    <p class="color-gray">招募类型：个人、团队</p>';
                        }
                        strList += '        <p class="color-gray">时间：'+ time +'</p>';
                        strList += '        <p class="color-gray">地址：'+ address +'</p>';
                        strList += '    </div>';
                        strList += '</div>';
                        strList += '</div>';
                    })
                }

            },
            error: function (err) {
                strList = '获取失败';
            },
            complete: function(){
                $('#container').append(strList);
                // 更新最后加载的序号
                loadedRows = $('#container .card').length;
            }
        });
    }

    function goDetail(uuid){
        location.href='/wechatStatic/volunteerDetail.do?id=' + uuid
    }
</script>
</body>

</html>