<%--
  Created by IntelliJ IDEA.
  User: sundai
  Date: 2016/8/5
  Time: 10:21
  To change this template use File | Settings | File Templates.
--%>
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

        .A1-p > p {
            line-height: 15px;
        }

        .A1-img {
            position: absolute;
            right: 10px;
            bottom: 10px;
            width: 100px;
            height: 25px;
            text-align: center;
        }

        .A1-img > p {
            line-height: 25px;
        }

        .B-edit {
            border: 1px solid #ACB4C3;
        }

        .B-edit > ul > li {
            width: 25%;
            height: 106px;
            float: left;
            text-align: center;
        }

        .A2-edit {
            height: 147px;
            line-height: normal;
            position: relative;
            border: 1px solid #ACB4C3;
        }

        .A3-edit {
            width: 123px;
            height: 148px;
            position: relative;
            text-align: center;
            border: 1px solid #ACB4C3;
        }

        .C-edit {
            border: 1px solid #ACB4C3;
            width: 123px;
            height: 78px;
            margin: auto;
        }

        .cbn > td {
            padding: 0;
        }

        .part2-table > tbody > tr > th {
            line-height: 30px;
        }

        .part2-table > tbody > tr > td {
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

        .D1-in > input {
            width: 30px;
            height: 30px;
            text-align: center;
            font-size: 20px;
        }

        .D1-in > button {
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
                                    window.location.href = "../ccpAdvert/appFrontAdvertIndex.do";
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
                                    window.location.href = "../ccpAdvert/appFrontAdvertIndex.do";
                                    dialog.close().remove();
                                });
                                break;
                            default:
                                dialogAlert("系统提示", "保存发生错误，请查看数据是否完整", function () {
                                    window.location.href = "../ccpAdvert/appFrontAdvertIndex.do";
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
    <em>您现在所在的位置：</em>推荐管理 &gt; App端推荐 &gt; 首页广告位管理
</div>
<div class="site-title">活动发布</div>
<div class="main-publish" id="dataList">
    <table width="500" class="form-table" style="float: left;">
        <tbody>
        <tr>
            <c:forEach var="i" begin="1" end="1">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq 1 }">
                        <td colspan="4">
                            <div class="A1-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_1');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <img onclick="advEdit('2_A_1','_750_250')" src=""
                                         imgVal="${advert.advertImgUrl}" imgSize="_750_250"/>
                                    <div class="A1-p">
                                        <p>A1.1</p>
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
                            <img onclick="advEdit('2_A_1','_750_250')" src=""
                                 imgVal="" imgSize="_750_250"/>
                            <div class="A1-p">
                                <p>A1.1</p>
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
            <c:forEach var="i" begin="1" end="1">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq 8 }">
                        <td colspan="4">
                            <div class="A1-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_8');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <img onclick="advEdit('2_A_8','_750_250')" src=""
                                         imgVal="${advert.advertImgUrl}" imgSize="_750_250"/>
                                    <div class="A1-p">
                                        <p>A1.2</p>
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
                            <img onclick="advEdit('2_A_8','_750_250')" src=""
                                 imgVal="" imgSize="_750_250"/>
                            <div class="A1-p">
                                <p>A1.2</p>
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
            <c:forEach var="i" begin="1" end="1">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq 9 }">
                        <td colspan="4">
                            <div class="A1-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_9');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <img onclick="advEdit('2_A_9','_750_250')" src=""
                                         imgVal="${advert.advertImgUrl}" imgSize="_750_250"/>
                                    <div class="A1-p">
                                        <p>A1.3</p>
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
                            <img onclick="advEdit('2_A_9','_750_250')" src=""
                                 imgVal="" imgSize="_750_250"/>
                            <div class="A1-p">
                                <p>A1.3</p>
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
            <c:forEach var="i" begin="1" end="1">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq 10 }">
                        <td colspan="4">
                            <div class="A1-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_10');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <img onclick="advEdit('2_A_10','_750_250')" src=""
                                         imgVal="${advert.advertImgUrl}" imgSize="_750_250"/>
                                    <div class="A1-p">
                                        <p>A1.4</p>
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
                            <img onclick="advEdit('2_A_10','_750_250')" src=""
                                 imgVal="" imgSize="_750_250"/>
                            <div class="A1-p">
                                <p>A1.4</p>
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
            <td colspan="4">
                <div class="B-edit">
                    <ul>
                        <c:if test="${empty listB}">
                            <c:forEach var="i" begin="1" end="12">
                                <li>
                                    <div class="edit-btn">
                                        <a onclick="advEdit('2_B_${i}','_120_120')">
                                            <img src="" imgVal=""
                                                 imgSize="_120_120"/>
                                            <div class="A1-p">
                                                <p>B${i}</p>
                                                <p>编辑</p>
                                            </div>
                                            <div class="A1-img">
                                                <p>120*120</p>
                                            </div>
                                        </a>
                                    </div>
                                </li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty listB}">
                            <c:forEach var="i" begin="1" end="12">
                                <%boolean flag = false;%>
                                <c:forEach items="${listB}" var="advert">
                                    <c:if test="${advert.advertSort eq i}">
                                        <li>
                                            <div class="edit-btn">
                                                <div class="remove-btn" onclick="deleEdit('2_B_${i}');">
                                                    <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                                </div>
                                                <a onclick="advEdit('2_B_${i}','_120_120')">
                                                    <img src="" imgVal="${advert.advertImgUrl}"
                                                         imgSize="_120_120"/>
                                                    <div class="A1-p">
                                                        <p>B${i}</p>
                                                        <p>编辑</p>
                                                    </div>
                                                    <div class="A1-img">
                                                        <p>120*120</p>
                                                    </div>
                                                </a>
                                            </div>
                                        </li>
                                        <%flag = true;%>
                                    </c:if>
                                </c:forEach>
                                <%if (!flag) {%>
                                <li>
                                    <div class="edit-btn">
                                        <a onclick="advEdit('2_B_${i}','_120_120')">
                                            <img src="" imgVal=""
                                                 imgSize="_120_120"/>
                                            <div class="A1-p">
                                                <p>B${i}</p>
                                                <p>编辑</p>
                                            </div>
                                            <div class="A1-img">
                                                <p>120*120</p>
                                            </div>
                                        </a>
                                    </div>
                                </li>
                                <%}%>
                            </c:forEach>
                        </c:if>
                        <div style="clear: both;"></div>
                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <c:forEach var="i" begin="2" end="4">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq i}">
                        <td colspan="1">
                            <div class="A2-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_${i}');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <a onclick="advEdit('2_A_${i}','_249_215')">
                                        <img src="" imgVal="${advert.advertImgUrl}"
                                             imgSize="_249_215"/>
                                        <div class="A1-p">
                                            <p>A${i}</p>
                                            <p>编辑</p>
                                        </div>
                                        <div class="A1-img">
                                            <p>249*215</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </td>
                        <%flag = true;%>
                    </c:if>
                </c:forEach>
                <%if (!flag) {%>
                <td colspan="1">
                    <div class="A2-edit">
                        <div class="edit-btn">
                            <a onclick="advEdit('2_A_${i}','_250_200')">
                                <img src="" imgVal="${advert.advertImgUrl}"
                                     imgSize="_249_215"/>
                                <div class="A1-p">
                                    <p>A${i}</p>
                                    <p>编辑</p>
                                </div>
                                <div class="A1-img">
                                    <p>249*215</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </td>
                <%}%>
            </c:forEach>
        </tr>
        <tr>
            <c:forEach var="i" begin="5" end="6">
                <%boolean flag = false;%>
                <c:forEach items="${listA}" var="advert">
                    <c:if test="${advert.advertSort eq i}">
                        <td colspan="1">
                            <div class="A3-edit">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_A_${i}');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <a onclick="advEdit('2_A_${i}','_374_220')">
                                        <img src="" imgVal="${advert.advertImgUrl}"
                                             imgSize="_374_200"/>
                                        <div class="A1-p">
                                            <p>A${i}</p>
                                            <p>编辑</p>
                                        </div>
                                        <div class="A1-img">
                                            <p>374*220</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </td>
                        <%flag = true;%>
                    </c:if>
                </c:forEach>
                <%if (!flag) {%>
                <td colspan="1">
                    <div class="A3-edit">
                        <div class="edit-btn">
                            <a onclick="advEdit('2_A_${i}','_374_220')">
                                <img src="" imgVal="${advert.advertImgUrl}"
                                     imgSize="_375_220"/>
                                <div class="A1-p">
                                    <p>A${i}</p>
                                    <p>编辑</p>
                                </div>
                                <div class="A1-img">
                                    <p>374*220</p>
                                </div>
                            </a>
                        </div>
                    </div>
                </td>
                <%}%>
            </c:forEach>
        </tr>
        <tr class="cbn">
            <c:forEach var="i" begin="1" end="8">
                <c:if test="${i eq 5}">
        </tr>
        <tr class="cbn">
            </c:if>
            <%boolean flag = false;%>
            <c:forEach items="${listC}" var="advert">
                <c:if test="${advert.advertSort eq i}">
                    <td width="125">
                        <div class="C-edit">
                            <div class="edit-btn">
                                <div class="remove-btn" onclick="deleEdit('2_C_${i}');">
                                    <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                </div>
                                <a onclick="advEdit('2_C_${i}','_300_190')">
                                    <img src=""
                                         imgVal="${advert.advertImgUrl}"
                                         imgSize="_300_190"/>
                                    <div class="A1-p">
                                        <p>C${i}</p>
                                        <p>编辑</p>
                                    </div>
                                    <div class="A1-img">
                                        <p>300*190</p>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </td>
                    <%flag = true;%>
                </c:if>
            </c:forEach>
            <%if (!flag) {%>
            <td width="125">
                <div class="C-edit">
                    <div class="edit-btn">
                        <a onclick="advEdit('2_C_${i}','_300_190')">
                            <img src=""
                                 imgVal=""
                                 imgSize="_300_190"/>
                            <div class="A1-p">
                                <p>C${i}</p>
                                <p>编辑</p>
                            </div>
                            <div class="A1-img">
                                <p>300*190</p>
                            </div>
                        </a>
                    </div>
                </div>
            </td>
            <%}%>
            </c:forEach>
        </tr>
        <%boolean flag = false;%>
        <c:forEach var="i" begin="1" end="16">
            <%boolean flags = false;%>
            <c:forEach items="${listD}" var="advert">
                <c:if test="${advert.advertSort eq i}">
                    <tr>
                        <td colspan="4">
                            <div class="A1-edit" onclick="">
                                <div class="edit-btn">
                                    <div class="remove-btn" onclick="deleEdit('2_D_${i}');">
                                        <img src="${path}/STATIC/wechat/image/mobile_close.png"/>
                                    </div>
                                    <a onclick="advEdit('2_D_${i}','_750_250')">
                                        <img src="${advert.advertImgUrl}"imgVal="${advert.advertImgUrl}"
                                             imgSize="_750_250"/>
                                        <div class="A1-p">
                                            <p>D${i}
                                            </p>
                                            <p>编辑</p>
                                        </div>
                                        <div class="A1-img">
                                            <p>750*250</p>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <%flags = true;%>
                </c:if>
            </c:forEach>
            <%if (!flag) {%>
            <%if (!flags) {%>
            <tr>
                <td colspan="4">
                    <p style="font-size: 40px;color: red;cursor: pointer;" onclick="advEdit('2_D_${i}','_750_250')">
                        +<a style="font-size: 20px;">新增D类型广告位（每隔3场活动出现一次）</a>
                    </p>
                </td>
            </tr>
            <%flag = true;%>
            <%}%>
            <%}%>

        </c:forEach>


        </tbody>
    </table>
    <table class="form-table part2-table" style="float: left;margin-left: 100px;margin-top: 50px;width: 500px;">
        <tbody  width="500">
        <tr>
            <th colspan="2" style="text-align: left;">运营位链接列表：</th>
        </tr>
        <tr>
            <td width="100">运营位置123</td>
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
        <c:forEach items="${listC}" var="advert">
            <tr>
                <td width="100">C${advert.advertSort}</td>
                <td width="300">${advert.advertUrl}</td>
            </tr>
        </c:forEach>
        <c:forEach items="${listD}" var="advert">
            <tr>
                <td width="100">D${advert.advertSort}</td>
                <td width="300">${advert.advertUrl}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div style="clear: both;"></div>
</div>
</body>
</html>
