<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <title>非遗列表--文化云</title>
  <%@include file="../../common/frontPageFrame.jsp"%>

  <script type="text/javascript">

    $(function(){
        $("#search .attr-extra").trigger("click");
        doQuery();
    });

    $(function(){

        $('#keyword').keydown(function(event){
            if(event.keyCode == "13") {
                searchVenueList(1);
                event.preventDefault();
            }
        });

    });

    function searchVenueList(page){
      var systemData = '';
      $("#system-div li").each(function(){
          if($(this).attr("class") == 'cur'){
            systemData = $(this).children().attr("data-option");
          }
      });
      var typeData = '';
      $("#type-div li").each(function(){
        if($(this).attr("class") == 'cur'){
          typeData = $(this).children().attr("data-option");
        }
      });

      var yearData = '';
      $("#year-div li").each(function(){
        if($(this).attr("class") == 'cur'){
          yearData= $(this).children().attr("data-option");
        }
      });
      doQuery(systemData,typeData,yearData,page);
    }

    function getListPics(){
      $("#venue-list-ul li").each(function (index, item) {
        var imgUrl = $(this).attr("data-id");
        if(imgUrl) {
          imgUrl = getImgUrl(imgUrl);
          imgUrl = getIndexImgUrl(imgUrl,"_300_300");
          $(item).find("img").attr("src", imgUrl);
        }
      });
    }


    function doQuery(systemData,typeData,yearData,page){

      var cultureName =  $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();

      if(page){
      }else{
        page=1;
      }

      $("#venueListDiv").load("${path}/frontCulture/indexLoad.do #indexLoad",
              {
                cultureName:cultureName,
                cultureType:typeData,
                cultureSystem:systemData,
                cultureYears:yearData,
                page:page
              },function(){
                getListPics();

              kkpager.generPageHtml({
                  pno :$("#pages").val() ,
                  total :$("#countpage").val(),
                  totalRecords :$("#total").val(),
                  mode : 'click',
                  click : function(n){
                    this.selectPage(n);
                    $("#reqPage").val(n);
                    searchVenueList(n);
                    return false;
                  }
              });
      });
    }
</script>

</head>
<body>
<!-- 导入头部文件 -->
<%@include file="../list_top.jsp"%>


<div class="crumbs"><i></i>您所在的位置： <a href="${path}/frontVenue/venueList.do">非遗</a> &gt; 非遗列表</div>
<form action="${path}/frontVenue/venueDetail.do"  id="venueDetailForm" method="post">
  <input type="hidden" id="venueId" name="venueId"/>
  <input type="hidden" id="keywordVal" value="${keyword}"/>
</form>
<div id="search">

  <div class="search">

    <div class="prop-attrs">
      <div class="attr">
        <div class="attrKey">体系</div>
        <div class="attrValue"  id="system-div">
          <ul class="av-collapse">
            <li class="cur"><a href="javascript:;" data-option="">全部</a></li>
            <c:forEach items="${systemList}"  var="c">
              <li><a href="javascript:;" data-option="${c.dictId}">${c.dictName}</a></li>
            </c:forEach>
          </ul>
          <c:if test="${fn:length(systemList) gt 8}">
            <a href="javascript:;" class="av-more"><b></b>展开</a>
          </c:if>
        </div>
      </div>
    </div>


    <div class="prop-attrs" style="display: block;">
      <div class="attr">
        <div class="attrKey">类型</div>
        <div class="attrValue"  id="type-div">
          <ul class="av-collapse">
            <li class="cur"><a href="javascript:;" data-option="">全部</a></li>
            <c:forEach items="${typeList}"  var="c">
              <li><a href="javascript:;" data-option="${c.dictId}">${c.dictName}</a></li>
            </c:forEach>
          </ul>
          <c:if test="${fn:length(typeList) gt 8}">
            <a href="javascript:;" class="av-more"><b></b>展开</a>
          </c:if>
        </div>
      </div>
    </div>

    <div class="prop-attrs" style="display: block;">
      <div class="attr">
        <div class="attrKey">年代</div>
        <div class="attrValue"  id="year-div">
          <ul class="av-collapse">
            <li class="cur"><a href="javascript:;" data-option="">全部</a></li>
            <c:forEach items="${yearList}" var="c">
              <li><a href="javascript:;" data-option="${c.dictId}">${c.dictName}</a></li>
            </c:forEach>
          </ul>
          <c:if test="${fn:length(yearList) gt 8}">
            <a href="javascript:;" class="av-more"><b></b>展开</a>
          </c:if>
        </div>
      </div>
    </div>

  </div>


  <div class="search-btn">
    <input type="button" value="搜索" onclick="searchVenueList(1)"/>
  </div>

 <div class="advanced">
    <div class="attr-extra">
      <span>更多选项</span><b></b>
    </div>
  </div>


</div>


<div class="in-part1 activity-content clearfix" id="venueListDiv">

</div>

<input type="hidden" id="reqPage"  value="1">

<%@include file="../index_foot.jsp"%>

</body>
</html>