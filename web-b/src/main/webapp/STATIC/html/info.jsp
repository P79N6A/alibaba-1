<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>
    <title>活动--文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>
    <style type="text/css">
        #download_list{width:1200px;margin:0 auto;margin-top:40px;overflow:hidden; padding-bottom:60px;}
        #download_list .download_tit{width:1200px;height:35px;line-height:35px;text-align:center;overflow:hidden;background:#40b4ff;color:#ffffff;font-size:16px;}
        #download_list .table_tit{width:1198px;height:35px;line-height:35px;text-align:center;overflow:hidden;background:#40b4ff;color:#ffffff;font-size:16px;margin-top:25px;}
        #download_list .logo_download{ width:1198px;height:255px;border:1px solid #dfdfdf;}
        #download_list .logo_download li{width:399px;float:left;display:inline;background:#ffffff;}
        #download_list .logo_download li .pic{text-align:center;display:block;height:140px;padding:27px 0px;}
        #download_list .logo_download li .pic_size{text-align:center;display:block;height:140px;padding:54px 0px 0px 0px;}
        #download_list .logo_download li .pic_file{text-align:center;display:block;height:140px;padding:54px 0px 0px 0px;}
        #download_list .logo_download li a{width:374px;height:60px;line-height:60px;color:#f58636;font-size:18px;display:block;text-align:center; background:#f5f5f5 url(../image/download_icon.png) no-repeat 150px 22px;padding-left:25px;}
        #download_list .logo_download li .d_file{width:374px;height:60px;line-height:60px;color:#f58636;font-size:18px;display:block;text-align:center; background:#f5f5f5 url(../image/download_icon.png) no-repeat 140px 22px;padding-left:25px;}
        .code_slogan{width:1200px;height:290px;margin:0 auto;margin-top:25px;overflow:hidden;}
        .code_slogan .code{width:886px;height:289px;border:1px solid #e2e2e2;border-top:none;border-right:none;}
        .code_slogan .code h4{width:890px;height:35px;line-height:35px;text-align:center;display:block;color:#ffffff;font-size:16px;background:#40b4ff;}
        .code_slogan .code .code_img{width:149px;height:147px;padding:22px 0px; margin:0 auto; text-align:center;overflow:hidden; display:block;}
        .code_slogan .code a{width:863px;height:63px;line-height:63px;color:#f58636;font-size:18px;display:block;text-align:center; background:#f5f5f5 url(../image/download_icon.png) no-repeat 384px 22px;padding-left:25px;}
        .code_slogan .slogan{width:310px;height:289px;border:1px solid #e2e2e2;border-top:none;}
        .code_slogan .slogan h4{width:310px;height:35px;line-height:35px;text-align:center;display:block;color:#ffffff;font-size:16px;background:#40b4ff;}
        .code_slogan .slogan span{display:block;height:150px;text-align:center;color:#333333;font-size:18px;font-family:"微软雅黑";padding-top:105px;}
        #download_list .table_download{ width:1199px;height:150px;border:1px solid #dfdfdf; border-right:none;}
        #download_list .table_download li{width:398px;height:150px;float:left;display:inline;background:#ffffff; overflow:hidden; border-right:1px solid #dfdfdf;}
        #download_list .table_download li p{text-align:center;display:block; color:#333333;font-size:18px;padding:35px 0px;}
        #download_list .table_download li a{width:374px;height:60px;line-height:60px;color:#f58636;font-size:18px;display:block;text-align:center; background:#f5f5f5 url(../image/download_icon.png) no-repeat 150px 22px;padding-left:25px;}
        #download_list .table_download li .d_file{width:374px;height:60px;line-height:60px;color:#f58636;font-size:18px;display:block;text-align:center; background:#f5f5f5 url(../image/download_icon.png) no-repeat 140px 22px;padding-left:25px;}
        .contact_tel{margin-top:40px;margin-left:20px;}
        .contact_tel h3{color:#f58636;font-size:16px;font-family:"微软雅黑";margin-bottom:20px;}
        .contact_tel p{color:#333333;font-size:16px;font-family:"微软雅黑";line-height:30px;}
    </style>
    <script type="text/javascript">
        var phoneWidth =  parseInt(window.screen.width);
        var phoneScale = phoneWidth/1200;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if(version>2.3){
                document.write('<meta name="viewport" content="width=1200, minimum-scale = '+phoneScale+', maximum-scale = '+(phoneScale)+', target-densitydpi=device-dpi">');
            }else{
                document.write('<meta name="viewport" content="width=1200, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=1200, user-scalable=yes, target-densitydpi=device-dpi">');
        }
    </script>
</head>
<body>
<!-- 导入头部文件 -->
<%@include file="/WEB-INF/why/index/index_top.jsp"%>



<!--download start-->
<div id="download_list">
    <!--first start-->
    <div class="download_tit">LOGO下载</div>
    <ul class="logo_download clearfix">
        <li>
            <div class="pic"><img src="../image/download_logo.png" width="276" height="139" /></div>
            <a href="http://img1.wenhuayun.cn/admin/文化云logo.jpg" target="_blank">下载图片</a>
        </li>
        <li>
            <div class="pic_size"><img src="../image/download_color.png" width="159" height="87" /></div>
            <a href="http://img1.wenhuayun.cn/admin/logo标准色号.jpg" target="_blank">标准色号</a>
        </li>
        <li>
            <div class="pic_file"><img src="../image/download_file.png" width="76" height="73" /></div>
            <a href="http://img1.wenhuayun.cn/admin/文化云logo（原文件）.ai" class="d_file" target="_blank">下载源文件</a>
        </li>
    </ul>
    <!--first end-->
    <!--second start-->
    <div class="code_slogan clearfix">
        <div class="code fl">
            <h4>二维码下载</h4>
            <div class="code_img"><img src="../image/download_code.png" width="149" height="147" /></div>
            <a href="http://img1.wenhuayun.cn/admin/二维码.png" target="_blank">下载二维码</a>
        </div>
        <div class="slogan fl">
            <h4>标语</h4>
            <span>文化云-畅享文化生活新体验</span>
        </div>
    </div>
    <!--second end-->
    <!--third start-->
    <div class="table_tit">汇总表下载</div>
    <ul class="table_download clearfix">
        <li>
            <p>1.文化上海云平台运营补充规范（全文）</p>
            <a href="http://img1.wenhuayun.cn/admin/文化上海云平台运营补充规范.doc" target="_blank">下载文件</a>
        </li>
        <li>
            <p>2.文化上海云宣传物料汇总表</p>
            <a href="http://img1.wenhuayun.cn/admin/文化上海云宣传物料汇总表.doc" target="_blank">下载文件</a>
        </li>
        <li>
            <p>3.文化上海云资源汇总表</p>
            <a href="http://img1.wenhuayun.cn/admin/文化上海云资源汇总表.doc" class="d_file" target="_blank">下载文件</a>
        </li>
    </ul>
    <!--third end-->
    <!--four start-->
    <div class="contact_tel">
        <h3>若有疑问或咨询，请联系我们：  </h3>
        <p>联 系 人：高玲</p>
        <p>电　  话：18821217088</p>
    </div>
    <!--four end-->
</div>
<!--download end-->
<%--<div id="in-footer">--%>
<%--<div class="in-footer">--%>
<%--<div class="in-footer1">--%>
<%--<p>联系电话：4000182346 | 传真：36696098-8080 | 服务条款 | 意见反馈</p>--%>
<%--<p>沪ICP备07032795号-8 | Copyright &copy; 2014-2016 wenhuayun.cn 文化云 版权所有，未经授权禁止复制或镜像 | <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script></p>--%>
<%--<!--<p>文化上海云 版权所有 | 未经授权禁止复制或镜像 | 联系电话：021-58741254 | 传真：65874269 | 沪ICP备06021945号 | 服务协议 | 意见反馈</p>--%>
<%--<p>Copyright © 2014 - 2020 www.culture.com All Rights Reserved. <script type="text/javascript">var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");document.write(unescape("%3Cspan id='cnzz_stat_icon_1256993307'%3E%3C/span%3E%3Cscript src='" + cnzz_protocol + "s95.cnzz.com/z_stat.php%3Fid%3D1256993307' type='text/javascript'%3E%3C/script%3E"));</script></p>-->--%>
<%--</div>--%>
<%--</div>--%>

<!-- 导入尾部文件 -->
<%@include file="/WEB-INF/why/index/index_below.jsp"%>

</body>
</html>
