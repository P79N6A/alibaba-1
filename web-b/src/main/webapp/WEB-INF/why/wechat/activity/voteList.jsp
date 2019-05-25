<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
  <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <!-- <title>我要投票</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
  <script src="${path}/STATIC/js/common.js"></script>
  
  <script type="text/javascript">
    $(function(){
        $("#dataList img").each(function(){
            $(this).attr("src",getImgUrl(getIndexImgUrl($(this).attr("data-src"),"_300_300")));
        });
    });
    $(function(){
        var userId = '${userId}';
        if(userId){
            window.localStorage.setItem("userId",userId);
        }
    });
  </script>
</head>

<body>
	<div class="M_me_vote" id="dataList">
	  <c:forEach items="${dataList}" var="t">
	      <dl class="clearfix">
	        <dt><a href="${path}/frontVote/detail.do?dataId=${t.voteId}">
	            <img data-src="${t.voteCoverImgUrl}" width="200" height="130" />
	            </a>
	        </dt>
	        <dd>
	          <p>${t.voteTitel}</p>
	          <a href="${path}/frontVote/detail.do?dataId=${t.voteId}">参与投票</a>
	        </dd>
	      </dl>
	  </c:forEach>
	</div>
</body>
</html>