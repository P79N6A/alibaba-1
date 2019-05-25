/**
 * Created by xiaoyj on 2015/4/22.
 */
function getId(id){
    return document.getElementById(id);
}
function getByClass(oParent, sClass){
    var ele = oParent.getElementsByTagName('*');
    var aResult = [];
    var re=new RegExp('\\b'+sClass+'\\b', 'i');
    for(var i = 0; i < ele.length; i++){
        if(re.test(ele[i].className)){
            aResult.push(ele[i]);
        }
    }
    return aResult;
}
/*上传file*/
function uploadFile(obj){
    var oParent = obj.parentNode;
    var fileBtn = getByClass(oParent, 'btn-file')[0];
    var fileTxt = getByClass(oParent, 'file-txt')[0];
    var btn = getByClass(oParent, 'upload-btn')[0];
    //btn.onclick = fileBtn.onclick;

    fileBtn.click();
    fileBtn.onchange = function(){
        fileTxt.value = this.value;
        alert(this.value);
    }
    /*if(fileBtn.files && fileBtn.files[0]){
     //火狐下，直接设img属性
     //imgObjPreview.src = docObj.files[0].getAsDataURL();

     //火狐7以上版本不能用上面的getAsDataURL()方式获取，需要一下方式
     fileTxt.value = window.URL.createObjectURL(fileBtn.files[0]);
     }else{
     //IE下，使用滤镜
     fileBtn.select();
     var imgSrc = document.selection.createRange().text;
     //图片异常的捕捉，防止用户修改后缀来伪造图片
     try{
     fileTxt.value = imgSrc;
     }catch(e){
     alert("您上传的图片格式不正确，请重新选择!");
     return false;
     }
     document.selection.empty();
     }*/

}
/*下拉列表框*/
function selectModel() {
    var $box = $('div.select-box-one');
    var $option = $('ul.select-option', $box);
    var $txt = $('div.select-text-one', $box);
    var speed = 10;
    var zindex = 3;
    /*
     * 当机某个下拉列表时，显示当前下拉列表的下拉列表框
     * 并隐藏页面中其他下拉列表
     */
    $txt.click(function(e) {
        $option.not($(this).siblings('ul.select-option')).slideUp(speed, function() {
            int($(this));
        });
        zindex++;
        $(this).parent().css('zIndex', zindex);
        $(this).siblings('ul.select-option').slideToggle(speed, function() {
            int($(this));
        });
        return false;
    });
    //点击选择，关闭其他下拉
    /*
     * 为每个下拉列表框中的选项设置默认选中标识 data-selected
     * 点击下拉列表框中的选项时，将选项的 data-option 属性的属性值赋给下拉列表的 data-value 属性，并改变默认选中标识 data-selected
     * 为选项添加 mouseover 事件
     */
    $option.find('li')
        .each(function(index, element) {
            if ($(this).hasClass('seleced')) {
                $(this).addClass('data-selected');
            }
        })
        .mousedown(function() {
            //赋值操作
            $(this).parent().siblings('div.select-text-one').text($(this).text()).attr('data-value', $(this).attr('data-option'));
            $(this).parent().siblings('input').val( $(this).attr('data-option'));
            $option.slideUp(speed, function() {
                int($(this));
            });
            $(this).addClass('seleced data-selected').siblings('li').removeClass('seleced data-selected');
            return false;
        })
        .mouseover(function() {
            $(this).addClass('seleced').siblings('li').removeClass('seleced');
        });
    //点击文档，隐藏所有下拉
    $(document).click(function(e) {
        $option.slideUp(speed, function() {
            int($(this));
        });
    });
    //初始化默认选择
    function int(obj) {
        obj.find('li.data-selected').addClass('seleced').siblings('li').removeClass('seleced');
    }
}
$(function() {
    /*下拉列表框*/
    //selectModel();
    /*上传file*/
    //uploadFile();
    /*input提示*/
    $('input.inpTxt').focus(function(){
        if($(this).val() == $(this).attr('data-val')){
            $(this).val('').css('color', '#244C6B');
        }
    });
    $('input.inpTxt').blur(function(){
        if($(this).val() == $(this).attr('data-val') || $(this).val() == '' || $(this).val().trim() == ''){
            $(this).val($(this).attr('data-val')).css('color', '#74ABD1');
        }
    });
    /*密码框提示*/
    /*$('input.inpPwdTxt').focus(function(){
     $(this).css('display', 'none').siblings().css('display', 'block');
     });
     $('input.inpPwd').blur(function(){
     if($(this).val() == $(this).attr('data-val') || $(this).val() == '' || $(this).val().trim() == ''){
     $(this).val($(this).attr('data-val'));
     }
     });*/
    $("input.password_input").blur(function(){
        if($(this).val()==""){
            $(this).val("密码");
            if($(this).attr("type") == "password"){
                $(this).hide();
                $(this).siblings().show();
                $(this).siblings().val("密码");

            }
            else{
                var pass = $(this).siblings().val();
                if(pass.length<1){
                    $(this).hide();
                    $(this).siblings().show();
                }
            }
        }
    });
    $("input.password_text").focus(function(){
        if($(this).val()=="密码")
        {
            $(this).val("");
            if($(this).attr("type")=="text"){
                $(this).hide();
                $(this).siblings().show();
                $(this).siblings().val("");
                $(this).siblings().focus();//加上
            }else{
                var pass = $(this).siblings().val();
                if(pass.length<1){
                    $(this).hide();
                    $(this).show();
                }
            }
        }
    });
    /*tag标签选择*/
    $('.td-keyword').find('a').click(function(){
        if($(this).hasClass('cur')){
            $(this).removeClass('cur');
        }else{
            $(this).addClass('cur');
        }
    });
    /*统计页面区域选择*/
    $('.selectBox').find('a').click(function(){
        if(!$(this).hasClass('cur')){
            $(this).addClass('cur').siblings().removeClass('cur');
        }
    });
});
/*主框架高度自适应*/
$(function(){
    setMainHeight();
});
$(window).resize(function(){
    setMainHeight();
});
/*主框架高度自适应*/
function setMainHeight(){
    var winW = $(window).width();
    var winH = $(window).height();
    if($('#content').height() < (winH-10)){
        $('#content .content').css({'height':winH-10});
    }
}
/*ie7、8表格奇偶数样式 */
$(function(){
    if(navigator.userAgent.indexOf("MSIE")!=-1){
        var version = navigator.appVersion.split(";")[1].replace(/[ ]/g,"");
        if(version == "MSIE7.0" || version == "MSIE8.0") {
            $('.list-table tbody tr:nth-child(2n)').css('background-color', '#eeeeee');
            $('.list-table tbody tr:nth-child(2n-1)').css('background-color', '#D2E3F0');
        }
    }
});
/*radio box*/
$(function(){
    $(".yd_numlist input[type='radio']").click(function(){
        $(this).parents('.yd_numlist').find("input[type='radio']").prop("checked",false);
        $(this).prop("checked",true);
        $(this).parent().removeClass("r_off").addClass("r_on").siblings().removeClass("r_on").addClass("r_off");
        if($(this).attr("name") =='venueIsFree'|| $(this).attr("name") =='activityIsFreeLabel') {
            if($(this).val()==1){
                $("#charge").hide();
            }
            else{
                $("#charge").show();
            }
        }
        if($(this).attr("name") =='venueIsRoam') {
            if($(this).val()==1){
                $("#vRoam").hide();
            }
            else{
                $("#vRoam").show();
            }
        }

    });
});
/*check box*/
$(function(){
    $(".yd_numlist input[type='checkbox']").click(function(){
        if($(this).parent().hasClass('r_off')){
            $(this).prop("checked",true);
            $(this).parent().removeClass("r_off").addClass("r_on");
        }else{
            $(this).prop("checked",false);
            $(this).parent().removeClass("r_on").addClass("r_off");
        }
    });
});
/*弹出框事件*/
function confirmDialog(dialogTit, dialogcontent, url){
    jConfirm(dialogcontent, dialogTit, function(r) {
        if(r){
            //jAlert('操作成功',dialogTit);
            window.location.href = url;
        }
    });
}


///*input file框*/
//$(function() {
//    $("input.file-image").filestyle({
//        image: "image/file-image.png",
//        imageheight : 40,
//        imagewidth : 80,
//        width : 320
//    });
//    $("input.file-audio").filestyle({
//        image: "image/file-audio.png",
//        imageheight : 40,
//        imagewidth : 80,
//        width : 320
//    });
//    $("input.file-video").filestyle({
//        image: "image/file-video.png",
//        imageheight : 40,
//        imagewidth : 80,
//        width : 320
//    });
//});