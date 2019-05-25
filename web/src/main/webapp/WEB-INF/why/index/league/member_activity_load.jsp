<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<div class="sort-box search-result" style="display: none" id="no_results">
    <div class="no-result">
        <h2>抱歉，没有找到符合条件的结果</h2>
    </div>
</div>


<div id="hot_list" class="unionVenueList unionHotActList">
    <ul id="activity_list" class="hl_list clearfix">
    </ul>
</div>

<div id="kkpager"></div>

<script>

    $(function(){
        loadActivityList(1);
    });

    function loadActivityList(page) {
        $.ajax({
            url: "../member/activityQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 12,page:page},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        str += '<li>';
                        str += '  <div class="img">';
                        var imgUrl = data[k].activityIconUrl;
                        var trueImgUrl;
                        var index = imgUrl.lastIndexOf("http:");
                        if (index > -1) {
                            trueImgUrl = imgUrl;
                        }
                        else
                            trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");

                        var activityTime = data[k].activityStartTime;
                        //判断是否过期
                        var maxDateTime = "";
                        if (data[k].activityEndTime != undefined && data[k].activityEndTime != '') {
                            var maxDate = data[k].activityEndTime.substr(0, 16);
                            maxDateTime = new Date(maxDate.replace(/-/g, "/"));
                        }
                        var nowDateTime = new Date();
                        //是否收藏
                        var collectNum = data[k].collectNum;
                        var availableCount = data[k].availableCount;
                        if (data[k].activityEndTime != undefined && data[k].activityEndTime != '') {
                            activityTime += "至" + data[k].activityEndTime;
                        }
                        var activitySite = data[k].activitySite;
                        if (activitySite == undefined || activitySite == '') {
                            activitySite = data[k].activityAddress;
                        }
                        if (activitySite.length > 36) {
                            activitySite = activitySite.substr(0, 36);
                            activitySite += "...";
                        }
                        if (data[k].sysNo != undefined && data[k].sysNo != '' && data[k].sysId != undefined && data[k].sysId != '') {
                            str += '<input name="sysId" type="hidden" value="' + data[k].sysId + '" />';
                        }


                        str += '    <a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"><img src="' + trueImgUrl + '" width="280" height="185" /></a>';
                        str += '  </div>';
                        str += '  <div class="intro">';
                        str += '    <h3><a target="_blank" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '">' + data[k].activityName + '</a></h3>';
                        str += '    <p>时间：' + activityTime + '</p>';
                        str += '    <p>地点：' + activitySite + '</p>';
                        str += '  </div>';
                        str += '  <div class="do">';
                        if (collectNum > 0) {
                            str += '     <div class="collect"><a class="collected"></a><span>收藏</span></div>';
                        } else {
                            str += '    <div class="collect"><a></a><span>收藏</span></div>';
                        }
                        if (data[k].activityIsReservation == 2) {

                            if (nowDateTime - maxDateTime < 0) {
                                if (availableCount > 0) {
                                    str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + availableCount + '</em><span>余票</span></div>';
                                    str += ' <a target="_blank" dataId=' + data[k].activityId + ' id="bookType' + data[k].sysId + '" href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '" class="reserve">预 订</a>';
                                } else {
                                    str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + 0 + '</em><span>余票</span></div>';
                                    str += ' <a dataId=' + data[k].activityId + ' class="reserve gray" id="bookType' + data[k].sysId + '">已 订 完</a>';
                                }
                            } else {
                                str += '    <div class="ticket"><em id="' + data[k].sysId + '">' + 0 + '</em><span>余票</span></div>';
                                str += ' <a  dataId=' + data[k].activityId + ' class="reserve gray" id="bookType' + data[k].sysId + '">已 结 束</a>';
                            }

                        } else {
                            if (nowDateTime - maxDateTime < 0) {
                                str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"  dataId=' + data[k].activityId + ' class="traffic" id="bookType' + data[k].sysId + '">直 接 前 往</a>';

                            } else {
                                str += ' <a href="../frontActivity/frontActivityDetail.do?activityId=' + data[k].activityId + '"  dataId=' + data[k].activityId + ' class="traffic gray" id="bookType' + data[k].sysId + '">已 结 束</a>';
                            }
                        }
                        str += '  </div>';
                        str += '</li>';
                    }
                    $("#activity_list").html(str);
                }

                var page = rsObj.member;
                if(page.countPage<=1) return;
                kkpager.generPageHtml({
                    total : page.countPage,
                    pno : page.page,
                    totalRecords :  page.total,
                    mode : 'click',//默认值是link，可选link或者click
                    isShowFirstPageBtn	: true, //是否显示首页按钮
                    isShowLastPageBtn	: true, //是否显示尾页按钮
                    isShowPrePageBtn	: true, //是否显示上一页按钮
                    isShowNextPageBtn	: true, //是否显示下一页按钮
                    isShowTotalPage 	: false, //是否显示总页数
                    isShowCurrPage		: false,//是否显示当前页
                    isShowTotalRecords 	: true, //是否显示总记录数
                    isGoPage 			: false,	//是否显示页码跳转输入框
                    click : function(n){
                        $("#page").val(n);
                        loadActivityList(n)
                        //$("#content_div").load("../member/activityList.do?id=${member.id}&rows=12&page="+n,function () {
                        //});
                        return false;
                    }
                });
            }
        });
    }

</script>