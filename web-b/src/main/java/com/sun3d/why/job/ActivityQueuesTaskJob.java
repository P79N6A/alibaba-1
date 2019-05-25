package com.sun3d.why.job;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

/**
 *活动统计数据
 */
@Component("activityQueuesTaskJob")
public class ActivityQueuesTaskJob {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(ActivityQueuesTaskJob.class);

	@Autowired
	private CacheService cacheService;

	@Autowired
	private CmsActivityService cmsActivityService;

	public void activityQueuesTaskJob() throws Exception {
		try{
			//查询内存中仍然存在的活动队列
			Iterator iterator = cacheService.queryQueueName("activityQueues");
			List<String> list = new ArrayList<String>();
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			while (iterator != null && iterator.hasNext()) {
			    String queueName = (String)iterator.next();
				if (queueName != null && StringUtils.isNotBlank(queueName)) {
					String[] queueInfo = queueName.split("_");
					if (queueInfo != null && queueInfo.length > 0) {
						String activityId = queueInfo[0];
						String state = queueInfo[1];
						if(activityId != null) {
							CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(activityId);
							//判断活动是否过期
							String activityEndTime = cmsActivity.getActivityEndTime();
							if (StringUtils.isNotBlank(activityEndTime)) {
								if (df.parse(activityEndTime + " 23:59:59").before(new Date())) {

								}
								else {
									//将仍需要使用的活动队列重新放入内存中
									list.add(activityId + "_" + state);
								}
							}
						}
					}
				}
			}
			cacheService.deleteValueByKey("activityQueues");
			//将仍需要使用的活动队列重新放入内存中
			for (String name : list) {
				cacheService.saveQueueName("activityQueues", name);
			}
		}catch (Exception e){
			e.printStackTrace();
			logger.error("activityQueuesTaskJob error {}", e);
		}
	}
}
