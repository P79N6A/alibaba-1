package com.culturecloud.test.api;

/**
 * Created by sundai on 2016/8/29.
 */
public class MyClass {
    public int count;
    public MyClass(int start) {
        count = start;
    }
    public void increase(int step) {
        count = count + step;
    }
}
