package com.sun3d.why.service.impl;

import com.sun3d.why.dao.BpCarouselMapper;
import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpCarouselService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class BpCarouselServiceImpl implements BpCarouselService {

	@Autowired
	private BpCarouselMapper bpCarouselMapper;

	@Override
	public String addCarousel(BpCarousel bpCarousel, SysUser user) {
		int count = 0;
		bpCarousel.setCarouselUpdateTime(new Date());
		bpCarousel.setCarouselUpdateUser(user.getUserId());
		if (StringUtils.isBlank(bpCarousel.getCarouselId())) {
			bpCarousel.setCarouselId(UUIDUtils.createUUId());
			bpCarousel.setCarouselCreateTime(new Date());
			bpCarousel.setCarouselCreateUser(user.getUserId());
			bpCarousel.setCarouselStatus("0");
			bpCarousel.setCarouselNumber(new Integer(0));
			count = bpCarouselMapper.insert(bpCarousel);
		} else {
			count = bpCarouselMapper.updateByPrimaryKeySelective(bpCarousel);
		}
		if (count > 0) {
			return Constant.RESULT_STR_SUCCESS;
		} else {
			return Constant.RESULT_STR_FAILURE;
		}

	}

	@Override
	public List<BpCarousel> queryCarouselListByCondition(BpCarousel carousel,Pagination page) {
		// 定义一个map，存放分页数据作为分页参数
		Map<String, Object> pageMap = new HashMap<>();
		pageMap.put("carouselType", carousel.getCarouselType());
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			// 查询出总数
			int total = bpCarouselMapper.queryTotal(pageMap);
			// 当前页码
			pageMap.put("firstResult", page.getFirstResult());
			// 每页条数
			pageMap.put("rows", page.getRows());
			page.setTotal(total);
		}
		// 根据分页条件查找出当前页数据
		List<BpCarousel> list = bpCarouselMapper.queryListByMap(pageMap);
		for (BpCarousel bpCarousel : list) {
			String name = bpCarouselMapper.queryNameByUserId(bpCarousel.getCarouselUpdateUser());
			bpCarousel.setCarouselUpdateUser(name);
		}

		return list;
	}

	@Override
	public void delCarousel(String carouselId) {
		BpCarousel bpCarousel = new BpCarousel();
		if (carouselId != null && carouselId != "") {
			bpCarousel.setCarouselId(carouselId);
			// "2"表示已删除
			bpCarousel.setCarouselStatus("2");
			// 将轮播图序号设置未0
			bpCarousel.setCarouselNumber(new Integer(0));
		}
		bpCarouselMapper.updateByPrimaryKeySelective(bpCarousel);
	}

	@Override
	public void sortCarousel(String carouselId, String carouselStatus,SysUser loginUser) {
		if (carouselId != null && carouselId != "" && carouselStatus != null && carouselStatus != "") {
			BpCarousel bpCarousel = bpCarouselMapper.selectByPrimaryKey(carouselId);
			bpCarousel.setCarouselUpdateTime(new Date());
			bpCarousel.setCarouselUpdateUser(loginUser.getUserId());
			// 状态为1，执行下线操作
			if ("1".equals(carouselStatus)) {
				// "0"表示下线状态
				bpCarousel.setCarouselStatus("0");
				// 0表示未参与排序
				bpCarousel.setCarouselNumber(new Integer(0));
			}
			// 状态未0，执行上线操作
			if ("0".equals(carouselStatus)) {
				// 状态未"1"表示上线状态
				bpCarousel.setCarouselStatus("1");
				List<Integer> numberList = bpCarouselMapper.queryNumberList();
				// 设置第一张轮播图
				if (numberList.size() == 0) {
					bpCarousel.setCarouselNumber(new Integer(1));
				}else {
					// 原来的排序没有空缺，将此轮播图按照序号依次排序
					if (new Integer(numberList.size()).equals(Collections.max(numberList))) {
						bpCarousel.setCarouselNumber(new Integer(numberList.size() + 1));
					}
					// 如果序号集合大小与序号集合中的序号最大值不一致，说明原来的序号集合中一个已经下线，所以需要将现轮播图填充到之前的序号中
					if (!new Integer(numberList.size()).equals(Collections.max(numberList))) {
						// 此时需要查找出序号中的哪一个位置出现了空缺
						for (int i = 1; i <= numberList.size(); i++) {
							// 如果不包含则i即为空缺位置
							if (!numberList.contains(i)) {
								bpCarousel.setCarouselNumber(new Integer(i));
								break;
							}
						}
					}
				}
			}
			bpCarouselMapper.updateByPrimaryKeySelective(bpCarousel);
		}
	}

	@Override
	public BpCarousel selectCarouselById(String carouselId) {
		BpCarousel bpCarousel = null;
		if (carouselId != null && carouselId != "") {
			bpCarousel = bpCarouselMapper.selectByPrimaryKey(carouselId);
		}
		return bpCarousel;
	}
}
