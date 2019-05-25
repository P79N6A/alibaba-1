<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>团体首页--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>

  <script type="text/javascript">
    // code:区域 tuserName:名称 tagId:标签
    function doQuery(code,tuserName,tagId){
      var reqPage=$("#reqPage").val();
      $("#groupListDiv").load("${path}/frontTeamUser/teamUserLoadList.do",{tuserName:tuserName,tuserCounty:code,tagId:tagId,countPage:'${page.countPage}',page:reqPage},function(){
        getListPics();
        //分页
        kkpager.generPageHtml({
          pno :$("#pages").val() ,
          //总页码
          total :$("#countpage").val(),
          //总数据条数
          totalRecords :$("#total").val(),
          mode : 'click',
          click : function(n){
            this.selectPage(n);
            $("#reqPage").val(n);
            var tuserName = $("#tuserName").val() == "请输入关键词" ? "" : $("#tuserName").val();
            doQuery($("#countyCode").val(),tuserName,$("#tagCode").val());
            return false;
          }
        });

      });
    }

    $(function(){
      // 推荐标签
      getRecommendTag();
     // doQuery($("#countyCode").val(),$("#tuserName").val() == "请输入关键词" ? "" : $("#tuserName").val(),$("#tagCode").val());

      $("#area_div a").click(function(){
        var code = $(this).attr("data-option") == "45" ? "" : $(this).attr("data-option");
        $("#countyCode").val(code);
        var tuserName = $("#tuserName").val() == "请输入关键词" ? "" : $("#tuserName").val();
        doQuery($("#countyCode").val(),tuserName,$("#tagCode").val());
      });
      // 得到图片
      getListPics();

      $("#tuserName").blur(function(){
        var tuserName = $(this).val() == "请输入关键词" ? "" : $(this).val();
        doQuery($("#countyCode").val(),tuserName,$("#tagCode").val());
      });

      $('#tuserName').keydown(function(event){
        if(event.keyCode == "13"){
          var tuserName = $(this).val() == "请输入关键词" ? "" : $(this).val();
          doQuery($("#countyCode").val(),tuserName,$("#tagCode").val());
          event.preventDefault();
        }
      });
    });

    function getRecommendTag(){
      $.post("${path}/tag/getTagsByDictTagType.do?code=team", function(data) {
        var list = eval(data);
        var tagHtml='<a class="cur" onclick="tagSelect(\'\')">全部</a>';
        for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            tagHtml += '<a onclick="tagSelect(\'' + obj.tagId + '\')" >' + obj.tagName
            + '</a>';
        }
        tagHtml += '<a href="${path}/frontTeamUser/teamUserList.do" class="more">更多</a>';
        $("#tagDiv").html(tagHtml);
      });
    }

    // 标签选择
    function tagSelect(tagId){
      $("#tagCode").val(tagId);
      var tuserName = $("#tuserName").val() == "请输入关键词" ? "" : $("#tuserName").val();
      doQuery($("#countyCode").val(),tuserName,$("#tagCode").val());
    }

    function getListPics(){
      $("#data-ul li").each(function(index,item){
        var imgUrl = $(this).attr("data-li-url");
        imgUrl = getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl,'_300_300');
        $(item).find("img").attr("src", imgUrl);
      });
    }
  </script>
</head>
<body>
<%@include file="../index_top.jsp"%>

<div class="in-content in-part1 clearfix">
  <div class="in-tit">
    <div class="in-cate1 cateList fl" id="tagDiv">
      <%--<a onclick="tagSelect('')">全部</a>
      <c:forEach items="${crowdTagList}" var="crowdTag">
        <a onclick="tagSelect('${crowdTag.tagId}')">${crowdTag.tagName}</a>
      </c:forEach>
      <c:forEach items="${propertyTagList}" var="propertyTag">
        <a onclick="tagSelect('${propertyTag.tagId}')">${propertyTag.tagName}</a>
      </c:forEach>
      <c:forEach items="${siteTagList}" var="siteTag">
        <a onclick="tagSelect('${siteTag.tagId}')">${siteTag.tagName}</a>
      </c:forEach>
      <a href='${path}/frontTeamUser/teamUserList.do' class='more'>更多</a>--%>
    </div>
    <form class="in-hot-search fr">
      <input type="text" value="请输入关键词" data-val="请输入关键词" class="input-text" id="tuserName"/>
      <input type="hidden" id="countyCode"/>
      <input type="hidden" id="tagCode"/>
    </form>
  </div>
  <div id="groupListDiv">

  </div>

</div>
<input type="hidden" id="reqPage"  value="1">
<!-- 导入foot文件 start -->
<%@include file="../index_below.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/index/advert/advert.js"></script>
</body>
</html>