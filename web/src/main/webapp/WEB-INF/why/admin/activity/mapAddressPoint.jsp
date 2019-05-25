<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>活动列表--文化云</title>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <style type="text/css">
        body{
            margin:0;
            height:100%;
            width:100%;
            position:absolute;
            font-size:12px;
        }
        #mapContainer{
            position: absolute;
            top:0;
            left: 0;
            right:0;
            bottom:0;
            height: 500px;
            margin: 80px 0 0;
        }

        #tip{
            background-color:#fff;
            color: #555555;
            /*border:1px solid #ccc;
            padding-left:10px;
            padding-right:2px;*/
            position:absolute;
            min-height:65px;
            top:0px;
            font-size:12px;
            left:0px;
            border-radius:3px;
            overflow:hidden;
            line-height:26px;
            min-width:280px;
        }
        #tip input[type="button"]{
            background-color: #0D9BF2;
            height:25px;
            text-align:center;
            line-height:25px;
            color:#fff;
            font-size:12px;
            border-radius:3px;
            outline: none;
            border:0;
            cursor:pointer;
        }

        #tip input[type="text"]{
            height:25px;
            border:1px solid #ccc;
            padding-left:5px;
            border-radius:3px;
            outline:none;
        }
        #pos{
            height: 65px;
            background-color: #fff;
            /*padding-left: 10px;
            padding-right: 10px;*/
            position:absolute;
            font-size: 12px;
            color: #555555;
            right: 0px;
            top: 0px;
            border-radius: 3px;
            line-height: 26px;
            /*border:1px solid #ccc;*/
        }
        #pos input[type="text"]{
            width: 120px;
            border:1px solid #ddd;
            height:23px;
            border-radius:3px;
            outline:none;
        }
        #pos input[type="button"]{
            width: 80px;
            height:25px;
            border: none;
            cursor: pointer;
            border-radius:3px;
            outline:none;
            color: #FFFFFF;
            background-color: #5DA7FD;
            margin-left: 10px;;
        }

        #result1{
            max-height:480px;
            border: solid 1px #cccccc;
        }
    </style>
    <script type="text/javascript">

        $(function(){
          var address= $('#keyword').val();
            if(address!=undefined){
             $('#keyword').trigger("onkeydown");
            }

        });

        seajs.config({
            alias: {
                "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });


        window.console = window.console || {log:function () {}}
        seajs.use(['jquery'], function ($) {
            $(function () {
                var dialog = parent.dialog.get(window);


                /*点击确定按钮*/
                $(".btn-save").on("click", function(){
                    var xPoint =  document.getElementById("lngX").value;
                    var yPoint =  document.getElementById("latY").value;
                    var valData = {"xPoint": xPoint, "yPoint": yPoint};
                    dialog.close(valData).remove();

                });

            });
        });

    </script>
</head>
<body>
<div id="mapContainer" ></div>
<div id="tip">
    <b>请输入地址：</b><br>
    <input type="text" id="keyword" name="keyword" value="${address}" onkeydown='keydown(event)' style="width: 280px;line-height: 25px"/>
    <div id="result1" name="result1"></div>
</div>
<div id="pos">
    <b>鼠标左键在地图上单击获取坐标</b>
    <br><div>X：<input  style="line-height: 23px" type="text" id="lngX" name="lngX" value=""/>&nbsp;Y：<input style="line-height: 23px"  type="text" id="latY" name="latY" value=""/>
    <input  type="button" id="getMapPointInfo" class="btn-publish btn-save" value="确定"/></div>
</div>

<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=39da37a97677fa883d5f0c5000176163"></script>
<script type="text/javascript">
    var windowsArr = [];
    var marker = [];
    var mapObj = new AMap.Map("mapContainer", {
        resizeEnable: true,
        view: new AMap.View2D({
            resizeEnable: true,
            zoom:5//地图显示的缩放级别
        }),
        keyboardEnable:false
    });
    var clickEventListener=AMap.event.addListener(mapObj,'click',function(e){
        document.getElementById("lngX").value=e.lnglat.getLng();
        document.getElementById("latY").value=e.lnglat.getLat();
    });


    document.getElementById("keyword").onkeyup = keydown;
    //输入提示
    function autoSearch() {
        var keywords = document.getElementById("keyword").value;
        var auto;
        //加载输入提示插件
        AMap.service(["AMap.Autocomplete"], function() {
            var autoOptions = {
                city: "" //城市，默认全国
            };
            auto = new AMap.Autocomplete(autoOptions);
            //查询成功时返回查询结果
            if ( keywords.length > 0) {
                auto.search(keywords, function(status, result){
                    autocomplete_CallBack(result);
                });
            }
            else {
                document.getElementById("result1").style.display = "none";
            }
        });
    }

    //输出输入提示结果的回调函数
    function autocomplete_CallBack(data) {
        var resultStr = "";
        var tipArr = data.tips;
        if (tipArr&&tipArr.length>0) {
            for (var i = 0; i < tipArr.length; i++) {
                resultStr += "<div id='divid" + (i + 1) + "' onmouseover='openMarkerTipById(" + (i + 1)
                + ",this)' onclick='selectResult(" + i + ")' onmouseout='onmouseout_MarkerStyle(" + (i + 1)
                + ",this)' style=\"font-size: 13px;cursor:pointer;padding:5px 5px 5px 5px;\"" + "data=" + tipArr[i].adcode + ">" + tipArr[i].name + "<span style='color:#C1C1C1;'>"+ tipArr[i].district + "</span></div>";
            }
        }
        else  {
            resultStr = " π__π 亲,人家找不到结果!<br />要不试试：<br />1.请确保所有字词拼写正确<br />2.尝试不同的关键字<br />3.尝试更宽泛的关键字";
        }
        document.getElementById("result1").curSelect = -1;
        document.getElementById("result1").tipArr = tipArr;
        document.getElementById("result1").innerHTML = resultStr;
        document.getElementById("result1").style.display = "block";
    }

    //输入提示框鼠标滑过时的样式
    function openMarkerTipById(pointid, thiss) {  //根据id打开搜索结果点tip
        thiss.style.background = '#CAE1FF';
    }

    //输入提示框鼠标移出时的样式
    function onmouseout_MarkerStyle(pointid, thiss) {  //鼠标移开后点样式恢复
        thiss.style.background = "";
    }

    //从输入提示框中选择关键字并查询
    function selectResult(index) {
        if(index<0){
            return;
        }
        if (navigator.userAgent.indexOf("MSIE") > 0) {
            document.getElementById("keyword").onpropertychange = null;
            document.getElementById("keyword").onfocus = focus_callback;
        }
        //截取输入提示的关键字部分
        var text = document.getElementById("divid" + (index + 1)).innerHTML.replace(/<[^>].*?>.*<\/[^>].*?>/g,"");
        var cityCode = document.getElementById("divid" + (index + 1)).getAttribute('data');
        document.getElementById("keyword").value = text;
        document.getElementById("result1").style.display = "none";
        //根据选择的输入提示关键字查询
        mapObj.plugin(["AMap.PlaceSearch"], function() {
            var msearch = new AMap.PlaceSearch();  //构造地点查询类
            AMap.event.addListener(msearch, "complete", placeSearch_CallBack); //查询成功时的回调函数
            msearch.setCity(cityCode);
            msearch.search(text);  //关键字查询查询
        });
    }

    //定位选择输入提示关键字
    function focus_callback() {
        if (navigator.userAgent.indexOf("MSIE") > 0) {
            document.getElementById("keyword").onpropertychange = autoSearch;
        }
    }

    //输出关键字查询结果的回调函数
    function placeSearch_CallBack(data) {
        //清空地图上的InfoWindow和Marker
        windowsArr = [];
        marker     = [];
        mapObj.clearMap();
        var resultStr1 = "";
        var poiArr = data.poiList.pois;
        var resultCount = poiArr.length;
        for (var i = 0; i < resultCount; i++) {
            resultStr1 += "<div id='divid" + (i + 1) + "' onmouseover='openMarkerTipById1(" + i + ",this)' onmouseout='onmouseout_MarkerStyle(" + (i + 1) + ",this)' style=\"font-size: 12px;cursor:pointer;padding:0px 0 4px 2px; border-bottom:1px solid #C1FFC1;\"><table><tr><td><img src=\"http://webapi.amap.com/images/" + (i + 1) + ".png\"></td>" + "<td><h3><font color=\"#00a6ac\">名称: " + poiArr[i].name + "</font></h3>";
            resultStr1 +=  "</td></tr></table></div>";
            addmarker(i, poiArr[i]);
        }
        mapObj.setFitView();
    }

    //鼠标滑过查询结果改变背景样式，根据id打开信息窗体
    function openMarkerTipById1(pointid, thiss) {
        thiss.style.background = '#CAE1FF';
        windowsArr[pointid].open(mapObj, marker[pointid]);
    }

    //添加查询结果的marker&infowindow
    function addmarker(i, d) {
        var lngX = d.location.getLng();
        var latY = d.location.getLat();
        var markerOption = {
            map:mapObj,
            icon:"http://webapi.amap.com/images/" + (i + 1) + ".png",
            position:new AMap.LngLat(lngX, latY)
        };
        var mar = new AMap.Marker(markerOption);
        marker.push(new AMap.LngLat(lngX, latY));

        var infoWindow = new AMap.InfoWindow({
            content:"<h3><font color=\"#00a6ac\">  " + (i + 1) + ". " + d.name + "</font></h3>",
            size:new AMap.Size(300, 0),
            autoMove:true,
            offset:new AMap.Pixel(0,-30)
        });
        windowsArr.push(infoWindow);
        var aa = function (e) {infoWindow.open(mapObj, mar.getPosition());};
        AMap.event.addListener(mar, "mouseover", aa);
    }

    //infowindow显示内容
    function TipContents(type, address, tel) {  //窗体内容
        if (type == "" || type == "undefined" || type == null || type == " undefined" || typeof type == "undefined") {
            type = "暂无";
        }
        if (address == "" || address == "undefined" || address == null || address == " undefined" || typeof address == "undefined") {
            address = "暂无";
        }
        if (tel == "" || tel == "undefined" || tel == null || tel == " undefined" || typeof address == "tel") {
            tel = "暂无";
        }
        var str = "  地址：" + address + "<br />  电话：" + tel + " <br />  类型：" + type;
        return str;
    }
    function keydown(event){
        var key = (event||window.event).keyCode;
        var result = document.getElementById("result1")
        var cur = result.curSelect;
        if(key===40){//down
            if(cur + 1 < result.childNodes.length){
                if(result.childNodes[cur]){
                    result.childNodes[cur].style.background='';
                }
                result.curSelect=cur+1;
                result.childNodes[cur+1].style.background='#CAE1FF';
                document.getElementById("keyword").value = result.tipArr[cur+1].name;
            }
        }else if(key===38){//up
            if(cur-1>=0){
                if(result.childNodes[cur]){
                    result.childNodes[cur].style.background='';
                }
                result.curSelect=cur-1;
                result.childNodes[cur-1].style.background='#CAE1FF';
                document.getElementById("keyword").value = result.tipArr[cur-1].name;
            }
        }else if(key === 13){
            var res = document.getElementById("result1");
            if(res && res['curSelect'] !== -1){
                selectResult(document.getElementById("result1").curSelect);
            }
        }else{
            autoSearch();
        }
    }
</script>
</body>
</html>