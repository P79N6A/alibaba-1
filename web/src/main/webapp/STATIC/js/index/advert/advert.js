/**
 * 点击区县索引动态加载banner图片
 */

/*		$.get(path+"/frontActivity/getAdvertImg.do?siteId="+code,function(data){
 if(data.length!=0){
 $("#in-top .in-ban").html(getAdvertHtml(data));
 jQuery(".in-ban").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:600, trigger:"click"});
 }else{*/

$(document).ready(function(){
	$("#area_div a").click(function(){
		var code = $(this).attr("data-option");
		if(typeof(code)=="undefined" || code==""){
			code="45";
		}
		var path = $("#path").val();

		$.post(path+"/frontActivity/getAdvertImg.do?siteId="+code+"&version="+new Date().getTime(),function(data){
					if(data.length!=0){
						$("#in-top .in-ban").html(getAdvertHtml(data));
						jQuery(".in-ban").slide({ titCell:".in-ban-icon", mainCell:".in-ban-img",effect:"fold", autoPlay:true, autoPage:true, delayTime:600, trigger:"click"});
					}else{
					}
				});
	});
});
function getAdvertHtml(data){
	var htmlimg = "";
	var htmlindex="";
	htmlimg += "<ul class='in-ban-img'>";
	htmlindex += "<ul class='in-ban-icon'>";
	var imgUrl='';
	var connectUrl='';
	for(var i in data){
		imgUrl = getIndexImgUrl(getImgUrl(data[i].advertPicUrl),"");
		connectUrl=data[i].advertConnectUrl;
		if(""==connectUrl||connectUrl.indexOf("http")==-1){
			connectUrl="#";
			htmlimg += "<li><a href='#'><img src='"+imgUrl+"' "+ "width='1200' height='530'/></a></li>";
		}else{
			htmlimg += "<li><a target='_blank' href='"+connectUrl+"'><img onload='fixImage(this,1200,530)' src='" + imgUrl + "'/></a></li>";
		}
		if(i==0){
			htmlindex += "<li class='on'></li>";
		}else{
			htmlindex += "<li></li>";
		}
	}
	htmlimg += "</ul>";
	htmlindex += "</ul>";
	return  htmlimg+htmlindex;
}

$(function(){
	//$("#area_div a").eq(0).click();
});
