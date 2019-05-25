package com.sun3d.why.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.TreeSet;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.culturecloud.model.bean.culture.CcpCultureContestQuestion;
import com.sun3d.why.dao.CcpCultureContestAnswerMapper;
import com.sun3d.why.dao.CcpCultureContestQuestionMapper;
import com.sun3d.why.dao.dto.CcpCultureContestQuestionDto;
import com.sun3d.why.service.CcpCultureContestQuestionService;

@Service
@Transactional
public class CcpCultureContestQuestionServiceImpl implements CcpCultureContestQuestionService {

	@Autowired
	private CcpCultureContestQuestionMapper contestQuestionMapper;
	
	@Autowired
	private CcpCultureContestAnswerMapper contestAnswerMapper;

	@Override
	public Set<CcpCultureContestQuestionDto> queryStageQuestion(Integer stageNumber) {

		List<CcpCultureContestQuestionDto> questionList = contestQuestionMapper.queryStageQuestion(stageNumber);

		Map<Integer,Set<CcpCultureContestQuestionDto>> questionTypeMap=new HashMap<>();
		
		for (CcpCultureContestQuestionDto question : questionList) {
			
			Integer questionType=question.getQuestionType();
			Set<CcpCultureContestQuestionDto> set=questionTypeMap.get(questionType);
			
			if(set!=null){
				set.add(question);
			}else{
				set=new HashSet<CcpCultureContestQuestionDto>();
				set.add(question);
				questionTypeMap.put(questionType, set);
			}
		}
		// 总题数
		int questionSum=30;
		
		// 阶段一，每次随机30题，含判断题4道，单选题22道，多选题4道
		Set<CcpCultureContestQuestionDto> testList=new HashSet<CcpCultureContestQuestionDto>();
		
		if(questionList.size()>=questionSum){
			
			// 阶段一试题配比
			double [] s1=new double[]{0.73f,0.13f,0.13f};
			
			double [] s= null;
			
			if(stageNumber==1){
				s=s1;
			}
			
			for (int i = 0; i < s.length; i++) {
				
				Integer questionType=i+1;
			
				Set<CcpCultureContestQuestionDto> questionSet=questionTypeMap.get(questionType);
				
				if(questionSet!=null&&questionSet.size()>0){
					
					int questionTypeSum=questionSet.size();
					
					double f=s[i];
					// 题数
					int n=(int) Math.ceil(questionSum*f);
					
					// 题目扑出来了
					if(n+testList.size()>questionSum){
						
						int addQuestionCount= Math.abs(questionSum-testList.size());
						
						Set<CcpCultureContestQuestionDto> set=new HashSet<CcpCultureContestQuestionDto>();
						
						CcpCultureContestQuestionDto[] questionArray=questionSet.toArray(new CcpCultureContestQuestionDto[questionTypeSum]);
						
						while(set.size()!=addQuestionCount){
							
							int index =new Random().nextInt(questionTypeSum);
							
							CcpCultureContestQuestionDto question=questionArray[index];
							set.add(question);
						}
						
						testList.addAll(set);
					}
					
					else if(questionSet.size()<=n){
						
						
						testList.addAll(questionSet);
					}
					else{
						
						CcpCultureContestQuestionDto[] questionArray=questionSet.toArray(new CcpCultureContestQuestionDto[questionTypeSum]);
						
						Set<CcpCultureContestQuestionDto> set=new HashSet<CcpCultureContestQuestionDto>();
						
						while(set.size()!=n){
							
							int index =new Random().nextInt(questionTypeSum);
							
							CcpCultureContestQuestionDto question=questionArray[index];
							set.add(question);
						}
						
						testList.addAll(set);
						
					}
				}
				
			}
			
		}
		else
		{
			testList.addAll(questionList);
		}
		
		
		return testList;
	}

	@Override
	public Map<String, String> saveAnswer(String cultureAnswerId, String rightAnswer, Integer answerTime,
			Integer cultureQuestionId) {
		
		Map<String, String>  result=new HashMap<String, String>();
		
		CcpCultureContestAnswer answer=contestAnswerMapper.selectByPrimaryKey(cultureAnswerId);
		
		CcpCultureContestQuestion question=contestQuestionMapper.selectByPrimaryKey(cultureQuestionId);
		
		//已答试题
		String answerNumber=answer.getAnswerNumber();
		
		// 判断是否已答过30题
		if(answerNumber!=null){
			
			String [] array=answerNumber.split(",");
			
			TreeSet<String> set=new TreeSet<String>(Arrays.asList(array));
			
			if(set.size()>=30){
				
				result.put("result", "success");
				
				return result;
				
			}
		}
		
		Integer right=question.getRightAnswer();
		
		char []c=right.toString().toCharArray();
		
		char []c1=rightAnswer.toCharArray();
		
		// 答对了
		if(ArrayUtils.isEquals(c, c1)){
			
			String rightQuestion=answer.getAnswerRightQuestion();
			
			if(rightQuestion==null){
				rightQuestion="";
			}
			
			String [] array=rightQuestion.split(",");
			
			TreeSet<String> set=new TreeSet<String>(Arrays.asList(array));
			
			set.add(cultureQuestionId.toString());
			
			answer.setAnswerRightQuestion(StringUtils.join(set.toArray(), ","));
			
			if(answerTime<(15*60)){
				
				Integer answerRightNumber= answer.getAnswerRightNumber();
				
				answer.setAnswerRightNumber(answerRightNumber+1);
				
				result.put("right", "true");
			}
		}
		
		if(answerNumber==null){
			answer.setAnswerNumber(cultureQuestionId.toString());
		}
		else
		{
			String [] array=answerNumber.split(",");
			
			TreeSet<String> set=new TreeSet<String>(Arrays.asList(array));
			
			set.add(cultureQuestionId.toString());
			
			answer.setAnswerNumber(StringUtils.join(set.toArray(), ","));
		}
		
		answer.setAnswerTime(answerTime);
		
		contestAnswerMapper.updateByPrimaryKeySelective(answer);
		
		result.put("result", "success");
		
		return result;
	}
	
	

}
