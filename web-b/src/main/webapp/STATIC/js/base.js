/**
 * Created by minh on 2015/6/29.
 */

$(function(){
    $(".input-text").focus(function(){
        if($(this).val() == $(this).attr("data-val") || $(this).val() == "" || $(this).val() == null){
            $(this).val("").css("color", "#13213F");
        }
    });
    $(".input-text").blur(function(){
        if($(this).val() == $(this).attr("data-val") || $(this).val() == "" || $(this).val() == null){
            $(this).val($(this).attr("data-val")).removeAttr('style');
        }
    });
    $(".input-text").each(function(){
        if($(this).val() == $(this).attr("data-val") || $(this).val() == "" || $(this).val() == null){
            if(this.tagName != "TEXTAREA"){
                $(this).val($(this).attr("data-val")).removeAttr('style');
            }
        }
    });
    $(".main-publish .room-time-set tr:odd").addClass("odd");
    $(".main-content tbody tr:odd").addClass("odd");
    $(".main-content tbody tr").on({
        mouseover: function(){  $(this).addClass("current"); },
        mouseout: function(){  $(this).removeClass("current"); }
    });
    /*tag标签选择*/
    $('.td-tag').find('a').click(function(){
        if($(this).attr("disable") == "true") return;
        if($(this).hasClass('cur')){
            $(this).removeClass('cur');
        }else{
            $(this).addClass('cur');
        }
    });
    /*是否收费*/
    $(".form-table .td-fees").on("click", "input[type=radio]", function(){
        if($(this).val() == "yes"){
            $(this).parents(".td-fees").find(".extra").css("display", "inline-block");
        }else{
            $(this).parents(".td-fees").find(".extra").css("display", "none");
        }
    });
    /*活动馆藏情况*/
    $(".form-table .td-collection").on("click", "input[type=radio]", function(){
        var thatSiblings = $(this).parent().siblings(".venue-type");
        if($(this).val() == "yes"){
            thatSiblings.each(function(){
                if($(this).attr("data-status") == "block") {
                    $(this).css("display", "inline-block");
                }
            });
        }else{
            thatSiblings.each(function(){
                if($(this).attr("data-status") == "block") {
                    $(this).css("display", "none");
                }
            });
        }
    });
    /*出生日期选择*/
    $(".birthList").on("change", "select", function(){
        var selectVal =  $(this).find("option:selected").text();
        var textDom = $(this).parent().find(".caption");
        if(selectVal == "请选择所属团体"){
            textDom.addClass("default");
        }else {
            textDom.removeClass("default")
        }
        textDom.text(selectVal);
    })
    /*下拉列表框*/
    //selectModel();
});
/*下拉列表框*/
function selectModel(fn) {
    var $box = $('div.select-box');
    var $option = $('ul.select-option', $box);
    var $txt = $('div.select-text', $box);
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
            var $this = $(this);
            var $input = $this.parents(".select-box").find("input");
            if($input.length > 0){
                var $selectTxt = $input.next(".select-text");
                var $val = $input.val();
                var $data = $this.attr("data-option");
                if($data == $val){
                    $this.addClass("seleced");
                    $selectTxt.text($this.text());
                }
            }
            if ($(this).hasClass('seleced')) {
                $(this).addClass('data-selected');
            }
        });
    $option.on({
        mousedown: function(){
            //赋值操作
            $(this).parent().siblings('div.select-text').text($(this).text()).attr('data-value', $(this).attr('data-option'));
            $(this).parent().siblings('input').val( $(this).attr('data-option')).attr("data-txt", $(this).html());
            if(fn){ fn();}
            $option.slideUp(speed, function() {
                int($(this));
            });
            $(this).addClass('seleced data-selected').siblings('li').removeClass('seleced data-selected');
            return false;
        },
        mouseover: function(){
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
/**/
function dialogConfirm(title, content, fn){
    var d = dialog({
        width:400,
        title:title,
        content:content,
        fixed: true,
        button:[{
            value: '确定',
            callback: function () {
                if(fn)  fn();
                //this.content('你同意了');
                //return false;
            },
            autofocus: true
        },{
            value: '取消'
        }]
    });
    d.showModal();
}



function dialogInitImgConfirm(title, content, fn){
    var d = dialog({
        //width:440,
        title:title,
        content:content,
        fixed: true,
        button:[{
            value: '确定',
            callback: function () {
                if(fn)  fn();
                //this.content('你同意了');
                //return false;
            },
            autofocus: true
        },{
            value: '取消'
        }]
    });
    d.showModal();
}






function dialogAlert(title, content, fn){
    var d = dialog({
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
/*保存草稿箱*/
function dialogSaveDraft(title, content, fn){
    var d = dialog({
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

function getImg(url){
    var imgHeight,imgWidth,layerLeft,layerTop;
    $('<div id="layer-bg"></div>').show().appendTo($("body"));
    var winW = $(window).width();
    var winH = $(window).height();
    layerLeft = Math.floor((winW - 52)/2) + "px";
    layerTop = Math.floor((winH - 52)/2) + "px";
    $('<div id="layer-imgBox" style="left:'+ layerLeft +';top:'+ layerTop +';"><img src="image/loading.gif"/></div>').show().appendTo($("body"));
    /*获取大图的宽高*/
    var start_time = new Date().getTime();
    var img_url = url + '?' + start_time;
    var img = new Image();
    img.src = img_url;
    // 定时执行获取宽高
    var check = function(){
        // 只要任何一方大于0，清除定时器
        if(img.width > 0 || img.height > 0){
            clearInterval(timer);
        }
    };
    var timer = setInterval(check, 40);
    // 加载完成获取图片宽高
    img.onload = function(){
        if(img.width / img.height  >= winW/winH){
            imgWidth = Math.floor(Math.min(img.width, winW*0.8));
            imgHeight = parseInt((img.height*imgWidth)/img.width)
        }else{
            imgHeight = Math.floor(Math.min(img.height, winH*0.8));
            imgWidth = parseInt((img.width*imgHeight)/img.height);
        }
        layerLeft = Math.floor((winW - imgWidth)/2);  //layer的marginLeft
        layerTop = Math.floor((winH - imgHeight)/2);    //layer的marginTop
        var htmlTxt = '<div class="layer-imgBox"><img src="'+ img_url +'" alt="" width="'+ imgWidth +'" height="'+ imgHeight +'"/><a class="layer-close"></a></div>';
        $('#layer-imgBox').html(htmlTxt).animate({"left": layerLeft, "top": layerTop, "width": imgWidth, "height": imgHeight});
        /*关闭按钮*/
        $("#layer-imgBox .layer-close").on("click", function(){
            $("#layer-imgBox").fadeOut(function(){ $(this).remove();});
            $("#layer-bg").fadeOut(function(){ $(this).remove();});
        });
    };
}
/*显示select 数据*/
function showSelectData(el_id, url, title, selected_id, fn) {
    var el	= $('#'+el_id);
    el.empty();
    el.append('<option value="">'+ title +'</option>');

    el.select2();
   /* el.change(function() {

        fn();
    })*/

    if (selected_id) {
        loadingSelectData(el_id, url,  selected_id);
    } else {
        loadingSelectData(el_id, url);
    }
}
/*加载select 数据*/
function loadingSelectData(el_id , url , selected_id){
    var el	= $('#'+el_id);
    if(url) {
        $.post(url, {}, function (data) {
            if (data) {
                var index = 1;
                var selected_index = 0;
                $.each(data, function (k, v) {
                    var option	= '<option value="'+data[k].userId+'">'+data[k].userNickName+'</option>';
                    el.append(option);
                    if (data[k].id == selected_id) {
                        selected_index = index;
                    }
                    index++;
                });
                //el.attr('selectedIndex' , selected_index);
            }
        }).success(function(){
            el.select2("val", selected_id);   /*赋默认值*/
        });
    }
    el.select2("val", "");
}

function imgCheck(src){
	
	var img=new Image();  
	img.src=src;
	
	var width ;
	var height ;
	
	img.onload = function(){ 
	    //原始宽度
	    width = this.width;
	    //原始高度
	    height = this.height
	    
	  
	    if(window.parent.dialog)
	    	window.parent.dialog({
	    		 padding: 0,
	            title: '图片预览',
	            content: '<img style="max-height:1000px;max-width:1000px;" src="'+src+'" width="'+width+'" height="'+height+'" />',
	            center:true,  
	            fixed: false,
	            onclose: function () {
	            }
	        }).showModal();
	    	else
	    		dialog({
	    			 padding: 0,
	    			  content: '<img style="max-height:1000px;max-width:1000px;" src="'+src+'" width="'+width+'" height="'+height+'" />',
	    	        title: '图片预览',
	    	        center:true,  
	    	        fixed: false,
	    	        onclose: function () {
	    	        }
	    	    }).showModal();
	}
	
	
}

/**大图展示**/
$(function(){
    $("#commentImg").on("click", ".pld_img img", function(){
        var urls=$(this).attr("src");
        var startUrl = "";
        var endUrl = urls.substr(urls.lastIndexOf("."));
        if(urls.indexOf("_") != -1){
            startUrl = urls.substr(0,urls.indexOf("_"));
        }else{
            startUrl = urls.substr(0,urls.lastIndexOf("."));
        }
        urls = startUrl + endUrl;
        $(this).parent().parent().find(".fd_img").attr("src", urls);
        //$(".after_img").children(".fd_img").attr("src",urls);
        $(".yuantu").attr("href",urls);
        // $(".after_img").show();
        $(this).parent().parent().find(".after_img").show();
    });

    $("#commentImg").on("click", ".shouqi", function(){
        //$(".after_img").hide();
        $(this).parent().parent().hide();
    });
    
    $(".bigCheck").on("click",function(){
		var img_src = $(this).attr('src');
		
		var i=img_src.indexOf("@");
		
		if(i>-1){
			img_src=img_src.substring(0,i);
		}
		
		imgCheck(img_src);
	})	
});

//String扩展，兼容ie8
String.prototype.trim = function ()
{
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.ltrim = function ()
{
    return this.replace(/(^\s*)/g, "");
}
String.prototype.rtrim = function ()
{
    return this.replace(/(\s*$)/g, "");
}