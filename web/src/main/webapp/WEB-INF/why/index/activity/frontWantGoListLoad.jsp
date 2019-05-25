<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>

<%
  String path = request.getContextPath();
  request.setAttribute("path", path);
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<script type="text/javascript" >

  /**活动头像展开**/
  $(function(){ 
  	var $goHead = $("#go_head");
  	var $headList = $goHead.find(".head_list")					  
  	var $toggleBtn = $('#show_btn');
  	var flag = $("#wantGoFlag").val();
  	if(flag == 1){
  		$goHead.css({"height": "45px"});     	
  	}else{
  		$toggleBtn.hide();
  	}
	  if ('${page.total}' == '0') {
		  $toggleBtn.hide();
	  }
  	$toggleBtn.click(function(){  		
  		$("#wantGoFlag").val("2");
  		var $this = $(this);
  		$this.hide();	
  		$goHead.css({"height": "auto"});			 
  		/*if($this.hasClass("show")){
  			$this.removeClass("show");
  			$parent.css({"height": "40px"});							
  		}else{
  			$this.addClass("show");
  			$parent.css({"height": "auto"});		        
  		}*/
  		return false;					      
  	})
  });
</script>
<div class="gh_l fl">
	<c:choose>
        <c:when test="${isWantGo == 'Y'}" >
	 		<a id="wantGoA" href="javascript:wantgo2()">我想去</a>
	 		<!--<a id="wantGoA" href="javascript:wantGo('${activityId}','${userId}')">我想去</a>-->
		</c:when>
		<c:otherwise>
			<a id="wantGoA" href="javascript:void(0);" style="background: #808080;cursor:default;">我想去</a>
		</c:otherwise>
	</c:choose>
    <span>已有<font class="red">${count}</font>人想去</span>
</div>
<div class="gh_r fr">
    <div class="head_list fl">
       <ul>
	       <c:forEach items="${wantGoList}" var="wantGoList" >
	       		<li><img id="${wantGoList.userId}" width="40" height="40"/></li>
	       		<script>
	       			var userHeadImgUrl = '${wantGoList.userHeadImgUrl}';
	       			var userId = '${wantGoList.userId}';
	       			if(userHeadImgUrl!=""&&userHeadImgUrl.indexOf("http")==-1){
	       		        $("#"+userId).attr("src",getIndexImgUrl(getImgUrl(userHeadImgUrl),"_300_300"));
	       		    }else if(userHeadImgUrl.indexOf("http")!=-1){
	       		        $("#"+userId).attr("src",userHeadImgUrl);
	       		    }else{
	       		    	var userSex = '${wantGoList.userSex}';
	       		        if(userSex==1){
	       		            $("#"+userId).attr("src","../STATIC/image/face_boy.png");
	       		        }else if(userSex==2){
	       		            $("#"+userId).attr("src","../STATIC/image/face_girl.png");
	       		        }else{
	       		            $("#"+userId).attr("src","../STATIC/image/face_boy.png");
	       		        }
	       		    }
	       		</script>
	       </c:forEach>
       </ul>
       
       <!--page start-->
       <c:if test="${fn:length(wantGoList) gt 0}">
	        <div id="kkpager" class="small"></div>
	        <input type="hidden" id="pages" value="${page.page}">
	        <input type="hidden" id="countpage" value="${page.countPage}">
	        <input type="hidden" id="total" value="${page.total}">
      </c:if>
      <!--page end-->
   </div>
   <c:if test="${fn:length(wantGoList) gt 12}">
   	  <a href="#" class="fl" id="show_btn"><img src="../STATIC/image/zk_icon.png" width="8" height="8"/></a> 
   </c:if>
</div>
<script>
	function wantgo2(){
        // var activityId = $("#activityId").val();
        var userId = $("#userId").val();
        if( userId == null || userId == ""){
            dialogAlert("提示","登录之后才能预订");
            return;
        }else{
            wantGo('${activityId}','${userId}')
		}
	}
</script>
