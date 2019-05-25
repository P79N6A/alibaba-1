<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

    <script type="text/javascript">
        function moduleSubmit(obj){
            $(obj).attr("disabled","disabled");
            $.ajax({
                type:"post",
                url:"${path}/roleModule/saveRoleModule.do",
                async:false,
                data:$("#moduleForm").serialize(),
                success :function(result){
                    if(result == 'success'){
                        dialogSaveDraft("提示", "权限分配成功,退出重新登录后生效");
                    }else{
                        dialogSaveDraft("提示", "保存失败");
                    }
                    $(obj).removeAttr("disabled");
                }
            });
        }

        function selectAll(obj){
            if($(obj).is(":checked")){
                $(obj).parent().parent("td").next().find("[name=moduleId]:checkbox").prop("checked",true);
            }else{
                $(obj).parent().parent("td").next().find("[name=moduleId]:checkbox").prop("checked",false);
            }
        }
        /*******2015.11.16 add niu*******/
        function selectSingle(obj){
            var _thisEl = $(obj);
            var tf = _thisEl.find("input").prop("checked");
            var _domEl = _thisEl.parents("tr").find("td").eq(1).find("input[type=checkbox]");
            if(!tf){
                _domEl.prop("checked", false);
            }else{
                var flag = true;
                _thisEl.parent().find("label").each(function(i,el){
                    if(!$(el).find("input[type=checkbox]").prop("checked")){
                        flag = false;
                    }
                });
                if(!flag){
                    _domEl.prop("checked", false);
                }else{
                    _domEl.prop("checked", true);
                }
            }
        }

    </script>
</head>
<body>
    <div class="site">
        <em>您现在所在的位置：</em>角色管理 &gt; 权限分配
    </div>


    <div class="main-content">
        <table width="100%" class="tag-tab power-tab">
            <thead>
                    <tr>
                        <th width="30">ID</th>
                        <th width="110">栏目</th>
                        <th>权限</th>
                    </tr>
            </thead>
            <tbody>

    <%--<div class="main-content">--%>
        <form id="moduleForm">
            <input type="hidden" value="${roleId}" name="roleId"/>
            <%int i=0;%>
                <c:forEach items="${sysModules}" var="sysModule" varStatus="status">
                    <c:if test="${sysModule.moduleParentId == '0'}">
            <%i++;%>
                        <tr>
                            <td><%=i%></td>

                            <td>
                                <label>${sysModule.moduleName}
                                    <input type="checkbox" onclick="selectAll(this)"/>
                                </label>
                            </td>

                            <td>
                                <div class="power-list">
                                    <c:forEach items="${sysModules}" var="module">
                                        <c:if test="${module.moduleParentId == sysModule.moduleId}">

                                                <label onclick="selectSingle(this)">
                                                    <input type="checkbox" name="moduleId" value="${module.moduleId}"
                                                        <c:forEach items="${myModules}" var="moduleList">
                                                            <c:if test="${module.moduleId == moduleList.moduleId}"> checked </c:if>
                                                        </c:forEach> />
                                                        ${module.moduleName}
                                                </label>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
            </table>
                    <div class="btn-box" style="text-align: center; padding: 40px;">
                        <a class="btn-add-tag btn-save" href="javascript:;" onclick="moduleSubmit(this)" >保存</a>
                        <a class="btn-add-tag" href="javascript:;" onclick="javascript:history.back(-1)" >返回</a>
                    </div>
        </form>
    </div>
</body>
</html>