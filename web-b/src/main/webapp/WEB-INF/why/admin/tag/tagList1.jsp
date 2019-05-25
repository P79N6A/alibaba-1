<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>活动列表--文化云</title>
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>

<div class="site">
  <em>您现在所在的位置：</em>运维管理 &gt;标签管理
    <c:if test="${tagType==2}">&gt;活动类型</c:if>
    <c:if test="${tagType==3}">&gt;场馆类型</c:if>
    <c:if test="${tagType==4}">&gt;活动室类型</c:if>
    
</div>
<form id="tagForm" >
<input id="tagType" name="tagType" type="hidden" value="${tagType }"/>
<div class="main-content">
<div class="search">
	<%
        if(tagPreAddButton) {
    %>
     <div class="menage-box">
		  
		  <div class="menage-box">
		    <a class="btn-add btn-common-tag">通用标签</a>
		    <a class="btn-add btn-add-tag">添加类型</a>
		  </div> 
	</div>
	<%
        }
    %>
</div>
  <table width="100%" class="tag-tab" id="tagTable">

    <thead>
      <tr>
     
        <th width="80" >类型名称</th>
        <th width="" class="">标签</th>
        <th width="200">最新操作人</th>
        <th width="240">最新操作时间</th>
         <%
             if(tagPreEditButton) {
           %>
        <th width="120">管理</th>
          <%
              }
          %>
      </tr>
    </thead>
    <tbody>

 <c:forEach items="${tagList}" var="c" varStatus="varSta">
    <tr>
       
        <td >${c.tagName}</td>
        <td class="tag-list">
           <!--  <ul>
                    <li>
                        <div class="img">
                            <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                            <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                          
                         
                          
                        </div>
                        <span>${c.tagNames }</span>
                    </li>
             
            </ul> -->
             ${c.tagNames }
        </td>
        <td>${c.updateUserName}</td>
          <td>  <fmt:formatDate value="${c.tagUpdateTime}"  pattern="yyyy-MM-dd HH:mm" /></td>
          <%
             if(tagPreEditButton) {
           %>
        <td>   <a id="${c.tagId}" class="tag-edit">编辑</a></td>
          <%
              }
          %>
    </tr>
   </c:forEach>

    </tbody>
  </table>
  
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>

</div>

</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script>
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
</script>

<script type="text/javascript" >
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });
    function getWinName(type){
        var winName ="";
        if(type==2){
            winName ="活动";
        }else if(type==3){
            winName ="场馆";
        }else if(type==4){
            winName ="活动室";
        }
        //}else if(type==5){
        //    winName="新闻";
        //}
        return winName;
    }
    window.console = window.console || {log:function () {}}
    //添加标签
    seajs.use(['jquery'], function ($) {
        var tagType = '${tagType}';
        var dictId='${dictId}';
        /*$('.btn-add-tag').click(function(){
         console.log(111);
         });*/
         
         $('.btn-common-tag').on('click', function () { 
        	 
        	  dialog({
                  url: '${path}/tag/commonTag.do?tagType='+tagType+"&dictId="+dictId,
                  title: '通用标签',
                  width: 460,
                  fixed: true
              }).showModal();
              return false;
         
         });
         
        $('.btn-add-tag').on('click', function () {
            dialog({
                url: '${path}/tag/preTagAdd.do?tagType='+tagType+"&dictId="+dictId,
                title: '添加'+getWinName(tagType)+'类型',
                width: 460,
                fixed: true
            }).showModal();
            return false;
        });
        //编辑标签
        $('.tag-edit').on('click', function () {
            var tagId = $(this).attr("id");
            dialog({
                url: '${path}/tag/preEditTags.do?tagId='+tagId+"&tagType="+tagType,
                title: '编辑'+getWinName(tagType)+'类型',
                width: 460,
                fixed: true,
                data: {
                    title: $(this).parent().siblings().text(),
                    type: $(this).parents("tr").find(".title").text(),
                    imgUrl: $(this).siblings().attr("src")
                } // 给 iframe 的数据
            }).showModal();
            return false;
        });
    });
    //遍历图片
    $(function(){
        $("#tagTable img").each(
                function(){
                    var imgUrl =$(this).attr("data-src");
                    if(""!=imgUrl){
                        $(this).attr("src",getImgUrl(imgUrl));
                    }else{
                        $(this).attr("src","../STATIC/image/tag-img1.jpg");
                    }
                });
        
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    $('#tagForm').submit();
                    return false;
                }
            });
    });
</script>


</body>
</html>
