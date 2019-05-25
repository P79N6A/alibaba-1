<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <!-- <title>帮助</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>

	<script>
		$(function() {
			$(".help-list>ul>li").click(function() {
				var num = $(this).index()
				$(".help-list").hide()
				$(".help-tab>ul>li").eq(num).show()
				switch (num) {
					case 0:
						$(".index-top-2").html("如何选择自己感兴趣的活动标签");
						$(".index-top-2").addClass("fs32")
						$(".index-top-2").css("top", "35px")
						break;
					case 1:
						$(".index-top-2").html("如何搜索及筛选活动");
						break;
					case 2:
						$(".index-top-2").html("如何按日期查看活动");
						break;
					case 3:
						$(".index-top-2").html("如何查看附近的活动");
						break;
					case 4:
						$(".index-top-2").html("如何查找文化场馆");
						break;
					case 5:
						$(".index-top-2").html("活动预定流程");
						break;
					case 6:
						$(".index-top-2").html("场馆活动室预定流程");
						break;
					case 7:
						$(".index-top-2").html("如何取消订单");
						break;
					case 8:
						$(".index-top-2").html("账号设置相关问题");
						break;
					case 9:
						$(".index-top-2").html("第三方登陆帐号如何绑定手机");
						$(".index-top-2").addClass("fs32")
						$(".index-top-2").css("top", "35px")
						break;
				}
			})
			$(".help-back").click(function() {
				$(".help-tab>ul>li").hide()
				$(".help-list").show()
				$(".index-top-2").html("使用说明");
				$(".index-top-2").css("top", "25px").removeClass("fs32")
			})
		})
	</script>
</head>
<body>
	<div class="main">
		<div class="header">
			<c:if test="${type!='app'}">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png" onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2" style="left: 75px;width: 600px;">使用说明</span>
				</div>
			</c:if>
		</div>
		<div class="content padding-bottom0 margin-bottom100">
			<c:if test="${type!='app'}">
				<script>
					$(".content").addClass("margin-top100");
				</script>
			</c:if>
			<div class="help-list">
				<ul>
					<li class="border-bottom"><span>如何选择自己感兴趣的活动标签</span></li>
					<li class="border-bottom"><span>如何搜索及筛选活动</span></li>
					<li class="border-bottom"><span>如何按日期查看活动</span></li>
					<li class="border-bottom"><span>如何查看附近的活动</span></li>
					<li class="border-bottom"><span>如何查找文化场馆</span></li>
					<li class="border-bottom"><span>活动预定流程</span></li>
					<li class="border-bottom"><span>场馆活动室预定流程</span></li>
					<li class="border-bottom"><span>如何取消订单</span></li>
					<li class="border-bottom"><span>账号设置相关问题</span></li>
					<li><span>第三方登陆帐号如何绑定手机</span></li>
				</ul>
			</div>
			<div class="help-tab">
				<ul>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">如何选择自己感兴趣的活动标签</p>
							<p class="margin-top20">进入首页，点击【+】，选定一个或多个感兴趣的标签，点击【确定】按钮返回</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/01pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/01pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">如何搜索及筛选活动</p>
							<p class="margin-top20">a)搜索</p>
							<div class="padding-left30">
								<p>点击首页右上角【放大镜】，输入关键字进行活动搜索；或者点击【热门分类】、【热门区域】、【热门搜索】进行搜索。</p>
							</div>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/02pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/02pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top20">b)搜索</p>
							<div class="padding-left30">
								<p>点击【筛选框】，可根据【区域】、【分类】、【排序】、【筛选】等，进行进一步的活动及场馆筛选。</p>
							</div>
							<div class="margin-top50">
								<img style="margin: auto;" src="${path}/STATIC/wechat/image/help/02pic3.png" />
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">如何按日期查看活动</p>
							<p class="margin-top20">点击底部【日历】，可根据活动日期进行活动的搜索，点击具体日期，可查看当天的在线活动。</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/03pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/03pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">如何查看附近的活动</p>
							<p class="margin-top20">点击底部【附近】，可根据当前所在位置，显示周边5公里范围内的活动，并可按照距离由近及远排列。</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/04pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/04pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">如何查找文化场馆</p>
							<p class="margin-top20">点击底部【场馆】，可根据【区域】、【分类】、【排序】、【状态】来进行文化场馆的查找。</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/05pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/05pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">活动预定流程</p>
							<p class="margin-top20">点击某一活动，进入活动详情页，点击底部【立即预定】，填写预约信息，点击【确认预订】。</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/06pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/06pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top50 fs32 fsbold">注意事项</p>
							<table class="margin-top20">
								<tbody valign="top">
									<tr>
										<td>1)</td>
										<td class="padding-bottom20">部分活动预定需要用户达到规定的积分，或者每次预定需要扣除部分积分，具体视不同活动而定。</td>
									</tr>
									<tr>
										<td>2)</td>
										<td>部分活动为秒杀活动，只可在限定时间段内才可预定，具体视不同活动而定。</td>
									</tr>
								</tbody>
							</table>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/06pic3.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/06pic4.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">场馆活动室预定流程</p>
							<p class="margin-top20">选择“可预订”场馆，进入场馆详情页，点击“可预订活动室”，进入活动室详情页，点击选择“可预订”场次，点击底部的【立即预定】，填写预约信息完成预定。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/07pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/07pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top50">预订后必须进行用户实名认证及使用者身份认同，才可进入正常预约流程。</p>
							<p class="margin-top20">注意：活动室预定仅为提交预订信息，是否预订成功将由场馆进行审核，预定结果会通过短信及站内信通知，请注意查收。</p>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/07pic3.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/07pic4.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">场馆活动室预定流程</p>
							<p class="margin-top20">选择“可预订”场馆，进入场馆详情页，点击“可预订活动室”，进入活动室详情页，点击选择“可预订”场次，点击底部的【立即预定】，填写预约信息完成预定。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/08pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/08pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/08pic5.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/08pic4.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">文化云注册流程</p>
							<p class="margin-top20">下载文化云app，打开文化云→点击【创建账号】按钮→填写注册信息→手机号码验证→注册成功。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/09pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/09pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top50 fs32 fsbold">文化云登录流程</p>
							<p class="margin-top20">下载文化云app，打开文化云→点击【登录】按钮→填写账号和密码→登陆成功。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/09pic3.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/09pic4.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top50 fs32 fsbold">怎么修改昵/年龄/性别/修改登录密码</p>
							<p class="margin-top20">点击首页左上角头像→进入个人中心，点击【个人设置】→修改信息。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/09pic5.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/09pic6.png" />
								<div style="clear: both;"></div>
							</div>
							<p class="margin-top50 fs32 fsbold">如何找回忘记的登录密码</p>
							<p class="margin-top20">打开文化云app，进入登录页面→点击【忘记密码】→验证手机→设置新密码→密码修改成功。</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/09pic7.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/09pic8.png" />
								<div style="clear: both;"></div>
							</div>
							
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
					<li>
						<div>
							<p class="padding-top20 fs32 fsbold">第三方登陆帐号如何绑定手机</p>
							<p class="margin-top20">点击首页左上角的</p>

							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/10pic1.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/10pic2.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<img class="f-left" src="${path}/STATIC/wechat/image/help/10pic3.png" />
								<img class="f-left margin-left50" src="${path}/STATIC/wechat/image/help/10pic4.png" />
								<div style="clear: both;"></div>
							</div>
							<div class="margin-top50">
								<button class="help-back f-right">返回</button>
								<div style="clear: both;"></div>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>