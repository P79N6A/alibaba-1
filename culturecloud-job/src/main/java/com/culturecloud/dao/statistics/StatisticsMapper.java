package com.culturecloud.dao.statistics;


import com.culturecloud.annotation.DataSource;
import com.culturecloud.util.Constants;

import java.util.List;
import java.util.Map;

/**
 * Created by ct on 2017/4/24.
 */
public interface StatisticsMapper
{

    void generateVenueStatistics();


    void generateActivityStatistics();

//    @DataSource(value = Constants.DATASOURCE_CHINA)
    List<Map<String,String>> getRegisterUserByArea();

    void insertRegisterUserByArea();


}
