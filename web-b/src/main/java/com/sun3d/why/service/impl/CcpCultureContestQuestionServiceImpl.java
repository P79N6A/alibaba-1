package com.sun3d.why.service.impl;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.culture.CcpCultureContestOption;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;
import com.sun3d.why.dao.CcpCultureContestOptionMapper;
import com.sun3d.why.dao.CcpCultureContestQuestionMapper;
import com.sun3d.why.dao.CcpCultureContestUserMapper;
import com.sun3d.why.dao.dto.CcpDramaCommentDto;
import com.sun3d.why.service.CcpCultureContestQuestionService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CcpCultureContestQuestionServiceImpl implements CcpCultureContestQuestionService {
	
	@Autowired
	private CcpCultureContestQuestionMapper ccpCultureContestQuestionMapper;
	 
	@Autowired
	private CcpCultureContestOptionMapper ccpCultureContestOptionMapper;
	
	/**
	 * 根据条件查询出题目信息
	 * @param CcpCultureContestQuestion :对应的该题目对象
	 * @param Pagination：对应分页信息
	 * */
	@Override
	public List<CcpCultureContestQuestion> queryCultureContestQuestionByCondition(CcpCultureContestQuestion question,Pagination page) {
		
		Map<String, Object> map = new HashMap<>();
		//题目内容
		map.put("questionContent", question.getQuestionContent());
		//题目编号
		map.put("cultureQuestionId", question.getCultureQuestionId());
		//题目类型
		if(question.getQuestionType()==null){
			map.put("questionType", 0);
		}else{
			map.put("questionType", question.getQuestionType());
		}
		
		
		
		//题目挤捏
		map.put("stageNumber", question.getStageNumber());
		
		
		if(page != null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());	
			int total = ccpCultureContestQuestionMapper.queryQuestionCountByCondition(map);
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		List<CcpCultureContestQuestion> list = ccpCultureContestQuestionMapper.queryQuestionByCondition(map);
		return list;
	}

	
	
	
	/**
	 * 新增题目对象以及对应的四个选项
	 * @param CcpCultureContestQuestion :对应的该题目对象
	 * @param rightAnswer：多选中对应的多个答案
	 * @param optionContent：对应的题目问题
	 * */
	@Override
	public void insertCultureContestQuestion(CcpCultureContestQuestion question,int[] rightAnswer,String[] optionContent) {
		
		
//		String questionContent = question.getQuestionContent();
		Integer questionType = question.getQuestionType();
		Integer right_answer = null; 
		String create_user = question.getQuestionCreateUser();
		Timestamp create_time = new Timestamp(System.currentTimeMillis()); 
//		Integer stage_number = question.getStageNumber();
		if(questionType == null){
			return;
		}else{
			if(questionType==3){
				//判断题
				right_answer = rightAnswer[0];
				
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
				
				
				
				/*map.put("questionContent", questionContent);
				map.put("questionType", questionType);
				map.put("rightAnswer", right_answer);
				map.put("questionCreateUser", create_user);
				map.put("questionCreateTime", create_time);
				map.put("stageNumber", stage_number);*/
				
			}else if(questionType==1){
				//单选题
				right_answer = rightAnswer[0];
			/*	map.put("questionContent", questionContent);
				map.put("questionType", questionType);
				map.put("rightAnswer", right_answer);
				map.put("questionCreateUser", create_user);
				map.put("questionCreateTime", create_time);
				map.put("stageNumber", stage_number);*/
				
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
				
				
				
			}else{
				//多选题
				String sum = "";
				for(int i = 0;i< rightAnswer.length;i++){
					sum+=rightAnswer[i];
				}
				//多个答案
				right_answer = Integer.parseInt(sum);
				/*//题目
				map.put("questionContent", questionContent);
				//类型
				map.put("questionType", questionType);
				//答案
				map.put("rightAnswer", right_answer);
				//创建人
				map.put("questionCreateUser", create_user);
				//创建时间
				map.put("questionCreateTime", create_time);
				//阶段
				map.put("stageNumber", stage_number);*/
				
				
				
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
				
				
			}
		}
		ccpCultureContestQuestionMapper.insert(question);
		int questionId = question.getCultureQuestionId();
		String culture_option_id = null;
		if(questionType==1){
			int answer = rightAnswer[0];
			for(int i = 0;i<4;i++){
				Map<String, Object> map = new HashMap<String, Object>();
				culture_option_id = UUIDUtils.createUUId();
				map.put("cultureOptionId", culture_option_id);
				map.put("questionId", questionId);
				map.put("optionContent", optionContent[i].trim());
				map.put("optionIndex", i+1);
				if(answer==i+1){
					map.put("optionIsRight", 1);
				}else{
					map.put("optionIsRight", 0);
				}
				ccpCultureContestOptionMapper.insert(map);
			}
		}else if(questionType==2){
				for(int i = 0;i<4;i++){
					Map<String, Object> map = new HashMap<String, Object>();
					culture_option_id = UUIDUtils.createUUId();
					map.put("cultureOptionId", culture_option_id);
					map.put("questionId", questionId);
					map.put("optionContent", optionContent[i+4].trim());
					map.put("optionIndex", i+1);
					
					for(int j=0;j<rightAnswer.length;j++){
						if(rightAnswer[j]==i+1){
							map.put("optionIsRight", 1);
							break;
						}else{
							map.put("optionIsRight", 0);
						}
					}
					ccpCultureContestOptionMapper.insert(map);
				}
			}
		}



	
	
	/**
	 * 更新用户需改的信息
	 * @param CcpCultureContestQuestion :对应的该题目对象
	 * @param rightAnswer：多选中对应的多个答案
	 * @param optionContent：对应的题目问题
	 * */
	@Override
	public void updateCultureContestQuestion(CcpCultureContestQuestion question, int[] rightAnswer,
			String[] optionContent,String[] cultureOptionId) {
		Integer questionType = question.getQuestionType();
		Integer right_answer = null; 
		String create_user = question.getQuestionCreateUser();
		Timestamp create_time = new Timestamp(System.currentTimeMillis()); 
		if(questionType == null){
			return;
		}else{
			if(questionType==3){
				//判断题
				right_answer = rightAnswer[0];
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
			}else if(questionType==1){
				//单选题
				right_answer = rightAnswer[0];
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
			}else{
				//多选题
				String sum = "";
				for(int i = 0;i< rightAnswer.length;i++){
					sum+=rightAnswer[i];
				}
				right_answer = Integer.parseInt(sum);
				question.setQuestionCreateTime(create_time);
				question.setQuestionCreateUser(create_user);
				question.setRightAnswer(right_answer);
			}
		}
		ccpCultureContestQuestionMapper.updateByPrimaryKey(question);
		
		
		//选项的操作
		if(questionType==1){
			int answer = rightAnswer[0];
			for(int i = 0;i<4;i++){
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("cultureOptionId", cultureOptionId[i]);
				map.put("optionContent", optionContent[i].trim());
				if(answer==i+1){
					map.put("optionIsRight", 1);
				}else{
					map.put("optionIsRight", 0);
				}
				ccpCultureContestOptionMapper.updateByPrimaryKey(map);
			}
		}else if(questionType==2){
				for(int i = 0;i<4;i++){
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("cultureOptionId", cultureOptionId[i]);
					map.put("optionContent", optionContent[i].trim());
					for(int j=0;j<rightAnswer.length;j++){
						if(rightAnswer[j]==i+1){
							map.put("optionIsRight", 1);
							break;
						}else{
							map.put("optionIsRight", 0);
						}
					}
					ccpCultureContestOptionMapper.updateByPrimaryKey(map);
				}
			}
		
	}
	
	
	
	
	


	/**
	 * 根据该题目id删除题目
	 * 
	 * */
	@Override
	public void deleteByPrimaryKey(Integer cultureQuestionId) {
		//删除题目
		int id = ccpCultureContestQuestionMapper.deleteByPrimaryKey(cultureQuestionId);
		//删除选项
		ccpCultureContestOptionMapper.deleteByPrimaryKey(cultureQuestionId);
	}



	/**
	 * 根据该题目id查询题目信息
	 * @param ccpCultureContestQuestion :对应的该题目对象
	 * @return CcpCultureContestQuestion:查询到的对象
	 * */
	@Override
	public CcpCultureContestQuestion queryCultureContestQuestionById(CcpCultureContestQuestion ccpCultureContestQuestion) {
		List<CcpCultureContestQuestion> question = ccpCultureContestQuestionMapper.queryQuestionById(ccpCultureContestQuestion.getCultureQuestionId());
		CcpCultureContestQuestion contestQuestion = null;
		if(question.size()!=0){
			 contestQuestion = (CcpCultureContestQuestion)question.get(0);
		}
			 
		return contestQuestion;
	}



	/**
	 * 查询题目对应的选项
	 * @param ccpCultureContestQuestion :对应的该题目对象
	 * @return ContestOption:查询到的选项对象
	 * */
	@Override
	public List<CcpCultureContestOption> queryCultureContestOptionById(
			CcpCultureContestQuestion ccpCultureContestQuestion) {
		List<CcpCultureContestOption> ContestOption = ccpCultureContestOptionMapper.selectByPrimaryKey(ccpCultureContestQuestion.getCultureQuestionId());
		return ContestOption;
	}




	

	
	
	
	

}
