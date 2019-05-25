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

	<script type="text/javascript" src="${path}/STATIC/js/admin/gather/UploadGatherFile.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
    	$.ajaxSettings.async = false; 	//同步执行ajax
    	
    	var userId = '${user.userId}';
    	
    
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        $(function () {
        	//活动类型
            $.post("${path}/tag/getChildTagByType.do",{'code' : 'ACTIVITY_TYPE'},function(data) {
            	if (data.length>0) {
    	            var tagHtml = '';
    	            $.each(data,function(i,dom){
    	            	if(dom.tagId == '${gather.gatherTag}'){
    	            		tagHtml += '<a data-option="'+dom.tagId+'" class="cur">'+dom.tagName+'</a>';
            			}else{
            				tagHtml += '<a data-option="'+dom.tagId+'">'+dom.tagName+'</a>';
            			}
    	            })
    	            $('#gatherTagLabel').html(tagHtml);
    	            
    	          	//活动类型点击事件
    	            $("#gatherTagLabel a").on("click",function(){
    	            	var selectTag = $(this).attr("data-option");
    	            	
    	            	$(this).parent().find('a').removeClass('cur');
    			        $(this).addClass('cur');
    			        $("#gatherTag").val(selectTag);
    	            });
    	        }
    		},"json");
        	
        	//评级类别
            $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'RATINGS_INFO'},function(data) {
            	if (data.length>0) {
    	            var ulHtml = '';
    	            $.each(data,function(i,dom){
    	            	ulHtml += '<li data-option="'+dom.dictId+'">'+dom.dictName+'</li>';
    	            })
    	            $('#gatherGradeUl').html(ulHtml);
    	        }
    		},"json");
        	
            selectModel();
        	
            //活动标签点击事件
            $("#gatherTypeLabel a").on("click",function(){
            	var gatherType = $("#gatherType").val();
            	var selectType = $(this).attr("data-option");
            	
            	$(this).parent().find('a').removeClass('cur');
		        $(this).addClass('cur');
		        $("#gatherType").val(selectType);
            	
            	if(gatherType==0&&selectType!=0 || gatherType!=0&&selectType==0){
            		emptyInput();
            	}
            	
            	if($(this).attr("data-option") == 0){	//热映影片
            		$("#commonGatherTable").hide();
            		$("#movieGatherTable").show();
            	}else{
            		$("#movieGatherTable").hide();
            		$("#commonGatherTable").show();
            	}
            });
            
            //时间点击事件
            $(".start-btn").on("click", function () {
                WdatePicker({
                    el: 'startDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '',
                    maxDate: '#F{$dp.$D(\'endDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedStartFunc
                })
            });
            $(".end-btn").on("click", function () {
                WdatePicker({
                    el: 'endDateHidden',
                    dateFmt: 'yyyy-MM-dd',
                    doubleCalendar: true,
                    minDate: '#F{$dp.$D(\'startDateHidden\')}',
                    position: {left: -224, top: 8},
                    isShowClear: false,
                    isShowOK: true,
                    isShowToday: false,
                    onpicked: pickedendFunc
                })
            })
            
        });
    	
        function pickedStartFunc() {
            $dp.$('gatherStartDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc() {
            $dp.$('gatherEndDate').value = $dp.cal.getDateStr('yyyy-MM-dd');
        }
        
        function emptyInput(){
        	$("#activityAddress").val("");
        	$("#addressId").val("");
        	$("#gatherTime").val("");
        	$("#gatherHost").val("");
        	$("#gatherPrice").val("");
        	
        	$("#gatherMovieType").val("");
        	$("#gatherMovieTime").val("");
        	$("#gatherMovieActor").val("");
        	$("#gatherMovieDirector").val("");
        }
        
        function changeAddress(){
        	var addressId = $("#referId").val();
            var winW = parseInt($(window).width() * 0.8);
            var winH = parseInt($(window).height() * 0.95);
            $.DialogBySHF.Dialog({
                Width: winW,
                Height: winH,
                URL: '../activity/subjectAddressIndex.do?addressId=' + addressId
            });
        }
        
        //保存
    	function saveGather(){
    		if (userId == null || userId == '') {
    			dialogAlert('系统提示', '登录超时',function(){
    				location.href = '${path}/user/sysUserLoginOut.do'
    			});
                return;
            }
    		
    		$("#saveBut").attr("onclick","");
    		var gatherName=$('#gatherName').val();
    		var gatherTag=$('#gatherTag').val();
    		var gatherType=$('#gatherType').val();
    		var gatherMovieType=$('#gatherMovieType').val();
    		var gatherMovieTime=$('#gatherMovieTime').val();
    		var gatherMovieActor=$('#gatherMovieActor').val();
    		var gatherMovieDirector=$('#gatherMovieDirector').val();
    		var activityAddress=$('#activityAddress').val();
    		var gatherTime=$('#gatherTime').val();
    		var gatherHost=$('#gatherHost').val();
    		var gatherPrice=$('#gatherPrice').val();
    		var gatherStartDate=$('#gatherStartDate').val();
    		var gatherEndDate=$('#gatherEndDate').val();
    		var gatherImg=$('#gatherImg').val();
    		
    		if(!checkInfo(gatherName,"gatherName","活动名称为必填项！")) return;
    		if(!checkInfo(gatherTag,"gatherTag","活动类型为必选项！")) return;
    	    if(!checkInfo(gatherType,"gatherType","活动类型为必选项！")) return;
    	    
    	    if(gatherType == 0){	//热映影片
    	    	if(!checkInfo(gatherMovieType,"gatherMovieType","影片类型为必填项！")) return;
    	    	if(!checkInfo(gatherMovieTime,"gatherMovieTime","时长为必填项！")) return;
    	    	if(!checkInfo(gatherMovieActor,"gatherMovieActor","主演/配音为必填项！")) return;
    	    	if(!checkInfo(gatherMovieDirector,"gatherMovieDirector","导演为必填项！")) return;
	        }else{
	        	if(!checkInfo(activityAddress,"gatherAddress","活动地址为必填项！")) return;
	        	if(!checkInfo(gatherTime,"gatherTime","活动时间为必填项！")) return;
	        	if(!checkInfo(gatherHost,"gatherHost","主办/演出为必填项！")) return;
	        	if(!checkInfo(gatherPrice,"gatherPrice","票价为必填项！")) return;
	        }
    	    
    	    if(!checkInfo(gatherStartDate,"gatherDate","活动开始日期为必选项！")) return;
    	    if(!checkInfo(gatherEndDate,"gatherDate","活动结束日期为必选项！")) return;
    		
    	    if(gatherImg && "N"==isCutImg) {
    	    	$("#saveBut").attr("onclick","saveGather();");
    	        dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！");
    	        return;
    	    }
    	    
    	  	//保存活动信息
    	    $.post("${path}/gather/saveOrUpdateGather.do", $("#gatherForm").serialize(),function(data) {
   	            if(data=="200") {
   	                dialogAlert('系统提示', "保存成功!",function (r){
   	                	window.location.href="../gather/gatherIndex.do";
   	                });
   	            }else{
   	                dialogAlert('系统提示', '保存失败');
   	                $("#saveBut").attr("onclick","saveGather();");
   	            }
   	     	},"json");
    	}

    	//信息必填验证
        function checkInfo(param,paramName,warn){
        	if(!param.trim()){
    	        removeMsg(paramName+"Label");
    	        $("#saveBut").attr("onclick","saveGather();");
    	        appendMsg(paramName+"Label",warn);
    	        $('#'+paramName).focus();
    	        return false;
    	    }else{
    	        removeMsg(paramName+"Label");
    	        return true;
    	    }
        }
    </script>
    
</head>

<body>
	<form id="gatherForm" method="post">
	    <input type="hidden" id="userCounty" name="userCounty" value="${sessionScope.user.userCounty}"/>
	    <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
	    <c:if test="${empty gather.gatherImg}"><input type="hidden" id="isCutImg" value="N"/></c:if>
	    <c:if test="${not empty gather.gatherImg}"><input type="hidden" id="isCutImg" value="Y"/></c:if>
	    <input type="hidden" id="referId" name="gatherAddressId"/>
	    <input type="hidden" name="gatherId" value="${gather.gatherId}"/>
	    
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理  &gt; 编辑采集活动
	    </div>
	    <div class="site-title">编辑采集活动</div>
	    <div class="main-publish">
	    	<table width="100%" class="form-table">
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>活动名称：</td>
	                <td class="td-input" id="gatherNameLabel">
	                	<input type="text" id="gatherName" name="gatherName" class="input-text w510" maxlength="50" value="${gather.gatherName}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td class="td-title"><span class="red">*</span>活动类型：</td>
		            <td class="td-tag">
		            	<dd id="gatherTagLabel"></dd>
		            	<input type="hidden" name="gatherTag" id="gatherTag" value="${gather.gatherTag}"/>
		            </td>
	            </tr>
	            <tr>
	            	<td class="td-title"><span class="red">*</span>活动标签：</td>
		            <td class="td-tag">
		            	<dd id="gatherTypeLabel">
		            		<a data-option="0">热映影片</a>
			            	<a data-option="1">舞台演出</a>
			            	<a data-option="2">美术展览</a>
			            	<a data-option="3">音乐会</a>
			            	<a data-option="4">演唱会</a>
			            	<a data-option="5">舞蹈</a>
			            	<a data-option="6">话剧歌剧</a>
			            	<a data-option="7">戏曲曲艺</a>
			            	<a data-option="8">儿童剧</a>
			            	<a data-option="9">杂技魔术</a>
		            	</dd>
		            	<input type="hidden" name="gatherType" id="gatherType" value="${gather.gatherType}"/>
		            	<script>
		            		$("#gatherTypeLabel a").each(function(){
		            			if($(this).attr("data-option") == '${gather.gatherType}'){
		            				$(this).addClass("cur");
		            			}
		            		})
		            	</script>
		            </td>
	            </tr>
	        </table>
	        
        	<table width="100%" id="commonGatherTable" class="form-table" <c:if test="${gather.gatherType == 0}">style="display: none;"</c:if>>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>活动地址：</td>
		            <td width="560" class="td-input" id="gatherAddressLabel">
		                <input type="text" id="activityAddress" name="gatherAddress" class="actPlace input-text w510" placeholder="街道+门牌号，如：“广中西路777弄10号F楼”" readonly value="${gather.gatherAddress}">
		            </td>
		            <td class="td-input">
		                <input type="button" class="upload-btn" onclick="changeAddress()" value="地址设置">
		            </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>活动时间：</td>
	                <td class="td-input" id="gatherTimeLabel">
	                	<input type="text" id="gatherTime" name="gatherTime" class="input-text w510" maxlength="50" value="${gather.gatherTime}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>主办/演出：</td>
	                <td class="td-input" id="gatherHostLabel">
	                	<input type="text" id="gatherHost" name="gatherHost" class="input-text w510" maxlength="50" value="${gather.gatherHost}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>票价：</td>
	                <td class="td-input" id="gatherPriceLabel">
	                	<input type="text" id="gatherPrice" name="gatherPrice" class="input-text w310" maxlength="20" value="${gather.gatherPrice}"/>
	                </td>
	            </tr>
	        </table>
	        
	        <table width="100%" id="movieGatherTable" class="form-table" <c:if test="${gather.gatherType != 0}">style="display: none;"</c:if>>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>影片类型：</td>
		            <td class="td-input" id="gatherMovieTypeLabel">
	                	<input type="text" id="gatherMovieType" name="gatherMovieType" class="input-text w510" maxlength="50" value="${gather.gatherMovieType}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>时长：</td>
	                <td class="td-input" id="gatherMovieTimeLabel">
	                	<input type="text" id="gatherMovieTime" name="gatherMovieTime" class="input-text w310" maxlength="20" value="${gather.gatherMovieTime}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>主演/配音：</td>
	                <td class="td-input" id="gatherMovieActorLabel">
	                	<input type="text" id="gatherMovieActor" name="gatherMovieActor" class="input-text w510" maxlength="100" value="${gather.gatherMovieActor}"/>
	                </td>
	            </tr>
	            <tr>
	            	<td width="100" class="td-title"><span class="red">*</span>导演：</td>
	                <td class="td-input" id="gatherMovieDirectorLabel">
	                	<input type="text" id="gatherMovieDirector" name="gatherMovieDirector" class="input-text w510" maxlength="20" value="${gather.gatherMovieDirector}"/>
	                </td>
	            </tr>
	        </table>
	        
	        <table width="100%" class="form-table">
	        	<tr>
	        		<td width="100" class="td-title"><span class="red">*</span>活动日期：</td>
	        		<td>
	        			<div class="form-table" style="float: left;" id="gatherDateLabel">
				            <div class="td-time" style="margin-top: 0px;">
				                <div class="start w240">
				                    <span class="text">开始日期</span>
				                    <input type="hidden" id="startDateHidden" value="${gather.gatherStartDate}"/>
				                    <input type="text" id="gatherStartDate" name="gatherStartDate" value="${gather.gatherStartDate}" readonly/>
				                    <i class="data-btn start-btn"></i>
				                </div>
				                <span class="txt" style="line-height: 42px;">至</span>
				                <div class="end w240">
				                    <span class="text">结束日期</span>
				                    <input type="hidden" id="endDateHidden" value="${gather.gatherEndDate}"/>
				                    <input type="text" id="gatherEndDate" name="gatherEndDate" value="${gather.gatherEndDate}" readonly/>
				                    <i class="data-btn end-btn"></i>
				                </div>
				            </div>
				        </div>
	        		</td>
	        	</tr>
	            <tr>
	                <td class="td-title"><span></span>活动图片：</td>
	                <td class="td-upload" id="gatherImgLabel">
	                    <table>
	                        <tr>
	                            <td>
	                                <input type="hidden" name="gatherImg" id="gatherImg" value="${gather.gatherImg}">
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
	                                    <div id="fileContainer" style="float: left;"></div>
	                                    <div id="btnContainer" style="display: none;">
	                                        <a style="margin-left:310px;border:1px solid #D9D9D9;background-color: #F4F4F4;border-radius: 5px;padding: 5px;" href="javascript:clearQueue();" class="btn">取消</a>
	                                    </div>
	                                </div>
	                            </td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
		            <td class="td-title"><span></span>活动评级：</td>
		            <td class="td-input search" id="gatherGradeLabel">
		                <div class="select-box w135" style="margin-left: 0;">
		                    <input type="hidden" name="gatherGrade" id="gatherGrade" value="${gather.gatherGrade}"/>
		                    <div id="gatherGradeDiv" class="select-text" data-value="">-请选择-</div>
		                    <ul class="select-option" id="gatherGradeUl"></ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
	            	<td class="td-title"><span></span>活动链接：</td>
	                <td class="td-input" id="gatherLinkLabel">
	                	<input type="text" id="gatherLink" name="gatherLink" class="input-text w510" maxlength="200" value="${gather.gatherLink}"/>
	                </td>
	            </tr>
	        </table>
	        
	        <table width="100%" class="form-table">  
	            <tr>
	                <td width="100" class="td-title"></td>
	                <td class="td-btn">
	                    <div class="room-order-info info2" style="position: relative;">
	                        <input id="saveBut" class="btn-publish" type="button" onclick="saveGather()" value="保存"/>
	                    </div>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>