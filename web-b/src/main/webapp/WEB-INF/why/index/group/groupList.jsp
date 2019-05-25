<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>团体--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

  <script type="text/javascript">
    $(function(){
      $('#groupListLabel').addClass('cur').siblings().removeClass('cur');
      getTags();
      // 初始化时查询
      var sort = $("#sort").val();
      var disableSort = $("#disableSort").val();
      var reqPage=$("#reqPage").val();
      var teamUserName = '${tuserName}';
      if(teamUserName != ""){
        $("#keyword").val(teamUserName);
      }
      var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
      getTeamUserList(tuserName,"","","","","",reqPage,sort, disableSort);
      // 默认展开更多选项
      $("#search .attr-extra").trigger("click");

      /*$("#keyword").blur(function(){
        $("#disableSort").val("N");
        if($("#searchType").val() == 2){
          $("#reqPage").val(1);
        }
        $("#searchType").val(1);

        var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
        var reqPage=$("#reqPage").val();
        getTeamUserList(tuserName,"","","","","",reqPage,1,$("#disableSort").val());
      });*/

      $('#keyword').keydown(function(event){
        if(event.keyCode == "13"){
          $("#disableSort").val("N");
          if($("#searchType").val() == 2){
            $("#reqPage").val(1);
          }
          $("#searchType").val(1);
          var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
          //var reqPage=$("#reqPage").val();
          $("#reqPage").val(1);
          getTeamUserList(tuserName,"","","","","",1,1,$("#disableSort").val());
          event.preventDefault();
        }
      });
    });

    function searchTeamUser(){
      $("#disableSort").val("N");
      if($("#searchType").val() == 1){
        $("#reqPage").val(1);
      }
      $("#searchType").val(2);

      var countyCode = $("#countyCode").val();
      var tuserLocationDict = $("#tuserLocationDict").val();
      var tuserCrowdTag = $("#tuserCrowdTag").val();
      var tuserPropertyTag = $("#tuserPropertyTag").val();
      var tuserSiteTag = $("#tuserSiteTag").val();
      var reqPage=$("#reqPage").val();
      getTeamUserList("",countyCode,tuserLocationDict,tuserCrowdTag,tuserPropertyTag,tuserSiteTag,reqPage,1,$("#disableSort").val());
    }

    function getTeamUserList(tuserName,countyCode,tuserLocationDict,tuserCrowdTag,tuserPropertyTag,tuserSiteTag,reqPage,sort,disableSort){
      /*var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
      var countyCode = $("#countyCode").val();
      var tuserLocationDict = $("#tuserLocationDict").val();
      var tuserCrowdTag = $("#tuserCrowdTag").val();
      var tuserPropertyTag = $("#tuserPropertyTag").val();
      var tuserSiteTag = $("#tuserSiteTag").val();
      var reqPage=$("#reqPage").val();*/

      var params = {tuserName:tuserName,tuserCounty:countyCode,tuserLocationDict:tuserLocationDict,tuserCrowdTag:tuserCrowdTag,
        tuserPropertyTag:tuserPropertyTag,tuserSiteTag:tuserSiteTag,sortType:sort,countPage:'${page.countPage}',page:reqPage}
      $("#groupListDiv").load("${path}/frontTeamUser/teamUserListLoadList.do", params ,function(){
        if(disableSort == "Y"){
          $("#sortDiv").hide();
        }else if(disableSort == "N"){
          $("#sortDiv").show();
        }

        if(tuserName != undefined && tuserName != ""){
          $("#noGroup").html(tuserName);
          $("#searchNoGroup").show();
          $("#searchGroup").hide();

          $("#nameSpan").html(tuserName);
          $("#pageSpan").show();
        }else{
          $("#searchNoGroup").hide();
          $("#searchGroup").show();

          $("#pageSpan").hide();
        }

        // 加载load文件时
        $("#sortDiv").find("a").each(function(index,item){
          if($(this).text() == "默认"){
            $(this).addClass("icon-asc").siblings("a").attr("class", "item");
          }else if($(this).text() == "热度"){
            if(sort == 2){
              $(this).addClass("icon-asc").siblings("a").attr("class", "item");
            }else if(sort == 3){
              $(this).addClass("icon-desc").siblings("a").attr("class", "item");
            }
          }else if($(this).text() == "发布时间"){
            if(sort == 4){
              $(this).addClass("icon-asc").siblings("a").attr("class", "item");
            }else if(sort == 5){
              $(this).addClass("icon-desc").siblings("a").attr("class", "item");
            }
          }
        });

        /*搜索排序 1-默认 2-热度升序 3-热度降序 4-激活时间升序 5-激活时间降序*/
        $("#sortDiv").on("click", ".item", function(){
          var that = $(this);
          if(that.attr("class") == "item") {
            that.addClass("icon-asc").siblings("a").attr("class", "item");
            getSort(that);
          }else if(that.hasClass("icon-asc")){
            that.removeClass("icon-asc").addClass("icon-desc").siblings("a").attr("class", "item");
            getSort(that);
          }else if(that.hasClass("icon-desc")){
            that.removeClass("icon-desc").addClass("icon-asc").siblings("a").attr("class", "item");
            getSort(that);
          }
        });

        getPicture();
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
            var sort = $("#sort").val();
            var disableSort = $("#disableSort").val();
            var searchType = $("#searchType").val();
            var reqPage = $("#reqPage").val();
            if(searchType == 1){ // 1表示按名称
              var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
              getTeamUserList(tuserName,"","","","","",reqPage,sort, disableSort);
            }else if(searchType == 2){ //2表示按标签
              var countyCode = $("#countyCode").val();
              var tuserLocationDict = $("#tuserLocationDict").val();
              var tuserCrowdTag = $("#tuserCrowdTag").val();
              var tuserPropertyTag = $("#tuserPropertyTag").val();
              var tuserSiteTag = $("#tuserSiteTag").val();
              getTeamUserList("",countyCode,tuserLocationDict,tuserCrowdTag,tuserPropertyTag,tuserSiteTag,reqPage,sort, disableSort);
            }
            return false;
          }
        });

      });
    }

    function getSort(that){
      if(that.text() == "默认"){
        $("#sort").val(1);
      }
      if(that.text() == "热度"){
        if(that.hasClass("icon-asc")){
          $("#sort").val(2);
        }else if(that.hasClass("icon-desc")){
          $("#sort").val(3);
        }
      }
      if(that.text() == "发布时间"){
        if(that.hasClass("icon-asc")){
          $("#sort").val(4);
        }else if(that.hasClass("icon-desc")){
          $("#sort").val(5);
        }
      }
      var searchType = $("#searchType").val();
      var reqPage = $("#reqPage").val();
      if(searchType == 1){ // 1表示按名称
        var tuserName = $("#keyword").val() == "请输入关键词" ? "" : $("#keyword").val();
        getTeamUserList(tuserName,"","","","","",reqPage,$("#sort").val(),$("#disableSort").val());
      }else if(searchType == 2){ //2表示按标签
        var countyCode = $("#countyCode").val();
        var tuserLocationDict = $("#tuserLocationDict").val();
        var tuserCrowdTag = $("#tuserCrowdTag").val();
        var tuserPropertyTag = $("#tuserPropertyTag").val();
        var tuserSiteTag = $("#tuserSiteTag").val();
        getTeamUserList("",countyCode,tuserLocationDict,tuserCrowdTag,tuserPropertyTag,tuserSiteTag,reqPage,$("#sort").val(),$("#disableSort").val());
      }
    }

    // 选择区域
    function clickArea(code){
      $("#countyCode").val(code);
      if(code == ""){
        $("#businessDiv").hide();
        $("#tuserLocationDict").val("");
      }else{
        getBusiness(code);
      }
    }

    // 得到商圈
    function getBusiness(code){
      $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{dictCode:code}, function(data) {
        var list = eval(data);
        var dictHtml = '';
        var other = '';
        if(data != null && data.length > 0){
          for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
            if(dictName == '其他'){
              other = '<li><a onclick="selectTagOrDict(\''+ dictId + '\',\'tuserLocationDict\')">'+dictName+'</a></li>';
            }else{
              dictHtml += '<li><a onclick="selectTagOrDict(\''+ dictId + '\',\'tuserLocationDict\')">'+dictName+'</a></li>';
            }
          }
          dictHtml += other;
          $("#businessUl").html(dictHtml);
          $("#businessDiv").show();
        }else{
          $("#businessDiv").hide();
        }
      });
    }

    // 初始化显示标签
    function getTags(){
      // 人群
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_CROWD", function(data) {
        var list = eval(data);
        var tagHtml = '<li class="cur"><a onclick="selectTagOrDict(\'\',\'tuserCrowdTag\')">全部</a></li>';
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          tagHtml += '<li><a onclick="selectTagOrDict(\''+ tagId + '\',\'tuserCrowdTag\')">'+tagName+'</a></li>';
        }
        $("#teamUserCrowdUl").html(tagHtml);
      });

      // 属性
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_PROPERTY", function(data) {
        var list = eval(data);
        var tagHtml = '<li class="cur"><a onclick="selectTagOrDict(\'\',\'tuserPropertyTag\')">全部</a></li>';
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          tagHtml += '<li><a onclick="selectTagOrDict(\''+ tagId + '\',\'tuserPropertyTag\')">'+tagName+'</a></li>';
        }
        $("#teamUserPropertyUl").html(tagHtml);
      });

      // 地点
      $.post("${path}/tag/getChildTagByType.do?code=TEAMUSER_SITE", function(data) {
        var list = eval(data);
        var tagHtml = '<li class="cur"><a onclick="selectTagOrDict(\'\',\'tuserSiteTag\')">全部</a></li>';
        for (var i = 0; i < list.length; i++) {
          var obj = list[i];
          var tagId = obj.tagId;
          var tagName = obj.tagName;
          tagHtml += '<li><a onclick="selectTagOrDict(\''+ tagId + '\',\'tuserSiteTag\')">'+tagName+'</a></li>';
        }
        $("#teamUserSiteUl").html(tagHtml);
      });
    }

    function selectTagOrDict(value,id){
      $("#"+id).val(value);
    }

    function getPicture(){
      $("#data-ul li").each(function(index,item){
        var imgUrl = $(this).attr("data-li-url");
        imgUrl= getImgUrl(imgUrl);
        imgUrl = getIndexImgUrl(imgUrl, "_300_300");
        $(item).find("img").attr("src", imgUrl);
      });
    }
  </script>
</head>
<body>
<!-- 导入头部文件 -->
<%@include file="../list_top.jsp"%>
<input type="hidden" id="searchType" value="1"/>
<input type="hidden" id="disableSort" value="Y"/>
<input type="hidden" id="sort" value="1"/>
<div class="crumbs"><i></i>您所在的位置： <a href="javascript:;">团体</a> &gt; 最新团体搜索结果</div>
<div id="search">
  <div class="search">
    <div class="prop-attrs">
      <div class="attr">
        <div class="attrKey">区域</div>
        <div class="attrValue">
          <ul class="av-collapse">
            <li class="cur"><a href="javascript:clickArea('');">上海市</a></li>
            <li><a onclick="clickArea('46');">黄浦区</a></li>
            <li><a onclick="clickArea('48');">徐汇区</a></li>
            <li><a onclick="clickArea('50');">静安区</a></li>
            <li><a onclick="clickArea('49');">长宁区</a></li>
            <li><a onclick="clickArea('51');">普陀区</a></li>
            <li><a onclick="clickArea('52');">闸北区</a></li>
            <li><a onclick="clickArea('53');">虹口区</a></li>
            <li><a onclick="clickArea('54');">杨浦区</a></li>
            <li><a onclick="clickArea('58');">浦东新区</a></li>
            <li><a onclick="clickArea('56');">宝山区</a></li>
            <li><a onclick="clickArea('57');">嘉定区</a></li>
            <li><a onclick="clickArea('60');">松江区</a></li>
            <li><a onclick="clickArea('61');">青浦区</a></li>
            <li><a onclick="clickArea('55');">闵行区</a></li>
            <li><a onclick="clickArea('59');">金山区</a></li>
            <li><a onclick="clickArea('63');">奉贤区</a></li>
            <li><a onclick="clickArea('64');">崇明县</a></li>
          </ul>
          <input type="hidden" id="countyCode"/>
          <a href="javascript:;" class="av-more"><b></b>展开</a>
        </div>
      </div>
    </div>
    <div class="prop-attrs hot-attrs" id="businessDiv" style="display: none">
      <div class="attr">
        <div class="attrKey" style="background:none;"></div>
        <div class="attrValue">
          <input type="hidden" id="tuserLocationDict"/>
          <ul class="av-expand" id="businessUl"></ul>
        </div>
      </div>
    </div>
    <div class="prop-attrs">
      <div class="attr">
        <div class="attrKey">人群</div>
        <div class="attrValue">
          <ul class="av-collapse" id="teamUserCrowdUl"></ul>
          <input type="hidden" id="tuserCrowdTag"/>
          <a href="javascript:;" class="av-more" style="display: none;"><b></b>展开</a>
        </div>
      </div>
    </div>
    <div class="prop-attrs">
      <div class="attr">
        <div class="attrKey">属性</div>
        <div class="attrValue">
          <input type="hidden" id="tuserPropertyTag"/>
          <ul class="av-collapse" id="teamUserPropertyUl"></ul>
          <a href="javascript:;" class="av-more fold" style="display: none;"><b></b>收起</a>
        </div>
      </div>
    </div>
    <div class="prop-attrs">
      <div class="attr">
        <div class="attrKey">地点</div>
        <div class="attrValue">
          <input type="hidden" id="tuserSiteTag"/>
          <ul class="av-collapse" id="teamUserSiteUl"></ul>
          <a href="javascript:;" class="av-more" style="display: none;"><b></b>展开</a>
        </div>
      </div>
    </div>
  </div>
  <div class="search-btn">
    <input type="button" value="搜索" onclick="searchTeamUser()"/>
  </div>
  <div class="advanced">
    <div class="attr-extra">
      <span>更多选项</span><b></b>
    </div>
  </div>
</div>
<div class="in-part1 activity-content clearfix" id="groupListDiv">

</div>
<input type="hidden" id="reqPage"  value="1">
<!-- 导入foot文件 start -->
<%@include file="../index_foot.jsp"%>
</body>
</html>