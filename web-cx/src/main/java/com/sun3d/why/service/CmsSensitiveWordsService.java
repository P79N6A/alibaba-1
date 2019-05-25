package com.sun3d.why.service;


import com.sun3d.why.model.CmsSensitiveWords;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CmsSensitiveWordsService {

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
     * @param page
     * @return
     */
    List<CmsSensitiveWords> queryCmsSensitiveWordsList(CmsSensitiveWords cmsSensitiveWords, Pagination page);

    /**
     * 根据条件查询总数
     * @param record
     * @return 1 成功  0 失败
     */
    int queryCmsSensitiveWordsCount(CmsSensitiveWords record);

    /**
     * 逻辑删除
     * @param record
     * @param loginUser
     * @return
     */
    int deleteSensitiveWords(CmsSensitiveWords record ,SysUser loginUser);

    String saveCmsSensitiveWords(CmsSensitiveWords cmsSensitiveWords ,SysUser loginUser);

    int queryCmsSensitiveWordsByWords(String sensitiveWords);
}