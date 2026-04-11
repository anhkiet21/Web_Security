package com.proj.webprojrct.websocket.user;

import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class UserRegistryService {

    // sessionId -> UserSession
    private final Map<String, UserSession> registry = new ConcurrentHashMap<>();

    public void add(String sessionId, UserSession user) {
        user.setSessionId(sessionId);
        registry.put(sessionId, user);
    }

    public void remove(String sessionId) {
        registry.remove(sessionId);
    }

    public Collection<UserSession> listUsers() {
        return new ArrayList<>(registry.values());
    }

    public List<String> findSessionIdsByNick(String nickName) {
        if (nickName == null) return List.of();
        return registry.entrySet().stream()
                .filter(e -> nickName.equals(e.getValue().getNickName()))
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());
    }
}
