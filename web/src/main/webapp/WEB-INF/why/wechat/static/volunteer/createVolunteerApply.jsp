<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·文化志愿者报名</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css">
		
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/volunteersUpload.js"></script>
	
	<style>
		.volunteers-content {
			padding-bottom: 100px;
		}
	</style>

	<script>
	
	//分享是否隐藏
  	 if(window.injs){
   	
		injs.setAppShareButtonStatus(false);
	}
	
		//判断图片按钮是否显示
		function imgButton() {
			var clnum = $(".vUserUpl-list li");
			if(clnum.length >= 10) {
				$(".vUserUp-button").hide();
			} else {
				$(".vUserUp-button").show();
			}
		}
		
		// 学历
	    function getDegreeType(){
	        $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'education'},function(data) {
	            if (data != '' && data != null) {
	               var list = eval(data);
	               TypeChose(list, "volunteerApplyForm #volunteerDegree","volunteerApplyForm #degreeName") 
	            }
	        });
	    }
		
		// 加载招募集合
		function getRecruitList(){
			
			  $.post("${path}/wechatStatic/getVolunteerRecruitList.do",function(data) {
				  
		            if (data.status==1) {
		            	
		            	var list=new Array();
		            	
		            	list.push({dictId:'',dictName:'不限'})
		            	
		               	$.each(data.data,function(i,dom){
		    				
		               		list.push({dictId:dom.recruitId,dictName:dom.recruitName})
		    			});
		               	
		               	TypeChose(list, "volunteerApplyForm #recruitId","volunteerApplyForm #recruitName") 
		            }
		        }, "json");
		}
		
		$(function () {
			
			var recruitId=$("#recruitId").val();
			
			// 保存
			$(".volunteers-footer").click(function () {
				
				if (userId ==null || userId == '') {
					
					if(recruitId)
		           		 publicLogin("${basePath}wechatStatic/createVolunteerApply.do?recruitId=" + recruitId);
					else
						 publicLogin("${basePath}wechatStatic/createVolunteerApply.do");
		            return ;
		        }
				
				var volunteerRealName=$("#volunteerRealName").val();
				var volunteerMobile=$("#volunteerMobile").val();
				var volunteerAge=$("#volunteerAge").val();
				var volunteerSex=$("input[name='volunteerSex']:checked").val();
				var volunteerDegree=$("#volunteerDegree").val();
				
				 if(volunteerRealName.trim()==""){
	    	        	dialogAlert('系统提示', '姓名为必填项！');
	    	            return;
	    	        }
				 
				 if(volunteerRealName.length>50){
	    	        	dialogAlert('系统提示', '姓名长度不能大于50！');
	    	            return;
	    	        }
				 
				 
				var isMobile=/^(?:13\d|15\d|18\d|17\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则
				 
				 if(!isMobile.test(volunteerMobile)){
	    	        	dialogAlert('系统提示', '手机格式不正确！');
	    	            return;
	    	        }
				 
				 if(volunteerAge.trim()==""){
	    	        	dialogAlert('系统提示', '年龄为必填项！');
	    	            return;
	    	        }
				 
					var reg=/^[1-9]([0-9]*)$/;
					if(!reg.test(volunteerAge)){
						dialogAlert('提示', "年龄必须为数字!");
						return ;
					}
				 
				 if(!volunteerSex) {
	    	        	dialogAlert('系统提示', '性别为必选项！');
	    	            return;
	    	        }
				 
				 if(!volunteerDegree) {
	    	        	dialogAlert('系统提示', '学历为必选项！');
	    	            return;
	    	        }
				 
				var formData= $("#volunteerApplyForm").serializeArray();
				
				
				$("#volunteerApplyForm .vUserUpl-list li.upload-state-done").each(function(index, element) {
	    			formData.push({'name':'volunteerApplyPic','value':$(element).attr("commentimgurl")});
	    		});
				
				$.post("${path}/wechatStatic/saveVolunteerApply.do",formData, function(data) {
	    			
	    			if(data.status==1){

	    				dialogConfirm('提示', "报名成功！", function () {
                          	location.href = "${path}/wechatStatic/volunteerRecruitIndex.do";
                        });
	    				
	    			}else{
	    				dialogAlert('提示', data.msg);
	    			}
	    		},'json');
		    })
		});
	</script>
	
	</head>

	<body>
	<form id="volunteerApplyForm" >
	<input id="userId" type="hidden" name="userId" value="${sessionScope.terminalUser.userId}"/>
	<input id="recruitId" type="hidden" name="recruitId" value="${recruitId }"/>
	<div class="volunteers-main">
			<div class="volunteers-content">
				<div class="vUserInfo">
					<ul>
						<li>
							<label>姓名：</label>
							<input id="volunteerRealName" name="volunteerRealName" type="text" />
						</li>
						<li>
							<label>手机：</label>
							<input id="volunteerMobile" name="volunteerMobile" type="text"/>
						</li>
						<li>
							<label>年龄：</label>
							<input type="text" id="volunteerAge" name="volunteerAge"/>
						</li>
						<li>
							<label>性别：</label>
							<span><input type="radio" name="volunteerSex" value="0" />男<input type="radio" name="volunteerSex" value="1" />女</span>
						</li>
						<li>
							<label>学历：</label>
							<span id="degreeName" ></span>
							<input type="hidden" id="volunteerDegree" name="volunteerDegree"/>
							<div class="scChoose" onclick="getDegreeType();">
								<p>选择</p>
							</div>
							<div style="clear: both;"></div>
						</li>
						<li >
							<label>自我介绍：</label>
							<textarea id="volunteerIntroduction" name="volunteerIntroduction" style="resize: none;width: 540px;height: 200px;border: none;font-size: 30px;line-height: 70px;"></textarea>
						</li>
					</ul>
				</div>
			
				<div class="vUserUpl vUserInfo">
					<ul>
						<c:if test="${empty recruitId }">
						<li>
							<label>意向志愿者团体：</label>
							<span id="recruitName"></span>
							<div class="scChoose" onclick="getRecruitList();">
								<p>选择</p>
							</div>
							<div style="clear: both;"></div>
						</li>
						</c:if>
						<li>
							<label>照片：</label>
							<div class="vUserUpl-list">
								<ul id="vUserUplList">
									<li class="vUserUp-button uploadClass">
										<div >
											<img src="${path}/STATIC/wechat/image/add-comment.png" />
										</div>
									</li>
									<div style="clear: both;"></div>
								</ul>
								
							</div>
						</li>
					</ul>
				</div>
				
			</div>
			<div class="volunteers-footer" style="z-index:3;">
				<p>我要报名</p>
			</div>
		</div>
		</form>
	</body>

</html>