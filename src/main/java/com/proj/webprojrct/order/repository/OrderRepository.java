package com.proj.webprojrct.order.repository;

import com.proj.webprojrct.order.entity.Order;
import com.proj.webprojrct.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByUser(User user);

    List<Order> findByStatus(String status);

    List<Order> findByStatusIn(List<String> statuses);

}
