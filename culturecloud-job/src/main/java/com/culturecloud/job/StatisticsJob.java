package com.culturecloud.job;

import com.culturecloud.dao.statistics.StatisticsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/24.
 */
@Service("NewStatisticsService")
public class StatisticsJob
{
    @Autowired
    private StatisticsMapper mapper;

    public void generateVenueStatistics()
    {
        mapper.generateVenueStatistics();
    }

    public void generateActivityStatistics()
    {
        mapper.generateActivityStatistics();
    }


    public void genUserRegisterArea()
    {
//        List<Map<String,String>> result = mapper.getRegisterUserByArea();
//        for (Map<String,String> map : result)
//        {
//            mapper.insertRegisterUserByArea(map);
//        }
        mapper.insertRegisterUserByArea();
    }

}
