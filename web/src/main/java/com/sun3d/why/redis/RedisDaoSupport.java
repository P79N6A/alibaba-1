package com.sun3d.why.redis;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.annotation.Resource;

import org.springframework.dao.DataAccessException;
import org.springframework.data.redis.connection.RedisConnection;
import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.SetOperations;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;

@Service("redisDao")
public class RedisDaoSupport<T extends Serializable> implements RedisDAO<T> {
	@Resource
	private RedisTemplate<String, T> stringobjRedisTemplate;

	public void save(String key, T data) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		valueOper.set(key, data);

	}

	@Override
	public void save(final byte[] key, final byte[] data) {

		stringobjRedisTemplate.execute(new RedisCallback() {
			public Long doInRedis(RedisConnection connection) throws DataAccessException {
				connection.set(key, data);

				return 1L;
			}
		});
	}

	public void save(String k, T v, long timeout) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		valueOper.set(k, v, timeout, TimeUnit.SECONDS);
	}

	public T getData(String keystr) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		return valueOper.get(keystr);
	}

	@Override
	public void save(Map<String, T> kvmap) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		Iterator<String> iterator = kvmap.keySet().iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			T value = kvmap.get(key);
			valueOper.set(key, value);
		}
	}

	@Override
	public void save(Map<String, T> kvmap, long timeout) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		Iterator<String> iterator = kvmap.keySet().iterator();
		while (iterator.hasNext()) {
			String key = (String) iterator.next();
			T value = kvmap.get(key);
			valueOper.set(key, value, timeout, TimeUnit.SECONDS);
		}
	}

	@Override
	public List<T> getData(Set<String> keys) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();
		return valueOper.multiGet(keys);
	}

	public RedisTemplate<String, T> getStringobjRedisTemplate() {
		return stringobjRedisTemplate;
	}

	public void setStringobjRedisTemplate(RedisTemplate<String, T> stringobjRedisTemplate) {
		this.stringobjRedisTemplate = stringobjRedisTemplate;
	}

	@Override
	public void delete(String key) {
		stringobjRedisTemplate.delete(key);
	}

	@Override
	public void delete(List<String> keys) {
		stringobjRedisTemplate.delete(keys);
		
	}

	@Override
	public long saveSet(String key, T data) {
		SetOperations<String, T> setOper = stringobjRedisTemplate.opsForSet();
		
		long result = setOper.add(key, data);
		
		return result;
	}

	@Override
	public byte[] getData(final byte[] keystr) {
		
		return stringobjRedisTemplate.execute(new RedisCallback<byte[]>() {
			@Override
			public byte[] doInRedis(RedisConnection connection) throws DataAccessException {
				
				return connection.get(keystr);
			}
		});
	}

	@Override
	public long incr(String key) {
		ValueOperations<String, T> valueOper = stringobjRedisTemplate.opsForValue();

		return valueOper.increment(key, 1);
	}

	@Override
	public boolean expire(String key, int expireSeconds) {

		return stringobjRedisTemplate.expire(key, expireSeconds, TimeUnit.SECONDS);

	}

	@Override
	public Set<T> getDataSet(String key) {

		SetOperations<String, T> setOper = stringobjRedisTemplate.opsForSet();

		return setOper.members(key);
	}

	@Override
	public boolean expire(final byte[] key, final int expireSeconds) {
		
		stringobjRedisTemplate.execute(new RedisCallback() {
			@Override
			public Object doInRedis(RedisConnection connection) throws DataAccessException {
				
				
				return connection.expire(key, expireSeconds);
			}
		});
		
		return true;
	}

	@Override
	public long ttl(String key) {
		return stringobjRedisTemplate.getExpire(key);
		
	}

	@Override
	public boolean isMember(String key, T data) {
		SetOperations<String, T> setOper = stringobjRedisTemplate.opsForSet();
		
		return setOper.isMember(key, data);
	}

	@Override
	public void delete(final byte[] key) {

	 stringobjRedisTemplate.execute(new RedisCallback() {
			@Override
			public Object doInRedis(RedisConnection connection) throws DataAccessException {
				return connection.del(key);
			}
		});
		
	}

	
}
