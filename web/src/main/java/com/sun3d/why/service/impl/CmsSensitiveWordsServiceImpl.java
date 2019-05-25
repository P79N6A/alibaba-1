package com.sun3d.why.service.impl;


import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.CmsSensitiveWords;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsSensitiveWordsService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class CmsSensitiveWordsServiceImpl implements CmsSensitiveWordsService{

    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;


    /**
     *
     * @param sid
     * @return 1 成功  0 失败
     */
    @Override
   public int deleteSensitiveWordsBySid(String sid) {
        return cmsSensitiveWordsMapper.deleteSensitiveWordsBySid(sid);
    }

    /**
     *
     * @param record
     * @return 1 成功  0 失败
     */
    @Override
    public int addCmsSensitiveWords(CmsSensitiveWords record) {
        return cmsSensitiveWordsMapper.addCmsSensitiveWords(record);
    }

    /**
     * 根据Id查询敏感词信息
     * @param sid
     * @return
     */
    @Override
    public CmsSensitiveWords querySensitiveWordsBySid(String sid) {
        return cmsSensitiveWordsMapper.querySensitiveWordsBySid(sid);
    }

    /**
     * 编辑敏感词信息
     * @param record
     * @return 1 成功  0 失败
     */
    @Override
    public int editSensitiveWords(CmsSensitiveWords record){
        return cmsSensitiveWordsMapper.editSensitiveWords(record);
    }

    /**
     * 分页查询敏感词信息
     * @param cmsSensitiveWords
     * @param page
     * @return
     */
    @Override
    public List<CmsSensitiveWords> queryCmsSensitiveWordsList(CmsSensitiveWords cmsSensitiveWords, Pagination page) {
        if (page != null) {
            cmsSensitiveWords.setPage(page.getPage());
            cmsSensitiveWords.setRows(page.getRows());
            cmsSensitiveWords.setFirstResult(page.getFirstResult());
            //cmsSensitiveWords.setTotal(page.getTotal());
        }
        return cmsSensitiveWordsMapper.queryCmsSensitiveWordsList(cmsSensitiveWords);
    }

    /**
     * 根据条件查询总数
     * @param record
     * @return 1 成功  0 失败
     */
    @Override
    public int queryCmsSensitiveWordsCount(CmsSensitiveWords record) {
        return cmsSensitiveWordsMapper.queryCmsSensitiveWordsCount(record);
    }

    @Override
    public int deleteSensitiveWords(CmsSensitiveWords record, SysUser loginUser) {
        record.setUpdateTime(new Date());
        record.setUpdateUser(loginUser.getUserId());
        return editSensitiveWords(record);
    }

    @Override
    public String  saveCmsSensitiveWords(CmsSensitiveWords cmsSensitiveWords ,SysUser loginUser) {
        //判断是否重复
        if (queryCmsSensitiveWordsByWords(cmsSensitiveWords.getSensitiveWords()) >0 ) {
            return "repeat";
        }
        cmsSensitiveWords.setSid(UUIDUtils.createUUId());
        cmsSensitiveWords.setUpdateTime(new Date());
        cmsSensitiveWords.setUpdateUser(loginUser.getUserId());
        cmsSensitiveWords.setCreateTime(new Date());
        cmsSensitiveWords.setCreateUser(loginUser.getUserId());
        cmsSensitiveWords.setWordsStatus(1);
        return addCmsSensitiveWords(cmsSensitiveWords) == 1 ? Constant.RESULT_STR_SUCCESS : Constant.RESULT_STR_FAILURE;
    }
    @Override
    public int queryCmsSensitiveWordsByWords(String sensitiveWords) {
        return cmsSensitiveWordsMapper.queryCmsSensitiveWordsByWords(sensitiveWords);
    }
}