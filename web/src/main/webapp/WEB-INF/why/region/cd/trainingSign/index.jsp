<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>2017常德市文化馆</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
	
	<script>
		var noControl = '${noControl}';	//1：不可操作
		//参数变量
		var signCourse;
		var signType;
		var signSmsType;
		var limitNum;
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '报名 | 常德文化馆公益培训招生啦';
	    	appShareDesc = '2.28-3.1 热爱艺术的朋友快来看看是否有您喜爱的课程';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w';
	    	
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
					title: "报名 | 常德文化馆公益培训招生啦",
					desc: '2.28-3.1 热爱艺术的朋友快来看看是否有您喜爱的课程',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w'
				});
				wx.onMenuShareTimeline({
					title: "报名 | 常德文化馆公益培训招生啦",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w'
				});
				wx.onMenuShareQQ({
					title: "报名 | 常德文化馆公益培训招生啦",
					desc: '2.28-3.1 热爱艺术的朋友快来看看是否有您喜爱的课程',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w'
				});
				wx.onMenuShareWeibo({
					title: "报名 | 常德文化馆公益培训招生啦",
					desc: '2.28-3.1 热爱艺术的朋友快来看看是否有您喜爱的课程',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w'
				});
				wx.onMenuShareQZone({
					title: "报名 | 常德文化馆公益培训招生啦",
					desc: '2.28-3.1 热爱艺术的朋友快来看看是否有您喜爱的课程',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017224141553mh0JSSulmUlXoNHiPNdpajp6Z462gr.jpg@300w'
				});
			});
		}
		
		$(function () {
		     // 导航固定
		    function navFixed(ele, type, topH) {
		        $(document).on(type, function() {
		            if($(document).scrollTop() > topH) {
		                ele.css('position', 'fixed');
		            } else {
		                ele.css('position', 'static');
		            }
		        });
		    }
		    navFixed($(".listTit"),'touchmove',242);
		    navFixed($(".listTit"),'scroll',242);

		    //标签切换
		    $('.listTit li').bind('click', function () {
		        $('.listTit li').removeClass('current');
		        $(this).addClass('current');
		        $('.contentWc .content').hide();
		        $('.contentWc .content').eq($(this).index()).show();
		    });

		    //禁止滚动
		    $('.changTanWC').bind('touchmove', function () {
		        return false;
		    });

		    //取消，确认
		    $('#tan1 .btn1,#tan2 .btn2').bind('click', function () {
		        $(this).parents('.changTanWC').hide();
		    });
		});
		
		//立即报名
		function toSign(param1,param2,param3,param4){
			if(noControl == 1){
				dialogAlert('系统提示', '报名已截止！');
			}else if(noControl == 2){
				dialogAlert('系统提示', '报名尚未开始！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}trainingSign/index.do");
	        	}else{
    				$.post("${path}/trainingSign/checkSignLimit.do", {signCourse:param1,limitNum:param4}, function(data) {
    					if (data == "200") {
    						signCourse = param1;
    		        		signType = param2;
    		        		signSmsType = param3;
    		        		limitNum = param4;
    		        		$("#signName").val("");
    		        		$("#signSexF").prop('checked', true);
    		        		$("#signIdcard").val("");
    		        		$("#signMobile").val("");
    		        		$('#tan1').show();
    					}else if(data == "limit"){
    						dialogAlert('系统提示', "该课程报名已满！");
    					}else {
    						dialogAlert('系统提示', "提交失败！");
    					}
    				},"json");
	        	}
			}
		}
		
		//提交
		function addSign(){
			if(noControl == 1){
				dialogAlert('系统提示', '报名已截止！');
			}else if(noControl == 2){
				dialogAlert('系统提示', '报名尚未开始！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}trainingSign/index.do");
	        	}else{
	        		$("#addSignBtn").attr("onclick", "");
	        		
	        		var signName = $("#signName").val();
					if(!signName){
				    	dialogAlert('系统提示', '请输入姓名！');
				    	$("#addSignBtn").attr("onclick", "addSign();");
				        return false;
				    }
					var signSex = $("#signSexTd input[name='sex']:checked").val();
					var signIdcard = $("#signIdcard").val();
					var idCardReg = (/^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/);
					if (!signIdcard) {
	                    dialogAlert('系统提示', '请输入身份证号！');
	                    $("#addSignBtn").attr("onclick", "addSign();");
	                    return false;
	                } else if (!signIdcard.match(idCardReg)) {
	                    dialogAlert('系统提示', '请正确填写身份证号！');
	                    $("#addSignBtn").attr("onclick", "addSign();");
	                    return false;
	                }
		    		var signMobile = $("#signMobile").val();
					var telReg = (/^1[34578]\d{9}$/);
					if(!signMobile){
				    	dialogAlert('系统提示', '请输入手机号码！');
				    	$("#addSignBtn").attr("onclick", "addSign();");
				        return false;
				    }else if(!signMobile.match(telReg)){
				    	dialogAlert('系统提示', '请正确填写手机号码！');
				    	$("#addSignBtn").attr("onclick", "addSign();");
				        return false;
				    }
					var data = {
						userId:userId,
						signCourse:signCourse,
						signType:signType,
						signName:signName,
						signSex:signSex,
						signIdcard:signIdcard,
						signMobile:signMobile,
						signSmsType:signSmsType,
						limitNum:limitNum
					}
					$.post("${path}/trainingSign/addSign.do", data, function(data) {
						if (data == "200") {
							$('.changTanWC').hide();
							$('#tan2').show();
						}else if(data == "limit"){
							dialogAlert('系统提示', "该课程报名已满！");
						}else if(data == "repeat"){
							dialogAlert('系统提示', "该身份证已被使用！");
						}else {
							dialogAlert('系统提示', "提交失败！");
						}
						$("#addSignBtn").attr("onclick", "addSign();");
					},"json");
	        	}
			}
		}
	</script>
	
	<style type="text/css">
	    html,body {background-color: #f5f5f5;}
	</style>
</head>

<body>
	<div class="changde">
	    <div class="ban"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222161253NTeWdmGQVAf7z6vppXPZoCoGstzF5Y.jpg"></div>
	    <div class="listTitWc">
	        <ul class="listTit clearfix">
	            <li class="current"><a href="javascript:;">成年人培训</a></li>
	            <li><a href="javascript:;">外来务工子女</a></li>
	        </ul>
	    </div>
	
	    <div class="contentWc">
	        <div class="content">
	            <div class="charWc">
	                <div class="char">
	                    <p>常德市文化馆公益培训招生啦，热爱艺术的朋友快来看看是否有您喜爱的课程。</p>
	                    <p>为贯彻落实《中华人民共和国公共文化服务保障法》，推动我市公共文化服务体系建设，让更多的市民朋友享受公共文化服务权益，满足市民朋友日益增长的文化生活需求，常德市文化馆公益培训班将于2017年3月全面招生开课。</p>
	                </div>
	                <div class="tishi">
	                    <table>
	                        <tr>
	                            <td class="td1">报名时间：</td>
	                            <td class="td2">2017.2.28 上午10:00 至 2017.3.1 下午17:00</td>
	                        </tr>
	                        <tr>
	                            <td class="td1">招生计划：</td>
	                            <td class="td2">报名人数请看招生计划，招生数量有限，报完即止。</td>
	                        </tr>
	                        <tr class="red">
	                            <td class="td1">友情提示：</td>
	                            <td class="td2">每位用户每个身份证号只能报名一次，每次只能报一个课程。</td>
	                        </tr>
	                    </table>
	                </div>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>舞 蹈</span></div>
	                    <div class="xiao">共8个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315197TkbyYg3iUYBL4ecXCrcH5eknUt0ncf.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈1班（中国民族舞蹈）</span></p>
	                                <p><span>授课老师：</span>刘剑蓉</p>
	                                <p><span>招生计划：</span>招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40-65周岁，身体康健有一定舞蹈基础的民族舞蹈好爱者。</p>
	                                <p><span>教学内容：</span>藏族舞《布达拉》、秧歌《小看戏》</p>
	                                <p><span>教学时间：</span>每周四上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈1班（中国民族舞蹈）',1,1,25);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152040MxYHaRUBRLSYoFbIGSN4wspRwwctvo.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈2班（中国古典汉唐）</span></p>
	                                <p><span>授课老师：</span>胡丽娜</p>
	                                <p><span>招生计划：</span>每班招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定舞蹈基础的古典舞蹈爱好者。</p>
	                                <p><span>教学内容：</span>中国古典汉唐教学内容：基本体态训练、手位、舞姿训练、基本舞姿组合。</p>
	                                <p><span>教学时间：</span>每周二上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈2班（中国古典汉唐）',1,1,25);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152040MxYHaRUBRLSYoFbIGSN4wspRwwctvo.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈3班（中国古典敦煌）</span></p>
	                                <p><span>授课老师：</span>胡丽娜</p>
	                                <p><span>招生计划：</span>每班招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定舞蹈基础的古典舞蹈爱好者。</p>
	                                <p><span>教学内容：</span>中国敦煌舞蹈教学内容：启示冥想——手势与气韵训练组合；伎乐弄腰——腰和跨步韵律训练组合；步态生莲——伎乐天脚位，步伐训练组合；综合性组合。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈3班（中国古典敦煌）',1,1,25);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152149ufHacixjgbQV2Zme7kgTRUju98HRKW.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈4班（初级芭蕾）</span></p>
	                                <p><span>授课老师：</span>黄茜</p>
	                                <p><span>招生计划：</span>每班招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定舞蹈基础的芭蕾舞蹈爱好者。</p>
	                                <p><span>教学内容：</span>芭蕾元素性训练、芭蕾舞姿训练、其它舞种的结合。</p>
	                                <p><span>教学时间：</span>每周二上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈4班（初级芭蕾）',1,1,25);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152149ufHacixjgbQV2Zme7kgTRUju98HRKW.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈5班（初级芭蕾）</span></p>
	                                <p><span>授课老师：</span>黄茜</p>
	                                <p><span>招生计划：</span>每班招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定舞蹈基础的芭蕾舞蹈爱好者。</p>
	                                <p><span>教学内容：</span>芭蕾元素性训练、芭蕾舞姿训练、其它舞种的结合。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈5班（初级芭蕾）',1,1,25);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315236DvajSgjyfSUu3WnE466GGEIZy0gbfM.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈6班（广场舞）</span></p>
	                                <p><span>授课老师：</span>刘颖</p>
	                                <p><span>招生计划：</span>招收学员30人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁身体健康广场舞爱好者。</p>
	                                <p><span>教学内容：</span>基本动作训练、基本节奏训练、广场舞组合。</p>
	                                <p><span>教学时间：</span>每周五上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈6班（广场舞）',1,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222175329rKlpsy166VgpJbguEqZjZz3FqeIKli.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈7班（交谊舞）</span></p>
	                                <p><span>授课老师：</span>李建英、曹宏</p>
	                                <p><span>招生计划：</span>招收学员30人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康交谊舞爱好者。</p>
	                                <p><span>教学内容：</span>国家标准拉丁舞、伦巴基础性训练。</p>
	                                <p><span>教学时间：</span>每周一上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈7班（交谊舞）',1,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152349rM8gGAI50247qgov6QbniK5l9qTZeJ.png"></div>
	                            <div class="wenz">
	                                <p><span>舞蹈8班（现当代舞）</span></p>
	                                <p><span>授课老师：</span>杨艾</p>
	                                <p><span>招生计划：</span>招收学员25人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在30—65周岁现当代舞爱好者。</p>
	                                <p><span>教学内容：</span>现代舞《演员》、当代舞《九儿》。</p>
	                                <p><span>教学时间：</span>每周四上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈8班（现当代舞）',1,1,25);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>声 乐</span></div>
	                    <div class="xiao">共2个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017227173043hdtlurJpzWXBuULm9jpbYRMMDvpQoG.png"></div>
	                            <div class="wenz">
	                                <p><span>声乐1班</span></p>
	                                <p><span>授课老师：</span>陈志斌</p>
	                                <p><span>招生计划：</span>每班招收学员60人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40-65周岁，身体健康声乐爱好者。</p>
	                                <p><span>教学内容：</span>音乐理论基础知识、演唱技巧、合唱排练。</p>
	                                <p><span>教学时间：</span>每周二上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('声乐1班',1,1,60);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152519YBXKE199vdrEeQ7etifrTvCEExc2IK.png"></div>
	                            <div class="wenz">
	                                <p><span>声乐2班</span></p>
	                                <p><span>授课老师：</span>李子</p>
	                                <p><span>招生计划：</span>每班招收学员60人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40-65周岁，身体健康声乐爱好者。</p>
	                                <p><span>教学内容：</span>音乐理论基础知识、演唱技巧、合唱排练。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('声乐2班',1,1,60);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>器 乐</span></div>
	                    <div class="xiao">共5个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152634oAU92JJxPgoJ4YENkTwhxfAEeQr6hk.png"></div>
	                            <div class="wenz">
	                                <p><span>钢琴1班</span></p>
	                                <p><span>授课老师：</span>罗娟娟</p>
	                                <p><span>招生计划：</span>每班招收学员10人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在45-65周岁，喜爱音乐，对钢琴学习有浓厚兴趣者。</p>
	                                <p><span>教学内容：</span>识谱、简单左右手指法运用、简单乐曲弹奏。</p>
	                                <p><span>教学时间：</span>每周一上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('钢琴1班',1,2,10);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152634oAU92JJxPgoJ4YENkTwhxfAEeQr6hk.png"></div>
	                            <div class="wenz">
	                                <p><span>钢琴2班</span></p>
	                                <p><span>授课老师：</span>罗娟娟</p>
	                                <p><span>招生计划：</span>每班招收学员10人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在45-65周岁，喜爱音乐，对钢琴学习有浓厚兴趣者。</p>
	                                <p><span>教学内容：</span>识谱、简单左右手指法运用、简单乐曲弹奏。</p>
	                                <p><span>教学时间：</span>每周一下午2:00—4:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('钢琴2班',1,2,10);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152795hpN8HIt5vOo9wV0hIxXx3SHBTBXiD.png"></div>
	                            <div class="wenz">
	                                <p><span>古筝班</span></p>
	                                <p><span>授课老师：</span>李贞</p>
	                                <p><span>招生计划：</span>招收学员24人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40-65周岁，喜爱音乐，对古筝学习有浓厚兴趣者。</p>
	                                <p><span>教学内容：</span>古筝基本乐理、古筝基本指法、简单乐曲弹奏。</p>
	                                <p><span>教学时间：</span>每周四上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('古筝班',1,2,24);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223152849ELnAWYDu1eX8a7N731U3h3LpxZNur1.png"></div>
	                            <div class="wenz">
	                                <p><span>二胡班</span></p>
	                                <p><span>授课老师：</span>杨皓</p>
	                                <p><span>招生计划：</span>招收学员15人，额满为止（上课乐器自备）。</p>
	                                <p><span>招生对象：</span>年龄在45-65周岁，喜爱音乐，对二胡学习有浓厚兴趣者。</p>
	                                <p><span>教学内容：</span>持琴基本姿势、基本乐理入门、基本调式练习曲演奏。</p>
	                                <p><span>教学时间：</span>每周五上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('二胡班',1,2,15);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722218658SWRBmcMYlZTzqooqvF4cF90T48RnHo.png"></div>
	                            <div class="wenz">
	                                <p><span>葫芦丝班</span></p>
	                                <p><span>授课老师：</span>苏平</p>
	                                <p><span>招生计划：</span>招收学员30人，额满为止（上课乐器自备）。</p>
	                                <p><span>招生对象：</span>年龄在45-65周岁，喜爱音乐，对葫芦丝学习有浓厚兴趣者。</p>
	                                <p><span>教学内容：</span>基础乐理、基本演奏法、1—3级乐曲练习。</p>
	                                <p><span>教学时间：</span>每周五上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('葫芦丝班',1,2,30);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>美术书法</span></div>
	                    <div class="xiao">共5个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315300pxLTgQ0DqD6FhUWodOcFtegNCl8BFo.png"></div>
	                            <div class="wenz">
	                                <p><span>美术1班（素描）</span></p>
	                                <p><span>授课老师：</span>熊海扬</p>
	                                <p><span>招生计划：</span>每班招收学员15人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定绘画基础的美术爱好者。</p>
	                                <p><span>教学内容：</span>素描基础教学和提高。</p>
	                                <p><span>教学时间：</span>每周二上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('美术1班（素描）',1,2,15);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315300pxLTgQ0DqD6FhUWodOcFtegNCl8BFo.png"></div>
	                            <div class="wenz">
	                                <p><span>美术2班（素描）</span></p>
	                                <p><span>授课老师：</span>熊海扬</p>
	                                <p><span>招生计划：</span>每班招收学员15人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定绘画基础的美术爱好者。</p>
	                                <p><span>教学内容：</span>素描基础教学和提高。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('美术2班（素描）',1,2,15);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017227173610gWlVVvkd49ZiIh3K5co6A5DzGxDzBy.png"></div>
	                            <div class="wenz">
	                                <p><span>美术3班（新水墨画）</span></p>
	                                <p><span>授课老师：</span>杨新明</p>
	                                <p><span>招生计划：</span>招收学员15人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—65周岁，身体健康有一定绘画基础的美术爱好者。</p>
	                                <p><span>教学内容：</span>基层线描、花鸟临摹、自选课题、命题创作。</p>
	                                <p><span>教学时间：</span>每周二上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('美术3班（新水墨画）',1,2,15);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315304358zYjAsZG4VduDNVBlNACEGH5en3kD.png"></div>
	                            <div class="wenz">
	                                <p><span>书法1班</span></p>
	                                <p><span>授课老师：</span>钟儒慧</p>
	                                <p><span>招生计划：</span>每班招收学员20人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—70周岁，身体健康书法爱好者。</p>
	                                <p><span>教学内容：</span>楷书、行书的练习与临摹创作。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('书法1班',1,2,20);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201722315304358zYjAsZG4VduDNVBlNACEGH5en3kD.png"></div>
	                            <div class="wenz">
	                                <p><span>书法2班</span></p>
	                                <p><span>授课老师：</span>钟儒慧</p>
	                                <p><span>招生计划：</span>每班招收学员20人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在40—70周岁，身体健康书法爱好者。</p>
	                                <p><span>教学内容：</span>楷书、行书的练习与临摹创作。</p>
	                                <p><span>教学时间：</span>每周四上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('书法2班',1,2,20);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>其 他</span></div>
	                    <div class="xiao">共2个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017227173712YQlSQaU9xMA6ksWE4124yXFzLPDmPS.png"></div>
	                            <div class="wenz">
	                                <p><span>语言艺术班</span></p>
	                                <p><span>授课老师：</span>赵玮</p>
	                                <p><span>招生计划：</span>招收学员40人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在30—65周岁，身体健康且语言艺术爱好者。</p>
	                                <p><span>教学内容：</span>语音培训、朗诵表演、故事演讲。</p>
	                                <p><span>教学时间：</span>每周四上午9:00-11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('语言艺术班',1,2,40);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017222182320P4wDPMjlrl3N7aQFF3mnwVFIKb6XO2.png"></div>
	                            <div class="wenz">
	                                <p><span>电脑班</span></p>
	                                <p><span>授课老师：</span>李铁苗</p>
	                                <p><span>招生计划：</span>招收学员20人，额满为止。</p>
	                                <p><span>招生对象：</span>年龄在45—65周岁，身体健康且电脑爱好者。</p>
	                                <p><span>教学内容：</span>常见PC机的软硬件基础知识及其应用。</p>
	                                <p><span>教学时间：</span>每周三上午9:00—11:00</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('电脑班',1,2,20);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	        <div class="content" style="display:none;">
	            <div class="charWc">
	                <div class="char">
	                    <p>常德市外来务工人员子女免费艺术培训班是我馆 “文化惠民”的一项开创性举措，旨在增强孩子们自信、自立、自强的意识，提高孩子们的艺术素养，让他们感受更多的关爱。为了实现公益培训均等化，2017年我馆将在全市范围内招收符合条件的外来务工人员子女公益培训班5个。</p>
	                </div>
	                <div class="tishi">
	                    <table>
	                        <tr>
	                            <td class="td1">报名时间：</td>
	                            <td class="td2">2017.2.28 上午10:00 至 2017.3.1 下午17:00</td>
	                        </tr>
	                        <tr>
	                            <td class="td1">招生对象：</td>
	                            <td class="td2">外来务工人员子女（三至六年级小学生）</td>
	                        </tr>
	                        <tr>
	                            <td class="td1">招生计划：</td>
	                            <td class="td2">每班招生30人，招生数量有限，报完即止。</td>
	                        </tr>
	                        <tr>
	                            <td class="td1">咨询电话：</td>
	                            <td class="td2">0736-7222902</td>
	                        </tr>
	                        <tr class="red">
	                            <td class="td1">友情提示：</td>
	                            <td class="td2">每位用户每个身份证号只能报名一次，每次只能报一个课程。</td>
	                        </tr>
	                    </table>
	                </div>
	            </div>
	            <div class="listWc">
	                <div class="biao">
	                    <div class="tit"><span>课 程</span></div>
	                    <div class="xiao">共5个班</div>
	                </div>
	                <ul class="listUl">
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223153209AcWbg96Lt43o5O4nyFctFjx1nkbSi.png"></div>
	                            <div class="wenz">
	                                <div class="clearfix"><p style="float:left"><span>舞蹈班</span></p><p style="float:right"><span>授课老师：</span>彭惠芳</p></div>
	                                <p><span>教学目标：</span>学习舞蹈的基础知识，培养少儿良好的艺术气质和优雅的行为举止</p>
	                                <p><span>教学内容：</span>热身小舞蹈、北舞教材、群舞排练</p>
	                                <p><span>教学时间：</span>每周六上午9:00—11:00</p>
	                                <p><span>教学地点：</span>舞蹈教室</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('舞蹈班',2,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017223153237MCt6FQVblIO1C0CWAPMxWQMQa59ess.png"></div>
	                            <div class="wenz">
	                                <div class="clearfix"><p style="float:left"><span>美术班</span></p><p style="float:right"><span>授课老师：</span>胡雅琦</p></div>
	                                <p><span>教学目标：</span>培养孩子们的观察力和大胆表现的能力，学习内容以培养孩子创意思维为主导，用艺术的审美眼光观察世事万物，用艺术的发散思维方式去了解世界，让孩子对绘画产生兴趣，有无限的创造力。</p>
	                                <p><span>教学内容：</span>绘画基本功练习、色彩练习、版画学习、手工、写生练习、临摹大师作品。</p>
	                                <p><span>教学时间：</span>每周日下午2:30-4:30</p>
	                                <p><span>教学地点：</span>书法教室</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('美术班',2,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017227173412bKU8sI1b1d9QlJMhCkgUSjkekLZrEs.png"></div>
	                            <div class="wenz">
	                                <div class="clearfix"><p style="float:left"><span>书法班</span></p><p style="float:right"><span>授课老师：</span>杨程程</p></div>
	                                <p><span>教学目标：</span>培养学生正确的书写习惯，提高书写水平，增强对中国传统艺术文化的认知。</p>
	                                <p><span>教学内容：</span>楷书的基础入门、基本笔画、基本结构（独体字和复合字）、古帖临摹</p>
	                                <p><span>教学时间：</span>每周六下午2:30—4:30</p>
	                                <p><span>教学地点：</span>书法教室</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('书法班',2,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20172231533120QLIfjmUwJCxbFZtcMHnjkjFHk0zB2.png"></div>
	                            <div class="wenz">
	                                <div class="clearfix"><p style="float:left"><span>武术班</span></p><p style="float:right"><span>授课老师：</span>胡雅诗</p></div>
	                                <p><span>教学目标：</span>经过一个学期的学习和授课，可以完成《千字文》集体拳全套的表演展示，并配合适当音乐，提升展示效果。</p>
	                                <p><span>教学内容：</span>武术的基本知识、基本功、基本动作</p>
	                                <p><span>教学时间：</span>每周日上午9:00-11:00</p>
	                                <p><span>教学地点：</span>舞蹈教室</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('武术班',2,1,30);">报名已满</div>
	                    </li>
	                    <li>
	                        <div class="nc clearfix">
	                            <div class="pic"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017227173245GaliOCH48kYaTWMglTr44oNixbuMXj.png"></div>
	                            <div class="wenz">
	                                <div class="clearfix"><p style="float:left"><span>拉丁舞班</span></p><p style="float:right"><span>授课老师：</span>李建英</p></div>
	                                <p><span>教学目标：</span>通过学习使学生形体得到一定改变，培养学生的乐感及协调性，掌握一定的拉丁舞基本技术要领及一些舞台艺术表演的方法</p>
	                                <p><span>教学内容：</span>伦巴的形体训练、拉丁舞的基础训练、伦巴的集体舞</p>
	                                <p><span>教学时间：</span>每周日上午9:00—11:00</p>
	                                <p><span>教学地点：</span>舞蹈教室</p>
	                            </div>
	                        </div>
	                        <div class="ljbm btnDis" onclick="toSign('拉丁舞班',2,1,30);">报名已满</div>
	                    </li>
	                </ul>
	            </div>
	        </div>
	    </div>
	    <!-- 培训报名弹窗 -->
	    <div class="changTanWC" style="display:none;" id="tan1">
	        <div class="changTan">
	            <div class="tit">培训报名</div>
	            <table class="tab">
	                <tr>
	                    <td class="td1">姓　　名</td>
	                    <td class="td2"><input class="txt" type="text" id="signName" maxlength="20"></td>
	                </tr>
	                <tr>
	                    <td class="td1">性　　别</td>
	                    <td class="td2" id="signSexTd">
	                        <label class="danx"><input id="signSexF" type="radio" name="sex" value="1" checked> 男</label>
	                        <label class="danx"><input type="radio" name="sex" value="2"> 女</label>
	                    </td>
	                </tr>
	                <tr>
	                    <td class="td1">身份证号</td>
	                    <td class="td2"><input class="txt" type="text" id="signIdcard" maxlength="18"></td>
	                </tr>
	                <tr>
	                    <td class="td1">手　　机</td>
	                    <td class="td2"><input class="txt" type="text" id="signMobile" maxlength="11"></td>
	                </tr>
	            </table>
	            <div class="btnDiv">
	                <div class="btn1">取消</div>
	                <div id="addSignBtn" class="btn2" onclick="addSign();">确认报名</div>
	            </div>
	        </div>
	    </div>
	    <!-- 报名成功 -->
	    <div class="changTanWC" style="display:none;" id="tan2">
	        <div class="changTan">
	            <div class="tit">报名成功</div>
	            <div class="neir">
	                请您凭收到的短信前往常德市文化馆艺术活动中心确认成功报名。<br><br>
	                咨询电话：<a href="tel:0736-7222902" style="color:#6875b5;">0736-7222902</a>
	            </div>
	            <div class="btnDiv">
	                <div class="btn2" style="width:308px;">确认</div>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>