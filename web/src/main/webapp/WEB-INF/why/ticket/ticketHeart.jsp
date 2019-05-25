<%@ page language="java" pageEncoding="UTF-8" %>

<script>
    window.setInterval(readFile, 300000);
    window.setInterval(refresh, 600000);
    /*刷新本机页面*/
    function refresh() {
        if ($("#ticket-code").val() == "") {
            window.location.reload();
        }
    }
    /*读取本地文件,上传本机心跳代号*/
    function readFile() {

        var file = "D:/chuangtu/ctCode.txt";
        var fso = new ActiveXObject("Scripting.FileSystemObject");
        var f = fso.OpenTextFile(file, 1);
        var s = "";
        while (!f.AtEndOfStream)
            s += f.ReadLine();
        f.Close();
        var json = {
            'machineCode': s
        };
        $.post("${path}/ticketActivity/heartBeat.do", json,
                function (data) {
                }, "json");
    }
</script>
<script type="text/javascript" src="${path}/stat/stat.js"></script>