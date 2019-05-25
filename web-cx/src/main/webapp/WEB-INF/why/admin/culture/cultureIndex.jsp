<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>非遗列表--文化云</title>
  <%@include file="../../common/pageFrame.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <script type="text/javascript">
    $(function() {
          var defaultAreaId = $("#areaData").val();
          $.post("${path}/culture/getArea.do",function(areaData) {
            var ulHtml = "<li data-option=''>全部区县</li>";
            var divText = "全部区县";
            if (areaData != '' && areaData != null) {
              for(var i=0; i<areaData.length; i++){
                var area = areaData[i];
                var areaId = area.id;
                var areaText = area.text;
                ulHtml += '<li data-option="'+areaId+'">'
                + areaText
                + '</li>';
                if(defaultAreaId == areaId){
                  divText = areaText;
                }
              }
              $("#areaDiv").html(divText);
              $("#areaUl").html(ulHtml);
            }
          }).success(function() {
            //selectModel();
          });
    });




    function updateState(id,state){

            dialogConfirm("提示","确定要删除吗？",function(){

                  $.ajax({
                    type: "POST",
                    url: "${path}/culture/updateState.do",
                    data: {
                      id: id,
                      state:state
                    },
                    dataType: "json",
                    success: function (data) {
                      if (data=="success") {
                        dialogSaveDraft("提示","删除成功!",function(){
                          window.location.href="${path}/culture/getList.do?cultureState=1";
                        });
                      }else{
                        dialogSaveDraft("提示","删除失败!",function(){
                          window.location.href="${path}/culture/getList.do?cultureState=1";
                        });
                      }
                    }
                  });
            });

    }


   $(function(){
     $.post(
             "${path}/sysdict/queryChildSysDictByDictCode.do",
             {
               'dictCode' : 'CULTURETYPE'
             },
             function(data) {
               if (data != '' && data != null) {
                 var sty ='${c.cultureType}';
                 //alert(sty);
                 var list = eval(data);
                 var ulHtml = '<li data-option="">所有类别</li>';
                 for (var i in data) {
                   var dict = list[i];
                   ulHtml += '<li data-option="'+dict.dictId+'">'
                   + dict.dictName + '</li>';
                   if(sty!=""&&sty==dict.dictId){
                     $('#tagTypeDiv').html(dict.dictName);
                   }
                 }
                 $('#tagType').html(ulHtml);
               }
             }).success(function() {
                 $.post(
                         "${path}/sysdict/queryChildSysDictByDictCode.do",
                         {
                           'dictCode' : 'CULTURESYSTEM'
                         },
                         function(data) {
                           if (data != '' && data != null) {
                             var sty ='${c.cultureSystem}';
                             //alert(sty);
                             var list = eval(data);
                             var ulHtml = '<li data-option="">所有体系</li>';
                             for (var i in data) {
                               var dict = list[i];
                               ulHtml += '<li data-option="'+dict.dictId+'">'
                               + dict.dictName + '</li>';
                               if(sty!=""&&sty==dict.dictId){
                                 $('#tagDynastyDiv').html(dict.dictName);
                               }
                             }
                             $('#tagDynasty').html(ulHtml);
                           }
                         }).success(function() {
                            selectModel();
                         });
             });

        });

  </script>
</head>
<body>
<%--<%
  boolean inheritorIndexButton=false;
%>--%>

<%
  boolean inheritorIndexButton=true;
%>

<%--<%if(session.getAttribute("user") != null)
{
%>
<c:forEach items="${sessionScope.user.sysModuleList}" var="module">
  <c:if test="${module.moduleUrl == '${path}/inheritor/inheritorIndex.do'}">
    <% inheritorIndexButton=true;%>
  </c:if>
</c:forEach>
<%
  }
%>--%>

<div class="site">
  <em>您现在所在的位置：</em>非遗管理 &gt; 非遗列表
</div>
<form id="venueIndexForm" method="post" action="${path}/culture/getList.do">
  <%--当前状态--%>
  <input type="hidden"  name="cultureState" value="${c.cultureState}" />

  <div class="search">
    <div class="search-box">
      <i></i><input id="venueName" name="cultureName" class="input-text" data-val="输入关键词" type="text" value="${c.cultureName}" />
    </div>


    <div class="select-box w135">
      <input type="hidden" name="areaData" id="areaData" value="${areaData}"/>
      <div id="areaDiv" class="select-text" data-value="">全部区县</div>
      <ul id="areaUl" class="select-option">
      </ul>
    </div>

    <div class="select-box w135">
      <input type="hidden"/>
      <div class="select-text" data-value="" id="tagTypeDiv" >全部类型</div>
      <input type="hidden" name="cultureType" value="${c.cultureType}" />
      <ul class="select-option" id="tagType">

      </ul>
    </div>

    <div class="select-box w135">
      <input type="hidden" name="cultureSystem" value="${c.cultureSystem}" />
      <div class="select-text" data-value=""  id="tagDynastyDiv" >全部体系</div>
      <ul class="select-option" id="tagDynasty"  id="antiqueYears" >

      </ul>
    </div>




    <div class="select-btn">
      <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#venueIndexForm')"/>
    </div>
  </div>
  <div class="main-content">
    <table width="100%">
      <thead>
      <tr>
        <th>ID</th>
        <th class="title">非遗名称</th>
        <th>所属区县</th>
        <th>类别</th>
        <th>体系</th>
        <th>操作人</th>
        <th>操作时间</th>
        <th width="160">管理</th>
      </tr>
      </thead>
      <c:if test="${empty dataList}">
        <tr>
          <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
        </tr>
      </c:if>
      <tbody>

      <c:forEach items="${dataList}" var="c" varStatus="s">
        <tr>
          <td>${s.index+1}</td>
          <td class="title"><a href="#">${c.cultureName }</a></td>
          <td>${fn:substringAfter(c.cultureArea, ',')}</td>
          <td>${c.cultureTypeName}</td>
          <td>${c.cultureSystemName}</td>
          <td>${c.sysUserName }</td>
          <td><fmt:formatDate value="${c.updateTime}" pattern="yyyy-MM-dd HH:mm"/></td>

          <td>
            <a href="${path}/culture/toEdit.do?id=${c.cultureId}">编辑</a>|
            <a href="${path}/frontCulture/cultureDetail.do?cultureId=${c.cultureId}" target="_blank">查看</a>|
            <a href="javascript:;" onclick="updateState('${c.cultureId}','3')">删除</a>|
            <%
              if(inheritorIndexButton){
            %>
              <a href="${path}/inheritor/inheritorIndex.do?cultureId=${c.cultureId}&cultureName=${c.cultureName}">传承人</a>
            <%
              }
            %>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
    <c:if test="${not empty dataList}">
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager"></div>
    </c:if>
    <script type="text/javascript">
      $(function(){
        kkpager.generPageHtml({
          pno : '${page.page}',
          total : '${page.countPage}',
          totalRecords :  '${page.total}',
          mode : 'click',//默认值是link，可选link或者click
          click : function(n){
            this.selectPage(n);
            $("#page").val(n);
            formSub('#venueIndexForm');
            return false;
          }
        });
      });

      //提交表单
      function formSub(formName){
        var venueName = $("#venueName").val();
        if(venueName == "输入关键词"){
          $("#venueName").val("");
        }
        $(formName).submit();
      }
    </script>
  </div>
</form>

</body>
</html>