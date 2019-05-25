package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociationRecruitApply;
import com.sun3d.why.dao.CcpAssociationMapper;
import com.sun3d.why.dao.CcpAssociationRecruitApplyMapper;
import com.sun3d.why.dao.CcpAssociationResMapper;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRes;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CcpAssociationServiceImpl implements CcpAssociationService {

    private Logger logger = Logger.getLogger(CcpAssociationServiceImpl.class);
    @Autowired
    private CcpAssociationMapper ccpAssociationMapper;
    @Autowired
    private CcpAssociationResMapper ccpAssociationResMapper;
    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
	private CcpAssociationRecruitApplyMapper ccpAssociationRecruitApplyMapper ;

    /**
	 * 社团列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	@Override
	public List<CcpAssociation> queryAssociationByCondition(CcpAssociation ccpAssociation, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpAssociation != null) {
            if (StringUtils.isNotBlank(ccpAssociation.getAssnName())){
                map.put("assnName", "%" + ccpAssociation.getAssnName() + "%");
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = ccpAssociationMapper.queryAssociationCountByCondition(map);
            page.setTotal(total);
        }
        List<CcpAssociation> list = ccpAssociationMapper.queryAssociationByCondition(map);
        for(CcpAssociation assn : list){
        	if(assn.getAssnImgUrl().indexOf("http://")<0){
        		int endIndex = assn.getAssnImgUrl().lastIndexOf(".");
        		assn.setAssnImgUrl(staticServer.getStaticServerUrl() + assn.getAssnImgUrl().substring(0, endIndex) + "_750_500" + assn.getAssnImgUrl().substring(endIndex));
        	}
        	if(assn.getAssnIconUrl().indexOf("http://")<0){
        		int endIndex = assn.getAssnIconUrl().lastIndexOf(".");
        		assn.setAssnIconUrl(staticServer.getStaticServerUrl() + assn.getAssnIconUrl().substring(0, endIndex) + "_150_150" + assn.getAssnIconUrl().substring(endIndex));
        	}
        }
        return list;
	}
	
	/**
	 * 社团申请列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	@Override
	public List<CcpAssociation> queryAssociationApplyByCondition(CcpAssociation ccpAssociation, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (ccpAssociation != null) {
            if (StringUtils.isNotBlank(ccpAssociation.getAssnName())){
                map.put("assnName", "%" + ccpAssociation.getAssnName() + "%");
            }
        }
		//分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = ccpAssociationMapper.queryAssociationApplyCountByCondition(map);
            page.setTotal(total);
        }

        return ccpAssociationMapper.queryAssociationApplyByCondition(map);
	}

	/**
	 * 申请社团
	 * @param ccpAssociationApply
	 * @return
	 */
	@Override
	public boolean saveAssnApply(CcpAssociationApply ccpAssociationApply) {
        try {
            int count = ccpAssociationMapper.saveAssnApply(ccpAssociationApply);
            if (count > 0) {
                return true;
            }
        } catch (Exception e) {
            logger.error("saveAssnApply error", e);
            return false;
        }
        return false;
	}

	@Override
	public CcpAssociation queryAssnByPrimaryKey(String assnId) {
		CcpAssociation ccpAssociation = ccpAssociationMapper.selectByPrimaryKey(assnId);
    	if(ccpAssociation.getAssnImgUrl().indexOf("http://")<0){
    		int endIndex = ccpAssociation.getAssnImgUrl().lastIndexOf(".");
    		ccpAssociation.setAssnImgUrl(staticServer.getStaticServerUrl() + ccpAssociation.getAssnImgUrl().substring(0, endIndex) + "_750_500" + ccpAssociation.getAssnImgUrl().substring(endIndex));
    	}
    	if(ccpAssociation.getAssnIconUrl().indexOf("http://")<0){
    		int endIndex = ccpAssociation.getAssnIconUrl().lastIndexOf(".");
    		ccpAssociation.setAssnIconUrl(staticServer.getStaticServerUrl() + ccpAssociation.getAssnIconUrl().substring(0, endIndex) + "_150_150" + ccpAssociation.getAssnIconUrl().substring(endIndex));
    	}
		return ccpAssociation;
	}
	
	@Override
	public String saveOrUpdateAssn(CcpAssociation vo) {
		try {
			int result = 1;
			SysUser sysUser = (SysUser) session.getAttribute("user");
			String[] tags = vo.getAssnTag().split(",");
			vo.setAssnTag(StringUtils.join(tags,","));
			if(sysUser != null){
				CcpAssociation ccpAssociation = ccpAssociationMapper.selectByPrimaryKey(vo.getAssnId());
				if(ccpAssociation!=null){
					vo.setUpdateSuser(sysUser.getUserId());
					vo.setUpdateTime(new Date());
					result = ccpAssociationMapper.update(vo);
				}else{
					vo.setAssnId(UUIDUtils.createUUId());
					vo.setCreateSuser(sysUser.getUserId());
					vo.setCreateTime(new Date());
					vo.setUpdateSuser(sysUser.getUserId());
					vo.setUpdateTime(new Date());
					result = ccpAssociationMapper.insert(vo);
				}
				if(result == 1){
					ccpAssociationResMapper.deleteByAssnId(vo.getAssnId());
					//社团图片
					if(vo.getAssnResImgUrls()!=null){
						for(String img: vo.getAssnResImgUrls()){
							CcpAssociationRes ccpAssociationRes = new CcpAssociationRes();
							ccpAssociationRes.setResId(UUIDUtils.createUUId());
							ccpAssociationRes.setAssnId(vo.getAssnId());
							ccpAssociationRes.setAssnResUrl(img);
							ccpAssociationRes.setResType(1);
							ccpAssociationRes.setCreateTime(new Date());
							ccpAssociationRes.setCreateUser(sysUser.getUserId());
							ccpAssociationRes.setUpdateTime(new Date());
							ccpAssociationRes.setUpdateUser(sysUser.getUserId());
							ccpAssociationResMapper.insert(ccpAssociationRes);
						}
					}
					//社团视频
					if(vo.getAssnResVideoUrls()!=null){
						for(int i=0;i<vo.getAssnResVideoUrls().length;i++){
							if(StringUtils.isNotBlank(vo.getAssnResVideoUrls()[i])){
								CcpAssociationRes ccpAssociationRes = new CcpAssociationRes();
								ccpAssociationRes.setResId(UUIDUtils.createUUId());
								ccpAssociationRes.setAssnId(vo.getAssnId());
								ccpAssociationRes.setAssnResUrl(vo.getAssnResVideoUrls()[i]);
								ccpAssociationRes.setAssnResName(vo.getAssnResVideoNames()[i]);
								ccpAssociationRes.setAssnResCover(vo.getAssnResVideoCovers()[i]);
								ccpAssociationRes.setResType(2);
								ccpAssociationRes.setCreateTime(new Date());
								ccpAssociationRes.setCreateUser(sysUser.getUserId());
								ccpAssociationRes.setUpdateTime(new Date());
								ccpAssociationRes.setUpdateUser(sysUser.getUserId());
								ccpAssociationResMapper.insert(ccpAssociationRes);
							}
						}
					}
				    return  "200";
				}else{
				    return  "500";
				}
			}else{
				return  "500";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "500";
		}
	}

	@Override
	public String deleteAssn(String assnId) {
		int result = ccpAssociationMapper.deleteByPrimaryKey(assnId);
		if(result == 1){
			ccpAssociationResMapper.deleteByAssnId(assnId);
			return  "200";
		}else{
		    return  "500";
		}
	}

	@Override
	public List<CcpAssociationRes> queryAssnResByAssnId(String assnId) {
		List<CcpAssociationRes> resList = ccpAssociationResMapper.queryAssnResByAssnId(assnId);
		for(CcpAssociationRes res : resList){
			if(res.getResType() == 1){	//	图片
				if(res.getAssnResUrl().indexOf("http://")<0){
					int endIndex = res.getAssnResUrl().lastIndexOf(".");
		    		res.setAssnResUrl(staticServer.getStaticServerUrl() + res.getAssnResUrl().substring(0, endIndex) + "_750_500" + res.getAssnResUrl().substring(endIndex));
		    	}
			}else if(res.getResType() == 2){	//视频封面
				if(StringUtils.isNotBlank(res.getAssnResCover()) && res.getAssnResCover().indexOf("http://")<0){
					int endIndex = res.getAssnResCover().lastIndexOf(".");
		    		res.setAssnResCover(staticServer.getStaticServerUrl() + res.getAssnResCover().substring(0, endIndex) + "_750_500" + res.getAssnResCover().substring(endIndex));
		    	}
			}
		}
		return resList;
	}

	@Override
	public List<CcpAssociationRecruitApply> queryRecruitApplyByCondition(CcpAssociationRecruitApply recruitApply,
																		 Pagination page) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		if (recruitApply != null) {
			if (StringUtils.isNotBlank(recruitApply.getSelectinput())){
				map.put("selectinput", "%" + recruitApply.getSelectinput() + "%");
			}
			if (StringUtils.isNotBlank(recruitApply.getAssnId())){
				map.put("assnId", recruitApply.getAssnId());
			}
			if (StringUtils.isNotBlank(recruitApply.getAssnName())){
				map.put("assnName", "%" + recruitApply.getAssnName() + "%");
			}
			try {
				if (StringUtils.isNotBlank(recruitApply.getApplyStartTimeString())){
					String applyStartTime = recruitApply.getApplyStartTimeString()+" 00:00";
					map.put("applyStartTime", applyStartTime);
				}
				if (StringUtils.isNotBlank(recruitApply.getApplyEndTimeString())){
					String applyEndTime = recruitApply.getApplyEndTimeString()+" 24:00";
					map.put("applyEndTime", applyEndTime);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		//分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpAssociationRecruitApplyMapper.queryRecruitApplyCountByMap(map);
			page.setTotal(total);
		}
		List<CcpAssociationRecruitApply> list = ccpAssociationRecruitApplyMapper.queryRecruitApplyByMap(map);

		return list;
	}

	@Override
	public List<CcpAssociation> selectAllAssn() {
		List<CcpAssociation> list= ccpAssociationMapper.selectAllAssn();
		return list;
	}
}
