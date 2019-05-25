package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsQuestionAnwser;

public interface CmsQuestionAnwserMapper {

    int queryQuestionAnwserByCount(Map<String, Object> map);

    List<CmsQuestionAnwser> queryQuestionAnwserByContent(Map<String, Object> map);

    /**
     * 文化云3.1前端首页互动天地查询数据
     * @param map
     * @return
     */
    List<CmsQuestionAnwser> queryQuestionAnswer(Map<String, Object> map);

    /**
     * 文化云3.1前端首页互动天地查询个数
     * @param map
     * @return
     */
    int queryQuestionAnswerCount(Map<String, Object> map);
    
    /**
	 * 删除互动
	 * @param anwserId
	 * @return
	 */
    int deleteQuestionAnwser(String anwserId);
    
    /**
	 * 添加互动
	 * @param cmsQuestionAnwser
	 * @return
	 */
	int addQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser);
	
	/**
	 * 编辑互动
	 * @param cmsQuestionAnwser
	 * @return
	 */
	int editQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser);
    
	/**
	 * 根据ID查询互动
	 * @param anwserId
	 * @return
	 */
	CmsQuestionAnwser queryQuestionAnwserById(String anwserId);
}