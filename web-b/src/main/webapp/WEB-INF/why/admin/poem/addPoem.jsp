<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>

    <script type="text/javascript">
    
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	
		var userId = '${sessionScope.user.userId}';
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
        
        	$(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'dateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    minDate: '2017-05-01',
                    doubleCalendar: true,
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedDateFunc
                })
            })
            
        });
        
        function pickedDateFunc() {
            $dp.$('poemDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
    	
    	function savePoem(){
    		if (userId == null || userId == '') {
    			dialogAlert('系统提示', '登录超时',function(){
    				location.href = '${path}/user/sysUserLoginOut.do'
    			});
                return;
            }
    		
    		$("#saveBut").attr("onclick","");
    		var poemDate=$('#poemDate').val();
    		var poemTitle=$('#poemTitle').val();
    		var poemAuthor=$('#poemAuthor').val();
    		var poemContent=$('#poemContent').val();
    		var poemTemplate=$('#poemTemplate').val();
    		var poemWord=$('#poemWord').val();
    		var poemLectorId=$('#poemLectorId').val();
    		var poemLectorExplain=$('#poemLectorExplain').val();
    		
    		if(!checkInfo(poemDate,"poemDate","日期为必选项！")) return;
    		if(!checkInfo(poemTitle,"poemTitle","标题为必填项！")) return;
    		if(!checkInfo(poemAuthor,"poemAuthor","作者为必填项！")) return;
    		if(!checkInfo(poemContent,"poemContent","内容为必填项！")) return;
    		if(!checkInfo(poemTemplate,"poemTemplate","答题模板为必填项！")) return;
    		if(!checkInfo(poemWord,"poemWord","题目选字为必填项！")) return;
    		if(!checkInfo(poemLectorId,"poemLectorId","请选择讲师！")) return;
    		if(!checkInfo(poemLectorExplain,"poemLectorExplain","讲师解析为必填项！")) return;
    		
    	  	//保存信息
    	    $.post("${path}/poem/saveOrUpdatePoem.do", $("#poemForm").serialize(),function(data) {
   	            if(data == "200") {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="${path}/poem/poemIndex.do";
   	                });
   	            }else if(data == "repeat"){
   	            	dialogAlert('系统提示', '该日期已被设置，请前往列表进行修改');
   	                $("#saveBut").attr("onclick","savePoem();");
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","savePoem();");
   	            }
   	     	},"json");
    	}

    	//信息必填验证
        function checkInfo(param,paramName,warn){
        	if(!param){
    	        removeMsg(paramName+"Label");
    	        $("#saveBut").attr("onclick","savePoem();");
    	        appendMsg(paramName+"Label",warn);
    	        $('#'+paramName).focus();
    	        return false;
    	    }else{
    	        removeMsg(paramName+"Label");
    	        return true;
    	    }
        }
    	
    	//讲师弹窗
    	function selectLector(){
            var winW = parseInt($(window).width() * 0.8);
            var winH = parseInt($(window).height() * 0.95);
            $.DialogBySHF.Dialog({
                Width: winW,
                Height: winH,
                URL: '${path}/poem/selectLectorIndex.do'
            });
    	}
    	
    </script>
    
    <style type="text/css">
		
	</style>
</head>

<body>
	<form id="poemForm" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 每日一诗管理  &gt;每日一诗新增
	    </div>
	    <div class="site-title">新增每日一诗</div>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	        	<tr>
	                <td width="100" class="td-title"><span class="red">*</span>日期：</td>
	                <td class="td-time" id="poemDateLabel">
	                    <div class="start" style="width: 140px;">
	                        <input type="hidden" id="dateHidden"/>
		                    <input type="text" id="poemDate" name="poemDate" readonly/>
		                    <i class="data-btn start-btn"></i>
	                    </div>
	            	</td>
	            </tr>
		        <tr>
	                <td width="100" class="td-title"><span class="red">*</span>标题：</td>
	                <td class="td-input" id="poemTitleLabel"><input type="text" id="poemTitle" name="poemTitle" class="input-text w510" maxlength="30"/></td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>作者：</td>
	                <td class="td-input" id="poemAuthorLabel">
	                	<input type="text" id="poemAuthor" name="poemAuthor" class="input-text w510" maxlength="20"/>
	                	<span style="margin-left:20px;background-color:#DCDADA;border-radius:10px;padding:16px;">例：唐·杜甫</span>
	                </td>
	            </tr>
	            <tr>
		        	<td width="100" class="td-title"><span class="red">*</span>内容：</td>
					<td class="td-input" id="poemContentLabel">
	                    <div class="editor-box" style="float:left;">
	                        <textarea id="poemContent" name="poemContent" rows="6" class="textareaBox"  maxlength="1000" style="width: 500px;resize: none"></textarea>
	                    </div>
	                    <div style="float:left;margin-left:20px;background-color:#DCDADA;border-radius:10px;padding:16px;">
	                   		 <div style="float:left;line-height:25px;">例:</div>
	                       	 <div style="float:left;margin-left:10px;line-height:25px;">床前明月光，疑是地上霜。<br />举头望明月，低头思故乡。</div>
	                       	 <div style="clear:both;"></div>
	                    </div>
	                    <div style="clear:both;"></div>
	                </td>
				</tr>
	            <tr>
		        	<td width="100" class="td-title"><span class="red">*</span>答题模板：</td>
					<td class="td-input" id="poemTemplateLabel">
	                    <div class="editor-box" style="float:left;">
	                        <textarea id="poemTemplate" name="poemTemplate" rows="6" class="textareaBox"  maxlength="1000" style="width: 500px;resize: none"></textarea>
	                    </div>
	                    <div style="float:left;margin-left:20px;background-color:#DCDADA;border-radius:10px;padding:16px;">
	                   		 <div style="float:left;line-height:25px;">例:</div>
	                       	 <div style="float:left;margin-left:10px;line-height:25px;">床前明#光，<br />疑是地上#。<br />举#望明月，<br />低头思故#。</div>
	                       	 <div style="clear:both;"></div>
	                    </div>
	                    <div style="clear:both;"></div>
	                </td>
				</tr>
				<tr>
	                <td width="100" class="td-title"><span class="red">*</span>题目选字：</td>
	                <td class="td-input" id="poemWordLabel">
	                	<input type="text" id="poemWord" name="poemWord" class="input-text w510" maxlength="20"/>
	                	<span style="margin-left:20px;background-color:#DCDADA;border-radius:10px;padding:16px;" id="poemTemplateLabel">前四对应正确答案，英文逗号分隔。例：月,霜,头,乡,想,日,家,脚</span>
	                </td>
	            </tr>
	            <tr>
		            <td width="100" class="td-title"><span class="red">*</span>鉴赏讲师：</td>
		            <td class="td-input ">
		                <input type="hidden" id="poemLectorId" name="poemLectorId" class="input-text w510" >
		                <input type="text" id="poemLectorName"class="input-text w510" readonly>
		                <input type="button" class="upload-btn" onclick="selectLector()" value="选择讲师" />
		            </td>
		        </tr>
	            <tr>
		        	<td width="100" class="td-title"><span class="red">*</span>讲师解析：</td>
					<td class="td-input">
	                    <div class="editor-box">
	                        <textarea id="poemLectorExplain" name="poemLectorExplain" rows="5" class="textareaBox"  maxlength="5000" style="width: 500px;resize: none"></textarea>
	                        <span style="color:#596988" id="poemLectorExplainLabel">（5000字以内）</span>
	                    </div>
	                </td>
				</tr>
			</table>	
			
		    <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="savePoem()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>