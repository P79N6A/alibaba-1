<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>添加场馆--文化云</title>

	<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
	<%@ include file="/WEB-INF/why/common/limit.jsp"%>

	<!--文本编辑框 end-->
	<script type="text/javascript" src="${path}/STATIC/layer/layer.js"></script>
    <script type="text/javascript" src="${path}/STATIC/layer/extend/layer.ext.js"></script>
	<!-- dialog start -->
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/venue/addVenue.js?version=20151119"></script>
	<%-- add   version   避免上传js浏览器缓存 --%>
	<script type="text/javascript" src="${path}/STATIC/js/admin/peopleTrain/UploadCourseImg.js?version=201511101033">
	</script>
	<script type="text/javascript" src="${path}/STATIC/js/admin/venue/UploadVenueAudio.js?version=201511101033"></script>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<script type="text/javascript">
	$(function(){
	    $(".start-btn").on("click", function(){
	        WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
	    })
	    $(".end-btn").on("click", function(){
	        WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
	    })
	});
	function pickedStartFunc(){
	    $dp.$('courseStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
	  //  $dp.$('startWeek').innerHTML=$dp.cal.getDateStr('DD');
	    //getTotalTicketCount();
	}
	function pickedendFunc(){
	    $dp.$('courseEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
	  //  $dp.$('endWeek').innerHTML=$dp.cal.getDateStr('DD');
	   // getTotalTicketCount();
	}
	//监听 时间段的文本失去焦点事件
	$(function (){
	    $('#notOnlineTicket').on('blur','input',function () {
	        //getTotalTicketCount();
	    })
	});

		//显示小时分钟下拉框

		window.onload = function(){
			var editor2 = CKEDITOR.replace( 'venueMemo' );
		}
        function GetContents()
        {
            var oEditor = CKEDITOR.instances.venueMemo;
            alert( oEditor.getData() );
        }

        function GetText()
        {
            var oEditor = CKEDITOR.instances.venueMemo;//
            return oEditor.document.getBody().getText();
        }
        
		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
			window.dialog = dialog;
		});

		window.console = window.console || {log:function () {}}

		// 省市区
		function getArea(){
			var venueProvince='${user.userProvince}';
			var venueCity='${user.userCity}';
			var venueArea='${user.userCounty}';
			if(venueProvince!=undefined&&venueCity!=undefined&&venueArea!=undefined){
				//省市区
				showVenueLocation(venueProvince.split(",")[0],venueCity.split(",")[0],venueArea.split(",")[0]);
				$("#loc_province").select2("val", venueProvince.split(",")[0]);
				$("#loc_city").select2("val", venueCity.split(",")[0]);
				$("#loc_town").select2("val",  venueArea.split(",")[0]);
			}else {
				showVenueLocation();
			}
		}

		function showVenueLocation(province , city , town) {
			var loc	= new Location();
			var title	= ['省' , '市' , '区'];
			$.each(title , function(k , v) {
				title[k]	= '<option value="">'+v+'</option>';
			});

			$('#loc_province').append(title[0]);
			$('#loc_city').append(title[1]);
			$('#loc_town').append(title[2]);

			$("#loc_province,#loc_city,#loc_town").select2()
			$('#loc_province').change(function() {
				$('#loc_city').empty();
				$('#loc_city').append(title[1]);
				loc.fillOption('loc_city' , '0,'+$('#loc_province').val());
				$('#loc_city').change()
			});

			$('#loc_city').change(function() {
				$('#loc_town').empty();
				$('#loc_town').append(title[2]);
				loc.fillOption('loc_town' , '0,' + $('#loc_province').val() + ',' + $('#loc_city').val());
			});

			$('#loc_town').change(function() {
				$("#userId").val("");
				var userProvince = $("#loc_province").find("option:selected").val() +","+$("#loc_province").find("option:selected").text();
				var userCity = $("#loc_city").find("option:selected").val() +","+$("#loc_city").find("option:selected").text();
				var userArea = $("#loc_town").find("option:selected").val() +","+$("#loc_town").find("option:selected").text();
				// 位置字典根据区域变更
				dictLocation($("#loc_town").find("option:selected").val());
			});

			if (province) {
				loc.fillOption('loc_province' , '0' , province);
				if (city) {
					loc.fillOption('loc_city' , '0,'+province , city);
					if (town) {
						loc.fillOption('loc_town' , '0,'+province+','+city , town);
					}
				}
			} else {
				loc.fillOption('loc_province' , '0');
			}
		}

		$(function() {
			//培训方式
		$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"PXFS"}, function(data) {
          var list = eval(data);
           if(data != null && data.length > 0){
           $("#courseList").html("");
           var dictHtml="";
          for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
           dictHtml+="<li data-option='"+dictId+"'>"+dictName+"</li>";
          }
          $("#courseList").html(dictHtml);
        }
      });
		//课程批次
		$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"KCPC"}, function(data) {
          var list = eval(data);
           if(data != null && data.length > 0){
           $("#courseRankList").html("");
           var dictHtml="";
          for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
           dictHtml+="<li data-option='"+dictId+"'>"+dictName+"</li>";
          }
          $("#courseRankList").html(dictHtml);
        }
      });
        //从事领域
		$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"COURSE_FIELD"}, function(data) {
          var list = eval(data);
           if(data != null && data.length > 0){
           $("#coursefieldList").html("");
           var dictHtml="";
          for (var i = 0; i < list.length; i++) {
                     var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
          if(i==5){
          dictHtml+="<label><input name=\"coursefield\" type=\"checkbox\" value='"+dictId+"'>"+dictName+"</label><br>"
          }
           else{
           dictHtml+="<label><input name=\"coursefield\" type=\"checkbox\" value='"+dictId+"'>"+dictName+"</label>"
            } 
          }
          $("#coursefieldList").html(dictHtml);
        }
      });
       });
/*      //专业类别
		 $.post("${path}/sysdict/queryChildCode.do",{'dictCode':"2c714ca067b347e5823844358fce5224"}, function(data) {
          var list = eval(data);
           if(data != null && data.length > 0){
           $("#majorTypeList").html("");
           var dictHtml="";
          for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
           dictHtml+="<li data-option='"+dictId+"'>"+dictName+"</li>";
          }
          $("#majorTypeList").html(dictHtml);
        }
      });
   		}); */
		$(function(){
			selectModel();
		});

		//提交与发布草稿按钮对应事件
		$(function() {

			$(".btn-publish").on("click", function(){
                text = $("input:checkbox[name='coursefield']:checked").map(function(index,elem) {
			    return $(elem).val();
		        }).get().join(',');
		         $("#coursefield").val(text);
/* 		         alert( $("#courseTitle").val())
		         alert( $("#peopleNumber").val()) */
                 var courseType=$("#courseType").val();
                 var courseRank=$("#courseRank").val();
                 var courseTitle=$("#courseTitle").val().replace(/\"/g,"&quot");
                 var peopleNumber=$("#peopleNumber").val();
                 var coursePhoneNum=$("#coursePhoneNum").val();
                // var pictureUrl=$("#pictureUrl").val();
                 var courseField=$("#coursefield").val();
                 var courseStartTime=$("#courseStartTime").val();
                 var courseEndTime=$("#courseEndTime").val();
                 var teacherIntro=$("#teacherIntro").val().replace(/\"/g,"&quot");;
                 var targetAudienc=$("#targetAudienc").val().replace(/\"/g,"&quot");;
                 var trainAddress=$("#trainAddress").val().replace(/\"/g,"&quot");;
                 var trainTime=$("#trainTime").val();
                 var courseDescription= GetText();
		          var collegesAttributes=$("#collegesAttributes").val();
				//var isCutImg =$("#isCutImg").val();
				//if("N"==isCutImg) {
				//	dialogAlert("提示","请先裁剪系统要求尺寸(750*500)的图片，再提交！",function(){
				///	});
				//	return;
				//}
		          if(courseTitle.trim() == ""){
		              removeMsg("courseTitleLabel");
		              appendMsg("courseTitleLabel", "请填课程名称!");
		              $('#courseTitle').focus();
		              return false;
		          }else{
		              removeMsg("courseTitleLabel");
		          }
		          if(peopleNumber.trim() == ""){
		              removeMsg("peopleNumberLable");
		              appendMsg("peopleNumberLable", "请填写最大人数!");
		              $('#peopleNumber').focus();
		              return false;
		          }else{
		              removeMsg("peopleNumberLable");
		          }
		          if(courseType.trim() == ""){
		              removeMsg("courseTypeLabel");
		              appendMsg("courseTypeLabel", "请选择培训方式!");
		              $('#courseType').focus();
		              return false;
		          }else{
		              removeMsg("courseTypeLabel");
		          }
		          if(courseRank.trim() == ""){
		              removeMsg("courseRankLabel");
		              appendMsg("courseRankLabel", "请选择课程批次!");
		              $('#courseRank').focus();
		              return false;
		          }else{
		              removeMsg("courseRankLabel");
		          }
		          if(trainAddress.trim() == ""){
		              removeMsg("trainAddressLabel");
		              appendMsg("trainAddressLabel", "请填写培训地点!");
		              $('#trainAddress').focus();
		              return false;
		          }else{
		              removeMsg("trainAddressLabel");
		          }
		         
		          if(courseStartTime==undefined||courseStartTime==""){
		              removeMsg("courseStartTimeLabel");
		              appendMsg("courseStartTimeLabel","请选择课程开始时间!");
		              $('#courseStartTime').focus();
		              return;
		          }else{
		              removeMsg("courseStartTimeLabel");
		          }
		          //活动结束时间
		          if(courseEndTime==undefined||courseEndTime==""){
		              removeMsg("courseStartTimeLabel");
		              appendMsg("courseStartTimeLabel","请选择课程结束时间!");
		              $('#courseEndTime').focus();

		              return;
		          }else{
		              removeMsg("courseStartTimeLabel");
		          }
		          var startTime=$("#courseStartTime").val();
		             var start=new Date(startTime.replace("-", "/").replace("-", "/"));
		             var endTime=$("#courseEndTime").val();
		             var end=new Date(endTime.replace("-", "/").replace("-", "/"));
		            if(end <start){
		             appendMsg("courseStartTimeLabel","结束时间不能小于等于开始时间!");
		             $('#activityEndTime').focus();
		             return;
		             } else {
		             removeMsg("courseStartTimeLabel");
		             }
					var html = "";
					$.post("${path}/peopleTrain/saveCourse.do",{
					courseType:courseType,
					courseRank:courseRank,
					courseTitle:courseTitle,
					collegesAttributes:collegesAttributes,
					peopleNumber:peopleNumber,
				//	pictureUrl:pictureUrl,
					courseDescription:courseDescription,
					courseField:courseField,
					teacherIntro:teacherIntro,
					trainAddress:trainAddress,
					trainTime:trainTime,
					targetAudienc:targetAudienc,
					courseStartTime:courseStartTime,
					courseEndTime:courseEndTime,
					coursePhoneNum:coursePhoneNum
					},
						function(data) {
						if(data=="success"){
							html = "<h2>保存成功!</h2>";
								dialogSaveDraft("提示", html, function(){
									window.location.href = "${path}/peopleTrain/courseList.do";
									
						});
						}
			});

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
		seajs.use(['jquery'], function ($) {
		});

	</script>
	<!-- dialog end -->
</head>
<body>
<%--2015.11.6 niu  add  避免火狐下session丢失--%>
<input type="hidden" id="sessionId" value="${pageContext.session.id}" />

<input type="hidden" id="userCounty" value="${sessionScope.user.userCounty}" />
<div class="site">
	<em>您现在所在的位置：</em>培训管理 &gt;课程列表
</div>
<div class="site-title">添加课程</div>
<form method="post" id="addCourseForm">


<input type="hidden" id="isCutImg" value="N"/>
<%-- 基础路径 --%>
<div class="main-publish">
	<table width="100%" class="form-table">
		<tr>
			<td width="100" class="td-title"><span class="red">*</span>课程标题：</td>
			<td class="td-input" id="courseTitleLabel">
				<input id="courseTitle" name="courseTitle" type="text" class="input-text w510" maxlength="50"  />
				<span class="error-msg"></span>
			</td>
		</tr>
<%-- 		<tr>
				<tr>
			<td width="100" class="td-title"><span class="red">*</span>专业类别：
				<input id="collegesAttributesMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<td class="td-select">
				<div class="select-box w140">
					<input type="hidden" id="majorType" value="" />
					<div class="select-text" data-value="专业类别</">专业类别</div>
					<ul class="select-option" id="majorTypeList">
					</ul>
				</div>
			</td>
		</tr> --%>

	<%--	<tr>
			<td width="100" class="td-title"><span class="red">*</span>上传封面：</td>
			<td class="td-upload" id="venueIconUrlLabel">
				<table>
					<tr>
						<td>
							<input type="hidden"  name="pictureUrl" id="pictureUrl" value="">
							<input type="hidden" name="uploadType" value="Img" id="uploadType"/>
							<div class="img-box">
								<div  id="imgHeadPrev" class="img"> </div>
							</div>
							<div class="controls-box">
								<div style="height: 46px;">
									<div class="controls" style="float:left;">
										<input type="file" name="file" id="file">
									</div>
									<input type="button" class="upload-cut-btn" id="" value="裁剪图片"/>
									<span class="upload-tip">建议尺寸133*100px</span>
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
		</tr>--%>


		<tr>
			<td width="100" class="td-title"><span class="red">*</span>最大人数：</td>
			<td class="td-input" id="peopleNumberLable">
				<input id="peopleNumber" name="peopleNumber" type="text" class="input-text w210" maxlength="10" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title">联系方式：</td>
			<td class="td-input" id="coursePhoneNumLabel">
				<input id="coursePhoneNum" name="coursePhoneNum" type="text" class="input-text w510" />
				<span class="error-msg"></span>
			</td>
		</tr>

		<tr>
			<td width="100" class="td-title">从事领域：</td>
			<input type="hidden"  name="coursefield" id="coursefield" value="">
			<td class="td-checkbox td-checkbox-70" id="coursefieldList">
			</td>
		</tr>
				<tr>
			<td width="100" class="td-title"><span class="red">*</span>培训方式：
				<input id="courseTypeMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<td class="td-select"  id="courseTypeLabel">
				<div class="select-box w140">
					<input type="hidden" id="courseType" value="" />
					<div class="select-text" data-value="">培训方式</div>
					<ul class="select-option" id="courseList">
					</ul>
						<span class="error-msg"></span>
				</div>
			</td>
		</tr>
				<tr>
			<td width="100" class="td-title"><span class="red">*</span>课程批次：
				<input id="courseRankMessage" style="position: absolute; left: -9999px;"/>
			</td>
			<td class="td-select"  id="courseRankLabel">
				<div class="select-box w140">
					<input type="hidden" id="courseRank" value="" />
					<div class="select-text" data-value="">课程批次</div>
					<ul class="select-option" id="courseRankList">
					</ul>
						<span class="error-msg"></span>
				</div>
			</td>
		</tr>

	    <tr>
			<td width="100" class="td-title">目标学员：</td>
			<td class="td-input" id="targetAudiencLabel">
				<input id="targetAudienc" name="targetAudienc" type="text" class="input-text w510" />
				<span class="error-msg"></span>
			</td>
		</tr>
	    <tr>
			<td width="100" class="td-title"><span class="red">*</span>培训地点：</td>
			<td class="td-input" id="trainAddressLabel">
				<input id="trainAddress" name="trainAddress" type="text" class="input-text w510" />
				<span class="error-msg"></span>
			</td>
		</tr><%--
	    <tr>
			<td width="100" class="td-title"><span class="red">*</span>培训时间：</td>
			<td class="td-input" id="trainTimeLabel">
				<input id="trainTime" name="trainTime" type="text" class="input-text w510" />
				<span class="error-msg"></span>
			</td>
		</tr>
		     --%><tr>
                <td width="100" class="td-title"><span class="red">*</span>培训时间：</td>
                <td class="td-time" id="courseStartTimeLabel">
                    <div class="start w340">
                        <span class="text">开始日期</span>
                        <input type="hidden" id="startDateHidden"/>
                        <input type="text" id="courseStartTime" name="courseStartTime" value="" readonly/>
                        <span class="week" id="startWeek"></span>
                        <i class="data-btn start-btn"></i>
                    </div>
                    <span class="txt">至</span>
                    <div class="end w340">
                        <span class="text">结束日期</span>
                        <input type="hidden" id="endDateHidden"/>
                        <input type="text" id="courseEndTime" name="courseEndTime" value="" readonly/>
                        <span class="week" id="endWeek"></span>
                        <i class="data-btn end-btn"></i>
                    </div>
                    <span class="txt des">具体描述</span>
                    <input type="text" maxlength="100" class="input-text w210" value="" id="trainTime" name="trainTime"  placeholder="例如：每周三上午8:00-11:30" />
                </td>
            </tr>
	    <tr>
			<td width="100" class="td-title">师资简介：</td>
			<td class="td-input" id="teacherIntroLabel">
			    <!--  
				<input id="teacherIntro" name="teacherIntro" type="text" class="input-text w510" />-->
						<textarea id="teacherIntro" name="teacherIntro"   class="input-text w510" style="height:100px"></textarea>
				<span class="error-msg"></span>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title">内容简介：</td>
			<input type="hidden" id="courseDescription" value="" />
			<td class="td-content" id="courseDescriptionLabel">
				<div class="editor-box">
					<textarea name="venueMemo" id="venueMemo"></textarea>
				</div>
			</td>
		</tr>
		<tr>
			<td width="100" class="td-title"></td>
			<td class="td-btn">

				<input class="btn-save" type="button" onClick="javascript:history.go(-1)" value="取消"/>

				<input class="btn-publish" type="button" value="申报课程"/>
			</td>
		</tr>
	</table>
</div>
</form>

</body>
</html>