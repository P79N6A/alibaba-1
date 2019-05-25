<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>活动发布--文化云</title>

    <%@include file="../../common/pageFrame.jsp" %>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>

    <script type="text/javascript">
        //<![CDATA[
        window.onload = function () {
            var editor = CKEDITOR.replace('templateDesc');
        }
        function GetContents() {
            var oEditor = CKEDITOR.instances.templateDesc;
            dialogAlert("提示", oEditor.getData());
        }

        function GetText() {
            var oEditor = CKEDITOR.instances.templateDesc;
            dialogAlert("提示", oEditor.document.getBody().getText());
        }
        //]]>
    </script>
    <!--文本编辑框 end-->
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆列表 &gt; ${cmsVenue.venueName} &gt; 添加座位模板
</div>
<div class="site-title">添加票务模板</div>
<div class="main-publish">
    <style type="text/css">
        /*		.seatCharts-cell{}
                .seatCharts-row{}
                .seatCharts-row .seatCharts-cell:first-child{ margin-right: 7px;}
                .seatCharts-container{ overflow: hidden;}
                .seatCharts-seat.available{ background-color: #FFB973;}
                .seatCharts-seat.deleted{ background-color: #FF4D4D;}
                .seatCharts-seat.unavailable{ cursor: pointer;}*/
        .seatCharts-cell {
        }

        .seatCharts-row {
        }

        .seatCharts-row .seatCharts-cell:first-child {
            margin-right: 7px;
        }

        /*.seatCharts-container{ overflow: hidden; height: 300px; overflow: auto;}*/
        .seatCharts-seat.available {
            background-color: #FFB973;
        }

        .seatCharts-seat.deleted {
            background-color: #FF4D4D;
        }

        .seatCharts-seat.unavailable {
            background-color: #999999;
            cursor: pointer;
        }

        .seatCharts-seat .editTit {
            display: block;
            height: 26px;
            line-height: 26px;
            width: 28px;
            padding: 0;
            margin: 0;
            *margin-left: -7px;
            font-size: 12px;
            border: 1px #7EC4CC solid;
            text-align: center;
            vertical-align: top;
        }

        #map-tip {
            display: block;
            height: 20px;
            line-height: 20px;
            padding: 5px;
            position: absolute;
            color: #ff0000;
            font-size: 12px;
            background: #FFFFFF;
            border: solid 1px #cccccc;
        }

        .td-seat .front {
            width: auto;
        }

        .seatCharts-seat.selected {
            background-color: #67AF22;
        }
    </style>

    <form id="venueSeatTemplateForm" method="post">
        <input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
        <input type="hidden" id="seatIds" name="seatIds"/>
        <input type="hidden" id="validCount" name="validCount"/>
        <table width="100%" class="form-table">
            <tr>
                <td width="100" class="td-title">
                    <span class="red">*</span>模板名称：
                </td>
                <td class="td-input" id="templateNameLabel">
                    <input type="text" class="input-text w510" maxlength="255" id="templateName" name="templateName"/>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">模板简介：</td>
                <td class="td-content" id="templateDescLabel">
                    <div class="editor-box">
                        <textarea id="templateDesc" name="templateDesc"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"><span class="red">*</span>座位行和列：</td>
                <td class="td-input td-coordinate" id="seatLabel">
                    <input type="text" class="input-text w120" id="seat-row" name="seatRow"/><span class="txt">行</span>
                    <input type="text" class="input-text w120" id="seat-cell" name="seatColumn"/><span
                        class="txt">列</span>
                    <a id="build-seat" class="upload-btn">生成座位表</a><!--<span class="error-msg">请输入坐标</span>-->
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">颜色描述：</td>
                <td class="td-seat bt-line">
                    <div class="legend-box">
                        <ul>
                            <li>
                                <div class="seatCharts-seat seatCharts-cell deleted"></div>
                                <span>删除</span></li>
                            <li>
                                <div class="seatCharts-seat seatCharts-cell unavailable"></div>
                                <span>占用</span></li>
                            <li>
                                <div class="seatCharts-seat seatCharts-cell available"></div>
                                <span>可选</span></li>
                            <li>
                                <div class="seatCharts-seat seatCharts-cell selected"></div>
                                <span>已选</span></li>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">操作：</td>
                <td class="td-seat bt-line">
                    <div class="legend-box">
                        <a class="btn-seat seat-deleted" id="deleted">删除</a>
                        <a class="btn-seat seat-unavailable" id="unavailable">已占用</a>
                        <a class="btn-seat seat-available" id="available">恢复可用</a>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title">座位表：</td>
                <td class="td-seat">
                    <div id="seat-map">

                    </div>
                </td>
            </tr>
            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <input class="btn-publish btn-save" type="button" value="生成模板" id="generateTemplate"/>
                </td>
            </tr>
        </table>
    </form>

    <script type="text/javascript">
        var classDefault = "seatCharts-seat seatCharts-cell ";
        $(document).ready(function () {
            $("#build-seat").on("click", function () {
                var seatRow = Number($("#seat-row").val());   //座位行
                var seatCell = Number($("#seat-cell").val());  //座位列
                /*var seatRow = Number(seatRow);
                 var seatCell = Number(seatCell);*/
                if (seatRow == null || seatRow == "" || isNaN(seatRow) || seatRow <= 0) {
                    dialogAlert("提示", "请输入正确的座位行");
                    return false;
                } else if (seatCell == null || seatCell == "" || isNaN(seatCell) || seatCell <= 0) {
                    dialogAlert("提示", "请输入正确的座位列");
                    return false;
                } else {
                    buildSeat("seat-map", seatRow, seatCell);
                }
            });

            $("#deleted").on("click", function () {
                $(".seatCharts-container .selected").attr({
                    "class": classDefault + "deleted",
                    "data-status": "deleted"
                });
                /**2015 11 9 取消全选状态*/
                checkall()
            })
            $("#unavailable").on("click", function () {
                $(".seatCharts-container .selected").attr({
                    "class": classDefault + "unavailable",
                    "data-status": "unavailable"
                });
                /**2015 11 9 取消全选状态*/
                checkall()
            })
            $("#available").on("click", function () {
                $(".seatCharts-container .selected").attr({
                    "class": classDefault + "available",
                    "data-status": "available"
                });
                /**2015 11 9 取消全选状态*/
                checkall()
            })

            $("#generateTemplate").on("click", function () {

                var result = checkData();
                if (result) {
                    //点击后onclick时间失效
                    $("#generateTemplate").unbind("click");

                    var dataStr = getSeatData();
                    var validCount = getValidCount();

                    $("#seatIds").val(dataStr);
                    $("#validCount").val(validCount);

                    //富文本
                    $('#templateDesc').val(CKEDITOR.instances.templateDesc.getData());

                    //表单提交
                    $.post("${path}/venueSeatTemplate/addVenueSeatTemplate.do", $("#venueSeatTemplateForm").serialize(),
                            function (data) {
                                var html = "";
                                if (data == "success") {
                                    html = "<h2>保存成功!</h2>";
                                    dialogSaveDraft("提示", html, function () {
                                        window.location.href = "${path}/venueSeatTemplate/venueSeatTemplateIndex.do?venueId=" + $("#venueId").val();
                                    })
                                } else {
                                    html = "<h2>保存失败!</h2>";
                                    dialogSaveDraft("提示", html, function () {
                                        window.location.href = "${path}/venueSeatTemplate/venueSeatTemplateIndex.do?venueId=" + $("#venueId").val();
                                    })
                                }
                            });
                }
            });
        });
        //生成座位表方法
        function buildSeat(container, row, cell) {
            $("#seat-map").html('<div class="front">中心舞台</div><div class="seatCharts-container"></div>');
            var seatContainer = $("#seat-map .seatCharts-container");
            var boxWidth = Math.min(44 * cell + 64, $("#seat-map").width());
            seatContainer.css({"width": boxWidth, "overflow": "auto"});
            $(".td-seat .front").css("width", boxWidth);
            var cellWidth = 30;
            var cellMargin = parseInt(Math.max(boxWidth / (cell + 2) * 0.1, 1));
            var cellMarginStr = "6px " + cellMargin + "px";
            var oRowWidth = (cellWidth + cellMargin * 2) * (cell + 1) + (50 + cellMargin * 2);
            for (var i = 1; i < row + 1; i++) {


                if (i == 1) {
                    var oRowTitleBox = $("<div></div>").addClass("seatCharts-row").css({"width": oRowWidth}).appendTo(seatContainer);
                    var oColumnSpace = $('<div></div>').addClass("seatCharts-cell seatCharts-space").css({
                        "width": 50,
                        "margin": cellMarginStr
                    }).appendTo(oRowTitleBox);
                    for (var j = 1; j < cell + 1; j++) {
                        var oRowTitle = $("<div></div>").addClass("seatCharts-cell seatCharts-space").css({
                            "width": cellWidth,
                            "margin": cellMarginStr
                        }).text(j).appendTo(oRowTitleBox);
                    }
                    var oRowTitle = $("<div></div>").addClass("seatCharts-cell seatCharts-space").css({
                        "width": cellWidth,
                        "margin": cellMarginStr
                    }).text('全选').appendTo(oRowTitleBox);
                }
                var oRow = $('<div></div>').css({"width": oRowWidth}).addClass('seatCharts-row').appendTo(seatContainer);


                for (var j = 1; j < cell + 1; j++) {
                    var oCellTitle = "";
                    if (j == 1) {
                        /*行号*/
                        oCellTitle = $('<div></div>').addClass("seatCharts-cell seatCharts-space").css({
                            "width": 50,
                            "margin": cellMarginStr
                        }).text("第" + i + "排").appendTo(oRow);
                    }
                    /*座位号*/
                    var oCell = $('<div></div>').addClass(classDefault + "available").attr({
                        "id": i + "_" + j,
                        "data-status": "available",
                        "title": j
                    }).css({"width": cellWidth, "margin": cellMarginStr}).text(j).appendTo(oRow);
                    oCell.on({
                        "click": function () {
                            if ($(this).hasClass("selected")) {
                                $(this).attr("class", classDefault + $(this).attr("data-status"));
                            } else {
                                $(this).attr("class", classDefault + "selected");
                            }
                        },
                        "dblclick": function () { /*双击编辑事件*/
                            var $this = $(this);
                            $this.html("<input type='text' class='editTit' value='" + $this.text() + "'/>");
                            var inputObj = $this.find("input");
                            var inputTxt;
                            var tools = _tools;
                            tools.inputFocus(inputObj);

                            inputObj.bind('blur', function (event) {
                                inputTxt = inputObj.val();
                                if (tools.validateFun(inputObj)) {
                                    $this.empty();
                                    inputObj.unbind();
                                    $this.attr({"title": inputTxt}).text(inputTxt);
                                }
                            }).bind('keydown', function (event) {
                                event = event || window.event;
                                if (event.keyCode == "13") {
                                    inputTxt = inputObj.val();
                                    if (tools.validateFun(inputObj)) {
                                        $this.empty();
                                        inputObj.unbind();
                                        $this.attr({"title": inputTxt}).text(inputTxt);
                                    }
                                } else if (event.keyCode == "27") {
                                    inputTxt = $this.attr("title");
                                    $this.empty();
                                    inputObj.unbind();
                                    $this.text(inputTxt);
                                } else {
                                    $("#map-tip").remove();
                                    inputObj.css("border", "solid 1px #7EC4CC");
                                }
                            }).bind('click', function (event) {
                                return false;
                            }).bind('dblclick', function (event) {
                                return false;
                            });
                        }
                    });
                }
                oColumnselect = $("<div>").addClass("seated").css({
                    "width": "30px",
                    "margin": cellMarginStr,
                    "float": "left",
                    "height": "28px",
                    "line-height": "28px",
                    "background": "#FFB973",
                    "color": "#ffffff",
                    "text-align": "center"
                }).html("<span>全选</span>").appendTo(oRow);
                var init_class = "seatCharts-cell seatCharts-space ";
                oColumnselect.on({
                    "click": function () {
                        var seat = $(this).siblings(".seatCharts-seat");
                        var len = seat.length;

                        if (seat.hasClass("selected")) {

                            //$(this).siblings(".seatCharts-seat").attr("class", classDefault + $(this).siblings(".seatCharts-seat").attr("data-status"));
                            seat.each(function () {
                                $(this).attr("class", classDefault + $(this).attr("data-status"));

                            })
                            $(this).css("background", "#FFB973")

                        }
                        else if (seat.hasClass("disabled")) {
                            seat.each(function () {
                                if ($(this).hasClass("disabled")) {

                                }
                                else {
                                    $(this).attr("class", classDefault + "selected");
                                }


                            })
                        }

                        else {
                            seat.attr("class", classDefault + "selected");
                            $(this).css("background", "#67AF22")

                        }
                    }
                })
            }
        }
        /**2015 11 9 取消全选状态*/
        function checkall() {
            $(".seated").each(function () {
                $(this).css("background", "#FFB973")
            })
        }
        function checkData() {
            var templateName = $("#templateName").val();
            var seatRow = $("#seat-row").val();
            var seatCell = $("#seat-cell").val();

            if (templateName.trim() == "") {
                removeMsg("templateNameLabel");
                appendMsg("templateNameLabel", "请填写模板名称!");
                $('#templateName').focus();
                return false;
            } else {
                removeMsg("templateNameLabel");
            }

            if (seatRow.trim() == "") {
                removeMsg("seatLabel");
                appendMsg("seatLabel", "请填写座位行数!");
                $('#seatRow').focus();
                return false;
            } else {
                removeMsg("seatLabel");
            }

            if (seatCell.trim() == "") {
                removeMsg("seatLabel");
                appendMsg("seatLabel", "请填写座位列数!");
                $('#seatCell').focus();
                return false;
            } else {
                removeMsg("seatLabel");
            }

            var dataStr = getSeatData();
            if (dataStr.trim() == "") {
                dialogAlert("提示", "请点击 生成座位表 按钮!");
                return false;
            }
            return true;
        }


        //获取座位数据
        function getSeatData() {
            var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
            var seatArr = [];
            allCell.each(function () {
                var that = $(this);
                var cellStatus = that.attr("data-status").substr(0, 1).toLocaleUpperCase();
                var cellId = that.attr("id");
                var cellTit = that.attr("title");
                seatArr.push(cellStatus + "-" + cellId + "-" + cellTit);
            });
            var dataStr = seatArr.join(",");
            return dataStr;
        }
        var _tools = {
            inputFocus: function (inputObj) {
                inputObj.focus();
                inputObj.select();
            },
            validateFun: function (inputObj) {
                var siteMap = $("#seat-map");
                var inputTxt = inputObj.val();
                if (this.setTipText(inputTxt) == "" || this.setTipText(inputTxt) == null) {
                    $("#map-tip").remove();
                    return true;
                } else {
                    inputObj.css("border", "solid 1px #ff0000");
                    var posTop = inputObj.position().top;
                    var posLeft = inputObj.position().left;
                    $("#map-tip").remove();
                    var oTip = $("<span id='map-tip'></span>").css({"top": posTop - 40}).animate({"top": posTop - 34});
                    oTip.text(this.setTipText(inputTxt)).appendTo(siteMap);
                    oTip.css("left", (posLeft - (oTip.width() - 30) / 2));
                    this.setCursorPosition(inputObj, inputTxt.length);
                }
            },
            setTipText: function (inputTxt) {
                if (inputTxt == null || inputTxt == "") {
                    return "请输入座位号";
                } else if (isNaN(Number(inputTxt))) {
                    return "请输入正确的座位号";
                } else if (Number(inputTxt) > 999) {
                    return "座位号最大为三位数";
                } else {
                    return "";
                }
            },
            setCursorPosition: function (obj, pos) {
                if (obj.setSelectionRange) {
                    obj.focus();
                    obj.setSelectionRange(pos, pos);
                } else if (obj.createTextRange) {
                    var range = obj.createTextRange();
                    range.collapse(true);
                    range.moveEnd('character', pos);
                    range.moveStart('character', pos);
                    range.select();
                }
            }
        };

        //获取有效座位数量
        function getValidCount() {
            var allCell = $("#seat-map .seatCharts-container .seatCharts-seat");
            var validCount = 0;
            allCell.each(function () {
                var that = $(this);
                var cellStatus = that.attr("data-status");
                if (cellStatus == "available") {
                    validCount++;
                }
            });
            return validCount;
        }
    </script>

</div>

</body>
</html>