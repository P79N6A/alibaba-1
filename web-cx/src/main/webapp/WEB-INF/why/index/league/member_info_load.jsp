<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="sort-box search-result" style="display: none" id="no_results">
    <div class="no-result">
        <h2>抱歉，没有找到符合条件的结果</h2>
    </div>
</div>


<div class="unionCommonDiv">
    <ul class="unionUlList unionUlList-san clearfix" style="width: 855px;" id="info_ul">
    </ul>
</div>

<div id="kkpager"></div>


<script>

    $(function(){
        loadInfoList(1);
    });

    function loadInfoList(page) {
        $.ajax({
            url: "../member/infoQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 12,page:page},
            success: function (result) {
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        var obj = data[k];
                        str+=' <li onclick="window.location.href=\'${path}/beipiaoInfo/bpInfoDetail.do?infoId='+obj.beipiaoinfoId+'\'"  class="qyItem" style="height: 280px;">\n' +
                            '                    <div class="pic">\n' +
                            '                        <img src="'+obj.beipiaoinfoHomepage+'">\n' +
                            '                    </div>\n' +
                            '                    <div class="char">\n' +
                            '                        <p class="name">'+obj.beipiaoinfoTitle+'</p>\n' +
                            '                        <p class="info">'+obj.beipiaoinfoContent+'</p>\n' +
                            '                    </div>\n' +
                            '                </li>';
                    }
                    $("#info_ul").html(str);

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
                        isShowTotalRecords 	: false, //是否显示总记录数
                        isGoPage 			: false,	//是否显示页码跳转输入框
                        click : function(n){
                            $("#page").val(n);
                            loadInfoList(n);
                            //$("#content_div").load("../member/venueList.do?id=${member.id}&rows=12&page="+n,function () {
                            //});
                            return false;
                        }
                    });

                }
            }
        });
    }



    function loadVenueList(page) {
        //loadingIcon.add();
        $.ajax({
            url: "../member/venueQueryList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 12,page:page},
            success: function (result) {
                loadingIcon.remove();
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    var str = '';
                    for (var k in data) {
                        var obj = data[k];
                        var jiaotong = "";
                        if (obj.venueHasMetro == 2 && obj.venueHasBus == 3) {
                            jiaotong = '地铁、公交';
                        } else if (obj.venueHasMetro = 2 && obj.venueHasBus == 1) {
                            jiaotong = '地铁';
                        } else if (obj.venueHasMetro == 1 && obj.venueHasBus == 2) {
                            jiaotong = '公交';
                        }
                        var province = obj.venueProvince.split(',')[1];
                        var city = obj.venueCity.split(',')[1];
                        var area = obj.venueArea.split(',')[1];

                        var imgUrl = obj.venueIconUrl;
                        var trueImgUrl;
                        var index = imgUrl.lastIndexOf("http:");
                        if (index > -1) {
                            trueImgUrl = imgUrl;
                        }
                        else
                            trueImgUrl = getIndexImgUrl(getImgUrl(imgUrl), "_300_300");


                        str += '<li>\n';

                        if (obj.venueIsReserve == 2) {
                            str += '\t\t\t\t\t\t <div class="order">订</div>\n';
                        }

                        str += '\t\t\t\t\t\t <a href="/frontVenue/venueDetail.do?venueId=' + obj.venueId + '" class="img" target="_blank">\n' +
                            '\t\t\t\t\t\t\t <img onload="fixImage(this, 280, 187)" src="' + trueImgUrl + '" width="280" height="186">\n' +
                            '\t\t\t\t\t\t </a>\n' +
                            '\t\t\t\t\t\t <div class="info">\n' +
                            '\t\t\t\t\t\t\t <h1><a target="_blank" href="/frontVenue/venueDetail.do?venueId=4e0b5a08d934434c8882896f3076375f">' + obj.venueName + '</a></h1>\n' +
                            '\t\t\t\t\t\t\t <!-- <div class="start" tip="5"><p></p></div> -->\n' +
                            '\t\t\t\t\t\t\t <div class="text">\n' +
                            '\t\t\t\t\t\t\t\t <p title="' + province + '&nbsp;' + city + '&nbsp;' + area + obj.venueAddress + '"><span>地址:</span>' + province + '&nbsp;' + city + '&nbsp;' + area + obj.venueAddress + '</p>\n' +
                            '\t\t\t\t\t\t\t\t <p>\n' +
                            '\t\t\t\t\t\t\t\t\t <span>交通:</span>' + jiaotong + '\n' +
                            '\t\t\t\t\t\t\t\t </p>\n' +
                            '\t\t\t\t\t\t\t </div>\n' +
                            '\t\t\t\t\t\t </div>\n' +
                            '\t\t\t\t\t </li>';
                    }
                    $("#venue_list").html(str);
                }

                var page = rsObj.member;


            }
        });
    }






</script>