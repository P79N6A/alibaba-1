<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
    
    	<%-- <link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/component.css" /> --%>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/gridify.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery.imagesloaded.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/masonry.pkgd.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/modernizr.custom.js"></script>
      <script type="text/javascript" src="${path}/STATIC/wxStatic/js/AnimOnScroll.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wxStatic/js/classie.js"></script>
      
    <script type="text/javascript" src="${path}/STATIC/wechat/js/wechat.js"></script>
    <script type="text/javascript" src="${path}/STATIC/wx/js/wxcommon.js"></script>
    
    <script type="text/javascript">
        var str = "";
        var str1 = "";
        var str2 = "";
        var venueId = '${venueId}';
        
        var antiqueTypeName="";
		var antiqueDynasty="";
		
		var startIndex = 0;		//页数
		var pageSize=10;
        
        $(function () {
            loadData(startIndex, pageSize);
            
        });
        
        var title='馆藏列表';
        
        if(!venueId)
        {
        	title='艺术品鉴';
        }
        
        if(window.injs){	//判断是否存在方法
			injs.changeNavTitle(title); 
		}else{
			$(document).attr("title",title);
		}	
     
        function screenAppAntique(startIndex,pageSize){
        	
        	  $.post("${path}/wechatAntique/screenAppAntique.do", {
                  antiqueTypeName: antiqueTypeName,
                  antiqueDynasty: antiqueDynasty,
                  venueId: venueId,
                  pageNum: pageSize,
                  pageIndex: startIndex
              }, function (data) {
                  str = "";
                  if (data.status == 0) {
                	  
                 	 if(data.data.length<pageSize)
                 		$("#loadingDiv").hide();
                 	 
                 	 $("#loading").fadeOut();
                	
                      $.each(data.data, function (i, dom) {
                    	  str += appendDom(dom);
                      });
               
                  	/* applyLayout(); */
                  }
              }, "json");
        }
        
        function loadData(index, pagesize) {
            pageSize = pagesize;
            startIndex = index;
            //载入搜索结果
            var data = {
                venueId: venueId,
                pageIndex: startIndex,
                pageNum: pageSize
            };
            $.post("${path}/wechatAntique/antiqueAppIndex.do", data, function (data) {
               // $("#antiqueList").html('');
            //    $("#genre_list").html('');
             //  $("#dynasty_list").html('');
                str = "";
                str1 = "";
                str2 = "";
                if (data.status == 0) {
                	$("#antiqueTotal").html(data.data3);
                	
                	 $("#loading").fadeOut();
                	
                    $.each(data.data, function (i, dom) {
                    	
                    	 str += appendDom(dom);
                    });
                   
                	/* applyLayout(); */
                	
                	 //  str1 += "<a onclick=\"loadData(0, 999)\">查看全部</a>";
                    $.each(data.data1, function (i, dom) {
                    	
                    	str1 += "<p>"+dom.antique+"</p>";
                       // str1 += "<a onclick=\"antiqueType('" + dom.antique + "')\">" + dom.antique + "</a>";
                    });
                    $("#genre_list").append('<p>查看全部</p>');
                    $("#genre_list").append(str1);
                    $.each(data.data2, function (i, dom) {
                    	
                    	str2 += "<p>"+dom.dynasty+"</p>";
                    	//  str2 += "<a onclick=\"antiqueDynasty('" + dom.dynasty + "')\">" + dom.dynasty + "</a>";
                    });
                    $("#dynasty_list").append('<p>查看全部</p>');
                    $("#dynasty_list").append(str2);
                }
            }, "json");
        };
        
        function appendDom(dom){
        	
        	var img_url = getIndexImgUrl(dom.antiqueImgUrl, "_300_300");
        	
        	var img = new Image()
			img.src = img_url;
        	
        	var str ='<li class="pb" style="display:none;" id="'+dom.antiqueId +'" onclick="javascript:location.href=\'${path}/wechatAntique/preAntiqueDetail.do?antiqueId='+ dom.antiqueId+'\'">'+
			'<img src="'+img_url +'" width="360" >' +
			'<p class="artTitle">'+dom.antiqueName+'</p>'+
		'</li>';

        	img.onload = function(){
				$(antiqueListH()).append(str);
				$("#"+dom.antiqueId).fadeIn(300)
			}
        	
        	img.onerror= function(){
				$(antiqueListH()).append(str);
				$("#"+dom.antiqueId).fadeIn(300)
			}
        	
        	 return str;
        }
        
       /*  function applyLayout() {
        	
        	new AnimOnScroll(document.getElementById('grid'), {
				minDuration: 0.4,
				maxDuration: 0.7,
				viewportFactor: 0.2
			});
        
          } */
        
        //计算UL的高度
        function antiqueListH() {
			var height = $("#antiqueList1").height() > $("#antiqueList2").height() ? '#antiqueList2' : '#antiqueList1';
			return height;
		}

        
        $(function() {
			
			
			$(".dropdownMenu>ul>li").click(function() {
				var num = $(this).index()
				$(".dropdownMenu").hide();
				$(".dropdownList>ul>li").eq(num).fadeIn()
				$(".dropdown").css({
					"width":"200px",
					"height":"300px"
				})
			})
			$(".dropdownCbtn").click(function(){
				$(".dropdownList>ul>li").hide()
				$(".dropdownMenu").fadeIn()
				$(".dropdown").css({
					"width":"400px",
					"height":"60px"
				})
			})

			
			
				
			$('#genre_list').on('click','p',function(){
				
				var text=$(this).html();
				
				if(text=='查看全部'){
					antiqueTypeName='';
					$("#data-menu2").html('分类');
				}
				else
				{
					antiqueTypeName=text;
					$("#data-menu2").html(text);
				}

					$(".dropdownList>ul>li").hide()
					$(".dropdownMenu").fadeIn()
					$(".dropdown").css({
						"width":"400px",
						"height":"60px"
					})
				
				$("#antiqueList1").html('');
				$("#antiqueList2").html('');
				$("#loading").show();
				startIndex = 0;		//页数
				screenAppAntique(startIndex,pageSize);
				
			});
			
			$('#dynasty_list').on('click','p',function(){
				
				var text=$(this).html();
				
				if(text=='查看全部'){
					antiqueDynasty='';
					$("#data-menu3").html('朝代');
				}
				else{
					antiqueDynasty=text;
					$("#data-menu3").html(text);
				}

					$(".dropdownList>ul>li").hide()
					$(".dropdownMenu").fadeIn()
					$(".dropdown").css({
						"width":"400px",
						"height":"60px"
					})
				
				$("#antiqueList1").html('');
				$("#antiqueList2").html('');
				startIndex = 0;		//页数
				screenAppAntique(startIndex,pageSize);
				
			});
			
		})
        
        
    </script>
	<style>
	.grid li{
	float:none;}
		.data-menu2, .data-menu3{
		background:url(${path}/STATIC/wechat/image/arrow_down.png) no-repeat center right;
		}
		#antiqueList1,
#antiqueList2 {
	width: 362px;
	margin: auto;
}

#antiqueList1 li,
#antiqueList2 li {
	width: 360px;
	border: 1px solid #262626;
	margin-bottom: 20px;
}

#antiqueList1 li img,
#antiqueList2 li img{
	width: 360px;
	display: block;
	margin: auto;
}
	</style>
</head>
<body>

	<div class="artDisMain" >
	
	<!--loding-->
			<div id="loading" style="position: fixed;top: 0;right: 0;bottom: 0;left: 0;margin: auto;background-color: #fff;z-index: 9;">
				<img src="${path}/STATIC/wechat/image/bigLoading.gif" style="position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;" />
			</div>
	
			<div  class="content margin-top100">
			
		<!--  <div class="search_top">
		    <div class="l_arrow fl" style="margin-top: 32px;"><a href="javascript:history.back(-1);"><img src="${path}/STATIC/wechat/image/arrow1.png"/></a></div>
		    <div class="look fl" style="margin-left: 210px;">共计<span id="antiqueTotal"></span>件藏品</div>
		    <div class="clear"></div>
		</div>-->
		<%-- <div class="data-menu" style="width: 300px;">
		    <a class="genre data-menu2" data-id="">分类</a>
		    <a class="dynasty data-menu3" data-id="">朝代</a>
		    <div style="clear: both;"></div>
		    <div class="data-menu2-on">
				<div class="close-button ">
							<img src="${path}/STATIC/wechat/image/arrow_down.png" />
						</div>
						 <div class="genre_list" id="genre_list">
					    </div>
					</div>
					<div class="data-menu3-on">
						<div class="close-button ">
							<img src="${path}/STATIC/wechat/image/arrow_down.png" />
						</div>
						 <div class="dynasty_list" id="dynasty_list">
					    </div>
					</div>
				</div>	
		</div> --%>
		<div class="dropdown" style="width:400px">
				<div class="dropdownMenu">
					<ul>
						<li id="data-menu2" style="width:45%;background: url(${path}/STATIC/wechat/image/arrow_down.png) no-repeat center right;">分类</li>
						<li id="data-menu3" style="width:45%;background: url(${path}/STATIC/wechat/image/arrow_down.png) no-repeat center right;">朝代</li>
						<!-- <li>排序</li> -->
						<div style="clear: both;"></div>
					</ul>
				</div>
				<div class="dropdownList">
					<ul>
						<li>
							<div class="dropdownCbtn">
								<img src="${path}/STATIC/wechat/image/arrow_down.png" />
							</div>
							<div class="dropdownListMenu">
								<div id="genre_list">
									
								</div>
							</div>
						</li>
						<li>
							<div class="dropdownCbtn">
								<img src="${path}/STATIC/wechat/image/arrow_down.png" />
							</div>
							<div class="dropdownListMenu">
								<div id="dynasty_list">
									
								</div>
							</div>
						</li>
						<!-- <li>
							<div class="dropdownCbtn">
								<img src="image/arrow.png" />
							</div>
							<div class="dropdownListMenu">
								<div>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
									<p>333</p>
								</div>
							</div>
						</li> -->
					</ul>
				</div>
			</div>
		<div id="antiqueList" class="collect_display clearfix grid" style="position: relative">
			<div style ="width: 50%;float: left;">
						<ul id="antiqueList1">

						</ul>
					</div>
					<div style="width: 50%;float: left;">
						<ul id="antiqueList2">
							
						</ul>
					</div>
		</div>
	<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span  class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	</div>
</div>

</body>
<script type="text/javascript">
		$(document).ready(function() {
			//顶部菜单显示隐藏
			$(window).scroll(function() {
				if ($(document).scrollTop() > 100) {
					$(".header").css("top", "0px")
				} else {
					$(".header").css("top", "-100px")
				}
			})
			
			//滑屏分页
	        $(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight)-30) {
	           		startIndex += pageSize;
	           		var index = startIndex;
	           		setTimeout(function () { 
	           			screenAppAntique(index, pageSize);
	           		},300);
	            }
	        });
		});
		
	</script>

</html>