<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/css.css"/>
    <script type="text/javascript">

$(function(){
    var obj_lis = document.getElementById("color_choose").getElementsByTagName("li");
    for(i=0;i<obj_lis.length;i++){
        obj_lis[i].onclick = function(){
            $(this).addClass("gou").siblings().removeClass("gou");
            $("#tagColor").val($(this).find("a").text());
        }

    }
})
    </script>

</head>

<body style="background: none;">
<form action="" id="tagForm">
<div class="main-publish tag-add">
  <input type="hidden" value="${tagType}" name="tagType" id="tagType"/>
    
    <input id="dictId" type="hidden" name="dictId" value="${dictId}" >
    <table width="100%" class="form-table">
       <!-- <tr>
            <td width="28%" class="td-title">标签类别：</td>
            <td class="td-select">
              <div class="select-box w240">
                    <input type="hidden"  value="${tag.tagType}" name="tagType" id="tagType" />
                    <div class="select-text" data-value="">请选择标签类别</div>
                    <ul class="select-option">

                        <c:forEach items="${dicList}" var="t">
                            <li data-option="${t.dictId}">${t.dictName}</li>
                        </c:forEach>

                    </ul>
                </div>
            </td>
        </tr>
        <tr>
            <td width="28%" class="td-title">标签名称：</td>
            <td class="td-input">
                <input type="text" name="tagName" id="tagName" class="input-text w220" />
            </td>
        </tr>

       <tr>
            <td width="28%" class="td-title">标签首字：</td>
            <td class="td-input">
                <input type="text" name="tagInitial" id="tagInitial" class="input-text w220" maxlength="10"/>
            </td>
        </tr>
       <tr>
                <td width="28%" class="td-title">上传标签图片：</td>
                <td class="td-upload">
                    <input type="hidden"  name="tagImageUrl" id="headImgUrl" value=""  />
                    <input type="hidden" name="uploadType" value="Img" id="uploadType" />
                    <img id="imgHeadPrev"  width="80" height="80" />
                    <br/>
                    <input type="file" name="file" id="file" />
                    <span>可上传1张图片，建议尺寸300*300像素</span>
<%--                   <span>
                            <img id="imgHeadPrev"  width="80" height="80">
                            <span id="fileContainer"></span>
                            <input type="file" name="file" id="file">
                   </span>--%>
                </td>
        </tr>

        <tr>
            <td width="28%" class="td-title">标签颜色：</td>
            <td class="td-input">
                <input type="hidden" name="tagColor" id="tagColor" class="input-text w220" />
                <div id="color_choose">
                    <ul class="clearfix">
                        <li><a href="#" class="c_one">#666</a><span class="gou"></span></li>
                        <li><a href="#" class="c_two">#FF2D2D</a><span class="gou"></span></li>
                        <li><a href="#" class="c_three">#FF359A</a><span class="gou"></span></li>
                        <li><a href="#" class="c_four">#FF44FF</a><span class="gou"></span></li>
                        <li><a href="#" class="c_five">#8600FF</a><span class="gou"></span></li>
                        <li><a href="#" class="c_six">#0000E3</a><span class="gou"></span></li>
                        <li><a href="#" class="c_seven">#0072E3</a><span class="gou"></span></li>
                        <li><a href="#" class="c_eight">#00CACA</a><span class="gou"></span></li>
                        <li><a href="#" class="c_nine">#02DF82</a><span class="gou"></span></li>
                        <li><a href="#" class="c_ten">#64A600</a><span class="gou"></span></li>
                        <li><a href="#" class="c_eleven">#A6A600</a><span class="gou"></span></li>
                        <li><a href="#" class="c_twelve">#FFDC35</a><span class="gou"></span></li>
                        <li><a href="#" class="c_thirteen">#FFC78E</a><span class="gou"></span></li>
                        <li><a href="#" class="c_fourteen">#BB3D00</a><span class="gou"></span></li>
                        <li><a href="#" class="c_fifteen">#743A3A</a><span class="gou"></span></li>
                        <li><a href="#" class="c_sixteen">#707038</a><span class="gou"></span></li>
                        <li><a href="#" class="c_seventeen">#3D7878</a><span class="gou"></span></li>
                        <li><a href="#" class="c_eighteen">#5151A2</a><span class="gou"></span></li>
                        <li><a href="#" class="c_nineteen">#7E3D76</a><span class="gou"></span></li>
                        <li><a href="#" class="c_twenty">#000000</a><span class="gou"></span></li>
                    </ul>
                </div>
            </td>
        </tr> --> 
        <tr>
            <td width="28%" class="td-title"></td>
            <td class="td-input"><textarea id="tagNames" name="tagNames" rows="6" class="textareaBox w220"  style="resize: none;width: 235px;height:100px">${tagName }</textarea>
            </td>        	
        </tr>
         <td></td>
        	<td>
        		<p>标签之间用英文字符的逗号隔开，比如：文物，名画</p>
        	</td>
        </tr>
        <tr>
            <td class="td-btn" align="center" colspan="2">
                <input class="btn-save" type="button"  value="保存"/>
                <input class="btn-cancel" type="button" value="取消"/>
            </td>
        </tr>
    </table>
</div>

<input type="hidden" value="${tagType}"  name="myTagType"   />
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        selectModel();
    });
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
        $(function () {
            var dialog = parent.dialog.get(window);
        	var tagType='${tagType}';
            /*点击确定按钮*/
            $(".btn-save").on("click", function(){
            	
            	var tagNames=$("#tagNames").val();
            	
            	var tagNameArray=tagNames.split(",");
            	
            	var check=true;
            	
            	$.each(tagNameArray,function(i,dom){
            		
            		if(dom.length>10)
            		{
            			 dialogTypeSaveDraft("提示","标签长度不能大于10！",function(){
                             $("#tagNames").focus();
                         });
            			 
            			 check=false;
            			 return false;
            		}
            	})
              
            	if(check)
                $.post("${path}/tag/saveCommonTag.do", $("#tagForm").serialize(), function(
                        datas) {
                    if (datas == "success") {
                        dialogTypeSaveDraft("提示","保存成功",function(){
                            parent.location.href="${path}/tag/tagList.do?tagType="+tagType;
                            dialog.close().remove();
                        });
                    }else if(datas == "repeat"){
                        dialogTypeSaveDraft("提示","当前推荐标签已达到上限,请先取消部分推荐的标签",function(){
                            //dialog.close().remove();
                        });
                    }else if(datas == "nameRepeat"){
                        dialogTypeSaveDraft("提示","标签名称已存在,请修改标签名称",function(){
                            //dialog.close().remove();
                        });
                    }else if(datas == "colorRepeat"){
                        dialogTypeSaveDraft("提示","标签颜色已被其他标签选用！");
                    }else if(datas.length>0) {
						dialogTypeSaveDraft("提示","修改失败,"+datas+"!",function(){

						});
					}else  {
						dialogTypeSaveDraft("提示","修改失败!",function(){

						});
					}

                });
            });
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });


        });
    });
    function dialogTypeSaveDraft(title, content, fn){
        var d = parent.dialog({
            width:400,
            title:title,
            content:content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if(fn)  fn();
            }
        });
        d.showModal();
    }
</script>
<%--<script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>--%>
<script type="text/javascript">
    $(document).ready(function() {
        var Img=$("#uploadType").val();
        $("#file").uploadify({
            'formData':{'uploadType':Img,'type' :2 ,userCounty:'${sessionScope.user.userCounty}'},//传静态参数
            swf:'../STATIC/js/uploadify.swf',
            uploader:'../upload/uploadFile.do;jsessionid=${pageContext.session.id}',//后台处理的请求
            buttonText:'上传图片',//上传按钮的文字
            'buttonClass':"upload-btn",//按钮的样式
            queueSizeLimit:1, //   default 999
            'method': 'post',//和后台交互的方式：post/get
            queueID:'fileContainer',
            fileObjName:'file', //后台接受参数名称
            fileTypeExts:'*.gif;*.png;*.jpg;*.jpeg;', //控制可上传文件的扩展名，启用本项时需同时声明fileDesc
            'auto':true, //true当选择文件后就直接上传了，为false需要点击上传按钮才上传
            'multi':false, //是否支持多个附近同时上传
            height:25,//选择文件按钮的高度
            width:70,//选择文件按钮的宽度
            'debug':false,//debug模式开/关，打开后会显示debug时的信息
            'dataType':'json',
            removeCompleted:false,//上传成功后的文件，是否在队列中自动删除
            onUploadSuccess:function (file, data, response) {
                var json = $.parseJSON(data);
                var url=json.data;
                var imgUrl = getImgUrl(url);
                $("#headImgUrl").val(url);
                $("#imgHeadPrev").attr("src",imgUrl);
                //隐藏该区域
                $(".uploadify-queue-item").hide();
            },
            onSelect:function () {
            },
            onCancel:function () {
            }
        });
    });



    //if (navigator.userAgent.indexOf("Firefox") != -1) {
    //myUploadImg();
    //}
</script>

<%--<script type="text/javascript">
    if(navigator.userAgent.indexOf("Firefox")==-1) {
        var js = document.createElement("script");
        document.getElementsByTagName("head")[0].appendChild(js);
        js.src = '${path}/STATIC/js/jquery.uploadify-3.1.min.js';
    }
</script>--%>

<%--<script type="text/javascript">
    $(document).ready(function(){
        if(navigator.userAgent.indexOf("Firefox")==-1) {
            myUploadImg()
        }
    });
</script>--%>

</body>
</html>