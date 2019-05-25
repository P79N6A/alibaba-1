package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityVoteMapper;
import com.sun3d.why.dao.CmsActivityVoteRelevanceMapper;
import com.sun3d.why.model.CmsActivityVote;
import com.sun3d.why.model.CmsActivityVoteRelevance;
import com.sun3d.why.service.CmsActivityVoteService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CmsActivityVoteServiceImpl implements CmsActivityVoteService{

    //log4j日志
    private Logger logger = Logger.getLogger(CmsActivityVoteServiceImpl.class);

    @Autowired
    private CmsActivityVoteMapper cmsActivityVoteMapper;

    @Autowired
    private CmsActivityVoteRelevanceMapper cmsActivityVoteRelevanceMapper;

    /**
     * 查询投票列表分页列表
     * @para Map()查询条件
     * @return List<CmsActivityVote> 投票管理列表集合
     * @authours hucheng
     * @date 2016-2-16
     */
    @Override
    public List<CmsActivityVote> queryActivityVoteByCondition(CmsActivityVote cmsActivityVote,Pagination page){
        List<CmsActivityVote> list = null;
        Map<String,Object> map = new HashMap<String,Object>();
        try{
            if(StringUtils.isNotNull(cmsActivityVote.getActivityId())){
                map.put("activityName","%"+cmsActivityVote.getActivityId()+"%");
            }
//           if(StringUtils.isNotNull(cmsActivityVote.getVoteTitel())){
//               map.put("voteTitel","%"+cmsActivityVote.getVoteTitel()+"%");
//           }
            map.put("voteIsDel",1);//1代表正常显示，0代表删除
            int total = this.cmsActivityVoteMapper.queryActivityVoteCountByCondition(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
            page.setRows(page.getRows());
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            list = this.cmsActivityVoteMapper.queryActivityVoteByCondition(map);
        }catch(Exception e){
            e.printStackTrace();
            logger.error("执行带条件分页查询投票信息时出错",e);
        }
        return list;
    }

    /**
     * 根据主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsActivityVote
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
   public int editCmsActivityVote(CmsActivityVote record,String voteContents,String voteImgUrls){

        int success = 0;
        String[] voteContentArray = null;
        String[] voteImgUrlArray = null;
        try{
            record.setUpdateDate(new Date());
            success = this.cmsActivityVoteMapper.editCmsActivityVote(record);


            if(StringUtils.isNotNull(voteContents)){
                voteContentArray = voteContents.split(",");
            }
            if(StringUtils.isNotNull(voteImgUrls)){
                voteImgUrlArray = voteImgUrls.split(",");
            }
            if(voteContentArray.length>0 || voteImgUrlArray.length>0){
                cmsActivityVoteRelevanceMapper.deleteCmsActivityVoteRelevance(record.getVoteId());

                for(int i= 0 ;i< voteContentArray.length;i++){
                    CmsActivityVoteRelevance cmsActivityVoteRelevance = new CmsActivityVoteRelevance();
                    cmsActivityVoteRelevance.setVoteRelevanceId(UUIDUtils.createUUId());
                    cmsActivityVoteRelevance.setVoteId(record.getVoteId());
                    cmsActivityVoteRelevance.setVoteContent(voteContentArray[i]);
                    cmsActivityVoteRelevance.setVoteImgUrl(voteImgUrlArray[i]);
                    cmsActivityVoteRelevance.setVoteRelevanceDate(new Date());
                    cmsActivityVoteRelevance.setVoteSort(i);
                    success = cmsActivityVoteRelevanceMapper.addCmsActivityVoteRelevance(cmsActivityVoteRelevance);
                }
            }

        }catch (Exception e){
            logger.error("editCmsActivityVote {}",e);
        }


        return success;
    }


    /**
     * 添加投票信息
     *
     * @param record CmsActivityVote
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int  addActivityVote(CmsActivityVote record,String voteContents,String voteImgUrls){

        int success =0;
        String[] voteContentArray = null;
        String[] voteImgUrlArray = null;
        try{
            record.setVoteId(UUIDUtils.createUUId());
            record.setVoteIsDel(1);
            record.setVoteDate(new Date());
            record.setUpdateDate(new Date());
            success =this.cmsActivityVoteMapper.addActivityVote(record);

            if(StringUtils.isNotNull(voteContents)){
                voteContentArray = voteContents.split(",");
            }
            if(StringUtils.isNotNull(voteImgUrls)){
                voteImgUrlArray = voteImgUrls.split(",");
            }
            if(voteContentArray.length>0 || voteImgUrlArray.length>0){
                for(int i= 0 ;i< voteContentArray.length;i++){
                    CmsActivityVoteRelevance cmsActivityVoteRelevance = new CmsActivityVoteRelevance();
                    cmsActivityVoteRelevance.setVoteRelevanceId(UUIDUtils.createUUId());
                    cmsActivityVoteRelevance.setVoteId(record.getVoteId());
                    cmsActivityVoteRelevance.setVoteContent(voteContentArray[i]);
                    cmsActivityVoteRelevance.setVoteImgUrl(voteImgUrlArray[i]);
                    cmsActivityVoteRelevance.setVoteRelevanceDate(new Date());
                    cmsActivityVoteRelevance.setVoteSort(i);
                    success = cmsActivityVoteRelevanceMapper.addCmsActivityVoteRelevance(cmsActivityVoteRelevance);
                }
            }
        }catch (Exception e){
            logger.error("addActivityVote {}",e);
        }
         return success;
    }

    /**
     * 添加投票信息
     *
     * @param voteId
     * @return int 执行结果 1：成功 0：失败
     */
    @Override
    public int  deleteActivityVote(String voteId){
        if(StringUtils.isNotNull(voteId)){
            return this.cmsActivityVoteMapper.deleteActivityVote(voteId);
        }
        return 0;
    }


    /**
     * 根据主键id查询投票对象
     * @para
     * @return voteId
     * @authours hucheng
     * @date 2016-2-17
     */
    @Override
   public  CmsActivityVote queryActivityVoteById(String voteId){

        return  this.cmsActivityVoteMapper.queryActivityVoteById(voteId);
    }

    /**
     * 根据主键id查询投票对象
     * @para
     * @return voteId
     * @authours hucheng
     * @date 2016-2-17
     */
    @Override
    public CmsActivityVote queryActivityVoteByVoteTitel(String voteTitel){

        return  this.cmsActivityVoteMapper.queryActivityVoteByVoteTitel(voteTitel);
    }


    @Override
    public List<CmsActivityVote> queryVoteList(Map<String, Object> params) {
        return cmsActivityVoteMapper.queryVoteList(params);
    }

    @Override
    public CmsActivityVote queryDetailById(String dataId) {
        return cmsActivityVoteMapper.queryDetailById(dataId);
    }

    @Override
    public CmsActivityVote queryForIndex(Map<String, Object> params) {
        return cmsActivityVoteMapper.queryForIndex(params);
    }

    @Override
    public Map<String, Object> queryForIndexData(String voteId) {
        return cmsActivityVoteMapper.queryForIndexData(voteId);
    }

}