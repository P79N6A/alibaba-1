<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>“文化上海云”应用大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css"/>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！';
	    	appShareDesc = '群英荟萃，艺苑流觞，百佳云上活动花落谁家？';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png';
	    	
			injs.setAppShareButtonStatus(true);
		}
	
		//判断是否是微信浏览器打开
		if (is_weixin()) {
			//通过config接口注入权限验证配置
			wx.config({
				debug: false,
				appId: '${sign.appId}',
				timestamp: '${sign.timestamp}',
				nonceStr: '${sign.nonceStr}',
				signature: '${sign.signature}',
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！",
					desc: '群英荟萃，艺苑流觞，百佳云上活动花落谁家？',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png'
				});
				wx.onMenuShareTimeline({
					title: "有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png'
				});
				wx.onMenuShareQQ({
					title: "有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！",
					desc: '群英荟萃，艺苑流觞，百佳云上活动花落谁家？',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png'
				});
				wx.onMenuShareWeibo({
					title: "有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！",
					desc: '群英荟萃，艺苑流觞，百佳云上活动花落谁家？',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png'
				});
				wx.onMenuShareQZone({
					title: "有你吗？2016年上海市民文化节“文化上海云”应用大赛获奖名单公布啦！",
					desc: '群英荟萃，艺苑流觞，百佳云上活动花落谁家？',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173216453PPUi37ISVQACDr3NVvQFrdEtbxnNQZ.png'
				});
			});
		}
		
		$(function(){
			//分享
			$(".share-button").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			})
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
		})
		
	</script>
	
	<style>
		html,
		body {
			height: 100%;
		}
		
		.main {
			width: 750px;
			margin: auto;
			background-color: #f3f3f3;
		}
		
		.content {
			padding-top: 50px;
		}
		
		.singleAward {
			margin-bottom: 50px;
		}
		
		.singleAward img {
			display: block;
		}
		
		.eventAwards {
			width: 750px;
			height: 907px;
			background: url(${path}/STATIC/wxStatic/image/prizeList/listBg.jpg) no-repeat center center;
		}
		
		.eventAwards2 {
			width: 750px;
			height: 443px;
			background: url(${path}/STATIC/wxStatic/image/prizeList/listBg2.jpg) no-repeat center center;
		}
		
		.eventAwardsTable {
			background-color: #eb1957;
		}
		
		tr:nth-child(odd) {
			background-color: #f6e9ed;
		}
		
		tr:nth-child(even) {
			background-color: #f7f1f3;
		}
		
		td {
			font-size: 25px;
			padding: 15px;
			border: 1px solid #eb1957;
		}
		
		td:nth-child(1) {
			text-align: center;
		}
		
		.prizeListPop {
			position: fixed;
			left: 0;
			top: 0;
			bottom: 0;
			right: 0;
			margin: auto;
			background-color: rgba(226, 226, 226, 0.95);
		}
	</style>
</head>

<body>
	<div class="main">
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="plHead">
			<div style="width: 650px;height: 160px;padding: 20px 15px;position: absolute;left: 0;right: 0;top: 400px;margin: auto;">
				<p style="font-size: 24px;color: #333333;">&emsp;&emsp;由上海市民文化协会主办，上海创图网络科技股份发展有限公司承办的2016年上海市民文化节“文化上海云”应用大赛圆满结束了，通过广大会员单位的积极参与，在大赛中充分展现企业风采，涌现 ...<span style="float: right;color: #f12e67;border-bottom: 1px solid #f12e67;" onclick="$('.prizeListPop').show()">查看全文</span></p>
			</div>
			<div>
				<img class="share-button" src="${path}/STATIC/wxStatic/image/prizeList/share.png" style="position: absolute;right: 40px;top: 40px;width: 50px;height: 50px;" />
			</div>
		</div>
		<div class="content">
			<div class="singleAward">
				<img src="${path}/STATIC/wxStatic/image/prizeList/single.jpg" />
			</div>
			<div class="singleAward">
				<img src="${path}/STATIC/wxStatic/image/prizeList/1.png" />
			</div>
			<div class="clearfix singleAward">
				<img style="display: block;float: right;" src="${path}/STATIC/wxStatic/image/prizeList/2.png" />
			</div>
			<div class="singleAward">
				<img src="${path}/STATIC/wxStatic/image/prizeList/3.png" />
			</div>
			<div class="singleAward">
				<img src="${path}/STATIC/wxStatic/image/prizeList/4.png" />
			</div>
			<div class="eventAwards">

			</div>
			<div class="eventAwardsTable">
				<div>
					<table style="width: 707px;margin-left: 23px;border-left: 10px solid #fff;border-right: 11px solid #fff;border-bottom: 10px solid #fff;">
						<tr style="text-align: center;background-color: #7e2640;color: #fff;">
							<td width="75">编号</td>
							<td>活动名称</td>
							<td width="275">报送单位</td>
						</tr>
						<tr>
							<td>01</td>
							<td>阅读中的真善美—市民微笔记阅读大赛</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>02</td>
							<td>红星照耀中国—线上展览</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>03</td>
							<td>红星照耀中国纪念长征胜利80周年—挑战大转盘</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>04</td>
							<td>2016春华秋实-上海市社区文艺指导员教学成果展演</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>05</td>
							<td>回归“心”生活—传统文化主题活动</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>06</td>
							<td>文化进地铁—文化和艺术的展示新空间</td>
							<td>上海申通地铁集团有限公司</td>
						</tr>
						<tr>
							<td>07</td>
							<td>城市空间• 最美印象—市民微摄影征集活动</td>
							<td>上海城市动漫出版传媒有限公司</td>
						</tr>
						<tr>
							<td>08</td>
							<td>寻找最美笑脸 让生活充满爱—第二届上海国际喜剧节系列活动</td>
							<td>上海文广演艺集团</td>
						</tr>
						<tr>
							<td>09</td>
							<td>喜剧就是生活—第二届上海国际喜剧节系列演出</td>
							<td>上海文广演艺集团</td>
						</tr>
						<tr>
							<td>10</td>
							<td>你到底是多少分的奉贤人—在线游戏</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>11</td>
							<td>2016中国国际青年艺术周</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>12</td>
							<td>“海派小品—文脉虹口”小品专场演出季</td>
							<td>虹口区文化馆</td>
						</tr>
						<tr>
							<td>13</td>
							<td>大型原创情景剧《鲁迅在上海》　</td>
							<td>虹口区文化局</td>
						</tr>
						<tr>
							<td>14</td>
							<td>看话剧 写剧评 赢限量礼—2016第十二届上海当代戏剧节线上互动</td>
							<td>上海话剧艺术中心</td>
						</tr>
						<tr>
							<td>15</td>
							<td>戏如人生 你的人生有几分入戏—在线游戏</td>
							<td>上海话剧艺术中心</td>
						</tr>
						<tr>
							<td>16</td>
							<td>2016第十二届上海当代戏剧节</td>
							<td>上海话剧艺术中心</td>
						</tr>
						<tr>
							<td>17</td>
							<td>2016中国上海国际艺术节—“艺术天空”专场</td>
							<td>中国上海国际艺术节中心</td>
						</tr>
						<tr>
							<td>18</td>
							<td>12小时艺术狂欢 精彩内容知多少？—在线游戏</td>
							<td>中国上海国际艺术节中心</td>
						</tr>
						<tr>
							<td>19</td>
							<td>12小时艺术狂欢—现场直播</td>
							<td>中国上海国际艺术节中心</td>
						</tr>
						<tr>
							<td>20</td>
							<td>浦东话剧节</td>
							<td>星乐原文化传播公司</td>
						</tr>
						<tr>
							<td>21</td>
							<td>徐汇366市民摄影大赛</td>
							<td>徐汇区文化局</td>
						</tr>
						<tr>
							<td>22</td>
							<td>歌剧小知识问答—在线游戏</td>
							<td>长宁文化艺术中心</td>
						</tr>
						<tr>
							<td>23</td>
							<td>曼舞长宁—舞蹈艺术欣赏季</td>
							<td>长宁文化艺术中心</td>
						</tr>
						<tr>
							<td>24</td>
							<td>冬之乐—2016上海城市草坪音乐会</td>
							<td>黄浦区文化局</td>
						</tr>
						<tr>
							<td>25</td>
							<td>外滩源爵士艺术生活节</td>
							<td>黄浦区文化局</td>
						</tr>
						<tr>
							<td>26</td>
							<td>公益原创沪剧《雷雨后》主题活动</td>
							<td>长宁文化艺术中心</td>
						</tr>
						<tr>
							<td>27</td>
							<td>海上寻源—上海乡土文化大展主题活动暨颁奖典礼</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>28</td>
							<td>从小说到电影—法国电影展</td>
							<td>中华艺术宫</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="eventAwards2">

			</div>
			<div class="eventAwardsTable" style="padding-bottom: 50px;">
				<div>
					<table style="width: 707px;margin-left: 23px;border-left: 10px solid #fff;border-right: 11px solid #fff;border-bottom: 10px solid #fff;">
						<tr style="text-align: center;background-color: #7e2640;color: #fff;">
							<td width="75">编号</td>
							<td>活动名称</td>
							<td width="275">报送单位</td>
						</tr>
						<tr>
							<td>29</td>
							<td>2016年各街镇戏剧沙龙队展演—戏曲综艺</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>30</td>
							<td>百姓戏台—沪剧《半把剪刀》</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>31</td>
							<td>戏曲综艺（第一场）</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>32</td>
							<td>沪剧《大雷雨》</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>33</td>
							<td>2016各街镇戏剧沙龙队展演—越剧《梁祝》</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>34</td>
							<td>2017浦东市民新年音乐会</td>
							<td>浦东新区文化艺术指导中心</td>
						</tr>
						<tr>
							<td>35</td>
							<td>世界青年交响音乐会（开幕式）</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>36</td>
							<td>传承—“曲韵留风”京津沪渝非遗精品交流展演</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>37</td>
							<td>奉贤区青少年民乐专场</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>38</td>
							<td>上海国际艺术节—北京京剧院经典唱段演唱会</td>
							<td>松江区文化资源配送中心</td>
						</tr>
						<tr>
							<td>39</td>
							<td>中华艺术宫之约—“祖国万岁”合唱专场音乐会</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>40</td>
							<td>中华艺术宫之约—巴松管四重奏专场</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>41</td>
							<td>音乐剧《用鲜肉颠覆你想象的“瘾藏者”》</td>
							<td>四川北路街道社区文化活动中心</td>
						</tr>
						<tr>
							<td>42</td>
							<td>意大利歌剧魅力之旅—于浩磊独唱专场</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>43</td>
							<td>贝多芬早期弦乐四重奏作品专场音乐会</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>44</td>
							<td>打开音乐欣赏之门—弦乐重奏、独唱音乐会</td>
							<td>四川北路街道社区文化活动中心</td>
						</tr>
						<tr>
							<td>45</td>
							<td>欢腾的阿卡贝拉—AHA人声乐团专场演唱会</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>46</td>
							<td>宝山民俗文化节—中秋文艺晚会</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>47</td>
							<td>黄浦区白玉兰剧场系列活动</td>
							<td>黄浦区文化馆</td>
						</tr>
						<tr>
							<td>48</td>
							<td>赛乐尔三益之音—钢琴独奏音乐会</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>49</td>
							<td>我为黑管狂—“赵超与他的朋友们”专场音乐会</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>50</td>
							<td>耕耘路上•执着—本土曲艺全展示，致敬曲艺人谈敬德</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>51</td>
							<td>魔术专场《魔法三人行》</td>
							<td>黄浦区文化馆</td>
						</tr>
						<tr>
							<td>52</td>
							<td>第十八届中国上海国际艺术节“艺术天空”系列演出暨2016高雅艺术进奉贤系列演出</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>53</td>
							<td>音乐剧《国之当歌》</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>54</td>
							<td>原创木偶剧《小红军》</td>
							<td>长桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>55</td>
							<td>2016年“百姓艺苑”杨浦区社区与院团结对共建成果展演</td>
							<td>杨浦区文化馆</td>
						</tr>
						<tr>
							<td>56</td>
							<td>《好人老康发财记》南桥电影院专场</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>57</td>
							<td>艺术天空—水磨新调张军新昆曲音乐会</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>58</td>
							<td>北京京剧院经典唱段演唱会</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>59</td>
							<td>大型滑稽戏《一孝成名》</td>
							<td>宝山区月浦文化馆</td>
						</tr>
						<tr>
							<td>60</td>
							<td>大厅音乐会 —“击乐时光”打击乐艺术讲演会</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>61</td>
							<td>游“戏”国庆—中华传统戏曲国庆行</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>62</td>
							<td>儿童剧《泰坦尼克号》</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>63</td>
							<td>滑稽曲艺专场《笑语四季来相会》</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>64</td>
							<td>杂技专场演出《欢乐马戏》</td>
							<td>奉贤区文化资源配送管理中心</td>
						</tr>
						<tr>
							<td>65</td>
							<td>快乐学国学+妙趣手工坊</td>
							<td>上海少年儿童图书馆</td>
						</tr>
						<tr>
							<td>66</td>
							<td>世界青年交响音乐会</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>67</td>
							<td>中华绝技绝活—展演专场</td>
							<td>四川北路街道社区文化活动中心</td>
						</tr>
						<tr>
							<td>68</td>
							<td>市民艺术大课堂—宋频平和优秀群文声乐干部专场</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>69</td>
							<td>五味太郎邀你过圣诞—阅读越好玩亲子嘉年</td>
							<td>杨浦区图书馆</td>
						</tr>
						<tr>
							<td>70</td>
							<td>上海市北管弦乐团交响乐音乐会</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>71</td>
							<td>上海风情音乐会</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>72</td>
							<td>文化交融，青春绽放—中俄大学生新年联欢</td>
							<td>杨浦区图书馆</td>
						</tr>
						<tr>
							<td>73</td>
							<td>宝山市民艺术导赏《交响乐赏析》</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>74</td>
							<td>树信魔术杂技综艺演出</td>
							<td>四川北路街道社区文化活动中心</td>
						</tr>
						<tr>
							<td>75</td>
							<td>经典芭蕾舞剧《白毛女》</td>
							<td>奉贤区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>76</td>
							<td>阿卡贝拉互动讲演（第一场）</td>
							<td>黄浦区文化馆</td>
						</tr>
						<tr>
							<td>77</td>
							<td>法国默剧《魔都来了个卓别林》</td>
							<td>凌云社区文化活动中心</td>
						</tr>
						<tr>
							<td>78</td>
							<td>彩虹室内乐园2017新年音乐会</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>79</td>
							<td>世界名曲赏析音乐会</td>
							<td>四川北路街道社区文化活动中心</td>
						</tr>
						<tr>
							<td>80</td>
							<td>“笑传正能量　前卫脱口秀”</td>
							<td>宝山区月浦文化馆</td>
						</tr>
						<tr>
							<td>81</td>
							<td>周末去哪—专业讲师带你游三山会馆</td>
							<td>上海三山会馆</td>
						</tr>
						<tr>
							<td>82</td>
							<td>妙趣手工坊之彩泥蝴蝶—文化云专场</td>
							<td>上海少年儿童图书馆</td>
						</tr>
						<tr>
							<td>83</td>
							<td>祝福祖国—浦东新区庆国庆广场文艺演出</td>
							<td>浦东新区文化艺术指导中心</td>
						</tr>
						<tr>
							<td>84</td>
							<td>汉字的表情—让青少年快乐走进书法艺术大门</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>85</td>
							<td>纪念上海市群众艺术馆建馆 60 周年《“有梦•同行”—第十七届全国“群星奖”上海地区选拔获奖作品展演》</td>
							<td>上海市群众艺术馆</td>
						</tr>
						<tr>
							<td>86</td>
							<td>儿童剧《木偶奇遇记》</td>
							<td>凌云社区文化活动中心</td>
						</tr>
						<tr>
							<td>87</td>
							<td>世界首演—当代昆曲《我，哈姆雷特》</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>88</td>
							<td>揭开“狮子王”的台前幕后！《再现丛林—百老汇殿堂级音乐剧&lt;狮子王&gt;专题讲座》</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>89</td>
							<td>宝山市民艺术导赏《苏州园林经典赏析》</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>90</td>
							<td>“小松果”暑期电影展映《极地大冒险》</td>
							<td>松江区图书馆</td>
						</tr>
						<tr>
							<td>91</td>
							<td>百鸟朝凤—唢呐的前世今生</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>92</td>
							<td>凌云迎新春风起—新年交响音乐会</td>
							<td>凌云社区文化活动中心</td>
						</tr>
						<tr>
							<td>93</td>
							<td>上海博物馆景德镇瓷器精品赏析</td>
							<td>上海博物馆</td>
						</tr>
						<tr>
							<td>94</td>
							<td>导赏沙龙—小提琴协奏曲《梁祝》赏析</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>95</td>
							<td>滨江文化季—话剧《琥珀》</td>
							<td>五里桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>96</td>
							<td>塞万提斯的遗产：从《百年孤独》谈起</td>
							<td>中华艺术宫</td>
						</tr>
						<tr>
							<td>97</td>
							<td>沪剧《阿必大全传》</td>
							<td>大场镇社区文化活动中心</td>
						</tr>
						<tr>
							<td>98</td>
							<td>中外经典歌剧唱段导赏</td>
							<td>宝山区文化广播影视管理局</td>
						</tr>
						<tr>
							<td>99</td>
							<td>原创木偶剧《穿越“无礼国”》</td>
							<td>长桥社区文化活动中心</td>
						</tr>
						<tr>
							<td>100</td>
							<td>亲子—快乐小囡 沪语夏日会</td>
							<td>长桥社区文化活动中心</td>
						</tr>
						
					</table>
				</div>
			</div>
		</div>

	</div>
	<div class="prizeListPop" style="display: none;">
		<div style="overflow-y: scroll;height: 100%;width: 100%;-webkit-overflow-scrolling : touch;">
			<div style="padding: 20px 20px 120px;">
				<p style="text-align: center;font-size: 32px;color: #ba3d5b;line-height: 200px;">大赛简介</p>
				<p style="font-size: 25px;">&emsp;&emsp;由上海市民文化协会主办，上海创图网络科技股份发展有限公司承办的2016年上海市民文化节“文化上海云”应用大赛圆满结束了，通过广大会员单位的积极参与，在大赛中充分展现企业风采，涌现出一大批诸如“红星照耀中国纪念长征胜利80周年—挑战大转盘”一样优秀的云上活动，扩大了社会品牌效益，同时也为会员提供了更大平台和更多服务。<br /><br />&emsp;&emsp;各家参与对象根据自身特色，自主策划各类知识闯关竞赛、线上投票、线上展览等云上活动，并通过“文化云”互联网平台上传，从而获得市民的积极响应和广泛参与。从2016年3月26日至12月31日，全市共有207家单位发布了6363次OTO订票活动，12家单位在线上制作了28个线上专题。琳琅满目的文化活动涉及到全市各个公共文化演出场馆，这些精彩纷呈的中外文化活动，可谓是群英荟萃，目不暇接，赢得广大观众交口称赞，如：城市空间• 最美印象—市民微摄影征集活动、阅读中的真善美—市民微笔记阅读大赛、12小时艺术狂欢—现场直播、寻找最美笑脸 让生活充满爱—第二届上海国际喜剧节系列活动、大型原创情景剧《鲁迅在上海》、传承—“曲韵留风”京津沪渝非遗精品交流展演、曼舞长宁—舞蹈艺术欣赏季、冬之乐—2016上海城市草坪音乐会、2016中国上海国际艺术节—“艺术天空”专场、亲子—快乐小囡 沪语夏日会等优秀文化活动。<br /><br />&emsp;&emsp;“文化上海云”是汇聚上海公共文化活动资源的互联网平台，2016年上海市民文化节已于3月26日正式推出。在移动互联网日益改变人们生活方式的今天，基层公共文化单位和场馆通过互联网+公共文化的方式充分提升文化服务效能，同时随着日益成长发展的社会组织、文化团体和企业参与城市文化建设热情的提升，文化云也搭建了一个社会参与文化建设的平台。通过满足市民“我要知道、我要参与、我要评论、我要分享”的公共文化需求，提升上海公共文化机构和各方面社会力量为百姓提供公共文化服务的能力和口碑。<br /><br />&emsp;&emsp;“文化上海云”应用大赛旨在鼓励全市各层级公共文化单位和社会主体熟练使用文化上海云互联网平台，通过文化上海云发布和组织各类公共文化活动，能够熟练地在平台上进行公共文化活动运营，吸引、留存、扩展市民踊跃使用并参与文化上海云平台的设计发布的活动。本次大赛已评选出“100个最佳云上活动”。</p>
			</div>
		</div>
		<div style="position: fixed;left: 0;right: 0;bottom: 0;height: 100px;width: 100%;text-align: center;line-height: 100px;background-color: #ba3d5b;font-size: 30px;color: #fff;" onclick="$('.prizeListPop').hide()">关闭</div>
	</div>
</body>
</html>