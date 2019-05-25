package com.sun3d.why.controller.train;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.service.PeopleTrainService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsSend;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/***
 * 短息批量发送
 * 
 * @author zengjin
 *
 */
@Controller
@RequestMapping("/message")
public class MessageBatchSendController {

	private Logger logger = LoggerFactory.getLogger(MessageBatchSendController.class);

	@Autowired
	private PeopleTrainService peopleTrainService;

	@Autowired
	private HttpSession session;
	@Autowired
	private SmsSend smsSend;

	@RequestMapping(value = "/send/batch")
	@ResponseBody
	public Object messageBatchSend(String searchKey, TrainTerminalUser trainTerminalUser, Pagination page)
			throws Exception {
		Map<String, String> result = new HashMap<String, String>();
		result.put("result", "您还没有登录");
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			return result;
		}
		String context = "各位学员：2016年度上海市公共文化从业人员万人培训工作第三次报名将于9月7日上午9:00启动，请注意选课时间，课程详情可登录文化云官网或关注微信订阅号文化云进行预览。";
		List<TrainTerminalUser> users = peopleTrainService.queryPeopleTrainByCondition(searchKey, trainTerminalUser,
				page, sysUser);

		// TODO 发送短消息   真实
		 
		String res = "";
		for (TrainTerminalUser user : users) {
			res = this.smsSend.sendSmsMessage(user.getUserMobileNo(), context);
			if (!res.equals("100")) {
				logger.info("短信发送失败 {}", user.getUserMobileNo());
			}else{
				logger.info("短信发送 {}", user.getUserMobileNo());
			}
		} 
		 this.smsSend.sendSmsMessage("13817406320", context);
		result.put("result", "发送完成");
		return result;
	}

}
