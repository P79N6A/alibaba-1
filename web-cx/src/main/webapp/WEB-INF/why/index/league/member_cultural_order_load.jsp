<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<div class="sort-box search-result" style="display: none" id="no_results">
    <div class="no-result">
        <h2>抱歉，没有找到符合条件的结果</h2>
    </div>
</div>

<!-- start 我要点单 页面 -->
<div class="unionCommonDiv">
    <div class="unionRightTit clearfix" style="padding-top: 10px;">
        <div class="unionOrderNavTwo">
            <span class="cur" culturalOrderLargeType="1">我要参与</span>
            <span culturalOrderLargeType="2">我要邀请</span>
        </div>
    </div>
    <ul class="unionUlList unionUlList-san clearfix" style="width: 855px;" id="culturalList_ul">
    </ul>
</div>
<!-- end 我要点单 页面 -->



<div id="kkpager"></div>

<script>

    $(function(){
        loadCulturalOrderList(1,1);
        
        $(".unionOrderNavTwo span").on('click',function () {
            $(this).addClass('cur').siblings().removeClass('cur');
            var culturalOrderLargeType = $(this).attr('culturalOrderLargeType');
            $("#culturalList_ul").html('');
            loadCulturalOrderList(1,culturalOrderLargeType);
        })
        
    });

    function loadCulturalOrderList(page,culturalOrderLargeType) {
        $.ajax({
            url: "../member/loadCulturalOrderList.do",
            method: "post",
            dataType: "json",
            data: {id: '${member.id}', rows: 12,page:page,culturalOrderLargeType:culturalOrderLargeType},
            success: function (result) {
                var str = '';
                var rsObj = jQuery.parseJSON(result);
                var data = rsObj.list;
                if (data.length > 0) {
                    for (var k in data) {
                        var obj = data[k];
                        if(culturalOrderLargeType==1){
                            var date1 = new Date(obj.startDate);
                            var date2 = new Date(obj.endDate);
                        }else{
                            var date1 = new Date(obj.culturalOrderStartDate);
                            var date2 = new Date(obj.culturalOrderEndDate);
                        }
                        var startDate  =  date1.Format('yyyy-MM-dd');
                        var endDate = date2.Format('yyyy-MM-dd')
                        //culturalOrder/culturalOrderDetail.do?culturalOrderId=4685dac03e3945f2aa90e117f640457f&culturalOrderLargeType=1&userId=
                        str+='<li class="qyItem" style="height: 280px;" onclick="window.open(\'../culturalOrder/culturalOrderDetail.do?culturalOrderId='+obj.culturalOrderId+'&culturalOrderLargeType='+culturalOrderLargeType+'\')">\n' +
                            '            <div class="pic">\n' +
                            '                <img src="'+obj.culturalOrderImg+'">\n' +
                            '            </div>\n' +
                            '            <div class="char">\n' +
                            '                <p class="name">'+obj.culturalOrderName+'</p>\n' +
                            '                <p class="info">日期：'+startDate+'至'+endDate+'</p>\n' +
                            '            </div>\n' +
                            '        </li>';
                    }
                    $("#culturalList_ul").html(str);
                    var page = rsObj.page;
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
                            //$("#page").val(n);
                            loadCulturalOrderList(n,culturalOrderLargeType);
                            //$("#content_div").load("../member/venueList.do?id=${member.id}&rows=12&page="+n,function () {
                            //});
                            return false;
                        }
                    });
                }
            }
        });
    }

</script>