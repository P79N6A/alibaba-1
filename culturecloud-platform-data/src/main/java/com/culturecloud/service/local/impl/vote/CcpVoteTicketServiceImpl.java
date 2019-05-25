package com.culturecloud.service.local.impl.vote;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.vote.CcpVoteItemMapper;
import com.culturecloud.dao.vote.CcpVoteMapper;
import com.culturecloud.dao.vote.CcpVoteTicketMapper;
import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.culturecloud.model.bean.vote.CcpVoteTicket;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.vote.CcpVoteTicketService;

@Service
@Transactional
public class CcpVoteTicketServiceImpl implements CcpVoteTicketService {

	@Autowired
	private CcpVoteItemMapper voteItemMapper;
	@Autowired
	private CcpVoteMapper voteMapper;
	@Autowired
	private CcpVoteTicketMapper voteTicketMapper;

	@Autowired
	private BaseService baseService;

	@Override
	public String saveCcpVoteTicket(String userId, String voteItemId) {

		CcpVoteItem item = voteItemMapper.selectByPrimaryKey(voteItemId);

		String voteId = item.getVoteId();

		CcpVote vote = voteMapper.selectByPrimaryKey(voteId);

		Integer voteType = vote.getVoteType();

		CcpVoteTicket model = new CcpVoteTicket();

		model.setUserId(userId);
		model.setVoteId(voteId);

		// 用户该选项已投的票
		List<CcpVoteTicket> ticketList = baseService.findByModel(model);

		if (ticketList.size() == 0) {
			int result = this.insert(userId, voteId, voteItemId);
			if(result>0){
				return "投票成功";
			}
			else
				return "投票失败";
		} else {
			
			// 只能投一次
			if (2 == voteType) {
				return "每人只能投一票";
			}
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

			String todayStr = sdf.format(new Date());
			
			// 是否能投
			for (CcpVoteTicket ccpVoteTicket : ticketList) {

				String date = sdf.format(ccpVoteTicket.getVoteTime());
				
				if (date.equals(todayStr)) {
					
					if(3==voteType){
						
						String itemId=ccpVoteTicket.getVoteItemId();
						
						// 今日已投过此项
						if(voteItemId.equals(itemId)){
							return "今日已投过此项";
						}
					}
					// 一天只能投一次
					else{
						return "今日已投过票";
					}
				}
				
			}
		
			int result = this.insert(userId, voteId, voteItemId);
		
			if(result>0){
				return "投票成功";
			}
			else
				return "投票失败";
		}

	}

	private int insert(String userId, String voteId, String voteItemId) {

		CcpVoteTicket ticket = new CcpVoteTicket();
		ticket.setTicketId(UUIDUtils.createUUId());
		ticket.setUserId(userId);
		ticket.setVoteItemId(voteItemId);
		ticket.setVoteId(voteId);
		ticket.setVoteTime(new Date());

		return voteTicketMapper.insert(ticket);
	}

}
