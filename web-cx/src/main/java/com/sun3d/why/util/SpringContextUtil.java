package com.sun3d.why.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

/**
 * Created by yujinbing on 2015/6/26.
 */
@Component
public class SpringContextUtil implements ApplicationContextAware {

    private static ApplicationContext context;//声明一个静态变量保存

    @SuppressWarnings("static-access")
    @Override
    public void setApplicationContext(ApplicationContext context)
            throws BeansException {
        this.context = context;
    }
    public static ApplicationContext getContext(){
        return context;
    }
}
