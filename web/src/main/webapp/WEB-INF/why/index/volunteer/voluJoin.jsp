<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp" %>
<!--阿里上传-->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/ossjs/aliUploadStyle.css" />
<script type="text/javascript" src="${path}/STATIC/ossjs/crypto.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/hmac.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/sha1.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/base64.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/plupload.full.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/upload.js"></script>
<script type="text/javascript" src="${path}/STATIC/ossjs/uuid.js"></script>
		<title>安康文化云</title>
		<style type="text/css">
			html,
			body {
				background-color: #fafafa;
			}
			div[name=aliFile]{
				float: left;
				width: 140px;
				height: 140px;
				margin-right: 20px;
				margin-bottom: 10px;
			}
			div[name=aliFile] b,div[name=aliFile] span{
				display: none;
			}
			.imgPack{
				width: 140px;
				height: 140px;
				position: relative;
			}
			.imgPack .upload-img-identify{
				width: 140px;
				height: 140px;
			}
			.aliRemoveBtn{
				width: 20px;
				height: 20px;
				position: absolute;
				right: 0;top: 0;
			}
			#selectfiles{
				background-color: #a09ee0;
			}
			.subBtn{
				background-color: #a09ee0;
				width: 226px;
				height: 42px;
				margin: 75px auto 0;
				line-height: 42px;
				color: #fff;
				font-size: 18px;
				-webkit-border-radius: 5px;
				-moz-border-radius: 5px;
				border-radius: 5px;
				text-align: center;
			}
		</style>
	</head>
	
	<script>	
	var userId = '${sessionScope.terminalUser.userId}';
		function test(up, file, fileName){
			console.log('http://culturecloud.img-cn-hangzhou.aliyuncs.com/' + fileName)
		}
		$(function() {
			// 学历
			$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode' : 'education'},function(data) {
	            if (data != '' && data != null) {
	            	var list = data;
	                var ulHtml = '';
	                for (var i = 0; i < list.length; i++) {	    				
	                    var dict = list[i];
	                    ulHtml += '<option dictid="' + dict.dictId + '">'+ dict.dictName + '</option>';
	                }
	                $('#eduList').append(ulHtml);
            	}
	        },"json");
			
			console.log($("#select").val())
			
			aliUpload({
				uploadDomId:'webUpload',
				progressBar:false,
				callBackFunc:test,
				imgPreview:true,
				upLoadSrc:"H5",
				fileNum:2,
			})
			
			// 保存
			$(".subBtn").click(function () {
				
				if (userId ==null || userId == '') {
					dialogAlert("提示", '登录之后才能报名', function () {
	            		
	            	});
	            return;
		        }
				
				var volunteerRealName=$("#volunteerRealName").val();
				var volunteerMobile=$("#volunteerMobile").val();
				var volunteerAge=$("#volunteerAge").val();
				var volunteerSex=$("input[name='volunteerSex']:checked").val();
	 	        var volunteerDegree = $("#eduList").find("option:selected").attr("dictid");
	 	        $("#volunteerDegree").val(volunteerDegree);
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
				 var imgpic = $(".upload-img-identify");
		   	      	if(imgpic.length==0){
		   	        	dialogAlert('系统提示',"图片必须上传！");
		   	            return;
		   	      	}else{
		   	      		$("#volunteerApplyPic").val("");
		   	      		for(var i = 0;i < imgpic.length; i++){
		   	      			if($("#volunteerApplyPic").val().trim()==""){
		   						$("#volunteerApplyPic").val(imgpic[i].getAttribute('src'));
		   					}else{
		   						$("#volunteerApplyPic").val($("#volunteerApplyPic").val()+","+imgpic[i].getAttribute('src'));
		   					} 
		   	      		}
		   	      	}
				var formData= $("#volunteerApplyForm").serializeArray();
											
				$.post("${path}/volunteer/saveVolunteerApply.do",formData, function(data) {
	    			
	    			if(data.status==1){

	    				dialogConfirm('提示', "报名成功！", function () {
                          	location.href = "${path}/volunteer/volunteerRecruitIndex.do";
                        });
	    				
	    			}else{
	    				dialogAlert('提示', "报名失败！");
	    			}
	    		},'json');
		    })
		})
	</script>

	<body>
		<div class="hpMain">
	<div class="header">
	   <!-- 导入头部文件 -->
	<%@include file="/WEB-INF/why/index/header.jsp" %>
	</div>
			<!-- start 详情 -->
			<div class="detailMain">
				<div class="breadNavHp">您所在的位置：志愿者>志愿者报名</div>
				
			</div>
			<!-- end 详情 -->
			<form id="volunteerApplyForm" >
			<input id="userId" type="hidden" name="userId" value="${sessionScope.terminalUser.userId}"/>
			<input id="recruitId" type="hidden" name="recruitId" value="${recruitId }"/>
			<div class="wjFormBg">
				<div class="wjFormList">
					<ul>
						<li>
							<span>姓&emsp;&emsp;名</span>
							<input id="volunteerRealName" name="volunteerRealName" type="text" />
						</li>
						<li>
							<span>手&emsp;&emsp;机</span>
							<input id="volunteerMobile" name="volunteerMobile" type="text"/>
						</li>
						<li>
							<span>年&emsp;&emsp;龄</span>
							<input type="text" id="volunteerAge" name="volunteerAge"/>
						</li>
						<li>
							<span>性&emsp;&emsp;别</span>
							<label>
								<input type="radio" name="volunteerSex" value="0" checked=""/>
								男
							</label>
							<label>
								<input type="radio" name="volunteerSex" value="1"/>
								女
							</label>
						</li>
						<li>
							<span>学&emsp;&emsp;历</span>
							<select id="eduList">
								
							</select>
							<input type="hidden" id="volunteerDegree" name="volunteerDegree"/>
						</li>
						<li>
							<span>自我介绍</span>
							<textarea id="volunteerIntroduction" name="volunteerIntroduction"></textarea>
						</li>
					</ul>
					<div class="clearfix">
					<input id="volunteerApplyPic" name="volunteerApplyPic" type="hidden"/>
						<span style="float: left;margin-right: 20px;">照&emsp;&emsp;片</span>
						<div id="webUpload" style="width: 300px;float: left;">
							<div id="ossfile" class="clearfix" style="margin-right: -20px;"></div>
							<div id="container">
								<button id="selectfiles" href="javascript:void(0);" class='btn'>选择文件</button>
							</div>
						</div>
					</div>
					<div class="subBtn">提交</div>
				
				</div>
				
			</div>
		</form>
		</div>
		<!-- 导入尾部文件 -->
	<%@include file="/WEB-INF/why/index/footer.jsp" %>
	</body>
</html>