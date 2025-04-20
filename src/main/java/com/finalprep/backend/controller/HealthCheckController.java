package com.finalprep.backend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthCheckController {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private StringRedisTemplate redisTemplate;

    @GetMapping("/healthz")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> result = new HashMap<>();

        // Spring 애플리케이션이 살아 있음 (이 메서드가 호출됐다는 자체가 증거)
        result.put("spring", "OK");

        // MySQL 체크
        try (Connection conn = dataSource.getConnection()) {
            if (conn.isValid(1)) {
                result.put("mysql", "OK");
            } else {
                result.put("mysql", "Connection not valid");
            }
        } catch (Exception e) {
            result.put("mysql", "ERROR: " + e.getMessage());
        }

        // Redis 체크
        try {
            String pong = redisTemplate.getConnectionFactory().getConnection().ping();
            if ("PONG".equals(pong)) {
                result.put("redis", "OK");
            } else {
                result.put("redis", "Unexpected response: " + pong);
            }
        } catch (Exception e) {
            result.put("redis", "ERROR: " + e.getMessage());
        }

        // 모든 값이 "OK"면 UP, 아니면 DOWN
        boolean allOk = result.values().stream().allMatch(v -> "OK".equals(v));
        result.put("status", allOk ? "UP" : "DOWN");

        return allOk ? ResponseEntity.ok(result) : ResponseEntity.status(500).body(result);
    }
}
