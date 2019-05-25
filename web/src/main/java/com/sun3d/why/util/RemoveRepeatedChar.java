package com.sun3d.why.util;
import java.util.LinkedHashSet;
import java.util.Set;
/**
 * 字符串去重
 */
public class RemoveRepeatedChar {
    public static String removerepeatedchar(String str)
    {
        Set<String> mlinkedset = new LinkedHashSet<String>();
        String[] strarray = str.split(",");
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < strarray.length; i++)
        {
            if (!mlinkedset.contains(strarray[i]))
            {
                mlinkedset.add(strarray[i]);
                sb.append(strarray[i] + ",");
            }
        }
       // System.out.println(mlinkedset);
        return sb.toString().substring(0, sb.toString().length() - 1);
    }
}
