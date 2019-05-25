<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>发布文化文物--文化云</title>

    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@ include file="/WEB-INF/why/common/limit.jsp" %>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    <!--文本编辑框 end-->
    <script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    
     <link rel="stylesheet" href="${path}/STATIC/js/ossjs/style.css" type="text/css" />
    <script type="text/javascript" src="${path}/STATIC/js/ossjs/uuid.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/crypto.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/hmac.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/sha1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/base64.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/plupload.full.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-img.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/ossjs/upload-files.js"></script>
    <script type="text/javascript">
        window.onload = function () {
            var editor = CKEDITOR.replace('antiqueRemark');
        }

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log: function () {
                    }
                }
         
        $(function () {
          	aliUploadImg('antiqueImgUrlWebupload', getAntiqueImgUrl, 3, true, 'BeiPiao');
         
        });
        
      //图片回调    
        function getAntiqueImgUrl(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    		$("#"+file.id).append("<input type='hidden' name='antiqueImgUrl' value='"+filePath+"'/>"); 
		}
      
        /**
         * 单选
         * @param value
         * @param id
         */
        function setSingle(value,id){
            $("#"+id).val(value);
            $('#'+id).find('a').removeClass('cur');
        }
        /**
         * 单选
         * @param id
         */
        function tagSelectSingle(id) {
            /* tag标签选择 */

            $('#'+id).find('a').click(function() {
                $('#'+id).find('a').removeClass('cur');
                $(this).addClass('cur');
            });
        }
        $(function () {       
        	 //朝代
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'DYNASTY'}, function (data) {
                var list = data;
                var dictHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    var cl = '';
                    cl = 'class="cur"';
                    dictHtml += '<a id="'+dictId+'" class="tagType" onclick="setSingle(\''
                            + dictId + '\',\'antiqueDynasty\')">' + dictName
                            + '</a>';
                }
                $("#antiqueDynastyLabel").html(dictHtml);
                tagSelectSingle("antiqueDynastyLabel");
            },'json'); 
            //藏品类型
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'ANTIQUE'}, function (data) {
                var list = data;
                var dictHtml = '';
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    var cl = '';
                    cl = 'class="cur"';
                    dictHtml += '<a id="'+dictId+'" class="tagType" onclick="setSingle(\''
                            + dictId + '\',\'antiqueType\')">' + dictName
                            + '</a>';
                }
                $("#antiqueTypeLabel").html(dictHtml);
                tagSelectSingle("antiqueTypeLabel");
            },'json');
        	
        })

        /**
         * 校验
         */
        function checkValidation(){
        	$('#antiqueRemark').val(CKEDITOR.instances.antiqueRemark.getData());
            var antiqueName=$('#antiqueName').val();
            var antiqueImgNum=$("[name='antiqueImgUrl']").length;
            var antiqueDynasty=$("#antiqueDynasty").val();
            var antiqueType=$("#antiqueType").val();
            var antiqueInfo=$("#antiqueInfo").val();
            var antiqueRemark=CKEDITOR.instances.antiqueRemark.getData();

            if($.trim(antiqueName)){
            	removeMsg("antiqueNameLabel");
                if(antiqueName.length>20){
                	appendMsg("antiqueNameLabel","文物名称只能输入20字以内!");
                    $('#antiqueName').focus();
                    return false;
                }
            }else{
            	removeMsg("antiqueNameLabel");
            	appendMsg("antiqueNameLabel","文物名称为必填项!");
                $('#antiqueName').focus();
                return false;
            }
			if(antiqueImgNum==3){
				removeMsg("antiqueImgUrlLabel");
			}else{
				removeMsg("antiqueImgUrlLabel");
				appendMsg("antiqueImgUrlLabel","必须上传3张图片!");
				alert("必须上传3张图片");
	            return false;
			}
            if($.trim(antiqueDynasty)){
            	removeMsg("antiqueDynastyLabel");
            }else{
            	removeMsg("antiqueDynastyLabel");
            	appendMsg("antiqueDynastyLabel","年代为必填项!");
                $('#antiqueDynastyMessage').focus();
                return false;
            }

            if($.trim(antiqueType)){
            	removeMsg("antiqueTypeLabel");
            }else{
            	removeMsg("antiqueTypeLabel");
            	appendMsg("antiqueTypeLabel","类型为必填项!");
                $('#antiqueTypeMessage').focus();
                return false;
            }

            if($.trim(antiqueInfo)){
            	removeMsg("antiqueInfoLabel");
            }else{
            	removeMsg("antiqueInfoLabel");
            	appendMsg("antiqueInfoLabel","简介为必填项!");
                $('#antiqueInfo').focus();
                return false;
            }
            if($.trim(antiqueRemark)){
            	removeMsg("antiqueRemarkLabel");
            }else{
            	removeMsg("antiqueRemarkLabel");
            	appendMsg("antiqueRemarkLabel","详细描述为必填项!");
                $('#antiqueRemark').focus();
                return false;
            }
            return true;
        }
        //提交与发布草稿按钮对应事件
        $(function () {
            $("#btnPublish").on("click", function () {
               if(checkValidation()){
            	   $.post("${path}/bpAntique/publishAntique.do", $("#addAntiqueForm").serialize(),
                           function(data) {
                               if (data!=null && data=='success') {
                                       var html = "<h2>发布成功</h2>";
                                       dialogSaveDraft("提示", html, function(){
                                    	   window.location.href = "${path}/bpAntique/antiqueIndex.do";
                                       });
                                       
                               } else {
                                   var html = "<h2>发布失败,请联系管理员</h2>";
                                   dialogSaveDraft("提示", html, function(){

                                   });
                               }
                           });
               }
           	  
            });

            $("#test").on("click",function(){
            	
            	var val = $("#antiqueDynasty").val();
            	alert(val);
            	/* if($("[name='antiqueImgUrl']").length==0){
          		  alert('不存在');
          		  }else{
          			var array=$("[name='antiqueImgUrl']");
          			var value='';
          			for(var i=0;i<array.length;i++){
          				if(value!=''){
          					value = value+','+$(array[i]).val();
          					}else
          						value = $(array[i]).val();
          				
          			}
          			alert(value);
          		  } */
            	
            });

        });
        
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        

    </script>
    <!-- dialog end -->
    <style>
		div[name=aliFile] br,div[name=aliFile] p,div[name=aliFile] span，.progress{display:none!important;}
		#antiqueImgUrlWebupload div[name=aliFile] img:nth-child(1){position:relative!important;max-width:560px!important;max-height:420px!important;}
		#antiqueImgUrlWebupload div[name=aliFile] img:nth-child(1){max-width:560px;max-height:420px;}
		#antiqueImgUrlWebupload div[name=aliFile]{width:560px!important;max-width:420px!important;}
    </style>
</head>
<body>
	<input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
	<div class="site">
	    <em>您现在所在的位置：</em>文化文物管理 &gt; 发布文化文物
	</div>
	<div class="site-title">发布文化文物</div>
	<form method="post" id="addAntiqueForm" action="previewAntique.do" target="blank">
		<input type="hidden" id="roomTagName" name="roomTagName" />
	    <input type="hidden" id="isCutImg" value="N"/>
	    <%-- 基础路径 --%>
	    <div class="main-publish">
	        <table width="100%" class="form-table">
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>文物名称：</td>
	                <td class="td-input" id="antiqueNameLabel">
	                    <input id="antiqueName" name="antiqueName" type="text" class="input-text w510" maxlength="20"/>
	                    <span class="error-msg"></span>
	                </td>
	            </tr>
	          
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>图片：</td>
	                <td id="antiqueImgUrlLabel" class="td-upload">
		                <table>
		                    <tr>
		                        <td>
		                        	<div class="whyVedioInfoContent" style="margin-top:-10px;">
		                            <div class="whyUploadVedio" id="antiqueImgUrlWebupload">
										<div style="width: 700px;">
											<div id="ossfile2"></div>
											<div id="container2" style="clear:both;">
												<a id="selectfiles2" class="selectFiles btn">选择图片</a>
											</div>
										</div>
										<span class="upload-tip">必须上传3张图片,建议尺寸560*420像素，格式为jpg,jpeg,png,gif，建议大小不超过2M</span>
									</div>
								</div>
		                        </td>
		                    </tr>
		                </table>
						</td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>
	                                               年代：<input id="antiqueDynastyMessage" style="position: absolute; left: -9999px;"/>
	                </td>
	                <td class="td-tag">
	                    <dl>
	                        <input id="antiqueDynasty" name="antiqueDynasty" type="hidden"/>
	                        <dd id="antiqueDynastyLabel">
	                        </dd>
	                    </dl>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>类型：
	                    <input id="antiqueTypeMessage" style="position: absolute; left: -9999px;"/>
	                </td>
	                <td class="td-tag">
	                    <dl>
	                        <input id="antiqueType" name="antiqueType" type="hidden"/>
	                        <dd id="antiqueTypeLabel">
	                        </dd>
	                    </dl>
	                </td>
	            </tr>
	            
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>简介：</td>
	                <td class="td-input" id="antiqueInfoLabel">
	                     <textarea name="antiqueInfo" id="antiqueInfo" rows="4" class="textareaBox"  maxlength="300" style="width: 500px;resize: none"></textarea>
	                </td>
	            </tr>
	            
	            <tr>
	                <td width="100" class="td-title"><span class="red">*</span>详情描述：</td>
	                <td class="td-content" id="antiqueRemarkLabel">
	                    <div class="editor-box">
	                        <textarea name="antiqueRemark" id="antiqueRemark"></textarea>
	                    </div>
	                </td>
	            </tr>
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                	<input id="btnPublish" class="btn-publish" type="button" value="保存并发布信息"/>             	
	                </td>
	                <!-- <td class="td-btn">
	                	<input id="test" class="test" type="button" value="测试"/>             	
	                </td> -->
	            </tr>
	        </table>
	    </div>
	</form>

</body>
</html>