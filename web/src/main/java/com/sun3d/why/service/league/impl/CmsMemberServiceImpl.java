package com.sun3d.why.service.league.impl;

import com.sun3d.why.dao.league.CmsMemberLeagueMapper;
import com.sun3d.why.dao.league.CmsMemberMapper;
import com.sun3d.why.dao.league.CmsMemberRelationMapper;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.service.league.CmsMemberService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        List<CmsMemberBO> list =  memberMapper.queryList(bo);
        //分页
        if (bo.getFirstResult() != null && bo.getRows() != null) {
            bo.setTotal(memberMapper.queryListCount(bo));
        }
        return list;
    }


    @Override
    public List<CmsMemberBO> queryRelationMemberList(CmsMemberBO member) {
        List<CmsMemberBO> list = memberMapper.queryRelationMemberList(member);
        //分页
        member.setFirstResult(null);
        int total = memberMapper.queryRelationMemberList(member).size();
        member.setTotal(total);
        return list;
    }
}
