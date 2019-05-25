<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>个人中心-发起活动--文化云</title>

    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <link type="text/css" href="${path}/STATIC/css/select2.css" rel="stylesheet"/>
    <script type="text/javascript" src="${path}/STATIC/js/placeholder.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/ckeditor.js"></script>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>

    <!--搜索场馆三级联动 start-->
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/select2.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/select2_locale_zh-CN.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/index/userCenter/publicActivity.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
    $(function() {
        $('#publicActivityList').addClass('cur').siblings().removeClass('cur');
    });
</script>

    <script type="text/javascript">
        //富文本编辑器
        window.onload = function(){
            var editor = CKEDITOR.replace('activityMemo');
        };


        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });


        window.console = window.console || {log:function () {}}

        function uploadImage(){
            var Img=$("#uploadType").val();
            var userMobileNo="${sessionScope.terminalUser.userMobileNo}";
            $("#file").uploadify({
                'formData':{'uploadType':Img,'userMobileNo':userMobileNo},//传静态参数
                swf:'${path}/STATIC/js/uploadify.swf',
                uploader:'${path}/upload/frontUploadFile.do;jsessionid=111', //后台处理的请求
                buttonText:'上传图片',//上传按钮的文字
                'buttonClass':"upload-btn",//按钮的样式
                'fileSizeLimit':'2MB',
                queueSizeLimit:1, //   default 999
                'method': 'post',//和后台交互的方式：post/get
                queueID:'fileContainer',
                fileObjName:'file', //后台接受参数名称
                fileTypeExts:'*.*', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
                'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
                //'multi':true, //是否支持多个附近同时上传
                height:28,//选择文件按钮的高度
                width:98,//选择文件按钮的宽度
                'debug':false,//debug模式开/关，打开后会显示debug时的信息
                'dataType':'json',
                removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
                onUploadSuccess:function (file, data, response) {
                    var json = $.parseJSON(data);
                    var url=json.data;
                    var hiddenImgUrl = url;
                    //隐藏该区域
                    $(".uploadify-queue-item").hide();
                    //$("#fileContainer").hide();
                    var initWidth = parseInt(json.initWidth);
                    var initHeigth = parseInt(json.initHeigth);
                    if(initWidth<750 || initHeigth<500){
                        dialogAlert("提示","请上传尺寸不小于750*500(px)的图片",function(){
                        });
                        $("#isCutImg").val("N");
                        return;
                    }
                    //$("#isCutImg").val("N");
                    var url =getImgUrl(url);
                    $("#imgHeadPrev").attr("src",url);
                    var cutImageWidth=750;
                    var cutImageHeigth=500;
                    parent.dialog({
                        url: '${path}/att/toCutImgJsp.do',
                        data: {
                            imageUrl: url,
                            initWidth:initWidth,
                            initHeigth:initHeigth,
                            cutImageWidth:cutImageWidth,
                            cutImageHeigth:cutImageHeigth
                        },
                        title: '图片裁剪',
                        fixed: false,
                        onclose: function () {
                            if(this.returnValue){
                                var imgUrl = this.returnValue.imageUrl;
                                var isCutImg = this.returnValue.isCutImg;
                                setTimeout(function(){
                                    $("#imgHeadPrev").html(getImgHtml(imgUrl));
                                },0);
                                $("#isCutImg").val(isCutImg);
                                $("#activityIconUrl").val(hiddenImgUrl);
                            }
                        }
                    }).showModal();
                    return false;

                },
                onSelect:function () {
                },
                onCancel:function () {
                    //$('#btnContainer').hide();
                }
            });
        }

        function getImgHtml(imgUrl){
            if(imgUrl==""){
                return '<img src="../STATIC/image/defaultImg.png" />';
            }
            return '<img style="width:300px; height:200px;"  src="'+imgUrl+'" />';
        }



        function clearQueue() {
            $('#file').uploadify('cancel', '*');
            $('#btnContainer').hide();
            $("#activityIconUrl").val('');
            $("#imgHeadPrev").html("<img   src='../STATIC/image/defaultImg.png' id='userHeadImg'>");
        }

    </script>

<!-- dialog end -->
</head>
<body>

<%--引入个人中心头文件--%>
<%@include file="/WEB-INF/why/index/index_top.jsp"%>

<div id="register-content">
<div class="crumb"><i></i>您所在的位置： <a href="#">个人主页</a> &gt; 发起活动</div>
<div class="activity-content user-content clearfix">
    <%@include file="user_center_left.jsp"%>
<div class="user-right fr">
    <form action="" id="publicActivityForm" name="publicActivityForm" method="post">
        <input type="hidden" id="activityState" name="activityState" value="3"/>
        <input type="hidden" id="isCutImg" value="N"/>
    <div class="user-initiate">
        <h1>发起活动</h1>
        <div class="publish">
            <table width="100%" border="0">
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>活动名称</td>
                    <td class="td-input" id="activityNameLabel"><input type="text" name="activityName" id="activityName" placeholder="请输入活动名称" maxlength="20" class="input-text w330"/></td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>上传图片</td>
                    <td class="td-upload" id="activityIconUrlLabel">
                       <%-- <div class="img"><img src="" alt="" width="148" height="110"/></div>
                        <div class="btn">
                            <input type="button" value="选取图片" class="btn-upload"/>
                            <input type="button" value="截取上传" class="btn-upload"/>
                        </div>--%>
                       <input type="hidden" name="userId" value="${sessionScope.terminalUser.userId}"/>
                       <div class="img fl">
                           <input type="hidden"  name="activityIconUrl" id="activityIconUrl" value="">
                           <input type="hidden"  name="uploadType" value="Img" id="uploadType"/>
                           <span>
                                <img id="imgHeadPrev"  width="148" height="110">
    <%--                            <span id="fileContainer"></span>
                                <input type="file" name="file" id="file">--%>
                           </span>
                       </div>
                       <div class="btn controls-box" style="margin-top: 77px;">
                           <div class="controls">
                               <input type="file" name="file" id="file">
                           </div>
                           <%--<input type="button" class="btn-upload upload-cut-btn" id="" value="裁剪图片"/>--%>
                       </div>
                       <span class="tip"></span>
                       <div id="fileContainer"></div>
                       <div id="btnContainer" style="display: none;">
                           <a style="margin-left:335px;" href="javascript:clearQueue();" class="btn">取消</a>
                       </div>
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title">发布者</td>
                    <td class="td-upload">
                        ${sessionScope.terminalUser.userName}
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>所属区县</td>
                    <td class="td-select" id="loc_townLabel">
                        <script type="text/javascript">
                            /*传入默认值  start*/
                            $(function(){
                                //showLocation(44,45,48);
                                showLocation();
                                //$("#loc_province").select2("val", "44");
                                //$("#loc_city").select2("val", "45");
                                //$("#loc_town").select2("val", "48");
                            });
                            /*传入默认值  end*/
                        </script>
                        <select id="loc_province" style="width: 142px; margin-right: 10px;"></select>
                        <select id="loc_city" style="width: 142px; margin-right: 10px;"></select>
                        <select id="loc_town" style="width: 142px; margin-right: 10px;"></select>
                    </td>
                </tr>
                <input type="hidden" id="activityProvince" name="activityProvince" >
                <input  type="hidden"  id="activityCity" name="activityCity" >
                <input  type="hidden"  id="activityArea" name="activityArea" >
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>活动地址</td>
                    <td class="td-input" id="activityAddressLabel"><input type="text" name="activityAddress" id="activityAddress" placeholder="请输入活动地址" class="input-text w330"/></td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>地图坐标</td>
                    <td class="td-input td-coordinate" id="LonLabel">
                        <input type="text" name="activityLon" id="activityLon" class="input-text w130" placeholder="X"/><span class="txt">X</span>
                        <input type="text" name="activityLat" id="activityLat" class="input-text w130" placeholder="Y"/><span class="txt">Y</span>
                        <a id="getMapAddressPoint" class="btn-upload btn-query">查询坐标</a>
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>类型</td>
                    <input type="hidden" name="activityType" id="activityType" value=""/>
                    <td class="td-tag" id="activityTypeLabel">
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>活动日期</td>
                    <td class="td-time" id="activityStartTimeLabel">
                        <div class="start w172">
                            <input type="text"  id="activityStartTime" name="activityStartTime" placeholder="开始时间" readonly/>
                            <i class="data-btn start-btn"></i>
                        </div>
                        <span class="txt">至</span>
                        <div class="end w172">
                            <input type="text" id="activityEndTime"  name="activityEndTime" placeholder="结束时间" readonly/>
                            <i class="data-btn end-btn"></i>
                        </div>
                        <script type="text/javascript">
                            $(function(){
                                $(".start-btn").on("click", function(){
                                    WdatePicker({el:'activityStartTime',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'activityEndTime\')}',position:{left:-19,top:7},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
                                });
                                $(".end-btn").on("click", function(){
                                    WdatePicker({el:'activityEndTime',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'activityStartTime\')}',position:{left:-19,top:7},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
                                })
                            });
                        </script>
                    </td>
                </tr>
                <input type="hidden" name="eventStartTimes" value="" id="eventStartTimes" />
                <input type="hidden" name="eventEndTimes" value="" id="eventEndTimes" />
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>活动时间</td>
                    <td class="td-input">
                        <div id="free-time-set">
                            <div id="put-ticket-list" >
                                <div class="ticket-item" id="activityTimeLabel1">
                                    <input type="text" data-type="hour" id="startHourTime1" name="eventStartHourTime" class="input-text" maxlength="2" value="00"/><em>:</em>
                                    <input type="text" data-type="minute" id="startMinute1" name="eventStartMinuteTime" class="input-text" maxlength="2" value="00"/><span class="zhi">至</span>
                                    <input type="text" data-type="hour" id="endHourTime1" name="eventEndHourTime" class="input-text" maxlength="2" value="00"/><em>:</em>
                                    <input type="text" data-type="minute" id="endMinute1" name="eventEndMinuteTime" class="input-text" maxlength="2" value="00"/>
                                    <a href="javascript:void(0)" class="timeico add-btn"></a>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>电话</td>
                    <td class="td-input" id="activityTelLabel"><input type="text" id="activityTel" name="activityTel" placeholder="请输入电话" class="input-text w330"/></td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>入场方式</td>
                    <td class="td-input td-way">
                        <label><input type="radio" onclick="showCount(1)" checked  name="activityIsReservation" value="1"/><em>不可预订</em></label>
                        <label><input type="radio" onclick="showCount(2)" name="activityIsReservation" value="2"/><em>自由入座</em></label>
                        <div class="extra" style="display: none" id="showCount">
                            <em>每场售票数</em>
                            <input onblur="getTotalTicketCount();" type="text" id="eventCount" name="eventCount" class="input-text w120" onkeyup="this.value=this.value.replace(/\D/g,'')"/>
                            <em>张</em>&nbsp;<span id="totalEventCount"></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"><span class="red">*</span>活动描述</td>
                    <td class="td-content" id="activityMemoLabel">
                        <div class="editor-box">
                            <textarea  name="activityMemo" id="activityMemo"></textarea>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="130" class="td-title"></td>
                    <td class="td-btn td-center">
                        <input class="btn-default btn-save" type="button" value="提交" onclick="savePublicActivity(3)"/>
                        <input class="btn-default btn-publish" type="button" value="保存草稿箱" onclick="savePublicActivity(8)" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
 </form>
</div>
</div>
<!-- 导入foot文件 start -->
<%@include file="../index_foot.jsp"%>

</body>
</html>