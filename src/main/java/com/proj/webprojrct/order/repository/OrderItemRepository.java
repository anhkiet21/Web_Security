package com.proj.webprojrct.order.repository;

import com.proj.webprojrct.order.entity.OrderItem;
import com.proj.webprojrct.order.entity.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    List<OrderItem> findByOrder(Order order);
}
