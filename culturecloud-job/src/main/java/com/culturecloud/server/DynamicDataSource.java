package com.culturecloud.server;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import javax.sql.DataSource;
import java.util.Map;

/**
 * Created by ct on 2017/5/16.
 */
public class DynamicDataSource extends AbstractRoutingDataSource
{

    @Override
    protected Object determineCurrentLookupKey()
    {
        return DynamicDataSourceHolder.getDataSource();
    }
}
