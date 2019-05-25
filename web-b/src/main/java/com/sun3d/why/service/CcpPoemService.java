package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;
import com.sun3d.why.util.Pagination;

public interface CcpPoemService {
    
	List<CcpPoemLector> queryPoemLectorByCondition(CcpPoemLector ccpPoemLector, Pagination page);
	
	/**
	 * 保存或更新讲师
	 * @param ccpAssociation
	 * @return
	 */
	String saveOrUpdatePoemLector(CcpPoemLector ccpPoemLector);
	
	/**
	 * 删除讲师
	 * @param assnId
	 * @return
	 */
	String deletePoemLector(String lectorId);
	
	List<CcpPoem> queryPoemByCondition(CcpPoem ccpPoem, Pagination page);
	
	/**
	 * 保存或更新每日一诗
	 * @param ccpAssociation
	 * @return
	 */
	String saveOrUpdatePoem(CcpPoem ccpPoem);
	
	/**
	 * 删除每日一诗
	 * @param assnId
	 * @return
	 */
	String deletePoem(String poemId);
	
	List<CcpPoemUser> queryPoemUserByCondition(CcpPoemUser ccpPoemUser, Pagination page);
	
	/**
	 * 刷票
	 * @param poemId
	 * @param count
	 * @return
	 */
	String brushWantGo(String poemId, Integer count);
}