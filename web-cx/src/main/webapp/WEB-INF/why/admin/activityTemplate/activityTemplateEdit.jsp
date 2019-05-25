<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>编辑活动模板--文化云</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<script type="text/javascript" >
	function submitData(){
		$(".btn-save").attr("onclick", "");
		$.post("${path}/activityTemplate/activityTemplateEdit.do", $("#activityTemplateForm").serialize(),
			function(data) {
				if (data!=null&&data=='success') {
					dialogAlert('系统提示', '编辑成功！',function (r){
						window.location.href="${path}/activityTemplate/activityTemplateIndex.do";
					});
				}else{
					dialogAlert('系统提示', '编辑失败！');
					$(".btn-save").attr("onclick", "doSubmit();");
				}
			});
	}

	  $(function(){
		  $.post("${path}/activityTemplate/hasActivity.do",{"templId":'${cmsActivityTemplate.templId}'}, function(data) {
              if (data!=null && data==0) {
            	  $("#selectTemplTd").show();
              }
		  });
	        
	  });

      function doSubmit(){
			var templName = $("#templName").val();
			var selected_mode = $("#selected_mode").val();
    	  
    	    if(templName==undefined||templName.trim()==""){
			    removeMsg("templNameLabel");
			    appendMsg("templNameLabel","模板名称为必填项!");
			    $('#templName').focus();
			    return;
			}else{
			   removeMsg("templNameLabel");
			   if(templName.length>20){
			      appendMsg("templNameLabel","模板名称只能输入20字以内!");
			      $('#templName').focus();
			      return;
			   }
			}
    	    
    	    if(selected_mode==undefined||selected_mode==""){
		        removeMsg("template_list");
		        appendMsg("template_list","请至少选择一个模板功能!");
		        return;
			}else{
			  	removeMsg("template_list");
			}

		  var hideTemplName = $("#hideTemplName").val();
		  if(templName != hideTemplName){
			  $.post("${path}/activityTemplate/checkRepeat.do",{templateName:templName},function(data){
				  if(data=="success"){
					  submitData();
				  }else if(data=="false"){
					  removeMsg("templNameLabel");
					  appendMsg("templNameLabel","模板名称不能重名!");
					  $('#templName').focus();
				  }
			  });
		  }else{
			  submitData();
		  }
      }
</script>
</head>

<body>
  <form action="" id="activityTemplateForm" method="post">
  	  <input type="hidden" name="templId" value="${cmsActivityTemplate.templId}"/>
      <div class="site">
          <em>您现在所在的位置：</em>活动管理 &gt; 活动模板管理
      </div>
      <div class="site-title">添加活动模板</div>
      <div style="border-bottom: 1px dashed #d9d9d9;padding:30px 0px;">
      	<table width="100%" class="form-table">
          <tr>
          	<td width="100"	class="td-title">
          		<span class="red">*</span>模板名称：
          	</td>
          	<td class="td-input" id="templNameLabel">
          		<input type="text" id="templName" name="templName" class="input-text w510"  maxlength="20" value="${cmsActivityTemplate.templName}"/>
				<input type="hidden" id="hideTemplName" value="${cmsActivityTemplate.templName}"/>
          	</td>
          </tr>
        </table>
      </div>
      <div class="main-publish" style="padding-top: 0px;">
          <table width="100%" class="form-table">
              <tr id="selectTemplTd" style="display: none;">
              	<td style="line-height: 30px;">
	              	<div class="main-publish tag-add clearfix">
					   <div id="template_list">
					      <div class="template_l fl">
					        <h5><span class="red">*</span>已有模版功能</h5>
					        <div class="tl_l">
					        </div>
					     </div>
					     <input type="hidden" id="selected_mode" name="functions" value="${cmsActivityTemplate.functions}"/>
					      <div class="do_arrow fl">
					       <a id="l_arrow"><img src="${path}/STATIC/image/l_arrow.png" width="16" height="29" /></a> 
					       <a id="r_arrow"><img src="${path}/STATIC/image/r_arrow.png" width="16" height="29" /></a> 
					      </div>
					      <div class="template_r fl">
					         <h5>待添加模版功能</h5>
					         <div class="tl_r">
					         	<c:if test="${not empty functionList}">
				        			<c:forEach items="${functionList}" var="dataList">
				        				<span data-id="${dataList.funId}" data-descr="${dataList.funDescr}" data-url="${dataList.funIconUrl}">${dataList.funName}</span>
				        			</c:forEach>
				        		</c:if>
					         </div>
					      </div>
					      <div class="template_con fl">
					         <h5>功能介绍</h5>
					         <div class="template_container" id="template_container">
					             <%--<p id="funDescr"></p>--%>
					             <%--<img id="funIconUrl" src=""/>--%>
					         </div>
					      </div>
					   </div>
					</div>
					<script>
					
					   //初始化已有模板功能
					   var initVal=$("#selected_mode").val();
					   var arrVal=initVal.split(",")
					   var len=arrVal.length;
					   for(var i=0;i<len;i++){
						  var Id=arrVal[i];
						  $(".tl_r span[data-id='"+Id+"']").appendTo($(".tl_l"));
					   }
					   
					   //点击左键
					   $("#l_arrow").click(function(){
						    if($(".tl_r .blue_selected").length==0){
							   dialogAlert('系统提示', '请先选择需要移动的项！');
							}else{
							    $(".tl_r .blue_selected").appendTo($(".tl_l")); 
								$(".tl_l span").removeClass("blue_selected");
								getId();
							}
						})
							
					    //点击右键
						$("#r_arrow").click(function(){
						   if($(".tl_l .blue_selected").length==0){
							   dialogAlert('系统提示', '请先选择需要移动的项！');
						   }else{
							    $(".tl_l .blue_selected").appendTo($(".tl_r")); 
								$(".tl_r span").removeClass("blue_selected");
								getId();
						   }
						})
							
					    //移动列表
						$("body").on("click",".tl_r span,.tl_l span",function(){
						    $(this).toggleClass("blue_selected");
							var funDescr = $(this).attr("data-descr");
							var funIconUrl = $(this).attr("data-url");
							funIconUrl = getImgUrl(funIconUrl);

							$("#template_container").html("<p>"+funDescr+"</p><img src=" +funIconUrl + ">");
							/*$("#funDescr").html(funDescr);
							$("#funIconUrl").attr("src",getImgUrl(funIconUrl));*/
						})
						  
						function getId(){//获取列表id
							  var input_recive=$("#selected_mode");
							  var str=[];
							  $(".tl_l span").each(function(index, element) {
						          var dataId=$(this).attr("data-id");
								  str[index]=dataId;
						      }); 
							  var strings=str.join(",");
							  input_recive.val(strings);
						 }
					</script>
				  </td>
              </tr>
              
              <tr class="td-btn">
                  <td style="padding:50px 0 0 350px;">
                      <input type="button" value="保存" class="btn-save" onclick="doSubmit();"/>
                      <input type="button" value="返回" class="btn-publish" onclick="javascript:history.back(-1)"/>
                  </td>
              </tr>
          </table>
      </div>
  </form>
</body>
</html>
