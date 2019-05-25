$(function(){
    showCultureList();
    showPhoneList();
    showCutPageList();
});

// 年俗文化展示列表显示
function showCultureList(){
    $("#cultureShowDiv").load("../mc/indexCultureShowLoad.do #cultureShowDivChild",null,function(){
        showCultureImg();
    });
}

// 年俗文化展示列表显示图片
function showCultureImg(){
    $("#cultureShowDivChild li").each(function(index,item){
        var url = $(item).attr("data-url");
        $(item).find("img").attr("src", getImgUrl(url));
    });
}

// 团团圆圆照相馆显示
function showPhoneList(){
    $("#phoneDiv").load("../mc/indexPhoneLoad.do #phoneDivChild",null,function(){
        showPhoneImg();
    });
}

// 团团圆圆照相馆图片显示
function showPhoneImg(){
    $("#phoneDivUl a").each(function(index,item){
        var url = $(item).attr("data-url");
        $(item).find("img").attr("src", getImgUrl(url));
    });
}

// 剪纸与上海闲话显示
function showCutPageList(){
    $("#cutPageDiv").load("../mc/indexCutPageLoad.do #cutPageDivChild",null,function(){
        showCutPageImg();
    });
}

// 剪纸与上海闲话图片显示
function showCutPageImg(){
    $("#cutPageDivChild li").each(function(index,item){
        var url = $(item).attr("data-url");
        $(item).find("img").attr("src", getImgUrl(url));
    });
}


