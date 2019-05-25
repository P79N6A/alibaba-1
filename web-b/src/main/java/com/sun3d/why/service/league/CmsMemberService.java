package com.sun3d.why.service.league;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.league.CmsMemberBO;

import java.util.List;

public interface CmsMemberService {

    int deleteByPrimaryKey(String id);

    int insert(CmsMemberBO record);

    int insertSelective(CmsMemberBO record);

    CmsMemberBO selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsMemberBO record);

    int updateByPrimaryKey(CmsMemberBO record);

    List<CmsMemberBO> queryList(CmsMemberBO bo);

    String save(CmsMemberBO member, SysUser sysUser) throws Exception;

    String relationVenue(String[] venueIds, String memberId, Integer state);

    String relationMember(String[] memberIds, String infoId, Integer state);

    List<CmsMemberBO> queryRelationMemberList(CmsMemberBO member);
}
