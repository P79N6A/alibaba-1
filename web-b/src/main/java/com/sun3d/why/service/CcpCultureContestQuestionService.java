package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.culture.CcpCultureContestOption;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;
import com.sun3d.why.util.Pagination;

public interface CcpCultureContestQuestionService {
	
	
	/**
	 * 根据条件查询题库
     * @param map,page
     * @return List<CcpCultureContestQuestion>
	 * */
	List<CcpCultureContestQuestion> queryCultureContestQuestionByCondition(CcpCultureContestQuestion ccpCultureContestQuestion,Pagination page);
	
	
	
	/**
	 * 新增题库
     * @param CcpCultureContestQuestion
     * @return void
	 * */
	void insertCultureContestQuestion(CcpCultureContestQuestion question,int[] rightAnswer,String[] optionContent);
	
	
	
	
	/**
	 * 更新用户需改的信息
	 * @param CcpCultureContestQuestion :对应的该题目对象
	 * @param rightAnswer：多选中对应的多个答案
	 * @param optionContent：对应的题目问题
	 * */
	void updateCultureContestQuestion(CcpCultureContestQuestion question,int[] rightAnswer,String[] optionContent,String[] cultureOptionId);
		
	
	
	
	
	/**
	 * 删除答题操作
	 * @param deleteByPrimaryKey
	 * */
	void deleteByPrimaryKey(Integer cultureQuestionId);
	
	
	
	
	
	
	/**
	 * 根据cultureQuestionId查询题库
     * @param cultureQuestionId
     * @return List<CcpCultureContestQuestion>
	 * */
	CcpCultureContestQuestion queryCultureContestQuestionById(CcpCultureContestQuestion ccpCultureContestQuestion);
	
	
	
	/**
	 * 根据questionId查询题目选项
     * @param cultureQuestionId
     * @return List<CcpCultureContestQuestion>
	 * */
	List<CcpCultureContestOption> queryCultureContestOptionById(CcpCultureContestQuestion ccpCultureContestQuestion);
	
	
	
}
