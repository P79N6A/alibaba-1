<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
	<title>文化培训</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/normalize.css" />
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
	<link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">

	<link type="text/css" rel="stylesheet" href="${path}/STATIC/css/zjStyleChild.css" />
	<script type="text/javascript" src="${path}/STATIC/js/jquery-1.9.0.js"></script>

	<script type="text/javascript" src="${path}/STATIC/js/owl.carousel.js"></script>

	<script type="text/javascript" src="${path}/STATIC/js/jquery.SuperSlide.2.1.1.js" ></script>
    <script src="${path}/STATIC/js/avalon.js"></script>
	<script type="text/javascript">
        var startIndex = 0;		//页数

        function loadDate (index, pagesize) {
            $.post("${path}/wechatTrain/trainList.do", {
                pageIndex: index,
                pageNum: pagesize,
				venueId:$('#venueId').val(),
				trainType:$('#trainType').val(),
				order:$('#order').val()
            }, function (data) {
                $("#loadingDiv").hide();
                if (data.status == 0) {
					var html = "";
					if(index==0 && data.data.length==0){
                        $(".peixunList").html('<img style="display: block;position: absolute; top: 0;right: 0;bottom: 0;left: 0; margin: auto;" src="${path}/STATIC/wechat/image/dh-peixun/kong.png" />');
                        return;
                    }
                    for(var i=0;i<data.data.length;i++){
                        var obj = data.data[i];
                        //var tag = obj.trainTag.substring(start,',');
                        html +='<li>' +
                            '<div class="pic" d-id="'+obj.id+'">' +
							'<div class="shadow"></div>'+
                            '<img src="'+data.data[i].trainImgUrl+'" />';
                        html +='<div class="pxLabel clearfix">';
                        var tag;
                        if(data.data[i].trainTag.indexOf(",")>-1){
                            var tag = data.data[i].trainTag.split(",")[0];
                        }else{
                            tag = data.data[i].trainTag;
                        }
                        html +='<span>'+tag+'</span></div>'+
							'<div class="culInfo">'+
                        '<div class="title">'+data.data[i].trainTitle+'</div>' +
                        '<div class="people"><i>'+obj.admissionsPeoples+'</i>/'+obj.maxPeople+'人</div>' +
                        '</div>';


                       /* $(obj.trainTag.split(',')).each(function(i,n){
                            html +='<span>'+n+'</span>'
                        });*/

                        html +='</div>';
                        var registrationStartTime = obj.registrationStartTime.replace(/-/g,'.');
                        var registrationEndTime = obj.registrationEndTime.replace(/-/g,'.');
                        var trainStartTime = obj.trainStartTime.replace(/-/g,'.');
                        var trainEndTime = obj.trainEndTime.replace(/-/g,'.');

                        html +='<div class="culMsg">'+
							'<div d-id="'+obj.id+'" class="char">' +
                            '<div class="time">报名时间：'+registrationStartTime+' - '+registrationEndTime+'</div>' +
                            '<div class="time">开课时间：'+trainStartTime+' - '+trainEndTime+'</div>' +
                            '</div>' ;
                            //'<div id="bottBox" d-id="'+obj.id+'" class="bottBox">';
							//html += '<div class="colImg"></div>';
                        if(obj.isCollect==1){
                            html += '<div id="bottBox" d-id="'+obj.id+'" class="bottBox bottBoxChoose">';
                            html += '<div class="colImg"></div>';
                            html += '<div class="collect">已收藏</div></div>';
                        }else{
                            html += '<div id="bottBox" d-id="'+obj.id+'" class="bottBox">';
                            html += '<div class="colImg"></div>';
                            html += '<div class="collect">收藏</div></div>';
                        }

							html += '</div>';

                            '</li>';
					}
					if(index==0){
                        $(".peixunList").html(html);
					}else{
                    	$(".peixunList").append(html);
					}

                    $(".peixunList li .pic,.peixunList li .char").on('click',function () {
						location.href='${path}/wechatTrain/trainDetail.do?id='+$(this).attr('d-id');
                    })
                    $(".peixunList li .bottBox").on('click',function () {
                        collect(this)
                    })
                }
            }, "json");
		}

        function loadTrainType() {
           /*var html = "";
            $.post("${path}/tag/getChildTagByType.do?code=TRAIN_TYPE", function (data) {
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html +='<div v="' + obj.tagId + '" class="item clearfix">';
                    html +='<div class="mz">' + obj.tagName + '</div>';
                    html +='</div>';
                }
                $("#type").append(html);
            });*/

            $.post("../tag/getCommonTag.do?type=10", function (data) {
                var html = "";
                var list = eval(data);
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    html +='<div v="' + obj.tagName + '" class="item clearfix">';
                    html +='<div class="mz">' + obj.tagName + '</div>';
                    html +='</div>';
                }
                $("#type").append(html);
            })
        }

	</script>
    <style>
    	html,body,.main{height:100%;background-color:#f3f3f3}
        .content {padding-top: 100px;padding-bottom: 18px;}
    </style>
</head>
<body>
<div class="peixunTop">
<%--	<div class="enrollIntro">
		招生简章
	</div>
	<div class="closeImg"></div>
	<div class="enrollWords">
		<div class="title clearfix">
			<div class="choose">春季<i class="line"></i></div>
			<div>秋季<i class="line"></i></div>
		</div>
		<div class="content">
			<div class="words">
				文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供文案由项目经理提供
			</div>
			<div class="img">
				<img src="https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3200334446,1487314372&fm=27&gp=0.jpg" alt="">
			</div>
		</div>
	</div>--%>
	<!-- start 第一部分  -->

	<div class="zjCenter clearfix" style="margin: 20px auto 10px;">
		<!-- 筛选 -->
		<div class="filter">
			<div class="filterArea clearfix">
				<div class="title">区域：</div>
				<div class="area">
					<div class="filterRight clearfix">
						<a href="#" class="item cur">全部</a>
						<c:forEach items="${venues}" var="venue">
							<a href="#" class="item" value="${venue.venueId}">${venue.venueName}</a>
						</c:forEach>
					</div>
				</div>
			</div>
			<div class="filterKinds clearfix">
				<div class="title">类型：</div>
				<div class="kinds">
					<div class="filterRight clearfix">
						<a href="#" class="item cur">全部</a>
						<c:forEach items="${tagList}" var="tag">
							<a href="#" class="item" value="${tag.tagId}">${tag.tagName}</a>
						</c:forEach>
					</div>
				</div>
			</div>
			<div class="filterSort clearfix">
				<div class="title">排序：</div>
				<div class="sort">
					<div class="filterRight clearfix">
						<a href="#" class="item cur">最新发布</a>
						<a href="#" class="item">报名即将开始</a>
						<a href="#" class="item">报名中</a>
						<a href="#" class="item">培训中</a>
						<a href="#" class="item">培训结束</a>
					</div>
				</div>
			</div>
		</div>
		<div class="peixunLine"></div>
		<!-- 展示 -->
		<div class="peixunShow">
			<div class="peixunShowPic">
				<ul class="peixunUl clearfix">

				</ul>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">

	$(function () {
		$('.pxFilter .shaiBox').on('click', 'li', function () {
			$(this).siblings('li').removeClass('cur');
			if($(this).hasClass('cur')) {
				$(this).removeClass('cur');
				$('.pxFilter .shaiErjiWc').hide();
			} else {
				$(this).addClass('cur');
				$('.pxFilter .shaiErjiWc').show();
			}
			$('.pxFilter .shaiErjiWc .shaiErji').hide();
			$('.pxFilter .shaiErjiWc .shaiErji').eq($(this).index()).show();
		});
		$('.pxFilter .shaiErji').on('click', '.item', function () {
			$(this).addClass('cur').siblings('.item').removeClass('cur');
			var v = $(this).attr('v');
			$(this).parent().find('input').val(v);
			loadDate(0,20);

			$('.pxFilter .shaiBox li.cur').html($(this).find('.mz').html()+"<em></em><i class=\"x\"></i>");

			$('.pxFilter .shaiBox li').removeClass('cur');
			$('.pxFilter .shaiErjiWc').hide();



		});
		$('.pxFilter').on('click touchstart', function (e) {
			e = e || e.event;
			e.stopPropagation();
		});
		$('html, body').on('click touchstart', function () {
			$('.pxFilter .shaiBox li').removeClass('cur');
			$('.pxFilter .shaiErjiWc').hide();
		});

		//春秋季弹窗点击
		$('.kindsUl').on('click', 'li', function () {
			$(this).addClass('cur').siblings('li').removeClass('cur');
			$('.course .course_num').hide();
			$('.course .course_num').eq($(this).index()).show();
		});

		$(".know").click(function(){
			$(".alertWindow").hide();
		})
	});
</script>
</body>
</html>