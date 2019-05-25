package com.sun3d.why.model.extmodel;

import java.io.Serializable;

/**
 * Created by liyang on 2015/6/16.
 */
public class RedisConfig implements Serializable {

    public String host;
    public int port;
    public String password;

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
