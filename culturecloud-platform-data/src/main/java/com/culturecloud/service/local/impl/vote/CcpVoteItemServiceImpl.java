package com.culturecloud.service.local.impl.vote;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.dao.dto.vote.CcpVoteItemDto;
import com.culturecloud.dao.vote.CcpVoteItemMapper;
import com.culturecloud.dao.vote.CcpVoteMapper;
import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.request.vote.QueryVoteItemListVO;
import com.culturecloud.model.response.vote.CcpVoteItemVO;
import com.culturecloud.service.local.vote.CcpVoteItemService;

@Service
@Transactional
public class CcpVoteItemServiceImpl implements CcpVoteItemService {

	@Autowired
	private CcpVoteItemMapper ccpVoteItemMapper;

	@Autowired
	private CcpVoteMapper ccpVoteMapper;

	@Override
	public BasePageResultListVO<CcpVoteItemVO> queryVoteItemList(QueryVoteItemListVO request) {

		BasePageResultListVO<CcpVoteItemVO> result=new BasePageResultListVO<>(request);
		
		Map<String,Object>data=new HashMap<String,Object>();
				
		String voteId=request.getVoteId();
		
		String userId=request.getUserId();
		
		if(StringUtils.isNotBlank(userId)){
			data.put("userId", userId);
		}
		
		String voteItemId=request.getVoteItemId();
		if(!StringUtils.isNotBlank(voteItemId)){
			Integer first= request.getResultFirst();
			
			Integer resultSize=request.getResultSize();
			
			if(first!=null&&resultSize!=null){
				
				data.put("resultFirst", first);
				data.put("resultSize", resultSize);
			}
		}
			
		CcpVote vote=ccpVoteMapper.selectByPrimaryKey(voteId);
		
		if(vote==null)
			return result;
		Integer voteType=vote.getVoteType();
		
		if(voteType==null){
			voteType=1;
			vote.setVoteType(1);
			ccpVoteMapper.updateByPrimaryKeySelective(vote);
		}
			
		data.put("voteId", voteId);
		data.put("voteType", voteType);
		data.put("sort", request.getSort());
		
		
		
		
		//if(StringUtils.isNotBlank(voteItemId)){
			
		//	data.put("voteItemId", voteItemId);
		//}
		
		int sum =ccpVoteItemMapper.queryVoteItemCount(data);
		
		List<CcpVoteItemDto> list=ccpVoteItemMapper.queryVoteItemList(data);
		
		
		List<CcpVoteItemVO> voList=new ArrayList<CcpVoteItemVO>();
		
		for (int i = 0; i < list.size(); i++) {
			
			CcpVoteItemDto ccpVoteItemDto=list.get(i);
			
			CcpVoteItemVO vo=new CcpVoteItemVO();
			
			try {
				PropertyUtils.copyProperties(vo, ccpVoteItemDto);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			} catch (NoSuchMethodException e) {
				e.printStackTrace();
			}
			
			vo.setNumber(i+1);
			
			if(StringUtils.isBlank(voteItemId)){
				voList.add(vo);
			}
			else
			{
				if(voteItemId.equals(vo.getVoteItemId()))
					voList.add(vo);
			}
			
		}
		result.setSum(sum);
		result.setList(voList);
		
		return result;
	}

}
