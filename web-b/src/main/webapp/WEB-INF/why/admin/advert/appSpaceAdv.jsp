<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%@include file="../../common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <style>
        .A1-edit {
            position: relative;
            height: 166px;
            border: solid 1px #ACB4C3;
            border-radius: 4px;
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
        }

        .A1-p {
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
            margin: auto;
            width: 50px;
            height: 50px;
            text-align: center;
        }

        .A1-p>p {
            line-height: 25px;
        }

        .A1-img {
            position: absolute;
            right: 10px;
            bottom: 10px;
            width: 100px;
            height: 25px;
            text-align: center;
        }

        .A1-img>p {
            line-height: 25px;
        }

        .B-edit {
            border: 1px solid #ACB4C3;
        }

        .B-edit>ul>li {
            width: 25%;
            height: 148px;
            float: left;
            text-align: center;
        }

        .A2-edit {
            line-height: normal;
            position: relative;
            border: 1px solid #ACB4C3;
        }

        .A3-edit {
            width: 123px;
            height: 150px;
            position: relative;
            text-align: center;
            border: 1px solid #ACB4C3;
        }

        .A4-edit {
            width: 250px;
            height: 106px;
            position: relative;
            text-align: center;
            border: 1px solid #ACB4C3;
        }

        .C-edit {
            border: 1px solid #ACB4C3;
            width: 123px;
            height: 125px;
            margin: auto;
        }

        .cbn>td {
            padding: 0;
        }

        .part2-table>tbody>tr>th {
            line-height: 30px;
        }

        .part2-table>tbody>tr>td {
            word-break : break-all;
            word-wrap : break-word;
            text-align: center;
            line-height: 20px;
            border: 1px solid #ACB4C3;
        }

        .D1-in {
            vertical-align: top;
            text-align: center;
        }

        .D1-in>input {
            width: 30px;
            height: 30px;
            text-align: center;
            font-size: 20px;
        }

        .D1-in>button {
            display: block;
            margin: 100px auto 0px;
        }

        .D1add-btn {
            font-size: 50px;
            color: red;
        }

        .edit-btn {
            cursor: pointer;
            width: 100%;
            height: 100%;
            position: relative;
        }

        .edit-btn img {
            width: 100%;
            height: 100%;
        }

        .space-manage>li {
            float: left;
            width: 20%;
            position: relative;
        }

        .space-manage>li>p {
            white-space : nowrap;
            text-overflow : ellipsis;
            -o-text-overflow : ellipsis;
            overflow : hidden;
            cursor: pointer;
            text-align: center;
            border: 1px solid #ACB4C3;
        }

        .remove-btn {
            position: absolute;
            right: 0px;
            top: 0px;
            height: 20px;
            width: 20px;
        }

        .remove-btn img {
            display: block;
            width: 100%;
            height: 100%;
        }
        .ui-popup{
            width: 910px;
            height:713px;
            top: 0!important;
            bottom:0!important;
            right:0!important;
            left:0!important;
            margin:auto!important;
        }
    </style>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {
                    log: function () {

                    }
                };
        function advEdit(ID, size) {
            dialog({
                url: '${path}/ccpAdvert/addAppAdvertIndex.do?advertId=' + ID + '&imgSize=' + size,
                title: '添加app运营位',
                width: 850,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        }
        function deleEdit(ID) {
            $.post("../ccpAdvert/delAdvert.do", {advertId: ID},
                    function (data) {
                        switch (data) {
                            case("success"):
                                dialogAlert("系统提示", "操作成功", function () {
                                    window.location.href = "../ccpAdvert/appSpaceAdvertIndex.do";
                                    dialog.close().remove();
                                });
                                break;
                            case("noLogin"):
                                dialogAlert("系统提示", "请登陆后再进行操作", function () {
                                    window.location.href = "../admin.do";
                                    dialog.close().remove();
                                });
                                break;
                            case("failure"):
                                dialogAlert("系统提示", "服务器异常", function () {
                                    window.location.href = "../ccpAdvert/appSpaceAdvertIndex.do";
                                    dialog.close().remove();
                                });
                                break;
                            default:
                                dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                                    window.location.href = "../ccpAdvert/appSpaceAdvertIndex.do";
                                    dialog.close().remove();
                                });
                                break
                        }
                    });
        }
        $(function () {
            $("#dataList img").each(function () {
                if ($(this).attr("imgVal")) {
                    $(this).attr("src", getImgUrl(getIndexImgUrl($(this).attr("imgVal"), $(this).attr("imgSize"))));

                }
            });
        });
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>推荐管理 &gt; App端推荐 &gt; 空间广告位管理
</div>
<div class="site-title">活动发布</div>
<div class="main-publish" id="dataList">
    <table width="500" class="form-table" style="float: left;">
        <tbody>
        <tr>
            <td colspan="4">
                <ul class="space-manage">

                    <c:forEach var="i" begin="1" end="10">
                        <%boolean flag = false;%>
                        <c:forEach items="${listB}" var="advert">
                            <c:if test="${advert.advertSort eq i}">
                                <li>
                                    <p onclick="advEdit('3_B_${i}','_0_0')">B${i}:${advert.advertTitle}</p>
                                    <div class="remove-btn" onclick="deleEdit('3_B_${i}');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png" />
                                    </div>
                                </li>
                                <%flag = true;%>
                            </c:if>
                        </c:forEach>
                        <%if (!flag) {%>
                        <li>
                            <p onclick="advEdit('3_B_${i}','_0_0')">B${i}</p>
                        </li>
                        <%}%>
                    </c:forEach>
                </ul>
            </td>
        </tr>
        <tr>
            <c:forEach var="i" begin="1" end="1">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq 1}">
                        <td colspan="4">
                            <div class="A1-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('3_A_1');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <img onclick="advEdit('3_A_1','_750_250')" src="" width="498" height="200"
                                         imgVal="${advert.advertImgUrl}" imgSize="_750_250"/>
                                    <div class="A1-p">
                                        <p>A1</p>
                                        <p>编辑</p>
                                    </div>
                                    <div class="A1-img">
                                        <p>750*250</p>
                                    </div>
                                </div>
                            </div>
                        </td>
                        <%flag = true;%>
                    </c:if>
                </c:forEach>
                <%if (!flag) {%>
                <td colspan="4">
                    <div class="A1-edit">
                        <div class="edit-btn">
                            <img onclick="advEdit('3_A_1','_750_250')" src="" width="498" height="200"
                                 imgVal="" imgSize="_750_250"/>
                            <div class="A1-p">
                                <p>A1</p>
                                <p>编辑</p>
                            </div>
                            <div class="A1-img">
                                <p>750*250</p>
                            </div>
                        </div>
                    </div>
                </td>
                <%}%>
            </c:forEach>
        </tr>
        <tr>
            <c:forEach var="i" begin="2" end="3">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq i}">
                        <td colspan="2">
                            <div class="A4-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('3_A_${i}');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <a onclick="advEdit('3_A_${i}','_750_310')">
                                        <img src="" imgVal="${advert.advertImgUrl}"
                                             imgSize="_750_310"/>
                                        <div class="A1-p">
                                            <p>A${i}</p>
                                            <p>编辑</p>
                                        </div>
                                        <div class="A1-img">
                                            <p>750*310</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </td>
                        <%flag = true;%>
                    </c:if>
                </c:forEach>
                <%if (!flag) {%>
                <td height="100">
                    <div class="A4-edit">
                        <div class="edit-btn" onclick="">
                            <a onclick="advEdit('3_A_${i}','_750_310')">
                            <img src="" width="100%" height="100%" />
                            <div class="A1-p">
                                <p>A${i}</p>
                                <p>编辑</p>
                            </div>
                            <div class="A1-img">
                                <p>750*310</p>
                            </div>
                            </a>
                        </div>
                    </div>
                </td>
                <%}%>
            </c:forEach>
        </tr>
        </tbody>
    </table>
    <table  class="form-table part2-table" style="float: left;margin-left: 100px;margin-top: 50px;width: 500px;">
        <tbody width="500">
        <tr>
            <th colspan="2" style="text-align: left;">运营位链接列表：</th>
        </tr>
        <tr>
            <td width="100">运营位置</td>
            <td width="300">链接/ID/关键字</td>
        </tr>
        <c:forEach items="${listA}" var="advert">
            <tr>
                <td width="100">A${advert.advertSort}</td>
                <td width="300">${advert.advertUrl}</td>
            </tr>
        </c:forEach>
        <c:forEach items="${listB}" var="advert">
            <tr>
                <td width="100">B${advert.advertSort}</td>
                <td width="300">${advert.advertUrl}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div style="clear: both;"></div>
</div>
</body>
</html>
