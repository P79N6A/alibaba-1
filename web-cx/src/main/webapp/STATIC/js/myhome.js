/**
 * Created by xiaoyj on 2015/4/22.
 */
/*下拉列表框*/
function selectModel(fn) {
    var $box = $('div.select-box-one');
    var $option = $('ul.select-option', $box);
    var $txt = $('div.select-text-one', $box);
    var speed = 10;
    /*
     * 当机某个下拉列表时，显示当前下拉列表的下拉列表框
     * 并隐藏页面中其他下拉列表
     */
    $txt.click(function(e) {
        $option.not($(this).siblings('ul.select-option')).slideUp(speed, function() {
            int($(this));
        });
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
    $option.find('li').each(function(index, element) {
        if ($(this).hasClass('seleced')) {
            $(this).addClass('data-selected');
        }
    });
    $option.on({mousedown:function() {
        //赋值操作
        $(this).parent().siblings('div.select-text-one').text($(this).text()).attr('data-value', $(this).attr('data-option'));
        //if ($(this).attr('data-option') != null && $(this).attr('data-option') != '' && $(this).attr('data-option') != undefined && $(this).attr('data-option') !='undefined'){
        $(this).parent().siblings('input').val($(this).attr('data-option'));
        //}

        if (fn) {
            console.log("log in fn: " + $(this).attr('data-option') + "," + $(this).text());
            //if ($(this).attr('data-option') != ''){
            //    fn(($(this).attr('data-option') + ","+encodeURI(encodeURI($(this).text()))));
            //} else {
            //    fn(($(this).attr('data-option')));
            //}
            fn();
        }
        $option.slideUp(speed, function () {
            int($(this));
        });
        $(this).addClass('seleced data-selected').siblings('li').removeClass('seleced data-selected');
        return false;
    },mouseover:function() {
        $(this).addClass('seleced').siblings('li').removeClass('seleced');
    }
    },"li");
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
    /*input提示*/
    $('input.inpTxt').focus(function(){
        if($(this).val() == $(this).attr('data-val')){
            $(this).val('').css({'color':'#333333'});
        }
    });
    $('input.inpTxt').blur(function(){
        if($(this).val() == $(this).attr('data-val') || $(this).val() == '' || $(this).val().trim() == ''){
            $(this).val($(this).attr('data-val')).css({'color':'#bbbbbb'});
        }
    });
    /*user input提示*/
    $('input.userInput').focus(function(){
        if($(this).val() == $(this).attr('data-val')){
            $(this).val('').css({'color':'#ffffff'});
        }
    });
    $('input.userInput').blur(function(){
        if($(this).val() == $(this).attr('data-val') || $(this).val() == '' || $(this).val().trim() == ''){
            $(this).val($(this).attr('data-val')).css({'color':'#ffffff'});
        }
    });
    /*密码框提示*/
    $("input.password_input").blur(function(){
        if($(this).val()==""){
            $(this).val("密码");
            if($(this).attr("type") == "password"){
                $(this).hide();
                $(this).siblings().show();
                $(this).siblings().val($(this).siblings().attr("data-val"));

            }else{
                var pass = $(this).siblings().val();
                if(pass.length<1){
                    $(this).hide();
                    $(this).siblings().show();
                }
            }
        }
    });
    $("input.password_text").focus(function(){
        if($(this).val()== $(this).attr("data-val")){
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
    /*导航当前样式*/
    var webUrlStr = window.location.href.split("/");
    var webUrl = webUrlStr[webUrlStr.length-1];

     if(webUrl.indexOf("?")>0){
         webUrl=webUrl.split("?")[0];
     }
    $('#top-nav .main-nav a').each(function(){
        if(webUrl=='antiqueDetail.do'){
            //默认选中当前label
           $('#venueLabel').addClass('cur').siblings().removeClass('cur');
        }
        if($(this).attr("data-url") == webUrl){
          $(this).addClass('cur').siblings().removeClass('cur');
        }
    });
    /*我的收藏-删除*/
    $(".activity-main .my-collection").on("click","ul li .delete", function(){
        $(this).parent().fadeOut(function(){
            $(this).remove();
        });
    })
});
/*radio box*/
$(function(){
    $(".yd_numlist input[type='radio']").click(function(){
        $("input[type='radio']").prop("checked",false);
        $(this).prop("checked",true);
        $(this).parent().removeClass("r_off").addClass("r_on").siblings().removeClass("r_on").addClass("r_off");
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
/*活动日历*/
$(function(){
    var  day = new Date();  /*要显示的数据月份*/
    //获取天数：
    var yearNum = day.getFullYear();  /*当前的年份*/
    var monthNum = day.getMonth();  /*当前的月份*/
    var daycount = new Date((yearNum-1),(monthNum+1),0).getDate(); /*当前月份的天数*/
    var week = new Date(yearNum,monthNum,1).getDay();  /*当前月份第一天的星期*/
    $('#month-calendar li:gt('+ (daycount-1) +')').css({'display':'none'});
    if(week == 0){ week = 7;}
    for(var i = 0; i < week; i++){
        $('<li class="gray"></li>').insertBefore($('#month-calendar li').eq(0));
    }
});
$(window).resize(function(){
    setPopupPosition('pop_layer');
});
/*弹出框*/
function showPopupLayer(url, objW){
    if($('#pop_layer_bg').length <= 0){
        $('body').append('<div id="pop_layer_bg" style="display: none;"></div>');
    }else{
        $('#pop_layer_bg').css('display', 'none');
    }
    var layerW = objW ? objW : 540;
    $('body').append('<div id="pop_layer" style="width:'+ layerW +'px;"><iframe style="background-color:transparent;" allowtransparency="true" id="show_login" frameborder="0" scrolling="no" width="'+ layerW +'" height="auto" ></iframe></div>');
    load();
    var iframe;
    /*iframe加载事件*/
    function load() {
        iframe = document.getElementById("show_login");
        iframe. onload = iframe. onreadystatechange = iframeload;
        iframe.src = url;
    }
    /*判断iframe是否加载完成，加载完成之后iframe显示*/
    function iframeload() {
        if (!iframe.readyState || iframe.readyState == "complete") {
            $('#pop_layer_bg').fadeIn(function(){
                $('#show_login').fadeIn();
            });
            /* $('#pop_layer_bg').css('display', 'block');
             iframe.style.display = 'block';*/
            iFrameHeight();
        }
    }
    /*获取iframe的高度*/
    function iFrameHeight() {
        var ifm= document.getElementById("show_login");
        var subWeb = document.frames ? document.frames["show_login"].document : ifm.contentDocument;
        if(ifm != null && subWeb != null) {
            ifm.height = subWeb.body.scrollHeight;
        }
        setPopupPosition('pop_layer');
    }
    $('#pop_layer_bg').click(function(){
        $('#pop_layer').fadeOut(function(){
            $('#pop_layer').remove();
        });
        $(this).fadeOut(function(){
            $(this).remove();
        });
        /*$('#pop_layer').remove();
         $(this).remove();*/
    });
}
/*关闭弹出框*/
function closeLayerPopup(){
    //window.parent.$('#pop_layer_bg').remove();
    window.parent.$('#pop_layer').fadeOut(function(){
        $(this).remove();
    });
    window.parent.$('#pop_layer_bg').fadeOut(function(){
        $(this).remove();
    });
}
/*设置弹出框的位置*/
function setPopupPosition(cls){
    var obj = $('#'+cls);
    var objTop = parseInt(($(window).height() - $(obj).height())/2);
    var objLeft = parseInt(($(window).width() - $(obj).width())/2);
    if(objTop > 0){
        obj.css('top', objTop);
    }else{
        obj.css('top', '0px');
    }
    if(objLeft > 0){
        obj.css('left', objLeft);
    }else{
        obj.css('left', '0px');
    }
    if(isMobile()){
        obj.css({'position': 'absolute'});
    }
}
/*判断是否用手机打开页面*/
function isMobile(){
    var browser={
        versions:function(){
            var u = navigator.userAgent, app = navigator.appVersion;
            return {
                //移动终端浏览器版本信息
                trident: u.indexOf('Trident') > -1, //IE内核
                presto: u.indexOf('Presto') > -1, //opera内核
                webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
                gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
                mobile: !!u.match(/AppleWebKit.*Mobile.*/)||!!u.match(/AppleWebKit/), //是否为移动终端
                ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
                android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
                iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
                iPad: u.indexOf('iPad') > -1, //是否iPad
                webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
            };
        }(),
        language:(navigator.browserLanguage || navigator.language).toLowerCase()
    }
    if( browser.versions.android || browser.versions.iPhone || browser.versions.iPad){
        return true;
    }else{
        return false;
    }
}