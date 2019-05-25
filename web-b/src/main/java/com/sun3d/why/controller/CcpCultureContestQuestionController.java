package com.sun3d.why.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import com.culturecloud.model.bean.culture.CcpCultureContestOption;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpCultureContestQuestionService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/CultureContestQuestion")
@Controller
public class CcpCultureContestQuestionController {
	private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);
	@Autowired
	private CcpCultureContestQuestionService ccpCultureContestQuestionService;

	/**
	 * 新增题库跳转
	 * 
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/addCultureContestQuestion")
	public ModelAndView queryCultureContestUser(CcpCultureContestQuestion question) {
		ModelAndView model = new ModelAndView();
		model.addObject("stageNumber", question.getStageNumber());
		model.setViewName("admin/cultureContest/cultrueContestQuestionAdd");
		return model;
	}

	/**
	 * 新增题库
	 * 
	 * @return ModelAndView 新增插入操作
	 */
	@RequestMapping(value = "/insertCultureContestQuestion", method = RequestMethod.POST)
	@ResponseBody
	public String insertCultureContestQuestion(CcpCultureContestQuestion question, int[] rightAnswer,
			String[] optionContent, HttpSession session) {
		try {
			ModelAndView model = new ModelAndView();
			SysUser user = (SysUser) session.getAttribute("user");
			String name = user.getUserId();
			String questionContent = question.getQuestionContent().trim();
			question.setQuestionContent(questionContent);
			question.setQuestionCreateUser(name);
			ccpCultureContestQuestionService.insertCultureContestQuestion(question, rightAnswer, optionContent);
			model.addObject("stageNumber", question.getStageNumber());
		} catch (Exception e) {
			logger.error("CultureContestQuestion error {}", e);
		}
		return "success";
	}

	/**
	 * 更新用户修改的信息
	 * 
	 * @param page
	 * @param Pagination
	 *            分页功能类
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/updateCultureContestQuestion", method = RequestMethod.POST)
	@ResponseBody
	public String updateCultureContestQuestion(CcpCultureContestQuestion question, int[] rightAnswer,
			String[] optionContent, String[] cultureOptionId, HttpSession session) {
		try {
			SysUser user = (SysUser) session.getAttribute("user");
			String name = user.getUserId();
			String questionContent = question.getQuestionContent().trim();
			question.setQuestionContent(questionContent);
			question.setQuestionCreateUser(name);
			ccpCultureContestQuestionService.updateCultureContestQuestion(question, rightAnswer, optionContent,
					cultureOptionId);
		} catch (Exception e) {
			logger.error("CultureContestQuestion error {}", e);
		}
		return "success";
	}

	/**
	 * 删除操作
	 * 
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/deleteQuestion")
	@ResponseBody
	public String deleteCultureContestQuestion(CcpCultureContestQuestion question, HttpServletRequest req) {
		ModelAndView model = new ModelAndView();
		ccpCultureContestQuestionService.deleteByPrimaryKey(question.getCultureQuestionId());
		return "success";
	}

	/**
	 * 编辑操作
	 * 
	 * @return ModelAndView
	 */
	@RequestMapping(value = "/editQuestion")
	public ModelAndView editCultureContestQuestion(CcpCultureContestQuestion question) {
		ModelAndView model = new ModelAndView();
		try {
			model.addObject("stageNumber", question.getStageNumber());
			CcpCultureContestQuestion contestQuestion = ccpCultureContestQuestionService
					.queryCultureContestQuestionById(question);
			List<CcpCultureContestOption> contestOption = ccpCultureContestQuestionService
					.queryCultureContestOptionById(question);
			model.addObject("question", contestQuestion);

			String[] optionArray = { "A", "B", "C", "D" };
			model.addObject("optionArray", optionArray);

			model.addObject("option", contestOption);
			model.setViewName("admin/cultureContest/cultrueContestQuestionEdit");
		} catch (Exception e) {
			logger.error("CultureContestQuestion error {}", e);
		}
		return model;
	}

	/**
	 * 查询用户信息返回到页面展现
	 *
	 * @param page
	 * @param Pagination
	 *            分页功能类
	 * @return ModelAndView 页面及参数
	 */
	@RequestMapping(value = "/queryCultureContestQuestion")
	public ModelAndView queryCultureContestUser(CcpCultureContestQuestion ccpCultureContestQuestion, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			String paramStr = ccpCultureContestQuestion.getQuestionContent();
			if (StringUtils.isNotBlank(paramStr)) {
				if (paramStr.matches("^[0-9]*$")) {
					ccpCultureContestQuestion.setCultureQuestionId(Integer.parseInt(paramStr));
					ccpCultureContestQuestion.setQuestionContent(null);
				} else {
					ccpCultureContestQuestion.setQuestionContent(paramStr);
					ccpCultureContestQuestion.setCultureQuestionId(null);
				}
			}else{
				paramStr = null;
				ccpCultureContestQuestion.setQuestionContent(paramStr);
			}
			// 编号，题目名称，题目类型
			List<CcpCultureContestQuestion> userList = ccpCultureContestQuestionService
					.queryCultureContestQuestionByCondition(ccpCultureContestQuestion, page);
			model.addObject("userList", userList);
			model.addObject("page", page);
			ccpCultureContestQuestion.setQuestionContent(paramStr);
			model.addObject("question", ccpCultureContestQuestion);
			model.setViewName("admin/cultureContest/cultureContestQuestion");
		} catch (Exception e) {
			logger.error("CultureContestQuestion error {}", e);
		}
		return model;
	}

}
