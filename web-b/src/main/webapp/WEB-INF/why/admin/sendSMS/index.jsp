<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>

    <script type="text/javascript">



        function edittemplateId() {
        	
        	var radio=$("input[name='templateId']:checked");
           
            var templateId=$("input[name='templateId']:checked").val();
            if(templateId==undefined){
                dialogAlert("提示", "请选择发送短信模板", function () {
                });
                return;
            }
            
           var templateName= radio.parent().parent().find(".templateName").html();
          
           $("#templateName").val(templateName);
           
           $("#form").submit();
        }
        $(function () {
            /*点击取消按钮，关闭登录框*/
            $(".btn-publish").on("click", function () {
                parent.location.href = '${path}/activity/activityIndex.do?activityState=6';


            });


        });

    </script>
</head>
<body class="rbody">
 <div class="site">
		    <em>您现在所在的位置：</em>运维管理 &gt;后台发送短信&gt;选择模板
		</div>
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="form" action="${path}/sendSMS/selectTemplate.do" method="post">
            	<input type="hidden" name="templateName" id="templateName" >
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table" style="padding: 10;">
                            <tbody>
                            <tr style="padding-left:130px;display:block; margin-top:20px;">

                                <td><input type="radio" value="1" name="templateId" checked="checked" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"</td>
								<td style="width:160px;text-align:center"><font size="6" class="templateName">短信模板1</font></td>
								<td style="font-size: 16px;">【文化云】根据<font style="color: red;">10</font>月份数据统计结果，您（<font style="color: red;">**社区文化活动中心</font>）在文化上海云平台上的活动发布数量为零，如有疑问或需要帮助请致电4000182346 。</td>
                            </tr>
                             <tr style="padding-left:130px;display:block; margin-top:20px;">

                                <td><input type="radio" value="2" name="templateId" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"</td>
								<td style="width:160px;text-align:center"><font size="6" class="templateName">短信模板2</font></td>
								<td style="font-size: 16px;">【文化云】根据<font style="color: red;">10</font>月份数据统计结果，您（<font style="color: red;">**社区文化活动中心</font>）在文化上海云平台上的活动发布数量为（<font style="color: red;">100</font>），在本区排名第（<font style="color: red;">1</font>），在全市排名第（<font style="color: red;">2</font>），您的努力将丰富更多市民的文化活动。文化云客服电话：4000182346</td>
                            </tr>
                             <tr style="padding-left:130px;display:block; margin-top:20px;">

                                <td><input type="radio" value="3" name="templateId" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"</td>
								<td style="width:160px;text-align:center"><font size="6" class="templateName">短信模板3</font></td>
								<td style="font-size: 16px;">【文化云】根据<font style="color: red;">10</font>月份数据统计结果，您（<font style="color: red;">**社区文化活动中心</font>）在文化上海云平台上发布的可预订活动数量为（<font style="color: red;">100</font>），在本区排名第（<font style="color: red;">1</font>），在全市排名第（<font style="color: red;">2</font>），您的努力将丰富更多市民的文化活动。文化云客服电话：4000182346</td>
                            </tr>
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2"><input type="button" value="下一步" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;" onclick="edittemplateId();"/>
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