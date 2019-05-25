package com.sun3d.why.service.league.impl;

import com.sun3d.why.dao.league.CmsMemberLeagueMapper;
import com.sun3d.why.dao.league.CmsMemberMapper;
import com.sun3d.why.dao.league.CmsMemberRelationMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.model.league.CmsMemberLeague;
import com.sun3d.why.model.league.CmsMemberRelation;
import com.sun3d.why.service.league.CmsMemberService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
@Transactional(rollbackFor = Exception.class)
public class CmsMemberServiceImpl implements CmsMemberService {

    @Autowired
    private CmsMemberMapper memberMapper;

    @Autowired
    private CmsMemberLeagueMapper memberLeagueMapper;

    @Autowired
    private CmsMemberRelationMapper memberRelationMapper;

    @Override
    public int deleteByPrimaryKey(String id) {
        return 0;
    }

    @Override
    public int insert(CmsMemberBO record) {
        return 0;
    }

    @Override
    public int insertSelective(CmsMemberBO record) {
        return memberMapper.insertSelective(record);
    }

    @Override
    public CmsMemberBO selectByPrimaryKey(String id) {
        return memberMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(CmsMemberBO record) {
        return memberMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(CmsMemberBO record) {
        return 0;
    }

    @Override
    public List<CmsMemberBO> queryList(CmsMemberBO bo) {
        //分页
        if (bo.getFirstResult() != null && bo.getRows() != null) {
            int total = memberMapper.queryListCount(bo);
            bo.setTotal(total);
        }
        return memberMapper.queryList(bo);
    }

    @Override
    public String save(CmsMemberBO member, SysUser sysUser) throws Exception {
        int resultInt = 0;
        if (StringUtils.isNotBlank(member.getId())) {
            member.setUpdateTime(new Date());
            member.setUpdateUser(sysUser.getUserId());
            resultInt = this.updateByPrimaryKeySelective(member);
        } else {
            member.setId(UUIDUtils.createUUId());
            member.setCreateUser(sysUser.getUserId());
            member.setCreateTime(new Date());
            resultInt = this.insertSelective(member);
        }
        if (resultInt == 1) {
            if (member.getRelateIds() != null) {
                memberLeagueMapper.deleteByMemberId(member.getId());
                for (int i = 0; i < member.getRelateIds().length; i++) {
                    String id = member.getRelateIds()[i];
                    if (StringUtils.isNotBlank(id)) {
                        CmsMemberLeague relation = new CmsMemberLeague();
                        relation.setLeagueId(id);
                        relation.setMemberId(member.getId());
                        memberLeagueMapper.insert(relation);
                    }
                }
            }
        } else {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            return JSONResponse.getResult(500, "保存失败！");
        }
        return JSONResponse.getResult(200, "success");
    }

    @Override
    public String relationVenue(String[] venueId, String memberId, Integer state) {
        List<CmsMemberRelation> list = new ArrayList<>();
        try{
            for (int i = 0; i < venueId.length; i++) {
                String s = venueId[i];
                if (StringUtils.isNotBlank(s)) {
                    CmsMemberRelation relation = new CmsMemberRelation();
                    relation.setRelationType(1);
                    relation.setMemberId(memberId);
                    relation.setRelationId(s);
                    if(state==1){
                        memberRelationMapper.insert(relation);
                    }else{
                        list.add(relation);
                    }
                }
            }
            //取消关联
            if(state !=1)memberRelationMapper.cancelRelation(list);

        }catch (Exception e){
            System.out.println("场馆已关联："+e.getMessage());
            //TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return JSONResponse.getResult(200, "");
    }

    /**
     * 资讯关联成员
     * @param memberIds
     * @param infoId
     * @param state
     * @return
     */
    @Override
    public String relationMember(String[] memberIds, String infoId, Integer state) {
        List<CmsMemberRelation> list = new ArrayList<>();
        try{
        for (int i = 0; i < memberIds.length; i++) {
            String id = memberIds[i];
            if (StringUtils.isNotBlank(id)) {
                CmsMemberRelation relation = new CmsMemberRelation();
                relation.setRelationType(2);
                relation.setMemberId(id);
                relation.setRelationId(infoId);
                if(state==1){
                    memberRelationMapper.insert(relation);
                }else{
                    list.add(relation);
                }
            }
        }
            //取消关联
         if(state!=1)  memberRelationMapper.cancelRelation(list);

        }catch (Exception e){
            System.out.println("场馆已关联："+e.getMessage());
            //TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }
        return JSONResponse.getResult(200, "");
    }

    @Override
    public List<CmsMemberBO> queryRelationMemberList(CmsMemberBO member) {
        List<CmsMemberBO> list = memberMapper.queryRelationMemberList(member);
        //分页
        int total = memberMapper.queryRelationMemberListCount(member);
        member.setTotal(total);
        return list;
    }
}
