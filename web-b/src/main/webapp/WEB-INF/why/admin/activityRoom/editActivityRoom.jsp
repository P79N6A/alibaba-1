<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>编辑活动室--文化云</title>

    <%@include file="../../common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        function saveRoom(roomState){

           
            //检查字段是否满足格式
            var checkResult = checkSave();
            if(checkResult){
            	
            	 var isCutImg =$("#isCutImg").val();
                 if("N"==isCutImg) {
                     dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
                     });
                     return;
                 }
            	
                $("#roomState").val(roomState);
                setDefaultVal();
                var html = "";
                var venueId=$("#venueId").val();
                $.post("${path}/activityRoom/editActivityRoom.do", $("#editRoomForm").serialize(),
                    function(data) {
                        if (data == "success") {
                            html = "<h2>修改成功!</h2>";
                            dialogSaveDraft("提示", html, function(){
                                if(roomState == 6){
                                    window.location.href = "${path}/activityRoom/activityRoomIndex.do?venueId="+venueId;
                                }else{
                                    window.location.href = "${path}/activityRoom/roomDraftList.do?venueId="+venueId;
                                }
                            })
                        }else {
                            html = "<h2>修改失败!</h2>";
                            dialogSaveDraft("提示", html, function(){
                                if(roomState == 6){
                                    window.location.href = "${path}/activityRoom/activityRoomIndex.do?venueId=${cmsVenue.venueId}";
                                }else{
                                    window.location.href = "${path}/activityRoom/roomDraftList.do?venueId="+venueId;
                                }
                            })
                        }
                    });
            }
        }




        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        seajs.use(['jquery'], function ($) {


            $('.upload-cut-btn').on('click', function () {
                var cutImageSize;
                var width;
                var height;
                cutImageSize="750*500";

                var urlStr = $("#roomPicUrl").val();

                var url =getImgUrl(urlStr);
                dialog({
                    url: '${path}/att/toCutImgJsp.do?imageURL='+url+'&cutImageSize='+cutImageSize,
                    title: '图片裁剪',
                    fixed: false,
                    onclose: function () {
                        if(this.returnValue){
                            //alert("返回值：" + this.returnValue.imageUrl);
                            $("#imgHeadPrev").html(getImgHtml(this.returnValue.imageUrl));
                            $("#roomPicUrl").val(this.returnValue.imageUrl);
                        }
                    }
                }).showModal();
                return false;
            });
        });

        //选择关键字标签时，赋值
        function setRoomTag(value,id) {

            var tagIds = $("#"+id).val();
            if (tagIds != '') {
                var ids = tagIds.substring(0, tagIds.length - 1).split(",");
                var data = '', r = true;
                for (var i = 0; i < ids.length; i++) {
                    if (ids[i] == value) {
                        r = false;
                    } else {
                        data = data + ids[i] + ',';
                    }
                }
                if (r) {
                    data += value + ',';
                }
                $("#"+id).val(data);
            } else {
                $("#"+id).val(value + ",");
            }
        }
        
        function setRoomSingle(value,id){
        	  $("#"+id).val(value);
        	  $('#'+id).find('a').removeClass('cur');
        	}

        function tagSelect(id) {
            /* tag标签选择 */
            $('#'+id).find('a').click(function() {
                if ($(this).hasClass('cur')) {
                    $(this).removeClass('cur');
                } else {
                    $(this).addClass('cur');
                }
            });
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
        
      //配套设施赋值
        function setroomFacilityDict(){
        	var dictIds =$("input[name='roomFacilityDictLabel']");
        	var dictIdsStr = '';
        	for(var i=0;i<dictIds.length;i++){
	        	if(dictIds[i].checked){
	        		dictIdsStr += dictIds[i].value + ",";
        		}
        	}
        	$("#roomFacilityDict").val(dictIdsStr);
        }
    </script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activityRoom/editActivityRoom.js?version=20151118"></script>
    <script type="text/javascript"
            src="${path}/STATIC/js/admin/activityRoom/UploadActivityRoomImg.js?version=201511101045"></script>
   	<script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin-activityRoom.js?version=20151125"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        $(function() {
            $(".btn-save").on("click", function(){
                if($(this).val() == "返回"){
                    history.back(-1);
                }else if($(this).val() == "保存草稿"){
                    //添加活动室
                    saveRoom(1);
                }
            });

            $("#btnPublish").on("click", function(){
                saveRoom(6);
            });
            
            $("#roomFacilityDictAll").click(function() {
            	//复选框全选
                $('input[name="roomFacilityDictLabel"]').prop("checked",this.checked); 
                setroomFacilityDict();
            });
            
        	//类型标签
			$.post("${path}/tag/getChildTagByType.do?code=ROOM_TAG", function(data) {
				var list = eval(data);
				var tagHtml = '';
				var tagIds = $("#roomTag").val();
				var ids = '';
				if (tagIds.length > 0) {
					ids = tagIds.substring(0, tagIds.length).split(",");
				}
				for (var i = 0; i < list.length; i++) {
					var obj = list[i];
					var tagId = obj.tagId;
					var tagName = obj.tagName;
					var result = false;
					if (ids != '') {
						for (var j = 0; j <ids.length; j++) {
							if (list[i].tagId == ids[j]) {
								result = true;
								break;
							}
						}
					}
					var cl = 'class="tagType"';
					if (result) {
						cl = 'class="cur tagType"';
					}
					
					tagHtml += '<a id="'+tagId+'" '+cl+' onclick="setRoomSingle(\''
					+ tagId + '\',\'roomTag\')">' + tagName
					+ '</a>';
				}
				$("#roomTagLabel").html(tagHtml);
				tagSelectSingle("roomTagLabel");
			});
            
             var roomTags='${roomTags}';
             
 			var roomTagArray=roomTags.split(",");
 			
 		 	//通用标签
             $.post("${path}/tag/getCommonTag.do?type=7", function (data) {
                 var list = eval(data);
                 var tagHtml = '';
                 var commonTagArray=new Array();
                 for (var i = 0; i < list.length; i++) {
                     var obj = list[i];
                     var tagId = obj.tagSubId;
                     var tagName = obj.tagName;
                     
                     var cl = '';
                     
                     if($.inArray(tagId,roomTagArray)>-1)
                     {
                     	commonTagArray.push(tagId);
                     	
                     	cl = 'class="cur"';
                     }
                     
                     tagHtml += '<a '+cl+' onclick="setRoomTag(\''
                             + tagId + '\',\'commonTag\')">' + tagName
                             + '</a>';
                 }
                 $("#commonTagLabel").html(tagHtml);
                 tagSelect("commonTagLabel");
                 
                 if(commonTagArray.length>0)
             		$("#commonTag").val(commonTagArray.join(",")+",");
             });
 		 	
             var roomType = $("#roomTag").val();
             
             $.post("${path}/tag/getTagSubByTagId.do?tagId="+roomType, function (data) {
                 var list = eval(data);
                 var tagHtml = '';
                 var childTagArray=new Array();
                 for (var i = 0; i < list.length; i++) {
                     var obj = list[i];
                     var tagId = obj.tagSubId;
                     var tagName = obj.tagName;
                     var cl = 'class="tagType"';
                     
                     if($.inArray(tagId,roomTagArray)>-1)
                     {
                     	childTagArray.push(tagId);
                     	
                     	cl = 'class="cur tagType"';
                     }
                     
                     tagHtml += '<a id="'+tagId+'" '+cl+' onclick="setRoomTag(\''
                             + tagId + '\',\'childTag\')">' + tagName
                             + '</a>';
                 }
                 $("#childTagLabel").html(tagHtml);
                 tagSelect("childTagLabel");
                 
                 if(childTagArray.length>0)
             	$("#childTag").val(childTagArray.join(",")+",");
             });
          
            
          	$("#roomTagLabel").on("click",".tagType", function () { 
          		
          		var tagId=$(this).attr("id");
          		
          	  //类型标签
               $.post("${path}/tag/getTagSubByTagId.do?tagId="+tagId, function (data) {
                    var list = eval(data);
                    var tagHtml = '';
                    for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
                        var tagId = obj.tagSubId;
                        var tagName = obj.tagName;
                        var cl = '';
                        cl = 'class="cur"';
                        tagHtml += '<a id="'+tagId+'" class="tagType" onclick="setRoomTag(\''
                                + tagId + '\',\'childTag\')">' + tagName
                                + '</a>';
                    }
                    $("#childTagLabel").html(tagHtml);
                    $("#childTag").val("");
                    tagSelect("childTagLabel");
                });
          	});
          
         // 配套设施，并选中
            $.post("${path}/sysdict/queryChildSysDictByDictCode.do?dictCode=ROOM_FACILITY", function(data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var dictId = obj.dictId;
                    var dictName = obj.dictName;
                    $("#roomFacilityDictLabel").append('<label><input onclick="setroomFacilityDict()" id="'+dictId+'" name="roomFacilityDictLabel" type="checkbox" value="'+dictId+'"/><em>'+dictName+'</em></label>');
                	
                    var idsStr = $("#roomFacilityDict").val();
                    if (idsStr.length > 0) {
                        ids = idsStr.substring(0, idsStr.length - 1).split(",");
                        if(ids.length == list.length){	//确认是否已全选
                        	$('#roomFacilityDictAll').attr("checked",'true');
                        }
                       	for (var j = 0; j <ids.length; j++) {	//选中已选
                             if (dictId == ids[j]) {
                             	$('#'+dictId).attr("checked",'true');
                             	break;
                             }
                         }
                    }
                }
                
                //添加与全选键的联动
                var $subBox = $("input[name='roomFacilityDictLabel']");
                $subBox.click(function(){
                	if($subBox.length == $("input[name='roomFacilityDictLabel']:checked").length){
                		$("#roomFacilityDictAll").attr("checked",'true');
                	}else{
                		$("#roomFacilityDictAll").get(0).checked = false;
                	}
                });
            });
         
            var venueArea ='${cmsVenue.venueArea}';
            var venueType ='${cmsVenue.venueType}';
            if($("#createActivityCode").val()==2){	//区自建
            	venueType = "1";
        	}
            //场馆
            showVenueData(venueArea.split(",")[0],venueType,'${cmsVenue.venueId}');
            
 			$(".btn-preview").on("click", function(){
            	
            	var tagArray=new Array();
            	
				$(".td-tag .cur").each(function(index,item){
            		
            		var tagName=$(this).html();
            		
            		tagArray.push(tagName)
            	});
            	
            	/**$("#commonTagLabel .cur").each(function(index,item){
            		var tagName=$(this).html();
            		tagArray.push(tagName)
                });
            	
            	$("#childTagLabel .cur").each(function(index,item){
            		var tagName=$(this).html();
            		tagArray.push(tagName)
                });**/
            	
            	$("#roomTagName").val(tagArray.join(","))
            	
                var facilityArray=new Array(); 
            	
            	$("#roomFacilityDictLabel input:checkbox[name='roomFacilityDictLabel']:checked").each(function(index,item){
            		
            		var roomFacility=$(this).parent().find("em").html();
            		
            		facilityArray.push(roomFacility)
            		
            	});
            	
            	$("#roomFacilityInfo").val(facilityArray.join(","));
            	
            	$("#editRoomForm").submit();
            });
        });
    </script>
    <!-- dialog end -->

</head>
<body>
<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<input type="hidden" id="isCutImg" value="Y"/>
<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 活动室管理 &gt; 修改活动室
</div>
<div class="site-title">活动室发布</div>
<form method="post" id="editRoomForm" action="previewActivityRoom.do" target="blank">
	<input type="hidden" id="roomTagName" name="roomTagName" />
	<input type="hidden" id="roomFacilityInfo" name="roomFacilityInfo"/>
<div class="main-publish">
    <table width="100%" class="form-table">
       
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动室名称：</td>
            <td class="td-input" id="roomNameLabel">
                <input id="roomName" name="roomName" type="text" class="input-text w510" value='<c:out value="${cmsActivityRoom.roomName}" escapeXml="true"/>' maxlength="15"/>
                <span class="error-msg"></span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
            <td class="td-upload" id="roomPicUrlLabel">
              <input type="text" id="roomPicUrlMessage" style="position: absolute; left: -9999px;"/>
                <table>
                    <tr>
                        <td>
                            <input type="hidden"  name="roomPicUrl" id="roomPicUrl" value="${cmsActivityRoom.roomPicUrl}">
                            <input type="hidden" name="uploadType" value="Img" id="uploadType"/>
                            <div class="img-box">
                                <div  id="imgHeadPrev" class="img"> </div>
                            </div>
                            <div class="controls-box">
                                <div style="height: 46px;">
                                    <div class="controls" style="float:left;">
                                        <input type="file" name="file" id="file">
                                    </div>
                                    <%--<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>--%>
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
              <td width="100" class="td-title"><span class="red">*</span>类型（单选）：
              	 <input id="roomTagMessage" style="position: absolute; left: -9999px;"/>
              </td>
              <td class="td-tag">
                  <dl>
                        <input id="roomTag" name="roomTag" style="position: absolute; left: -9999px;" type="hidden" value="${cmsActivityRoom.roomTag}"/>
                      <dd id="roomTagLabel">
                      </dd>
                  </dl>
              </td>
        </tr>
       
             <tr>
                <td width="100" class="td-title"><span class="red">*</span>标签(多选)：
                    <input id="commonTagMessage" style="position: absolute; left: -9999px;"/>
                </td>
                <td class="td-tag">
                    <dl>
                        <input id="commonTag" name="commonTag" type="hidden"/>
                        <dd id="commonTagLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">
                    <input id="childTagMessage" style="position: absolute; left: -9999px;"/>
                </td>
                <td class="td-tag">
                    <dl>
                        <input id="childTag" name="childTag" type="hidden"/>
                        <dd id="childTagLabel">
                        </dd>
                    </dl>
                </td>
            </tr>
          <tr>
                <td width="100" class="td-title"><span class="red">*</span>所属场馆：</td>
         <td class="td-select" id="venueIdLabel">
	                  <input type="text" value="${venueId}" style="position: absolute; left: -9999px;" id="venueId" name="venueId" />  
	                  <c:if test="${sessionScope.user.userIsManger<=2}" >
	                  	<select id="create_activity_code" style="width:142px; margin-right: 8px"></select>
	                  	<script>
		                  	//所在市
	                  		var userProvince = '${user.userProvince}';
	                  		var userCity = '${user.userCity}';
	                  		var loc = new Location();
	            			var area = loc.find('0,' + userProvince.split(",")[0]);
	            			$.each(area , function(k , v) {
	                            if(k == userCity.split(",")[0]){
	                            	$('#create_activity_code').append('<option value=2>'+v+'</option>');
	                            }
	               			});
					    	//$('#create_activity_code').append('<option value=1>市级自建活动</option>');
							$('#create_activity_code').select2();
							$('#create_activity_code').change(function() {
								if($(this).val()==2){
									$("#loc_s").css("display", 'block');
									$("#createActivityCode").val("2");
                                    $("#onlineSelect").show();
								}else if($(this).val()==1){
									$("#loc_s").css("display", 'none');
									$('#loc_area').empty();
									$('#loc_area').append('<option value="">所有区县</option>');
                                    $("#onlineSelect").hide();
									loadingVenueData('loc_area');
									$('#loc_category').empty();
									$('#loc_category').append('<option value="">场馆类型</option>');
									$('#loc_category').select2("val", "");
									$('#loc_venue').empty();
									$('#loc_venue').append('<option value="">所有场馆</option>');
									$('#loc_venue').select2("val", "");
						            $("#activityArea").val("");
									$('#venueId').val("");
									$("#createActivityCode").val("1");
								//	dictLocation($("#loc_area").find("option:selected").val());		//位置重置
									$("#activityLocation").val("0");
								}
							})
						</script>
	                  </c:if>
	                  <div id="loc_s">
		                  <select id="loc_area" style="width:142px; margin-right: 8px"></select>
		                  <select id="loc_category" style="width:142px; margin-right: 8px"></select>
		                  <div id="loc_q">
		                  	<select id="loc_venue"  style="width:142px; margin-right: 8px"></select>
		                  </div>
	                  </div>
                      <script type="text/javascript">
                          if($("#userIsManager").val() == 4){
                              $("#loc_area").prop("disabled", true);
                              $("#loc_category").prop("disabled", true);
                              $("#loc_venue").prop("disabled", true);
                          }
                      </script>
	              </td>
	             </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动室位置：</td>
            <td class="td-input" id="roomNoLabel">
                <input id="roomNo" name="roomNo" type="text" class="input-text w510" value='<c:out value="${cmsActivityRoom.roomNo}" escapeXml="true"/>'/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>咨询电话：</td>
            <td class="td-input" id="roomConsultTelLabel">
                <input id="roomConsultTel" name="roomConsultTel" type="text" class="input-text w210" value="${cmsActivityRoom.roomConsultTel}" maxlength="30"/>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">开放场次模板：</td>
            <td class="td-room">
                <input id="allRoomDayStr" name="allRoomDayStr" type="hidden"/>
                <c:set var="roomDaySize" value="${fn:length(roomTimeList)}"></c:set>
                <c:set var="timePeriodSize" value="${roomDaySize/7}"></c:set>
                <table class="room-time-set">
                    <c:forEach items="${roomTimeList}" var="c" varStatus="s">
                        <c:if test="${s.index%timePeriodSize==0}">
                            <c:if test="${s.index==timePeriodSize*0}">
                                <tr id="roomDayMondayTr">
                                    <td><label><input id="roomDayMonday" name="roomDayMonday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDayMonday == 1}">checked="checked"</c:if> >周一</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*1}">
                                <tr id="roomDayTuesdayTr">
                                <td><label><input id="roomDayTuesday" name="roomDayTuesday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDayTuesday == 1}">checked="checked"</c:if> >周二</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*2}">
                                <tr id="roomDayWednesdayTr">
                                <td><label><input id="roomDayWednesday" name="roomDayWednesday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDayWednesday == 1}">checked="checked"</c:if> >周三</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*3}">
                                <tr id="roomDayThursdayTr">
                                <td><label><input id="roomDayThursday" name="roomDayThursday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDayThursday == 1}">checked="checked"</c:if> >周四</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*4}">
                                <tr id="roomDayFridayTr">
                                <td><label><input id="roomDayFriday" name="roomDayFriday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDayFriday == 1}">checked="checked"</c:if> >周五</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*5}">
                                <tr id="roomDaySaturdayTr">
                                <td><label><input id="roomDaySaturday" name="roomDaySaturday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDaySaturday == 1}">checked="checked"</c:if> >周六</label></td>
                            </c:if>
                            <c:if test="${s.index==timePeriodSize*6}">
                                <tr  id="roomDaySundayTr">
                                <td><label><input id="roomDaySunday" name="roomDaySunday" type="checkbox" value="1" <c:if test="${cmsActivityRoom.roomDaySunday == 1}">checked="checked"</c:if> >周日</label></td>
                            </c:if>
                        </c:if>
                        <td id="${c.roomTimeId}"><input type="text" class="input-text" value="<c:choose><c:when test="${c.timePeriod == 'OFF'}">请设置时间段</c:when><c:otherwise>${c.timePeriod}</c:otherwise></c:choose>"  <c:if test="${c.timePeriod == 'OFF'}">data-val="请设置时间段"</c:if> /></td>
                        <c:if test="${s.index%timePeriodSize==4}">
                            </tr>
                        </c:if>
                    </c:forEach>
                </table>
                <span class="red">注：时间格式标准为00:00-00:00,如09:00-18:30,中间间隔"-"和时间间隔":"皆为英文状态下符号。</span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>是否收费：</td>
            <td class="td-input td-fees" id="roomIsFreeLabel">
                <label><input type="radio" name="roomIsFree" value="no" <c:if test="${cmsActivityRoom.roomIsFree == 1}">checked="checked"</c:if> /><em>否</em></label>
                <label><input type="radio" name="roomIsFree" value="yes" <c:if test="${cmsActivityRoom.roomIsFree == 2}">checked="checked"</c:if>/><em>是</em></label>
                <div class="extra" <c:if test="${cmsActivityRoom.roomIsFree == 1}">style="display: none;"</c:if><c:if test="${cmsActivityRoom.roomIsFree == 2}">style="display: inline-block;"</c:if> >
                    <input id="roomFee" name="roomFee" type="text" class="input-text w120" value="${cmsActivityRoom.roomFee}"/><em></em>
                </div>
                <span class="error-msg"></span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>活动室面积：</td>
            <td class="td-input"  id="roomAreaLabel">
                <input id="roomArea" name="roomArea" type="text" class="input-text w120"  value="${cmsActivityRoom.roomArea}" maxlength="50"/><em>平方米</em>
                <span class="error-msg"></span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>可容纳人数：</td>
            <td class="td-input" id="roomCapacityLabel">
                <input id="roomCapacity" name="roomCapacity" type="text" class="input-text w120"  value="${cmsActivityRoom.roomCapacity}" maxlength="8" onkeyup="this.value=this.value.replace(/\D/g,'')"/><em>人</em>
                <span class="error-msg"></span>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">配套设施：</td>
            <td class="td-input td-fees">
           			 <input id="roomFacilityDict" name="roomFacilityDict" style="position: absolute; left: -9999px;" type="hidden" value="${cmsActivityRoom.roomFacilityDict}"/>
                <div><label><input id="roomFacilityDictAll" type="checkbox" value="" /><em>全部</em></label></div>
                <div style="margin-top:47px;"  id="roomFacilityDictLabel"></div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">简介：</td>
            <td class="td-input">
                <div class="editor-box">
                    <textarea name="roomIntro" rows="4" class="textareaBox" style="width: 500px;resize: none">${cmsActivityRoom.roomIntro}</textarea>
                </div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title">备注：</td>
            <td class="td-input">
                <div class="editor-box">
                    <textarea name="roomRemark" rows="4" class="textareaBox" style="width: 500px;resize: none">${cmsActivityRoom.roomRemark}</textarea>
                </div>
            </td>
        </tr>
        <%-- <tr>
            <td width="100" class="td-title">设施简介：</td>
            <td class="td-content" id="roomFacilityLabel">
                <div class="editor-box">
                    <textarea id="roomFacility" name="roomFacility">${cmsActivityRoom.roomFacility}</textarea>
                </div>
            </td>
        </tr> --%>
        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <input type="hidden" id="roomId" name="roomId" value="${cmsActivityRoom.roomId}"/>
                <input type="hidden" id="roomVenueId" name="roomVenueId" value="${cmsVenue.venueId}"/>
                <input type="hidden" id="roomState" name="roomState" value="${cmsActivityRoom.roomState}"/>
                <c:if test="${cmsActivityRoom.roomState == 6}">
                    <input class="btn-save" type="button" value="返回"/>
                </c:if>
                <c:if test="${cmsActivityRoom.roomState == 1 || cmsActivityRoom.roomState == 5}">
                    <input class="btn-save" type="button" value="保存草稿"/>
                </c:if>
               <input class="btn-preview btn-publish" type="button" value="预览"/>
               <input id="btnPublish" class="btn-publish" type="button" value="发布信息"/>
            </td>
        </tr>
    </table>
</div>
</form>

</body>
</html>