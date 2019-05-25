<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

	<head>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<!--红星style-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-redstar.css">
		<!--滑屏插件-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper-3.3.1.jquery.min.js"></script>
		<!--大转盘js-->
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery.rotate.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-redstarUploader.js"></script>
		<title></title>
		
		
		<style>
			html,
			body {
				width: 100%;
				height: 100%;
			}
			
			.redstarGame{
				width: 750px;
				margin: auto;
				height: 100%;
			}
			
			.swiper-container {
				margin: 20px auto 0px auto;
				width: 560px;
				height: 480px;
			}
			
			.swiper-slide {
				background-position: center;
				background-size: cover;
				width: 450px;
				height: 480px;
				display: none;
			}
			
			.swiper-slide-shadow-left,
			.swiper-slide-shadow-right {
				height: 480px!important;
			}
		</style>
		<script>
			var qNo = 0;
			var score = 0;
			var progressbar = 0; //题目进度条
			var topicNameArray=['浴血坚持','星火燎原','转战南北','共赴国难']
			var topicName='${topicName}'
			var index=$.inArray(topicName, topicNameArray)+1;
			
			$.ajaxSettings.async = false; //同步执行ajax
			
			 var title='红星照耀中国';
			//分享是否隐藏
		   	 if(window.injs){
				injs.setAppShareButtonStatus(false);
				injs.changeNavTitle(title); 
			 }else{
				$(document).attr("title",title);
			}
			
			var strQuestionArray='${questionArray}'
			
			var questionArray=eval(strQuestionArray);
			
			var length=questionArray.length;
			
			//确定按钮
			function confirmBut() {
				quesBar()
				if($(".swiper-slide-active").hasClass("true")) { //答对
					score++;
					$(".redq-true").show();
					loadQuestion();
					setTimeout(function() {
						if(qNo >= length) {
							if(score >= length) {
								
								$.post("${path}/wechatRedStar/savePass.do", {
									userId: userId,
									index: index
								}, function(data) {
									
								}, "json");
								
								$(".missioncomplete").show()
							} else {
								$(".missionfaild").show()
							}
						} else {
							$(".redq-true").fadeOut();
							qNo++
						}
					
					}, 1500);
				} else { //答错
					$(".redq-false").show();
					loadQuestion();
					setTimeout(function() {
						if(qNo >= length) {
							if(score >= length) {
								$(".missioncomplete").show()
							} else {
								$(".missionfaild").show()
							}
						} else {
							$(".redq-false").fadeOut();
							qNo++;
						}
					}, 1500);
				}
			}

			//加载题目
			function loadQuestion() {
				
				if(qNo >=length) {
					return;
				}
				
				//$.getJSON("./answerContent.json", function(data) {
					
					var questionData=questionArray[qNo];

					//清空已选的答案
					$(".qImg1").attr("src", "");
					$(".qImg2").attr("src", "");
					$(".swiper-slide").find(".pic-check").addClass("pic-check-none");
					$(".swiper-slide").find(".pic-check").removeClass("chose");
					$(".swiper-slide").removeClass("true");

					$("#question").html(questionData.questionTitle); 
					
					var answerList=questionData.answerList;

					$.each(answerList,function(i,dom){
						
						var src= getIndexImgUrl('${staticServerUrl}'+dom.answerPicUrl,"_750_500");
						
						
						$(".qImg"+(i+1)).attr("src", src);
						
						if(dom.isTrue==1){
							$(".qImg"+(i+1)).parent().addClass("true");
						}
						
						$(".qImg"+(i+1)).parent().show();
					})

					if(qNo == 0) {
						var swiper = new Swiper('.swiper-container', {
							pagination: '.swiper-pagination',
							effect: 'coverflow',
							grabCursor: true,
							centeredSlides: true,
							slidesPerView: 'auto',
							loop: true,
							coverflow: {
								rotate: 10,
								stretch: 0,
								depth: 100,
								modifier: 1,
								slideShadows: true
							},
							onTransitionEnd: function(swiper) {
								var snapIndex = swiper.snapIndex;
								var $slide = $(".swiper-wrapper .swiper-slide:eq(" + snapIndex + ")");
								$(".swiper-slide").find(".pic-check").addClass("pic-check-none")
								$(".swiper-slide").find(".pic-check").removeClass("chose")
								$slide.find(".pic-check").removeClass("pic-check-none")
								$slide.find(".pic-check").addClass("chose")
							}
						});
					} else {
						$(".swiper-slide-active").find(".pic-check").removeClass("pic-check-none")
						$(".swiper-slide-active").find(".pic-check").addClass("chose")
					}
				//});
			}

			//答题进度条
			function quesBar() {
				progressbar += 570/length;
				$(".redstargame-runcl").css("width", progressbar);
			}

			$(document).ready(function() {
				loadQuestion(); //加载题目
				qNo++;
				//题目提交按钮事件添加
				$(".redstargame-ckb").on("click", function() {
					confirmBut()
				})
				
				$(".faildBtn").click(function(){
					window.location.href = 'index.do';
				})
				$(".completeimg").click(function(){
					window.location.href = 'index.do';
				})
			})
		</script>

	</head>

	<body>
		<div class="redstarGame">
			<!--活动页-->
			<div class="redstar-gamepage">
				<div class="redstar-num">
					<div class="redstargame-runbg">

					</div>
					<div class="redstargame-runcl">

					</div>
				</div>

				<!--游戏问题-->
				<div class="redstargame-content">
					<div class="fs28 redstarTitle" id="question"></div>
					<div class="swiper-container" id="swiper-container3">
						<div class="swiper-wrapper">
							<div class="swiper-slide" >
								<img class="qImg1" src="" width="450" height="480" />
							</div>
							<div class="swiper-slide" >
								<img class="qImg2" src="" width="450" height="480" />
							</div>
						</div>
					</div>
					<div class="redstargame-ckb">
						<img src="${path}/STATIC/wxStatic/image/redStar/qtconfirm.png" />
					</div>
				</div>

				<!--正确-->
				<div class="redq-true">
					<div class="answerImg">
						<img src="${path}/STATIC/wxStatic/image/redStar/right.png" />
					</div>
				</div>

				<!--错误-->
				<div class="redq-false">
					<div class="answerImg">
						<img src="${path}/STATIC/wxStatic/image/redStar/wrong.png" />
					</div>
				</div>
			</div>
			<!--闯关成功-->
			<div class="missioncomplete">
				<div class="completeimg">
					<p>${topicName}</p>
					<div class="completeBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/keepchan.png" />
					</div>
				</div>
			</div>
			<!--闯关失败-->
			<div class="missionfaild">
				<div class="faildimg">
					<p>${topicName}</p>
					<div class="faildBtn">
						<img src="${path}/STATIC/wxStatic/image/redStar/chongxintiaozhan.png" />
					</div>
				</div>
			</div>
			
		</div>
	</body>

</html>