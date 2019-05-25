<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
	<script type="text/javascript">
		$.ajaxSettings.async = false; 	//同步执行ajax
	    var userId = '${sessionScope.user.userId}';
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
	
		$(function(){
			aliUploadImg("aliImg",uploadCallBack,1,true, 'H5');	

		});
		
	    window.console = window.console || {log:function () {}}
	   
    	function saveBrandAct(){
    		 if (userId == null || userId == '') {
     			dialogAlert('系统提示', '登录超时',function(){
     				location.href = '${path}/user/sysUserLoginOut.do'
     			});
                 return;
             }
    		 
   		    $('#saveBut').attr('onclick','');
          
            var actUrl = $("#actUrl").val();
            if(actUrl==undefined||$.trim(actUrl)==""){
                $("#actUrlSpan").html("活动链接为空");
                $('#actUrl').focus();
                return;
            }else{
                $("#actUrlSpan").html("");
            } 
      
            $.post("${path}/activityBrand/cmsActivityBrandAdd.do", $("#form").serializeArray(), function(result) {      	
            	if(result.msg == "success") {
   	                dialogAlert('系统提示', "保存成功!",function (){
   	                	window.location.href="${path}/activityBrand/cmsActivityBrandIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","saveBrandAct();");
   	            }
            });
        }
	    function uploadCallBack(up, file, info){
	    	var aliImgUrl = "${aliImgUrl}" + info 
	    	$("#imgSrc").val(aliImgUrl)
	    	$("#"+file.id).append('<input type="hidden" name="imgSrc" id="imgSrc" value="'+aliImgUrl+'"/>') 	
			$("#" + file.id).find("img.aliRemoveBtn").css("top","20px")
		}
	</script>
</head>
<style type="text/css">

	.aliRemoveBtn{
		position:absolute;
		right:0;
		top:30px;
		width:20px
	}
	.actUrls{
		margin-left:-65px;
	}
	
	div[name = aliFile]{width:540px!important;}
	div[name = aliFile] img:nth-child(1){position:relative!important;}
	/* div[name = aliFile] .aliRemoveBtn{top:10px!important;} */

	#inf{
		color:red;
	}
</style>

<body style="background: none;">
	<form id="form">
		<div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 大活动管理 
	    </div>
	    <div class="site-title">新增大活动</div>
   		<input type="hidden" name="id" id="id" value="${entity.id }"/>
   		<input type="hidden" name="actType" id="actType" value="1"/>
           <div class="main-publish">
       	<table width="100%" class="form-table">
				
			  <tr>
					<td class="td-title" width="20%"><span class="red">*</span>活动链接：</td>
					<td class="td-input"><input type="text" class="input-text w510" id="actUrl" name="actUrl" value="${entity.actUrl }"/>
						<span class="error-msg" id="actUrlSpan"></span>
					</td>
			  </tr> 
				
              <tr id="aliImg" style="height:210px;">
                   <td class="td-title" width="20%">上传图片：</td>
                   <td class="td-input" style="padding:0;height:210px;vertical-align:top;">
                    <div class="aliImg img-box">
	                    <c:choose>
	                 		<c:when test="${empty  entity.imgSrc}">
	                 		</c:when>
	                 		<c:otherwise>
	                 			<div name="aliFile" style="position:relative" ><span></span><b></b>
		                 			<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
		                 			<img src="${entity.imgSrc}@300w"  style="max-height: 100px;max-width: 100px;"  />
		                 			 <input type="hidden" value="${entity.imgSrc}" name="imgSrc"/>
	                 			</div>
	                 		</c:otherwise>
	                 	</c:choose> 
                      </div>
                      <div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
                      <div id="container2">
                  		<a id="selectfiles2" href="javascript:void(0);" class='btn' style="overflow: hidden;margin: 10px 10px 10px 0;">选择文件</a>
                  		<p id="inf">提示：板式一：一张图 750*250(图片高度不限);</p>
                      </div>
                    </td>
               </tr>
           </table>
           <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="saveBrandAct()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>

</html>