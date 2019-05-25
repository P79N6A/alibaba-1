<%--
  Created by IntelliJ IDEA.
  User: 54171
  Date: 2019/3/28
  Time: 11:38
  To change this template use File | Settings | File Templates.
--%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="http://223.84.188.54/STATIC/css/frontpage.css">
    <script type="text/javascript" src="http://223.84.188.54/STATIC/js/jquery.min.js"></script>
    <script type="text/javascript" src="http://223.84.188.54/STATIC/js/page.min.js"></script>
    <script>
    </script>
    <script>
        var module = '${module}';
        $(function () {
            loadSfData();
        });
        function loadSfData(){
            var reqPage=$("#reqPage").val();
            $("#activityListDivChild").load("../zxInformation/sfListIndex.do",{informationModuleId:module,page:reqPage},function(){
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
                        loadSfData();
                        return false;
                    }
                });
            });
        }
    </script>
</head>
<body>
<div id="activityListDivChild" style="background-color: #ffffff">

</div>
</body>
</html>
