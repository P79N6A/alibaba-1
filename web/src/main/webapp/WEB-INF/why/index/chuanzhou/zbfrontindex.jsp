<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>${moduleName}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon"
          mce_href="${path}/STATIC/image/favicon.ico">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/index_new.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/cutimg.js"></script>
    <!--移动端版本兼容 -->
    <script type="text/javascript">
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 1200;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=1200, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
        }
    </script>
    <!--移动端版本兼容 end -->

    <script>
    var module = '${module}';
	$(function () {
        $("#pageName").html("所在位置：${moduleName}");
        //新增资讯选中样式添加
        if(module=="767707e242a8486da7089b62ea4921d9"){
            $("#wlzx").addClass('cur').siblings().removeClass('cur');
        }else if(module=="ce9dd09433474f9d8ec9eccfb3e97962"){
            $("#lyfw").addClass('cur').siblings().removeClass('cur');
        }else if(module=="932e4be2fd3f42d3847ef71e9f2c34f1"){
            $("#whzb").addClass('cur').siblings().removeClass('cur');
        }else if(module=="12df5837827741c1a53424ceffbaeada" || module=="afa6dfe23a9745afa749f89e1f5b9b8a"){
            $("#szzg").addClass('cur').siblings().removeClass('cur');
        }

        //$("#${moduleName}").addClass('cur').siblings().removeClass('cur');
		getActivitySearchType();
		loadData();
		$("#in_search").on("click", ".av_list li", function () {
	        var $this = $(this);
	        $this.addClass("cur").siblings().removeClass("cur");
	    });
	})
     function setScreen(){
		    var $content = $("#info-content");
		    if($content.length > 0) {
		        $content.removeAttr("style");
		        var contentH = $content.outerHeight();
		        var otherH = $("#header").outerHeight() + $("#in-footer").outerHeight();
		        var screenConH = $(window).height() - otherH;
		        if (contentH < screenConH) {
		            $content.css({"height": screenConH});
		        }
		    }
		}
    //获取搜索类型
	function getActivitySearchType() {
	    $.post("${path}/zxInformation/zxtypelist.do?informationModuleId="+module, function (data) {
	        var beipiaoinfoTagHtml = "<ul class='av_list'>";
	        beipiaoinfoTagHtml += '<li class="cur"><a href="javascript:setValueById(\'beipiaoinfoTag\',\'\');"> 全部</a></li>';
	        var list = eval(data);
	        for (var i = 0; i < list.length; i++) {
	            var tag = list[i];
	            beipiaoinfoTagHtml += '<li><a href="javascript:setValueById(\'beipiaoinfoTag\',\'' + tag.informationTypeId + '\');">' + tag.typeName + '</a></li>';
	        }
	        beipiaoinfoTagHtml += "</ul>";
	        $("#activitySearchType").html(beipiaoinfoTagHtml);
	    });
	}
	//选中时赋值 并进行查询
	function setValueById(id, value) {
	    $("#" + id).val(value);
	    //$(".ul_list>ul").html("");
	    $("#reqPage").val(1);
        // loadDataByType();
        loadData();
	}
    /*function loadDataByType(){
        var keyword =  $("#searchVal").val();
        var reqPage=$("#reqPage").val();
        var countPage = $("#countpage").val();
        var beipiaoinfoTag = $("#beipiaoinfoTag").val();
        //var ysjType = $("#ysjType").val();
        if(beipiaoinfoTag){
            var href="../zxInformation/zblistByType.do";
            $("#activityListDivChild").load(href,{informationTypeId:beipiaoinfoTag,informationModuleId:module,page:reqPage},function(){
                //分页
                kkpager.generPageHtml({
                    pno :$("#pages").val() ,
                    //总页码
                    total :$("#countpage").val(),
                    //总数据条数
                    totalRecords :$("#total").val(),
                    mode : 'click',
                    click : function(n){
                        this.selectPage(n);
                        $("#reqPage").val(n);

                        loadData();
                        return false;
                    }
                });
                setScreen();
            });
        }else{
            var href="../zxInformation/zblistIndex.do";
            $("#activityListDivChild").load(href,{informationModuleId:module,page:reqPage},function(){
                //分页
                kkpager.generPageHtml({
                    pno :$("#pages").val() ,
                    //总页码
                    total :$("#countpage").val(),
                    //总数据条数
                    totalRecords :$("#total").val(),
                    mode : 'click',
                    click : function(n){
                        this.selectPage(n);
                        $("#reqPage").val(n);

                        loadData();
                        return false;
                    }
                });
                setScreen();
            });
        }

    }*/
	function loadData(){
		var keyword =  $("#searchVal").val();
	    var reqPage=$("#reqPage").val();
	    var countPage = $("#countpage").val();
	    var beipiaoinfoTag = $("#beipiaoinfoTag").val();
	    $("#activityListDivChild").load("../zxInformation/zblistIndex.do",{informationType:beipiaoinfoTag,informationModuleId:module,countPage:countPage,page:reqPage},function(){
	        //分页
	        kkpager.generPageHtml({
	            pno :$("#pages").val() ,
	            //总页码
	            total :$("#countpage").val(),
	            //总数据条数
	            totalRecords :$("#total").val(),
	            mode : 'click',
	            click : function(n){
	                this.selectPage(n);
	                $("#reqPage").val(n);

	                loadData();
	                return false;
	            }
	        });
	        setScreen();
	    });
	}
    </script>

    <style>
    	.in_search .prop-attrs-area .av_list:first-child>li:first-child {
		    float: none;
		}
		.in_search .prop-attrs-type .attrValue{
			padding-bottom: 0px;
		}
		#hot_list .hl_list li .intro p{height:40px;overflow:hidden;}
		#hot_list .hl_list li{height:325px;}
		ul .img .video {
		  width: 100%;
		  height: 100%;
		  position: absolute;
		  top: 0;
		  left: 0;
		  z-index: 5;
		  background: url(${path}/STATIC/image/qy_play.png) no-repeat center center;
		}
    </style>

</head>
<body class="body">
<!-- 导入头部文件 -->
	<div class="header">
	<%@include file="../header.jsp" %>
	</div>
<!--banner_recommond start-->
<form action="" id="indexForm" method="post">
    <!--banner_recommond end-->
    <input type="hidden" id="keywordVal" value="${keyword}"/>
    <input type="hidden" name="beipiaoinfoTag" id="beipiaoinfoTag"/>
    <!-- <input type="hidden" name="ysjType" id="ysjType"/> -->
    <input type="hidden" name="page" id="page"/>
    <input type="hidden" id="reqPage"  value="1">
    <div id="info-content">
    <div id="in_search">
        <div class="in_search">
            <div class="prop-attrs prop-attrs-type">
                <div class="attr clearfix">
                    <div class="attrKey">类型：</div>
                    <div class="attrValue" id="activitySearchType">
                        <ul class="av_list">
                        </ul>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <div id="hot_list">
        <div class="ul_list" id="activityListDivChild">
            <ul class="hl_list clearfix">
            </ul>
        </div>
    </div>
    </div>
</form>
<!--feet start-->
<div class="footer">
<%@include file="/WEB-INF/why/index/footer.jsp" %>
</div>
<!--list end-->
<script>
    var _hmt = _hmt || [];
    (function () {
        var hm = document.createElement("script");
        hm.src = "//hm.baidu.com/hm.js?eec797acd6a9a249946ec421c96aafeb";
        var s = document.getElementsByTagName("script")[0];
        s.parentNode.insertBefore(hm, s);
    })();
</script>
</body>
</html>
