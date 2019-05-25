<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>
    <TITLE> 部门管理 </TITLE>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <style>
        body {
            background-color: white;
            margin:0; padding:0;
            text-align: center;
        }
        div, p, table, th, td {
            list-style:none;
            margin:0; padding:0;
            color:#333; font-size:12px;
            font-family:dotum, Verdana, Arial, Helvetica, AppleGothic, sans-serif;
        }
        #testIframe {margin-left: 10px;}
    </style>
    <link rel="stylesheet" href="${path}/STATIC/zTree_v3/css/demo.css" type="text/css">
    <link rel="stylesheet" href="${path}/STATIC/zTree_v3/css/zTreeStyle/zTreeStyle.css"/>
    <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.core-3.5.js"></script>
    <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.excheck-3.5.js"></script>
    <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.exedit-3.5.js"></script>
    <script type="text/javascript" src="${path}/STATIC/zTree_v3/js/jquery.ztree.exedit-3.5.js"></script>

    <SCRIPT type="text/javascript">
        <!--
        var setting = {
            async: true,
            view: {
                 addHoverDom: addHoverDom,
                 removeHoverDom: removeHoverDom,
                selectedMulti: false
            },
            edit: {
                enable: true,
                showRemoveBtn: false,
                addHoverDom: false,
                showRemoveBtn: showRemoveBtn,
                removeHoverDom: true,
                editNameSelectAll: true
            },
            data: {
                simpleData: {
                    enable: true,
                    idKey: "deptId",
                    pIdKey: "deptParentId",
                    rootPId: "0"
                },
                key: {
                    name: "deptName",
                    deptIsFromVenue:'deptIsFromVenue'
                }
            },
            callback: {
                beforeDrag: beforeDrag,
                beforeEditName: beforeEditName,
                beforeRemove: beforeRemove,
                beforeRename: beforeRename,
                onRemove: zTreeOnRemove,
                //onNodeCreated: zTreeOnNodeCreated,
                onRename: zTreeOnRename
            }
        };

        //自定义标签
        IDMark_A = "_a";
        function addDiyDom(treeId, treeNode) {
            //if (treeNode.parentNode && treeNode.parentNode.deptParentId!=2) return;
            var aObj = $("#" + treeNode.deptId + IDMark_A);
                var editStr = "<a id='diyBtn1_" +treeNode.deptId+ "' onclick='alert(1);return false;'>链接1</a>" +
                        "<a id='diyBtn2_" +treeNode.deptId+ "' onclick='alert(2);return false;'>链接2</a>";
                aObj.after(editStr);

        }


        var log, className = "dark";
        function beforeDrag(treeId, treeNodes) {
            return false;
        }
        function beforeEditName(treeId, treeNode) {
            className = (className === "dark" ? "":"dark");
            showLog("[ "+getTime()+" beforeEditName ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.deptName);
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.selectNode(treeNode);
            return true;
        }
        var tempRS;
        function beforeRemove(treeId, treeNode) {
            className = (className === "dark" ? "":"dark");
            showLog("[ "+getTime()+" beforeRemove ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.deptName);
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            tempRS = false;
            zTree.selectNode(treeNode);
            dialogConfirm("确认提示框", "确定要删除这条数据吗?", removeParent);
            function removeParent() {
                $.ajax({
                    type: 'get',
                    url: "${path}/dept/deleteDept.do?id="+treeNode.deptId +"&name=" + treeNode.deptName+"&pId=" + treeNode.deptParentId,//请求的action路径
                    error: function () {//请求失败处理函数
                        // jAlert('请求失败', '系统提示','failure');
                        dialogAlert("提示", "请求失败");
                        return false;
                    },
                    success:function(data){ //请求成功后处理函数。
                        if (data=='success') {
                            zTree.removeNode(treeNode);
                        } else {
                            //jAlert('请求失败:'+data, '系统提示','failure');
                            dialogAlert("提示", data);
                            return false;
                        }
                    }
                });
            }
            return false;
        }


        function beforeRename(treeId, treeNode, newName, isCancel) {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            if (newName.length == 0) {
                zTree.removeNode(treeNode);
                return;
            }
            className = (className === "dark" ? "":"dark");
            showLog((isCancel ? "<span style='color:red'>":"") + "[ "+getTime()+" beforeRename ]&nbsp;&nbsp;&nbsp;&nbsp; " + treeNode.deptName + (isCancel ? "</span>":""));
            if (newName.length == 0) {
                //alert('部门名称不能为空');
                //jAlert('部门名称不能为空', '系统提示','failure',function(){return false;});
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                setTimeout(function(){zTree.editName(treeNode)}, 10);
                return false;
            } else {
                $.ajax({
                    type: 'get',
                    url: "${path}/dept/updateDept.do?id="+treeNode.deptId +"&name=" + encodeURI(encodeURI(newName))+"&pId=" + treeNode.deptParentId,//请求的action路径
                    error: function (data) {//请求失败处理函数
                        //jAlert('请求失败', '系统提示','failure');
                        dialogAlert("提示", "请求失败 : " + data);
                        return false;
                    },
                    success:function(data){ //请求成功后处理函数。
                        if (data.success == 'Y') {
                            treeNode.deptId = data.uId;
                            return true;
                        } else if (data.msg == 'repeatName'){
                            dialogAlert("提示", "请求失败: 部门名称不能重复 ");
                            //zTree.removeNode(treeNode);
                            return false;
                        } else {
                            dialogAlert("提示", "请求失败");
                            zTree.removeNode(treeNode);
                            return false;
                        }
                    }
                });
            }
        }

        function showRemoveBtn(treeId, treeNode) {
           return !treeNode.isParent;
        }

        function showLog(str) {
            if (!log) log = $("#log");
            log.append("<li class='"+className+"'>"+str+"</li>");
            if(log.children("li").length > 8) {
                log.get(0).removeChild(log.children("li")[0]);
            }
        }
        function getTime() {
            var now= new Date(),
                    h=now.getHours(),
                    m=now.getMinutes(),
                    s=now.getSeconds(),
                    ms=now.getMilliseconds();
            return (h+":"+m+":"+s+ " " +ms);
        }

        function add(e) {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
                    isParent = e.data.isParent,
                    nodes = zTree.getSelectedNodes(),
                    treeNode = nodes[0];
            if (treeNode) {
                treeNode = zTree.addNodes(treeNode, {id:(100 + newCount), pId:treeNode.id, isParent:isParent, deptName:"new node" + (newCount++)});
            } else {
                treeNode = zTree.addNodes(null, {id:(100 + newCount), pId:0, isParent:isParent, deptName:"new node" + (newCount++)});
            }
            if (treeNode) {
                zTree.editName(treeNode[0]);
            } else {
                //alert("叶子节点被锁定，无法增加子节点");
                dialogAlert("提示", "叶子节点被锁定，无法增加子节点");
            }
        };

        var newCount = 1;
        function addHoverDom(treeId, treeNode) {
            var sObj = $("#" + treeNode.tId + "_span");
            if (treeNode.editNameFlag || $("#upBtn_"+treeNode.tId).length>0 || $("#downBtn_"+treeNode.tId).length>0 || $("#addBtn_"+treeNode.tId).length>0 || $("#addVenue_"+treeNode.tId).length>0){
                return;
            }

            var addStr = "";
            if($.trim(treeNode.deptIsFromVenue)=="" || treeNode.deptIsFromVenue==2){
                addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                + "' title='新增组织机构' onfocus='this.blur();'>新增组织机构</span>";
                addStr += "<span class='button add' id='addVenue_" + treeNode.tId
                    + "' title='新增场馆' onfocus='this.blur();'>新增场馆</span>";
            }
            if (treeNode.getPreNode() != null && treeNode.getPreNode() != undefined) {
                addStr += "<span class='button up' id='upBtn_" + treeNode.tId
                + "' title='add sort' onfocus='this.blur();'>上移</span>";
            }
            if (treeNode.getNextNode() != null && treeNode.getNextNode() != undefined) {
                addStr += "<span class='button down' id='downBtn_" + treeNode.tId
                + "' title='add sort' onfocus='this.blur();'>下移</span>";
            }
            sObj.after(addStr);

            var btn = $("#addBtn_"+treeNode.tId);
            if (btn) btn.bind("click", function(){
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                var newNodes = zTree.addNodes(treeNode, {deptId:null, deptParentId:treeNode.deptParentId, name:null});
                zTree.editName(newNodes[0]);
                if (newNodes) {
                    zTree.editName(treeNode[0]);
                } else {
                    dialogAlert("提示", "叶子节点被锁定，无法增加子节点");
                }
                return false;
            });

            var venueBtn = $("#addVenue_"+treeNode.tId);
            if (venueBtn) venueBtn.bind("click", function(){
               window.open("${path}/venue/preAddVenue.do?parentId="+treeNode.deptId);
                return false;
            });

            var btn1 = $("#upBtn_"+treeNode.tId);
            var btn2 = $("#downBtn_"+treeNode.tId);
            if (btn1) btn1.bind("click", function(){
                var preNode = treeNode.getPreNode();
                $.ajax({
                    type: 'get',
                    url: "${path}/dept/updateDeptSort.do?id="+treeNode.deptId +"&type=1&pId=" + preNode.deptId,//请求的action路径
                    error: function () {//请求失败处理函数
                        //jAlert('请求失败', '系统提示','failure');
                        dialogAlert("提示", "操作失败");
                    },
                    success:function(data){ //请求成功后处理函数。
                        //成功后改变位置
                        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                        zTree.moveNode(preNode, treeNode, "prev");

                    }
                });
                return false;
            });
            if (btn2) btn2.bind("click", function(){
                var nxtNode = treeNode.getNextNode();
                $.ajax({
                    type: 'get',
                    url: "${path}/dept/updateDeptSort.do?id="+treeNode.deptId +"&type=-1&pId=" + nxtNode.deptId,//请求的action路径
                    error: function () {//请求失败处理函数
                        //jAlert('请求失败', '系统提示','failure');
                        dialogAlert("提示", "操作失败");
                    },
                    success:function(data){ //请求成功后处理函数。
                        //成功后改变位置
                        //$("#selectAll").bind("click", selectAll);
                        var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                        zTree.moveNode(nxtNode, treeNode, "next");
                    }
                });
                return false;
            });
        };

        function removeHoverDom(treeId, treeNode) {
            $("#addBtn_"+treeNode.tId).unbind().remove();
            $("#addVenue_"+treeNode.tId).unbind().remove();
            $("#upBtn_"+treeNode.tId).unbind().remove();
            $("#downBtn_"+treeNode.tId).unbind().remove();
        };
        function selectAll() {
            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
        }

        var treeNodes;
        $(document).ready(function(){
            $.ajax({
                type: 'POST',
                dataType : "json",
                url: "${path}/dept/getDeptList.do",//请求的action路径
                error: function () {//请求失败处理函数
                    //jAlert('请求失败', '系统提示','failure');
                    dialogAlert("提示", "操作失败");
                },
                success:function(data){ //请求成功后处理函数。
                    var t = $("#treeDemo");
                    treeNodes = eval(data);
                    t = $.fn.zTree.init(t, setting, treeNodes);
                    $("#selectAll").bind("click", selectAll);
                }
            });
        });

        /**
         *  编辑节点触发的action
         * @param event
         * @param treeId
         * @param treeNode
         * @param isCancel
         */
        function zTreeOnRename(event, treeId, treeNode, isCancel){

        }

        function zTreeOnRemove(event, treeId, treeNode) {

        }


        function zTreeOnNodeCreated(event, treeId, treeNode) {
            $.ajax({
                type: 'get',
                url: "${path}/dept/getDeptList.do?id="+treeNode.deptId +"&name=" + treeNode.deptName+"&pId=" + treeNode.deptParentId,//请求的action路径
                error: function () {//请求失败处理函数
                   // jAlert('请求失败', '系统提示');
                    dialogAlert("提示", "操作失败");
                },
                success:function(data){ //请求成功后处理函数。

                }
            });
        }
        //-->
    </SCRIPT>
    <style type="text/css">
        .ztree li span.button.add {width:auto;margin-left:10px; margin-right: 10px;/* background-position:-144px 0;*/ background: none; vertical-align:top; *vertical-align:left;}
        .ztree li span.button.up {width:auto;margin-left: 10px; margin-right: 10px;/* background-position:-144px 0;*/ background: none; vertical-align:top; *vertical-align:left;}
        .ztree li span.button.down {width:auto; margin-left: 10px; margin-right: 10px;/* background-position:-144px 0;*/ background: none; vertical-align:top; *vertical-align:left;}
    </style>
</HEAD>

<BODY>
<div class="site" style="text-align: left;">
    <em>您现在所在的位置：</em>站点管理 &gt; 部门管理
</div>
<div class="">
    <div class="">
        <ul id="treeDemo" class="ztree"></ul>
    </div>
</div>
</BODY>
</HTML>
