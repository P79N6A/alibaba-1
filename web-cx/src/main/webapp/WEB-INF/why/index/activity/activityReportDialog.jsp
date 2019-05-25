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
<script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/culture.js"></script>
 <script type="text/javascript">
   $(function() {
    // 举报选项
       $.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=REPORTTYPE", function(data) {
           var list = eval(data);
           for (var i = 0; i < list.length; i++) {
               var obj = list[i];
               var dictId = obj.dictId;
               var dictName = obj.dictName;
               if(dictName=="其他"){
            	   $("#report_type").append('<div class="reportDiv"><input onclick="setReportType()" name="reportType" id="qt" type="checkbox" value="'+dictId+'"/><span>'+dictName+'</span><input type="type" id="reportContent" maxlength="500"/></div>');
               }else{
            	   $("#report_type").append('<div class="reportDiv"><input onclick="setReportType()" name="reportType" type="checkbox" value="'+dictId+'"/><span>'+dictName+'</span></div>');
               }
           }
           
       });
   });
   
 	//举报选项赋值
   function setReportType(){
	   	var dictIds =$("input[name='reportType']");
	   	var dictIdsStr = '';
	   	for(var i=0;i<dictIds.length;i++){
	       	if(dictIds[i].checked){
	       		dictIdsStr += dictIds[i].value + ",";
	   		}
	   	}
   		$("#reportTypeDict").val(dictIdsStr);
   }
   
   //提交
   function reportActivity(activityId){
	   var reportTypeDict = $("#reportTypeDict").val();
	   if(reportTypeDict == null || reportTypeDict == ""){
	        dialogAlert("提示","请至少选择一个选项！");
	        return;
	   }
	   var reportContent = "";
	   if($("#qt").attr("checked")){
		   reportContent = $("#reportContent").val();
		   if(reportContent>500){
			   dialogAlert("提示","举报内容只能输入500字以内！");
			   return;
		   }
	   }
	   $.post("${path}/reportInformation/addReport.do?activityId="+activityId+
			   	"&reportType="+reportTypeDict+"&reportContent="+reportContent, function(data) {
		   if(data=="success"){
			   dialogAlert("提示","举报成功！",function(){
					parent.window.location.reload();
			   });
		   }else if(data=="timeOut"){
			   dialogAlert("提示","登录超时！");
		   }else{
			   dialogAlert("提示","举报失败！");
		   }
	   });
   }
</script>

<style>
	body{font-family: 'Microsoft YaHei', PingFangSC-Regular, SimHei;}
	span{font-size: 14px;margin: 8px;color: #4a4a4a;}
	.reportDiv{margin: 14px 4px;}
	.report_btn{background:#f58636;border-radius:5px;width:280px;height:44px; line-height:44px; display:inline-block; text-align:center; letter-spacing:1px;border:none; outline:none; cursor:pointer; color:#ffffff; font-size:16px;text-decoration:none;}
	#reportContent{width: 150px;border: none;border-bottom: 1px solid #c8c8c8;margin-left: 10px;outline: none;color: #4a4a4a;}
</style>

<body>
	<div id="report_type">
		<input id="reportTypeDict" name="reportTypeDict" type="hidden" value=""/>
	</div>
	<div style="margin:50px 64px;">
		<a class="report_btn" href="javascript:reportActivity('${activityId}')">提交</a>
	</div>
</body>

