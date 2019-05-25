<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
		var userId = '${sessionScope.user.userId}';
		var flag = '${flag}';
		
		
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
		
		
		
		
        $(function () {
        	
        	if(flag=='1'){
    			$('#selThemeType').hide();
    		}
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#lawnMusicForm');
                    return false;
                }
            });
            
            $('.shapiaoDiv').bind('click',function (evt) {
    	        setStopPropagation(evt);
    	    });
            
            selectModel();
        });
		
		
		seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        // 课程内容查看
        function look(ID){
             dialog({
                 url: '${path}/musicessayArticle/lookTitle.do?articleId='+ID+'&flag='+flag,
                 title: '文章内容',
                 width: 500,
                 fixed: true
             }).showModal();
             return false;
         }
		
        //提交表单
        function formSub(formName) {
            $(formName).submit();
        }
        
        //删除
        function shanchuOpen(ID){
        	dialogConfirm("提示", "确定要操作该文章吗？",function(){
        		$.post("${path}/musicessayArticle/del.do",{articleId:ID,flag:flag},function(data){
        			if(data.status=="ok"){
        				dialogConfirm("提示", data.msg,function(){
        					location.reload();
        				});
        			}else{
        				dialogConfirm("提示", data.msg);
        			}
        		})
        	})
        }
        
        //刷票弹窗
    	function shuapiaoOpen(id,name,piao) {
    		$("#shuapiaoName").html(name);
    		$("#piaoshu").html(piao);
    		$("#voteCount").val("");
    	    $('.shapiaoBack').show();
    	    
    	    $(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWalkVote('"+id+"','"+name+"');");
    	}
        
        
        
        //刷票
        function brushWalkVote(articleId,articleTitle){
      		var voteCount = $("#voteCount").val();
      		if(!isNaN(voteCount)){
      			if(voteCount>0){
      				dialogConfirm("提示", "确定为"+articleTitle+"刷票"+voteCount+"张？",function(r){
      					$(".shapiaoDiv .shuapiaoBtn").attr("onclick","");
      	            	$.post("${path}/musicessayArticle/brushWalkVote.do", {articleId: articleId,articleLike:voteCount,flag:flag}, function (data) {
      	                    if (data.status == "ok") {
      	                    	$('.shapiaoBack').hide();
      	                    	dialogAlert('提示', data.msg,function(){
      	                    		location.reload();
      	                    	});
      	                    } else {
      	                    	$(".shapiaoDiv .shuapiaoBtn").attr("onclick","brushWalkVote('"+articleId+"','"+articleTitle+"');");
      	                        dialogAlert('提示', data.msg);
      	                    }
      	                });
      	        	});
      			}
      		}
        }
        
        // 阻止事件冒泡
    	function setStopPropagation(evt) {
    	    var e = evt || window.event;
    	    if(typeof e.stopPropagation == 'function') {
    	        e.stopPropagation();
    	    } else {
    	        e.cancelBubble = true;
    	    }   
    	}
        
        
    </script>
    <style type="">
    	.entryButton{
    	color: #fff;background-color:rgba(125, 164, 203, 1);border:1px solid rgba(56, 78, 101, 1);font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.entryReButton{
    	color: #596988;border:1px solid #596988;font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.housel {width: 98%;height: 40px;border: none;color: #142340;font-family: \5FAE\8F6F\96C5\9ED1;margin-left: 1%;margin-top: 1px;}
    	/*刷票*/
	    .shapiaoBack {width: 100%;height: 100%;position: fixed;left: 0;top: 0;background-color: rgba(0,0,0,0.9);overflow: hidden;z-index: 99;}
	    .shapiaoDiv {width: 340px;  margin: auto;background-color: #fff;padding: 34px;height: 200px;position: absolute;top: 0;bottom: 0;left: 0;right: 0;line-height: 54px;font-size: 16px;}
	    .shapiaoDiv .shuapiaoBtn {display: block; width: 200px;height: 50px;line-height: 50px;overflow: hidden;background-color: #374E65;font-size: 20px;color: #fff;text-align: center;border: none;margin: 0 auto;margin-top: 20px;
	        -webkit-border-radius: 5px;-moz-border-radius: 5px;-o-border-radius: 5px;border-radius: 5px;
    </style>
</head>
<body>
<form id="lawnMusicForm" action="" method="post">
    <div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt; 
		<c:choose>
            <c:when test="${flag==1}">
        		音乐征文管理 
            </c:when>
            <c:otherwise>
                                      电影征文管理
           </c:otherwise>
       </c:choose>     
	</div>
	<div class="site-title">
	</div>
    <div class="search"> 	
        <div class="search-box">
	        <i></i><input type="text" id="userRealName" name="userRealName" value="${EntityArticle.userRealName}" placeholder="输入用户名" class="input-text"/>
	    </div>
	    <div class="search-box">
	        <i></i><input type="text" id="userMoblieNo" name="userMoblieNo" value="${EntityArticle.userMoblieNo}" placeholder="输入手机号" class="input-text"/>
	    </div>
        <div class="select-box w135">
            <input type="hidden" value="${EntityArticle.articleType}" name="articleType"
                   id="articleType"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${EntityArticle.articleType==1}">
                      微评 
                    </c:when>
                    <c:when test="${EntityArticle.articleType==2}">
                      征文
                    </c:when>
                    <c:otherwise>
                      征文类型
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="" >征文类型</li>
                <li data-option="1">微评</li>
                <li data-option="2">征文</li>
            </ul>
        </div>
        
        <div class="select-box w135" id="selThemeType">
        	 <input type="hidden" value="${EntityArticle.themeType}" name="themeType" id="themeType"/>
        	<div class="select-text" data-value="">
        			 <c:choose>
                    <c:when test="${EntityArticle.themeType==1}">
                    
                      电影中的真善美
                    </c:when>
                    <c:when test="${EntityArticle.themeType==2}">
                      我与我的电影节
                    </c:when>
                    <c:otherwise>
                      主题类型
                    </c:otherwise>
                    </c:choose>
        	</div>
        	<ul class="select-option">
                <li data-option="" >主题类型</li>
                <li data-option="1">电影中的真善美</li>
                <li data-option="2">我与我的电影节</li>
            </ul>
        </div>
        
        
        <div class="select-box w135">
            <input type="hidden" value="${EntityArticle.articleIsDel}" name="articleIsDel"
                   id="articleIsDel"/>
            <div class="select-text" data-value="">
                <c:choose>
                    <c:when test="${EntityArticle.articleIsDel==0}">
                      审核通过 
                    </c:when>
                    <c:when test="${EntityArticle.articleIsDel==1}">
                      审核不通过
                    </c:when>
                    <c:otherwise>
                      审核状态
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="select-option">
                <li data-option="" >审核状态</li>
                <li data-option="0">审核通过</li>
                <li data-option="1">审核不通过</li>
            </ul>
        </div>
       
        <input type="hidden" name="flag" value="${flag}" id="flag"/>
        
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#lawnMusicForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>编号</th>
                <th>姓名</th>
                <th>手机号</th>
                <th>文章标题</th>
                <th>文章内容</th>
                <th>文章创建时间</th>
                <th>票数</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${list}" var="lawnMusic">
            <%i++ ;%>
                <tr>
                    <td><%=i%></td>
                    <td>${lawnMusic.userRealName }</td>
                    <td>${lawnMusic.userMoblieNo }</td>
                    <td>${lawnMusic.articleTitle }</td>
                    <td>
                       <a href="#" onclick="look('${lawnMusic.articleId }')" >查看</a>
                    </td>
                    <td><fmt:formatDate value="${lawnMusic.articleCreateTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${lawnMusic.articleLike }</td>
                    <td>
                      <a target="main" href="${path }/musicessayArticle/checkMessage.do?articleId=${lawnMusic.articleId}&flag=${flag}" >详情</a> |
                      <c:if test="${lawnMusic.articleIsDel==0 }">
                        <a target="main" href="javascript:shanchuOpen('${lawnMusic.articleId}');" style="color: red;font-weight: bold;">审核不通过</a> |
                      </c:if>
                      <c:if test="${lawnMusic.articleIsDel==1 }">
                        <a target="main" href="javascript:shanchuOpen('${lawnMusic.articleId}');" style="color: red;font-weight: bold;">审核通过</a> |
                      </c:if>
                      <a target="main" href="javascript:shuapiaoOpen('${lawnMusic.articleId}','${lawnMusic.articleTitle}','${lawnMusic.articleLike }');">刷票</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="14"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <!-- 刷票界面 -->	
				<div class="shapiaoBack" style="display:none;" onclick="$(this).hide();">
	       			 <div class="shapiaoDiv">
			        	<strong>作品：</strong><span id="shuapiaoName"></span><br/>
			        	<strong>原有票数：</strong><span id="piaoshu"></span><br/>
			        	<strong>刷票数：</strong><input id="voteCount" type="number" min="0"/>
			            <input class="shuapiaoBtn" type="button" value="开始刷票">
	       			 </div>
	    		</div>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>
