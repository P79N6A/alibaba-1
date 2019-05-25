<%@ page import="org.apache.commons.lang.StringUtils,com.sun3d.why.model.CmsTerminalUser" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String userId = "";
    if (session.getAttribute("terminalUser") != null) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        userId = terminalUser.getUserId();
        if (StringUtils.isNotBlank(terminalUser.getUserId())) {
            userId = terminalUser.getUserId();
        } else {
            userId = "";
        }
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp" %>
    <title>注册志愿者</title>
    <style>
        .formDiv{
            width:1200px;
            height:auto;
            margin:20px auto 30px;
            background-color:#fff;
            border:1px solid #eceff1;
        }
        #signInfo{
            width:100%;
            /*height:50px;*/
            border-bottom:1px solid #eceff1;
        }
        #signInfo .title{
           line-height:50px;
            margin-left:40px;
        }
        table{
            width:100%;
            padding:30px;

        }
        table tr{
            margin-bottom: 30px;
            height:65px;
        }
        table .td1{
            height:50px;
            font-size:15px;
            width:8%;
            text-align: right;
        }
        table .td2{
            height:50px;
            font-size:15px;
            width:92%;
        }
        table .td2 input {
            margin-left:20px;
            height:40px;
            width:250px;
        }
        table .td2 select{
            margin-left:20px;
            width:250px;
            height:40px;
        }
        table .td2 textarea{
            margin-left:20px;
            width:60%;
            height:200px;
        }
        #submitBtn{
            padding:10px 30px;
            text-align: center;
            margin-left:100px;
            font-size:15px;
            border-radius: 5%;
            background-color:#197bd9;
            color:#fff;
        }
        .avatarImg{
            width:200px;
            height:200px;
            display:none;
        }
        .avatarImg img{
            width:100%;
            height:100%;
            margin-bottom: 10px;
        }
    </style>
    <script>
        $(function(){
            $("#volunteerRecruitIndex").addClass('cur').siblings().removeClass('cur');
            //setScreen();
        });
        /*function setScreen(){
            var $content = $("#volun-content");
            if($content.length > 0) {
                $content.removeAttr("style");
                var contentH = $content.outerHeight();
                var otherH = $("#header").outerHeight() + $("#in-footer").outerHeight();
                var screenConH = $(window).height() - otherH;
                if (contentH < screenConH) {
                    $content.css({"height": screenConH});
                }
            }
        }*/
    </script>
</head>
<body>
    <div class="header">
        <%@include file="../header.jsp" %>
    </div>
    <div id="volun-content" class="formDiv" style="height:auto">
        <form id="signInfo">
            <input type="hidden" id="userId" name="userId" value="<%=userId%>">
            <div class="title">
                <h3>基本信息</h3>
            </div>
            <table>
               <%-- <tr>
                    <td class="td1">志愿者头像/团队LOGO</td>
                    <td class="td2">
                        <div class="avatarImg"><img src="" /></div>
                        <input type="file" id="file" name="file" onchange="setImgUrl()"/>
                    </td>
                </tr>--%>
                <tr>
                    <td class="td1">类型</td>
                    <td class="td2" >
                        <input style="width:15px;height:15px" name="type" type="radio" value="1" checked="checked"/>个人
                        <input style="width:15px;height:15px" name="type" type="radio" value="2"/>团队
                    </td>
                </tr>
                <tr>
                    <td id="volunteerName" class="td1">志愿者姓名</td>
                    <td class="td2">
                        <input name="name" id="name"/>
                    </td>
                </tr>
                <tr id="volunteerNum" style="display:none">
                    <td  class="td1">人数</td>
                    <td class="td2">
                        <input name="" id="number"/>
                    </td>
                </tr>
                <%--<tr>
                    <td class="td1">服务类型</td>
                    <td class="td2">
                        <select name="" id="">
                            <option>文化义演</option>
                            <option>场地执行</option>
                            <option>场馆服务</option>
                            <option>艺术培训</option>
                            <option>爱心能量</option>
                        </select>
                    </td>
                </tr>--%>
                <tr>
                    <td class="td1">手机号码</td>
                    <td class="td2">
                        <input name="phone" id="phone"/>
                    </td>
                </tr>
                <tr>
                    <td class="td1">所属区域</td>
                    <td class="td2" id="chooseRegion">
                        <input type="hidden" id="region" name="region"/>
                        <select name="" id="province">
                            <option>陕西省</option>
                        </select>
                        <select name="" id="city">
                            <option>安康市</option>
                        </select>
                        <select name="" id="area" onchange="setRegion()">
                            <option>请选择区</option>
                        </select>
                        <input style="width:600px;margin-top:10px;" name="address" id="address" placeholder="请填写详细地址"/>
                    </td>
                </tr>
                <%--<tr>
                    <td class="td1">籍贯</td>
                    <td class="td2">
                        <input name="phone" id="5"/>
                    </td>
                </tr>--%>
                <tr>
                    <td class="td1">邮箱</td>
                    <td class="td2">
                        <input name="email" id="email"/>
                    </td>
                </tr>
                <tr>
                    <td class="td1">学历</td>
                    <input type="hidden" name="education" id="education" value="1"/>
                    <td class="td2" >
                        <select class="education">
                            <option value="1">高中</option>
                            <option value="2">大专</option>
                            <option value="3">本科</option>
                            <option value="4">博士及以上</option>
                        </select>
                    </td>
                </tr>
                <%--<tr>
                    <td class="td1">职业</td>
                    <input type="hidden" name="occupation"/>
                    <td class="td2">
                        <select>
                            <option>请选择</option>
                        </select>
                    </td>
                </tr>--%>
                <tr>
                    <td class="td1">政治面貌</td>
                    <input type="hidden" name="political" id="political" value="1"/>
                    <td class="td2">
                        <select class="political">
                            <option value="1">团员</option>
                            <option value="2">党员</option>

                        </select>
                    </td>
                </tr>
                <tr>
                    <td class="td1">志愿者介绍</td>
                    <td class="td2">
                        <textarea row="6" name="brief"></textarea>
                    </td>
                </tr>
            </table>
            <div style="margin: 50px;"><a id="submitBtn" onclick="sign()">提交</a></div>
        </form>

    </div>

    <%@include file="/WEB-INF/why/index/footer.jsp" %>
 <script type="text/javascript" src="${path}/STATIC/js/location.js"></script>
<script>
    loadArea();

    $("input[type=radio]").change(function(){
        if($(this).val()==1){
            $("#volunteerName").html("志愿者姓名");
            $("#volunteerNum").hide();
            $("#volunteerNum input").attr("name","");
        }
        if($(this).val()==2){
            //alert(22)
            $("#volunteerName").html("志愿团队名称");
            $("#volunteerNum").show();
          //  $("#volunteerNum input").attr("name","number");
        }
    })

    function setRegion(){
      var region=$("#area option:selected").val();
      $("#region").val(region);
    }
    $(".education").change(function(){
        var education=$(".education option:selected").val();
        $("#education").val(education);
    });
    $(".political").change(function(){
        var political=$(".political option:selected").val();
        $("#political").val(political);
    });

    function loadArea(){
        var provinceNo = '4136';
        var cityNo = '4300';
        var loc = new Location();
        var area = loc.find('0,' + provinceNo + ',' + cityNo);

        $.each(area , function(k , v) {
            //获取所有镇级区域
            var last=v.substr(v.length-1,1);
            if(last=="镇"){
                return;
            }
            //javascript:clickArea(\""+k+"\");
            /*$('#areaUl').append("<li id="+k+"><a>"+v+"</a></li>");*/
             $("#area").append("<option value="+k+">"+v+"</option>");

        });
    }

    function setImgUrl(){
        var file=$("#file")[0].files[0];
        var urlImg=URL.createObjectURL(file);
        $(".avatarImg img").attr("src",urlImg);
        $(".avatarImg").toggle();
    }

    function sign(){
       // var userId=$("#userId").val();
       var data=$("#signInfo").serialize();
       data=decodeURIComponent(data,true);
       var res={}
       var datas=data.split("&");
        for(var i = 0;i<datas.length;i++){
            var str = datas[i].split('=');
            res[str[0]]=str[1];
        }
        /*必填参数*/
        res.status=2;
        //res.cardId="11";
        //res.userId=userId;
        var name=res.name;
        var region=res.region;
        if(userId==""){
            dialogAlert("提示信息","登陆之后才能注册");
            return;
        }
        if(name==""){
            dialogAlert("提示信息","姓名不能为空");
            return;
        }
        if(region==""){
            dialogAlert("提示信息","区域不能为空");
            return;
        }
        $.ajax({
            contentType:"application/json",
            type: "post",
            url: "${path}/newVolunteer/addNewVolunteer.do",
            data: JSON.stringify(res),
            async: false,
            dataType:"json",
            success: function(data){
               if(data=="success"){
                   dialogAlert("提示信息","注册成功",function(){
                       location.href="${path}/volunteer/volunteerRecruitIndex.do"
                   });
               }else if(data=="exist"){
                    dialogAlert("提示信息","您已注册志愿者");
               }
            },
            error:function(){
                dialogAlert("提示信息","注册失败!")
            }
        });
      //http://localhost:8080/VolunteerActivityDemeanorDocumentary/Documentarylist.do?OwnerId=3321b0b45cbe4a6996fdab4b31cb22d5
    }
</script>
</body>
</html>
