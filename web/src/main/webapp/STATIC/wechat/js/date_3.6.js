function lastDay(num) {
	var nowMon = new Date();
	//num为月份数：0为上个月，1为当前月，2为下个月，3为下下月，以此类推;如为负数则往前推
	//d.getMonth()+1代表下个月，月份索引从0开始，即当前月为6月时，getMonth()返回值为5，创建日期时同理
	//此处构造的日期为下个月的第0天，天数索引从1开始，第0天即代表上个月的最后一天
	var curMonthDays = new Date(nowMon.getFullYear(), (nowMon.getMonth() + num), 0).getDate();
	return curMonthDays;
}

function week(num) {
	if(num == 1)
		return '一';
	else if(num == 2)
		return '二';
	else if(num == 3)
		return '三';
	else if(num == 4)
		return '四';
	else if(num == 5)
		return '五';
	else if(num == 6)
		return '六';
	else if(num == 7 || num == 0)
		return '日';
}

function numOfDigits(num) {
	if(num < 10) {
		return '0' + num;
	} else {
		return num;
	}
}

$(function() {
	var dayWeek = 0;
	var num_week = 0;
	var now_data = new Date()
	var now_mon = now_data.getMonth() + 1;
	var mon_id = 1;
	var now_year = now_data.getFullYear()
	for(var i = 1; i <= 3; i++) {
		if(i == 1) {
			var overplus = now_data.getDate()
				//上一个星期天是几号
			var lastMonOverplus = overplus - now_data.getDay()
			if(num_week == 0) {
				//今天不是星期天时
				if(now_data.getDay() != 0) {
					//上个星期天为上个月
					if(lastMonOverplus <= 0) {
						//上个月最后一个星期天是几号
						var lastMonLastDay = lastDay(0) + lastMonOverplus;
						for(; lastMonLastDay <= lastDay(0); lastMonLastDay++) {
							$(".data-tab .whyDataList ").append(
								"<li class='dateOut'>" +
								"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
								"<div class='whyDataDay whyDataOutDay'>" + lastMonLastDay + "</div>" +
								"</li>"
							)
							dayWeek++;
							if(dayWeek > 7)
								dayWeek = 1;
						}
						//今天不为星期天，昨天为本月
						if(overplus - 1 > 0) {
							for(var b = 1; b <= overplus - 1; b++) {
								$(".data-tab .whyDataList ").append(
									"<li class='dateOut'>" +
									"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
									"<div class='whyDataDay whyDataOutDay'>" + b + "</div>" +
									"</li>"
								)
								dayWeek++;
								if(dayWeek > 7)
									dayWeek = 1;
							}
						}
						//今天开始往后的剩余天
						for(; overplus <= lastDay(1); overplus++) {
							$(".data-tab .whyDataList ").append(
								"<li date='" + now_year + "-" + numOfDigits(now_mon) + "-" + numOfDigits(overplus) + "'>" +
								"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
								"<div class='whyDataDay'>" + overplus + "</div>" +
								"</li>"
							)
							dayWeek++;
							if(dayWeek > 7)
								dayWeek = 1;
						}
						num_week++;
					} else {
						//今天为星期天
						for(var Dvalue = now_data.getDate() - now_data.getDay(); Dvalue <= now_data.getDate(); Dvalue++) {
							//把昨天之前的天数置灰
							if(Dvalue < now_data.getDate()) {
								$(".data-tab .whyDataList ").append(
									"<li class='dateOut'>" +
									"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
									"<div class='whyDataDay whyDataOutDay'>" + Dvalue + "</div>" +
									"</li>"
								)
							} else {
								$(".data-tab .whyDataList ").append(
									"<li date='" + now_year + "-" + numOfDigits(now_mon) + "-" + numOfDigits(Dvalue) + "'>" +
									"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
									"<div class='whyDataDay'>" + Dvalue + "</div>" +
									"</li>"
								)
							}
							dayWeek++;
							if(dayWeek > 7)
								dayWeek = 1;
						}
						//今天开始往后的剩余天
						if(overplus - 1 > 0) {
							for(var a = overplus + 1; a <= lastDay(1); a++) {
								$(".data-tab .whyDataList ").append(
									"<li date='" + now_year + "-" + numOfDigits(now_mon) + "-" + numOfDigits(a) + "'>" +
									"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
									"<div class='whyDataDay'>" + a + "</div>" +
									"</li>"
								)
								dayWeek++;
								if(dayWeek > 7)
									dayWeek = 1;
							}
						}
					}
				} else {
					//今天是星期天
					for(var sun = now_data.getDate(); sun <= lastDay(i); sun++) {
						$(".data-tab .whyDataList ").append(
							"<li date='" + now_year + "-" + numOfDigits(now_mon) + "-" + numOfDigits(sun) + "'>" +
							"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
							"<div class='whyDataDay'>" + sun + "</div>" +
							"</li>"
						)
						dayWeek++;
						if(dayWeek > 7)
							dayWeek = 1;
					}
				}
			}
			//给今天加上标记圆圈
			$(".whyDataDay").each(function() {
				if($(this).text() == now_data.getDate()) {
					$(this).addClass("whyToday")
				}
			})
		} else {
			//下两个月的日期
			for(var day = 1; day <= lastDay(i); day++) {

				$(".data-tab .whyDataList ").append(
					"<li date='" + now_year + "-" + numOfDigits(now_mon) + "-" + numOfDigits(day) + "'>" +
					"<div class='whyDataWeek'>" + week(dayWeek) + "</div>" +
					"<div class='whyDataDay'>" + day + "</div>" +
					"</li>"
				)
				dayWeek++;
				if(dayWeek > 7)
					dayWeek = 1;
			}
		}
		$(".data-tab .whyDataList").append("<input type='hidden' value='" + now_mon + "' id = 'mon" + mon_id + "'/>")
		mon_id++
		now_mon++

		if(now_mon > 12) {
			now_mon = 1;
			now_year += 1;
		}

	}

	var li_num = $(".data-tab .whyDataList li").length
	$(".whyDataList").css("width", li_num * 100);
	

	//初始化
	$(".whyDataList li").not(".dateOut").each(function(){
		if($(this).attr("date") == selectDate){
			$(this).find(".whyDataDay").addClass("nowClick");
		}
	});
	if($(".whyDataList li .nowClick").parent('li').offset()){
		$(".data-tab").animate({scrollLeft:$(".whyDataList li .nowClick").parent('li').offset().left-325},1000);
	}
	
	$(".whyDataList li").not(".dateOut").click(function() {
		$(".whyDataList li").find(".whyDataDay").removeClass("nowClick");
		$(this).find(".whyDataDay").addClass("nowClick");
		
		sessionStorage.setItem("selectDate", $(this).attr("date"));	//界面位置缓存
		selectDate = $(this).attr("date");
		//重新加载页面
		reloadHtml();
	})

	var nowDate = new Date()
	$("#nowYear").text(nowDate.getFullYear())
	$("#nowMon").text(nowDate.getMonth() + 1)
	$(".data-tab").scroll(function() {
		if($("#mon1").next("li").offset().left >= 0) {
			$("#nowMon").text(nowDate.getMonth() + 1)
			$("#nowYear").text(nowDate.getFullYear())
		} else if($("#mon1").next("li").offset().left < 0 && $("#mon2").next("li").offset().left >= 0) {
			if(nowDate.getMonth() + 1 == 11) {
				$("#nowMon").text(12)
				$("#nowYear").text(nowDate.getFullYear())
			} else if(nowDate.getMonth() + 1 == 12) {
				$("#nowMon").text(1)
				$("#nowYear").text(nowDate.getFullYear() + 1)
			} else {
				$("#nowMon").text(nowDate.getMonth() + 2)
			}
		} else {
			if(nowDate.getMonth() + 1 == 11) {
				$("#nowMon").text(1)
				$("#nowYear").text(nowDate.getFullYear() + 1)
			} else if(nowDate.getMonth() + 1 == 12) {
				$("#nowMon").text(2)
				$("#nowYear").text(nowDate.getFullYear() + 1)
			} else {
				$("#nowMon").text(nowDate.getMonth() + 3)
			}
		}

	})

});