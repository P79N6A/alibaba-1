<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>标签管理</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
      <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
      });

    seajs.config({
        alias: {
          "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
        }
      });
     
       /*  $(function () {
        	
      
        	$(".btn-publish").click(function(){
        		
        		 var value=$("#pageType")[0].value;
        		
            	$.post("${path}/InsidePages/InsidePagesSkip.do",{"pageType":value},function(result) {
     			   
        				alert("跳转成功！"); 
        			
            });


        }); */
 
    $(function(){
    	$(".btn-publish").click(function(){
    		var val=$('input:radio[name="pageType"]:checked').val();
    		window.location.href = "${path}/InsidePages/InsidePagesSkip.do?pageType="+val+"&exhibitionId=${exhibitionId}";
    	});
    });
    

    </script>
</head>
<body class="rbody">
<div class="site">
    <em>您现在所在的位置：</em>运维管理  &gt; 线上展览&gt;管理内页&gt;添加内页
</div>
<div class="search">
</div>
<div class="site-title">选择模板</div>
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            
                            <tr style="padding-left:80px;display:block; margin-top:20px;">
                                    <td class="td-input" style="display:inline-block;font-size: 13px;margin-right:20px">
                                        <input type="radio" id="pageType" name="pageType" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"
                                             checked="checked"
                                               value="1" ><span id="templateName">板式一</span> </br>
                                      <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161110163915eGsXmSolX15JuqCTJUm6Tak7wSP8s5.png@300w" alt="" height="300" width="200" style="max-height: 50;max-width: 100">      
                                               
                                               
                                               </td>
                                               
                                                 <td class="td-input" style="display:inline-block;font-size: 13px;margin-right:20px">
                                        <input type="radio" id="pageType" name="pageType" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"

                                             
                                               value="2" ><span id="templateName">板式二</span> </br>
                                      <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201611101640498iZMFhKDlL7w6vrvNiMnZuDy392ln4.png@300w" alt="" height="300" width="200" style="max-height: 50;max-width: 100">      
                                               
                                               
                                               </td>
                                               
                                               <td class="td-input" style="display:inline-block;font-size: 13px;margin-right:20px">
                                        <input type="radio" id="pageType" name="pageType" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"

                                             
                                               value="4" ><span id="templateName">板式三</span> </br>
                                      <img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161110164122cCIzA2cXbrsAWyZa8nLKEqY8mXmr06.png" alt="" height="300" width="200" style="max-height: 50;max-width: 100">      
                                               
                                               
                                               </td>
                            </tr>
                            
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2">
                                
                                 <input type="button" value="返回" class="btn-save btn-cancel"  onclick="javascript:history.go(-1);" style="margin-left: 155px;margin-top: 20px;"/>
                                <input type="button" value="下一步" class="btn-publish" />
                                   </td>
                            </tr> 
                            </tbody>
                        </table>
                    </div>
                </div>
            </form> 
        </div>
    </div>
</div>

</body>
</html>