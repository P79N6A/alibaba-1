<%@ page language="java"  pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
  <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <!-- <title>实况直击</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
  <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
  <script src="${path}/STATIC/js/common.js"></script>
  
  <script type="text/javascript">
    $(function(){
        $("#like-list img").each(function(){
              $(this).attr("src",getImgUrl(getIndexImgUrl($(this).attr("data-src"),"_300_300")));
        });
    });

    $(function(){
          isScroll=true;
    });

    var myPage=1;
    function loadData(startI, p){
      if(isAjax) {
        return;
      }
      myPage+=1;
      var data={
        page:myPage,
        activityId:'${activityId}'
      };
      isAjax=1;
      $.ajax({
        url:'${path}/frontNews/listJson.do?'+new Date().getTime(),
        data: data,
        method: 'post',
        dataType:'json',
        success: function(datalist){
          isScroll=false;
          var _thisDataList = datalist.dataList;
          var _thisLength = datalist.dataList.length;
          var str = '';
          var imgUrl="";
          var timeStr ="";
          if(_thisLength>0){
            for(var k = 0; k < _thisLength; k++) {
              imgUrl = getImgUrl(getIndexImgUrl(_thisDataList[k].newsImgUrl,"_300_300"));
              timeStr = _thisDataList[k].newsReportTime.substr(0,10);
              str += '<li>' +
              '<a href="${path}/frontNews/detail.to?dataId='+_thisDataList[k].newsId+'" class="M-in-img"><img src="' +imgUrl+ '" /></a>' +
              '<div class="M-in-info"><h1><a href="${path}/frontNews/detail.to?dataId='+_thisDataList[k].newsId+'">'+_thisDataList[k].newsTitle+'</a></h1><span>'
              +_thisDataList[k].newsReportUser+'</span>' +
              '<i>'+ timeStr +'</i><a class="M-in-link" href="${path}/frontNews/detail.to?dataId='+_thisDataList[k].newsId+'">'+_thisDataList[k].dictName+'</a></div>' +
              '<div class="clearfix"></div><p>'+ _thisDataList[k].newsDesc +'</p></li>';
            }
          }
          setTimeout(function(){
                if(_thisLength>0){
                    isScroll=true;
                }else{
                    pullUpEl.className = 'none';
                    pullUpEl.querySelector('.pullUpLabel').innerHTML = '没有结果了';
                }
                $('.js-next').remove();
                $("#like-list").append(str);
                /*if(myPage>1){
                    $("#like-list").append(str);
                }else{
                    $("#like-list").html(str);
                }*/
                myScroll.refresh();
          }, 500);

        },
        error:function(){
          isAjax=0;
          setTimeout(function(){
            $(".js-next").remove();
          },500);
        },
        complete:function(){
          isAjax=0;
        }
      });
    }
    
  //初始化绑定iScroll控件
	document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
	document.addEventListener('DOMContentLoaded', function(){
	  loaded();
	}, false);
  </script>

  <script type="text/javascript" src="${path}/STATIC/wx/js/iscroll.js"></script>
 <script type="text/javascript" src="${path}/STATIC/wx/js/scrollLoadDataNews.js"></script>
</head>
<body style="height:100%;">
<div id="wrapper">
  <div id="scroller">
    <div id="pullDown">
      <span class="pullDownIcon"></span><span class="pullDownLabel">下拉加载更多...</span>
    </div>
<div class="M-watch-list">
  <ul class="M-in-like-list" id="like-list">
  <c:forEach items="${dataList}" var="t">
      <li>
        <a href="${path}/frontNews/detail.do?dataId=${t.newsId}" class="M-in-img">
          <img data-src="${t.newsImgUrl}" />
        </a>

        <div class="M-in-info">
          <h1><a href="${path}/frontNews/detail.do?dataId=${t.newsId}">${t.newsTitle}</a></h1>
          <span>${t.newsReportUser}</span>
          <i><fmt:formatDate value="${t.newsReportTime}" pattern="yyyy-MM-dd" /></i>
          <a href="${path}/frontNews/detail.do?dataId=${t.newsId}" class="M-in-link">${t.dictName}</a>
        </div>
        <div class="clearfix"></div>
        <p>${t.newsDesc}</p>
      </li>
  </c:forEach>
  </ul>
  </div>
    <div id="pullUp">
      <span class="pullUpIcon"></span><span class="pullUpLabel">上拉加载更多...</span>
    </div>

  </div>
</div>
</body>
</html>