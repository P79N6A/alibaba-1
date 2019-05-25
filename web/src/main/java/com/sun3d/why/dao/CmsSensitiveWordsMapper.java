package com.sun3d.why.dao;


import com.sun3d.why.model.CmsSensitiveWords;

import java.util.List;

public interface CmsSensitiveWordsMapper {

    /**
     *
     * @param sid
     * @return 1 成功  0 失败
     */
    int deleteSensitiveWordsBySid(String sid);

    /**
     *
     * @param record
     * @return 1 成功  0 失败
     */
    int addCmsSensitiveWords(CmsSensitiveWords record);

    /**
     * 根据Id查询敏感词信息
     * @param sid
     * @return
     */
    CmsSensitiveWords querySensitiveWordsBySid(String sid);

    /**
     * 编辑敏感词信息
     * @param record
     * @return 1 成功  0 失败
     */
    int editSensitiveWords(CmsSensitiveWords record);

    /**
     * 分页查询敏感词信息
     * @param cmsSensitiveWords
     * @return
     */
    List<CmsSensitiveWords> queryCmsSensitiveWordsList(CmsSensitiveWords cmsSensitiveWords);

    /**
     * 根据条件查询总数
     * @param record
     * @return 1 成功  0 失败
     */
    int queryCmsSensitiveWordsCount(CmsSensitiveWords record);

    int queryCmsSensitiveWordsByWords(String sensitiveWords);

    /**
     * 查询敏感词列表
     * @return
     */
   public List<CmsSensitiveWords> queryAppSensitiveWordsList();
}