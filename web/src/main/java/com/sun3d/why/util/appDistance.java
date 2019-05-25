package com.sun3d.why.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;

/**
 * Created by Administrator on 2015/7/14.
 */
public class appDistance {
    // 经度
    double longitude;
    // 维度
    double dimensionality;

    public double getLongitude()
    {
        return longitude;
    }

    public void setLongitude(double longitude)
    {
        this.longitude = longitude;
    }

    public double getDimensionality()
    {
        return dimensionality;
    }

    public void setDimensionality(double dimensionality)
    {
        this.dimensionality = dimensionality;
    }

    /*
     * 计算两点之间距离
     *
     * @param start
     *
     * @param end
     *
     * @return 米
     */
    public static   double getDistance(appDistance start, appDistance end)
    {
        double lon1 = (Math.PI / 180) * start.longitude;
        double lon2 = (Math.PI / 180) * end.longitude;
        double lat1 = (Math.PI / 180) * start.dimensionality;
        double lat2 = (Math.PI / 180) * end.dimensionality;
        // 地球半径
        double R = 6371;
        // 两点间距离 km，如果想要米的话，结果*1000就可以了
        double d = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1)) * R;
        return d ;
    }

  public  static  void  main(String args[]) throws ParseException {
      appDistance a=new appDistance();
      a.setLongitude(121.237573);
      a.setDimensionality(31.00315);
      appDistance b=new appDistance();
      b.setLongitude(121.438462);
      b.setDimensionality(31.279093);
      double c=getDistance(a, b);
      System.out.print("距离大小"+c*1000);
  }
}
