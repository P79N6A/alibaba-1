<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>中华优秀传统文化知识大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20170511"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	 <meta http-equiv="pragma" content="no-cache">
	 <meta http-equiv="cache-control" content="no-cache">
 	 <meta http-equiv="expires" content="0">   
<style type="text/css">
html,body {height: 100%;}
</style>
 <script type="text/javascript">
 
 $.ajaxSettings.async = false; 	//同步执行ajax
 
 if (userId == null || userId == '') {
		//判断登陆
	 publicLogin('${basePath}wechatStatic/cultureContestIndex.do');
}
 
 var questionList;
 var index;
 var answerTime=0;
 
 $(function() {
	 
	 if(window.screen.width > 750){
		 	//PC
		 	
		 	$("img").each(function(){
		 		
		 		
		 		var src=$(this).attr("src");
		 		
		 		src=src.replace('/tradKnow/','/tradKnowPc/')
		 		
		 		$(this).attr("src",src);
		 	});
		 }
	 
	 var stageNumber ='${stageNumber}'
	 
	$.post("${path}/cultureContest/queryStageQuestion.do",{stageNumber:stageNumber}, function(data) {
		
		var length=data.length
		
		if(length){
			
			$(".dar").append('<i class="number">1</i> / '+length);
			
		//	$.each(data,function(i,question){
		//	});
		
			questionList= data;
			index=0;
			
			nextQuestion();
			
			countDown();
		}
		
	},'json');
	 
	 $(".queDetail").on("click","li",function(){
         var $that = $(this);
         /*再次点击取消*/
         if ($(this).hasClass("cur")) {
             $that.removeClass("cur");
         }else{
             /*判断是否是多选和判断题*/
             if ($(this).parent().siblings("h2").hasClass("more")) {
                 $(this).addClass("cur");
             }else{
                 $(this).addClass("cur").siblings().removeClass("cur");
             }
         }
     });
	 
 });
 
 function nextQuestion(){
	 
	 if(index>0){
		 
		 var curs=$(".queDetail .cur")
		 
		 if(curs.length==0){
			 
				dialogAlert('系统提示', '请选择正确答案！');
		        return false;
		 }
		 
		 if($("h2").hasClass("more")&&curs.length==1){
			 
			 dialogAlert('系统提示', '多选题至少选两个答案！');
		        return false;
		 }
		 
		 var rightAnswer="";
		 
 		$.each(curs , function(i , li) {
			 
 			rightAnswer+=$(li).attr("optionindex")
		 });
 		
 		var cultureAnswerId=$("#cultureAnswerId").val();
 		
 		var cultureQuestionId=$(".subject").attr("cultureQuestionId");
 		
 		var data={
 			cultureAnswerId:cultureAnswerId,
 			rightAnswer:rightAnswer,
 			answerTime:answerTime,
 			cultureQuestionId:cultureQuestionId
 		}
 		
 		$.post("${path}/cultureContest/saveAnswer.do",data, function(result) {
 			
			var r=result.result;
			
			if(r=='success'){
				
				if(result.right=='true'){
					
					var score=$(".score").html();
					
					var newScore=parseInt(score)+1 
					
					$(".score").html(newScore);
				}
				
			}else{
				dialogAlert('提示', '保存失败，系统繁忙');
				return false;
			}
 			
 		},'json');
 		
	 }
	 
	if(index==questionList.length){
		 
		window.location.href='${basePath}wechatStatic/cultureContestEnd.do?cultureAnswerId='+cultureAnswerId;
	 }
	 
	 var question=questionList[index];
	 
	 var questionType=question.questionType;
	 
	 var testClass='single'
	 
	 var htmlSelect=''
	 
	 //试题类型 1.单选题 2.多选题 3是非题
	 if(questionType==2){
		 testClass='more'
	 }else if(questionType==3){
		 testClass='judge'
	 }
	 
	 var html=
	 
	 '<h2 class="title '+ testClass+'"></h2>'+
     '<div cultureQuestionId="'+question.cultureQuestionId+'" class="subject">'+question.questionContent+'</div>';
     
	 if(questionType==3){
		
		 htmlSelect+='<ul class="select selJudge">'+
			 '<li optionIndex="1">是</li>'+
	         '<li optionIndex="0">否</li>'
	         
	 }else{
		 
		 htmlSelect+='<ul class="select">'
		 
		 var t=['A','B','C','D']
		 
		 $.each(question.optionList , function(i , option) {
			 
			 htmlSelect+='<li optionIndex="'+option.optionIndex+'">'+t[i]+'<b>'+option.optionContent+'</b></li>'
		 });
	}
	 htmlSelect+='</ul>'
	
	 html+=htmlSelect;
	 
	 $(".queDetail").html(html)
	 
	 if(index>0){
		 
		 var number=$(".number").html();
			
			var newNumber=parseInt(number)+1 
			
			$(".number").html(newNumber);
	 }
	 
	 index++;
	 
	 if(index==questionList.length){
		 
		  $(".anniu").removeClass("next").addClass("end");
		 
	 }
	 
	
 }
 
 function countDown(){
	 
	 var cultureAnswerId=$("#cultureAnswerId").val();
	 
	  var x = 15,interval;
      var d = new Date("1111/1/1,0:" + x + ":0");
      interval = setInterval(function() {
          var m = d.getMinutes();
          var s = d.getSeconds();
          m = m < 10 ? "0" + m : m;
          s = s < 10 ? "0" + s : s;
           $(".dal .time").html( m + "：" + s);
          if (m == 0 && s == 0) {
              clearInterval(interval);
              $("body").append(
                  '<div class="mask"></div>'+
                  '<div class="remind">'+
                      '<h1>答题时间已结束</h1>'+
                      '<p>您可以继续完成没有答完的题目，但是答对题目将不再获得积分。</p>'+
                      '<div class="anniu clearfix">'+
                          '<img src="${path}/STATIC/wxStatic/image/tradKnow/icon15.png" class="continue">'+
                          '<img src="${path}/STATIC/wxStatic/image/tradKnow/icon14.png" class="over">'+
                      '</div>'+
                  '</div>'+
                  '<script type="text/javascript">'+
                  '    $(".continue").click(function(){'+
                  '        $(".mask").hide();'+
                  '        $(".remind").hide();'+
                  '    });'+
                  '    $(".over").click(function(){'+
                  '  window.location.href="${basePath}wechatStatic/cultureContestEnd.do?autoEnd=true&cultureAnswerId='+cultureAnswerId+'"'+
                  '    });'+
                  '<\/script>'
              );
          }
          d.setSeconds(s - 1);
          answerTime+=1;
      }, 1000);
 }
 
</script>

</head>

<body>
 <div class="question">
        <div class="detail">
        	<input type="hidden" id="cultureAnswerId" name="cultureAnswerId" value="${cultureAnswerId }"/>
            <img src="${path}/STATIC/wxStatic/image/tradKnow/tit${stageNumber }.png" class="tit"><!-- 三个阶段的答卷只是图片不一样 -->
            <div class="date clearfix">
                <div class="dal">
                    <span>得分<i class="score">0</i></span>
                    <span>剩余时间<i class="time">15：00</i></span>
                </div>
                <div class="dar">
                </div>
            </div>
            <div class="queDetail">
               
            </div>
            <a href="javascript:;" class="anniu next" onclick="nextQuestion();"><!-- 下一题next,交卷end --></a>
        </div>
    </div>
</body>

</html>

