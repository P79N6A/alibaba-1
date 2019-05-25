package com.culturecloud.annotation;

import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.TYPE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

/**
 * Created by ct on 2017/5/16.
 */
@Target({ TYPE, METHOD })
@Retention(RUNTIME)
public @interface DataSource
{
    String value();
}
