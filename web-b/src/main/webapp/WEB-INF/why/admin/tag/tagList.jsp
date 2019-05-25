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
    <c:if test="${tagType==2}">&gt;活动标签</c:if>
    <c:if test="${tagType==3}">&gt;场馆标签</c:if>
    <c:if test="${tagType==4}">&gt;团体标签</c:if>
    <c:if test="${tagType==5}">&gt;新闻标签</c:if>
</div>
<div class="main-content">

  <table width="100%" class="tag-tab" id="tagTable">

    <thead>
      <tr>
        <th width="30">ID</th>
        <th width="80" class="title">标签类别</th>
        <th align="left">标签区</th>
      </tr>
    </thead>
    <tbody>

<c:if test="${tagType eq '2'}">
    <%--<tr>
      <td>1</td>
      <td class="title">活动人群</td>
      <td class="tag-list">
        <ul>
          <c:forEach items="${actCrowList}" var="c">
              <li>
                <div class="img">
                  <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                    <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                    <%
				        if(tagPreEditButton) {
				    %>
                    	<a id="${c.tagId}" class="tag-edit">编辑</a>
                    <%
                        }
                    %>
                </div>
                <span>${c.tagName}</span>
              </li>
          </c:forEach>
        </ul>
      </td>
    </tr>


    <tr>
      <td>2</td>
      <td class="title">活动心情</td>
      <td class="tag-list">
        <ul>
         <c:forEach items="${actMoodList}" var="c">
          <li>
            <div class="img">
                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                <%
			        if(tagPreEditButton) {
			    %>
                	<a id="${c.tagId}" class="tag-edit">编辑</a></div>
                <%
                    }
                %>
            <span>${c.tagName}</span>
          </li>
         </c:forEach>
        </ul>
      </td>
    </tr>--%>

    <%--<tr>--%>
      <%--<td>1</td>--%>
      <%--<td class="title">活动主题</td>--%>
      <%--<td class="tag-list">--%>
        <%--<ul>--%>
          <%--<c:forEach items="${themeList}" var="c">--%>
            <%--<li>--%>
            <%--<div class="img">--%>
              <%--<img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>--%>
              <%--<c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>--%>
              <%--<%--%>
			        <%--if(tagPreEditButton) {--%>
			  <%--%>--%>
              		<%--<a id="${c.tagId}" class="tag-edit">编辑</a>--%>
              <%--<%--%>
                  <%--}--%>
              <%--%>--%>
            <%--</div>--%>
               <%--<span>${c.tagName}</span>--%>
            <%--</li>--%>
          <%--</c:forEach>--%>
        <%--</ul>--%>
      <%--</td>--%>
    <%--</tr>--%>


    <tr>
        <td>1</td>
        <td class="title">活动类型</td>
        <td class="tag-list">
            <ul>
                <c:forEach items="${typeList}" var="c">
                    <li>
                        <div class="img">
                            <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                            <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                            <%
                                if(tagPreEditButton) {
                            %>
                            <a id="${c.tagId}" class="tag-edit">编辑</a>
                            <%
                                }
                            %>
                        </div>
                        <span>${c.tagName}</span>
                    </li>
                </c:forEach>
            </ul>
        </td>
    </tr>

<%--    <tr>
      <td>4</td>
      <td class="title">时间</td>
      <td class="tag-list">
        <ul>
          <c:forEach items="${timeList}" var="c">
              <li>
                <div class="img">
                  <img src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                  <a id="${c.tagId}" class="tag-edit">编辑</a>
                </div>
                <span>${c.tagName}</span>
              </li>
          </c:forEach>
        </ul>
      </td>
    </tr>
--%>

    </c:if>

    <c:if test="${tagType eq '3'}">
        <tr>
                <td>1</td>
                <td class="title">场馆类型</td>
                <td class="tag-list">
                    <ul>
                        <c:forEach items="${venueTypeList}" var="c">
                            <li>
                                <div class="img">
                                    <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                    <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                    <%
								        if(tagPreEditButton) {
								    %>
                                    	<a id="${c.tagId}" class="tag-edit">编辑</a>
                                    <%
						                }
						            %>
                                </div>
                                <span>${c.tagName}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </td>
        </tr>

        <tr>
            <td>2</td>
            <td class="title">场馆人群</td>
            <td class="tag-list">
                <ul>
                    <c:forEach items="${venueCrowdList}" var="c">
                        <li>
                            <div class="img">
                                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                <%
							        if(tagPreEditButton) {
							    %>
                                	<a id="${c.tagId}" class="tag-edit">编辑</a>
                                <%
				                    }
				                %>
                            </div>
                            <span>${c.tagName}</span>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
        
        <tr>
            <td>3</td>
            <td class="title">活动室标签</td>
            <td class="tag-list">
                <ul>
                    <c:forEach items="${venueRoomTagList}" var="c">
                        <li>
                            <div class="img">
                                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                <%
							        if(tagPreEditButton) {
							    %>
                                	<a id="${c.tagId}" class="tag-edit">编辑</a>
                                <%
				                    }
				                %>
                            </div>
                            <span>${c.tagName}</span>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
    </c:if>

    <c:if test="${tagType eq '4'}">
        <tr>
                <td>1</td>
                <td class="title">团体属性</td>
                <td class="tag-list">
                    <ul>
                        <c:forEach items="${teamTypeList}" var="c">
                            <li>
                                <div class="img">
                                    <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                    <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                    <%
								        if(tagPreEditButton) {
								    %>
                                    	<a  id="${c.tagId}" class="tag-edit">编辑</a>
                                    <%
					                    }
					                %>
                                </div>
                                <span>${c.tagName}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </td>
        </tr>
        <%--<tr>
            <td>2</td>
            <td class="title">团体地点</td>
            <td class="tag-list">
                <ul>
                    <c:forEach items="${teamSiteList}" var="c">
                        <li>
                            <div class="img">
                                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                <%
							        if(tagPreEditButton) {
							    %>
                                	<a  id="${c.tagId}" class="tag-edit">编辑</a>
                                <%
				                    }
				                %>
                            </div>
                            <span>${c.tagName}</span>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td class="title">团体人群</td>
            <td class="tag-list">
                <ul>
                    <c:forEach items="${teamCrowdList}" var="c">
                        <li>
                            <div class="img">
                                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                <%
							        if(tagPreEditButton) {
							    %>
                                	<a id="${c.tagId}" class="tag-edit">编辑</a>
                                <%
				                    }
				                %>
                            </div>
                            <span>${c.tagName}</span>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>--%>
    </c:if>


    <c:if test="${tagType eq '5'}">
        <tr>
            <td>1</td>
            <td class="title">新闻类型</td>
            <td class="tag-list">
                <ul>
                    <c:forEach items="${newsTypeList}" var="c">
                        <li>
                            <div class="img">
                                <img src="" data-src="${c.tagImageUrl}" alt="" width="60" height="60"/>
                                <c:if test="${c.tagRecommend==1}"><i class="recommend-icon"></i></c:if>
                                <%
                                    if(tagPreEditButton) {
                                %>
                                <a  id="${c.tagId}" class="tag-edit">编辑</a>
                                <%
                                    }
                                %>
                            </div>
                            <span>${c.tagName}</span>
                        </li>
                    </c:forEach>
                </ul>
            </td>
        </tr>
    </c:if>

    </tbody>
  </table>

	<%
        if(tagPreAddButton) {
    %>
		  <div class="btn-box">
		    <a class="btn-add-tag">添加标签</a>
		  </div> 
	<%
        }
    %>
</div>


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
            winName ="团体";
        }else if(type==5){
            winName="新闻";
        }
        return winName;
    }
    window.console = window.console || {log:function () {}}
    //添加标签
    seajs.use(['jquery'], function ($) {
        var tagType = '${tagType}';
        /*$('.btn-add-tag').click(function(){
         console.log(111);
         });*/
        $('.btn-add-tag').on('click', function () {
            dialog({
                url: '${path}/tag/preTagAdd.do?tagType='+tagType,
                title: '添加'+getWinName(tagType)+'标签',
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
                title: '编辑'+getWinName(tagType)+'标签',
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
    });
</script>


</body>
</html>
