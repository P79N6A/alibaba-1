<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>编辑互动问答--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/admin/anwser/UploadQuestionAnwserImg.js"></script>

<script type="text/javascript" >

      $(function() {
    	  //选项后台赋值
    	  var anwserAllCode = $("#anwserAllCode").val();
    	  anwserAllCode = anwserAllCode.split('*/*');
    	  $("#anwserA").val(anwserAllCode[0].substring(2));
    	  $("#anwserB").val(anwserAllCode[1].substring(2));
    	  $("#anwserC").val(anwserAllCode[2].substring(2));
    	  $("#anwserD").val(anwserAllCode[3].substring(2));
      });
      
      function doSubmit(){

		  var isCutImg =$("#isCutImg").val();
		  if("N"==isCutImg) {
			  dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
			  });
			  return;
		  }


		  var anwserQuestion = $("#anwserQuestion").val();
    	  var anwserImgUrl = $("#anwserImgUrl").val();
    	  var anwserA = $("#anwserA").val();
    	  var anwserB = $("#anwserB").val();
    	  var anwserC = $("#anwserC").val();
    	  var anwserD = $("#anwserD").val();
    	  var anwserCode = $("#anwserCode").val();
    	  
		  if(anwserQuestion==undefined||anwserQuestion.trim()==""){
			    removeMsg("anwserQuestionLabel");
			    appendMsg("anwserQuestionLabel","题目为必填项!");
			    $('#anwserQuestion').focus();
			    return;
		  }else{
			    removeMsg("anwserQuestionLabel");
			    if(anwserQuestion.length>20){
			        appendMsg("anwserQuestionLabel","题目只能输入20字以内!");
			        $('#anwserQuestion').focus();
			        return;
			    }
		  }
		  
		  if(anwserImgUrl==undefined||anwserImgUrl==""){
		        removeMsg("anwserImgUrlLabel");
		        appendMsg("anwserImgUrlLabel","上传封面为必填项!");
		        $('#anwserImgUrl').focus();
		        return;
	      }else{
	        	removeMsg("anwserImgUrlLabel");
	      }
		  
		  if(anwserA==undefined||anwserA.trim()==""){
			    removeMsg("anwserALabel");
			    appendMsg("anwserALabel","选项A为必填项!");
			    $('#anwserA').focus();
			    return;
		  }else{
			    removeMsg("anwserALabel");
			    if(anwserA.length>20){
			        appendMsg("anwserALabel","选项A只能输入20字以内!");
			        $('#anwserA').focus();
			        return;
			    }
		  }
		  
		  if(anwserB==undefined||anwserB.trim()==""){
			    removeMsg("anwserBLabel");
			    appendMsg("anwserBLabel","选项B为必填项!");
			    $('#anwserB').focus();
			    return;
		  }else{
			    removeMsg("anwserBLabel");
			    if(anwserB.length>20){
			        appendMsg("anwserBLabel","选项B只能输入20字以内!");
			        $('#anwserB').focus();
			        return;
			    }
		  }
		  
		  if(anwserC==undefined||anwserC.trim()==""){
			    removeMsg("anwserCLabel");
			    appendMsg("anwserCLabel","选项C为必填项!");
			    $('#anwserC').focus();
			    return;
		  }else{
			    removeMsg("anwserCLabel");
			    if(anwserC.length>20){
			        appendMsg("anwserCLabel","选项C只能输入20字以内!");
			        $('#anwserC').focus();
			        return;
			    }
		  }
		  
		  if(anwserD==undefined||anwserD.trim()==""){
			    removeMsg("anwserDLabel");
			    appendMsg("anwserDLabel","选项D为必填项!");
			    $('#anwserD').focus();
			    return;
		  }else{
			    removeMsg("anwserDLabel");
			    if(anwserD.length>20){
			        appendMsg("anwserDLabel","选项D只能输入20字以内!");
			        $('#anwserD').focus();
			        return;
			    }
		  }
		  
		  if(anwserCode==undefined||anwserCode.trim()==""){
			    removeMsg("anwserCodeLabel");
			    appendMsg("anwserCodeLabel","答案为必填项!");
			    $('#anwserCode').focus();
			    return;
		  }else{
			    removeMsg("anwserCodeLabel");
			    if(anwserCode!="A"&&anwserCode!="B"&&anwserCode!="C"&&anwserCode!="D"){
			        appendMsg("anwserCodeLabel","答案只能输入A/B/C/D!");
			        $('#anwserCode').focus();
			        return;
			    }
		  }
		  
		  //选项后台传值赋值
		  $("#anwserAllCode").val("A "+anwserA+"*/*"+"B "+anwserB+"*/*"+"C "+anwserC+"*/*"+"D "+anwserD);
		  
		  $.post("${path}/questionAnwser/editQuestionAnwser.do", $("#anwserQuestionForm").serialize(),
		        function(data) {
		            $(this).attr("disabled", false);
		            if (data!=null&&data=='success') {
		            	dialogAlert('系统提示', '保存修改成功！',function (r){
		            		window.location.href="${path}/questionAnwser/questionAnwserIndex.do";
		            	});
		            }else{
		                dialogAlert('系统提示', '保存修改失败！');
		            }
		   });
      }
</script>
</head>
<body>
  <input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
  <input type="hidden" id="isCutImg" value="Y"/>
  <form action="" id="anwserQuestionForm" method="post">
  	  <input type="hidden" name="anwserId" value="${cmsQuestionAnwser.anwserId}" />
      <div class="site">
          <em>您现在所在的位置：</em>运维管理 &gt; 编辑互动问答
      </div>
      <div class="site-title">编辑问题</div>
      <div class="main-publish">
          <table width="100%" class="form-table">
              <tr>
                  <td width="100" class="td-title"><span class="red">*</span>题目：</td>
                  <td class="td-input" id="anwserQuestionLabel">
                      <input type="text" id="anwserQuestion" name="anwserQuestion" class="input-text w510"  maxlength="20" value="<c:out escapeXml='true' value='${cmsQuestionAnwser.anwserQuestion}'/>"/>
                  </td>
                  
              </tr>
              <tr>
	               <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
	               <td class="td-upload" id="anwserImgUrlLabel">
	                   <table>
	                       <tr>
	                           <td>
	                                <input type="hidden"  name="anwserImgUrl" id="anwserImgUrl" value="${cmsQuestionAnwser.anwserImgUrl}">
	                                <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
	
	                                <div class="img-box">
	                                    <div  id="imgHeadPrev" class="img"> </div>
	                                </div>
	                                <div class="controls-box">
	                                    <div style="height: 46px;">
	                                        <div class="controls" style="float:left;">
	                                            <input type="file" name="file" id="file">
	                                        </div>
	                                        <span class="upload-tip">可上传1张图片，建议尺寸750*500像素，格式为jpg,jpeg,png,gif，大小不超过2M</span>
	                                    </div>
	                                    <div id="fileContainer"></div>
	                                    <div id="btnContainer" style="display: none;">
	                                        <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
	                                    </div>
	                                </div>
	                            </td>
	                       </tr>
	                   </table>
	               </td>
	          </tr>
              <tr>
                  <td width="100" class="td-title"><span class="red">*</span>选项：</td>
                  <input type="hidden" id="anwserAllCode" name="anwserAllCode" value="${cmsQuestionAnwser.anwserAllCode}"/>
                  <td class="td-input" id="anwserALabel">
                      <span>A</span>&nbsp;&nbsp;&nbsp;<input type="text" id="anwserA" class="input-text w410"  maxlength="20" />
                  </td>
              </tr>
              <tr>
              	  <td width="100" class="td-title"></td>
              	  <td class="td-input" id="anwserBLabel">
                      <span>B</span>&nbsp;&nbsp;&nbsp;<input type="text" id="anwserB" class="input-text w410"  maxlength="20" />
                  </td>
              </tr>
              <tr>
              	  <td width="100" class="td-title"></td>
              	  <td class="td-input" id="anwserCLabel">
                      <span>C</span>&nbsp;&nbsp;&nbsp;<input type="text" id="anwserC" class="input-text w410"  maxlength="20" />
                  </td>
              </tr>
              <tr>
              	  <td width="100" class="td-title"></td>
              	  <td class="td-input" id="anwserDLabel">
                      <span>D</span>&nbsp;&nbsp;&nbsp;<input type="text" id="anwserD" class="input-text w410"  maxlength="20" />
                  </td>
              </tr>
              <tr>
                  <td width="100" class="td-title"><span class="red">*</span>答案：</td>
                  <td class="td-input" id="anwserCodeLabel">
                      <input type="text" id="anwserCode" name="anwserCode" class="input-text w410"  maxlength="1" value="${cmsQuestionAnwser.anwserCode}"/>
                  </td>
              </tr>
              <tr class="td-btn">
                  <td></td>
                  <td>
                      <input type="button" value="保存修改" class="btn-save" onclick="javascript:return doSubmit();"/>
                      <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1)"/>
                  </td>
              </tr>
          </table>
      </div>
  </form>
</body>
</html>
