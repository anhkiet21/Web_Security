package com.proj.webprojrct.admin.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.proj.webprojrct.user.repository.UserRepository;
import com.proj.webprojrct.product.repository.ProductRepository;
import com.proj.webprojrct.document.repository.DocumentRepository;
import com.proj.webprojrct.order.repository.OrderRepository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

@Service
public class AdminStatsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private DocumentRepository documentRepository;

    @Autowired
    private OrderRepository orderRepository;

    @PersistenceContext
    private EntityManager em;

    public Map<String, Object> overview() {
        long users = userRepository.count();
        long products = productRepository.count();
        long documents = documentRepository.count();
        long orders = orderRepository.count();

        // Get total revenue
        String revenueSql = "SELECT COALESCE(SUM(oi.price * oi.quantity), 0) FROM order_items oi";
        Query revenueQuery = em.createNativeQuery(revenueSql);
        Double totalRevenue = ((Number) revenueQuery.getSingleResult()).doubleValue();

        // Return all statistics, including total revenue
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("users", users);
        result.put("products", products);
        result.put("documents", documents);
        result.put("orders", orders);
        result.put("totalRevenue", totalRevenue);

        return result;
    }

    public Map<String, Long> orders(String period, String week, Integer month, Integer year) {
        String p = (period == null) ? "week" : period.toLowerCase();
        Map<String, Long> buckets = new LinkedHashMap<>();

        if (p.equals("year")) {
            // Yearly statistics - 12 months of a specific year
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            for (int m = 1; m <= 12; m++) {
                String monthKey = String.format("Tháng %d", m);
                buckets.put(monthKey, 0L);
            }

            String sql = "SELECT MONTH(created_at) as m, COUNT(*) as cnt FROM orders "
                    + "WHERE YEAR(created_at) = :year GROUP BY m ORDER BY m";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int monthNum = ((Number) r[0]).intValue();
                String key = String.format("Tháng %d", monthNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0L : num.longValue());
            }

        } else if (p.equals("month")) {
            // Monthly statistics - 30 days of a specific month
            int targetMonth = (month == null) ? LocalDate.now().getMonthValue() : month;
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            LocalDate firstDay = LocalDate.of(targetYear, targetMonth, 1);
            int daysInMonth = firstDay.lengthOfMonth();

            for (int day = 1; day <= daysInMonth; day++) {
                String dayKey = String.format("Ngày %d", day);
                buckets.put(dayKey, 0L);
            }

            String sql = "SELECT DAY(created_at) as d, COUNT(*) as cnt FROM orders "
                    + "WHERE YEAR(created_at) = :year AND MONTH(created_at) = :month "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);
            q.setParameter("month", targetMonth);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int dayNum = ((Number) r[0]).intValue();
                String key = String.format("Ngày %d", dayNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0L : num.longValue());
            }

        } else {
            // Weekly statistics - 7 days
            DateTimeFormatter fmt = DateTimeFormatter.ISO_DATE;
            LocalDate today = LocalDate.now();
            LocalDate startDate = today.minusDays(6);

            // If week parameter is provided (format: 2025-W43)
            if (week != null && week.matches("\\d{4}-W\\d{1,2}")) {
                String[] parts = week.split("-W");
                int weekYear = Integer.parseInt(parts[0]);
                int weekNum = Integer.parseInt(parts[1]);

                // Calculate start date of the week
                startDate = LocalDate.of(weekYear, 1, 1)
                        .with(java.time.temporal.IsoFields.WEEK_OF_WEEK_BASED_YEAR, weekNum)
                        .with(java.time.DayOfWeek.MONDAY);
            }

            for (int i = 0; i < 7; i++) {
                LocalDate date = startDate.plusDays(i);
                String k = date.format(fmt);
                buckets.put(k, 0L);
            }

            String sql = "SELECT DATE(created_at) as d, COUNT(*) as cnt FROM orders "
                    + "WHERE DATE(created_at) >= :startDate AND DATE(created_at) <= :endDate "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("startDate", startDate.toString());
            q.setParameter("endDate", startDate.plusDays(6).toString());

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                if (buckets.containsKey(key)) {
                    buckets.put(key, num == null ? 0L : num.longValue());
                }
            }
        }

        return buckets;
    }

    public Map<String, Double> revenue(String period, String week, Integer month, Integer year) {
        String p = (period == null) ? "week" : period.toLowerCase();
        Map<String, Double> buckets = new LinkedHashMap<>();

        if (p.equals("year")) {
            // Yearly statistics - 12 months of a specific year
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            for (int m = 1; m <= 12; m++) {
                String monthKey = String.format("Tháng %d", m);
                buckets.put(monthKey, 0.0);
            }

            String sql = "SELECT MONTH(o.created_at) as m, SUM(oi.price * oi.quantity) as rev "
                    + "FROM orders o JOIN order_items oi ON o.order_id = oi.order_id "
                    + "WHERE YEAR(o.created_at) = :year GROUP BY m ORDER BY m";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int monthNum = ((Number) r[0]).intValue();
                String key = String.format("Tháng %d", monthNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0.0 : num.doubleValue());
            }

        } else if (p.equals("month")) {
            // Monthly statistics - 30 days of a specific month
            int targetMonth = (month == null) ? LocalDate.now().getMonthValue() : month;
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            LocalDate firstDay = LocalDate.of(targetYear, targetMonth, 1);
            int daysInMonth = firstDay.lengthOfMonth();

            for (int day = 1; day <= daysInMonth; day++) {
                String dayKey = String.format("Ngày %d", day);
                buckets.put(dayKey, 0.0);
            }

            String sql = "SELECT DAY(o.created_at) as d, SUM(oi.price * oi.quantity) as rev "
                    + "FROM orders o JOIN order_items oi ON o.order_id = oi.order_id "
                    + "WHERE YEAR(o.created_at) = :year AND MONTH(o.created_at) = :month "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);
            q.setParameter("month", targetMonth);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int dayNum = ((Number) r[0]).intValue();
                String key = String.format("Ngày %d", dayNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0.0 : num.doubleValue());
            }

        } else {
            // Weekly statistics - 7 days
            LocalDate today = LocalDate.now();
            LocalDate startDate = today.minusDays(6);
            DateTimeFormatter fmt = DateTimeFormatter.ISO_DATE;

            // If week parameter is provided (format: 2025-W43)
            if (week != null && week.matches("\\d{4}-W\\d{1,2}")) {
                String[] parts = week.split("-W");
                int weekYear = Integer.parseInt(parts[0]);
                int weekNum = Integer.parseInt(parts[1]);

                // Calculate start date of the week
                startDate = LocalDate.of(weekYear, 1, 1)
                        .with(java.time.temporal.IsoFields.WEEK_OF_WEEK_BASED_YEAR, weekNum)
                        .with(java.time.DayOfWeek.MONDAY);
            }

            for (int i = 0; i < 7; i++) {
                LocalDate date = startDate.plusDays(i);
                String k = date.format(fmt);
                buckets.put(k, 0.0);
            }

            String sql = "SELECT DATE(o.created_at) as d, SUM(oi.price * oi.quantity) as rev "
                    + "FROM orders o JOIN order_items oi ON o.order_id = oi.order_id "
                    + "WHERE DATE(o.created_at) >= :startDate AND DATE(o.created_at) <= :endDate "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("startDate", startDate.toString());
            q.setParameter("endDate", startDate.plusDays(6).toString());

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                if (buckets.containsKey(key)) {
                    buckets.put(key, num == null ? 0.0 : num.doubleValue());
                }
            }
        }
        return buckets;
    }

    public List<Map<String, Object>> topProducts(Integer limit) {
        int lim = (limit == null || limit <= 0) ? 10 : limit;

        // Sử dụng parameter thay vì nối chuỗi để tránh SQL injection
        String sql = "SELECT p.id, p.name, SUM(oi.quantity) as sold, SUM(oi.price * oi.quantity) as revenue "
                + "FROM products p "
                + "JOIN order_items oi ON p.id = oi.product_id "
                + "GROUP BY p.id, p.name "
                + "ORDER BY sold DESC "
                + "LIMIT :limit";

        Query q = em.createNativeQuery(sql);
        q.setParameter("limit", lim);

        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();
        List<Map<String, Object>> out = new ArrayList<>();

        for (Object[] r : rows) {
            Map<String, Object> m = new java.util.HashMap<>();
            m.put("productId", r[0]);
            m.put("name", r[1]);
            Number sold = (Number) r[2];
            Number rev = (Number) r[3];
            m.put("sold", sold == null ? 0L : sold.longValue());
            m.put("revenue", rev == null ? 0.0 : rev.doubleValue());
            out.add(m);
        }
        return out;
    }

    public Map<String, Long> usersByTime(String period, String week, Integer month, Integer year) {
        String p = (period == null) ? "week" : period.toLowerCase();
        Map<String, Long> buckets = new LinkedHashMap<>();

        if (p.equals("year")) {
            // Yearly statistics - 12 months of a specific year
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            for (int m = 1; m <= 12; m++) {
                String monthKey = String.format("Tháng %d", m);
                buckets.put(monthKey, 0L);
            }

            String sql = "SELECT MONTH(created_at) as m, COUNT(*) as count "
                    + "FROM users "
                    + "WHERE YEAR(created_at) = :year "
                    + "GROUP BY m ORDER BY m";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int monthNum = ((Number) r[0]).intValue();
                String key = String.format("Tháng %d", monthNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0L : num.longValue());
            }

        } else if (p.equals("month")) {
            // Monthly statistics - 30 days of a specific month
            int targetMonth = (month == null) ? LocalDate.now().getMonthValue() : month;
            int targetYear = (year == null) ? LocalDate.now().getYear() : year;

            LocalDate firstDay = LocalDate.of(targetYear, targetMonth, 1);
            int daysInMonth = firstDay.lengthOfMonth();

            for (int day = 1; day <= daysInMonth; day++) {
                String dayKey = String.format("Ngày %d", day);
                buckets.put(dayKey, 0L);
            }

            String sql = "SELECT DAY(created_at) as d, COUNT(*) as count "
                    + "FROM users "
                    + "WHERE YEAR(created_at) = :year AND MONTH(created_at) = :month "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("year", targetYear);
            q.setParameter("month", targetMonth);

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                int dayNum = ((Number) r[0]).intValue();
                String key = String.format("Ngày %d", dayNum);
                Number num = (Number) r[1];
                buckets.put(key, num == null ? 0L : num.longValue());
            }

        } else {
            // Weekly statistics - 7 days
            LocalDate today = LocalDate.now();
            LocalDate startDate = today.minusDays(6);
            DateTimeFormatter fmt = DateTimeFormatter.ISO_DATE;

            // If week parameter is provided (format: 2025-W43)
            if (week != null && week.matches("\\d{4}-W\\d{1,2}")) {
                String[] parts = week.split("-W");
                int weekYear = Integer.parseInt(parts[0]);
                int weekNum = Integer.parseInt(parts[1]);

                // Calculate start date of the week
                startDate = LocalDate.of(weekYear, 1, 1)
                        .with(java.time.temporal.IsoFields.WEEK_OF_WEEK_BASED_YEAR, weekNum)
                        .with(java.time.DayOfWeek.MONDAY);
            }

            for (int i = 0; i < 7; i++) {
                LocalDate date = startDate.plusDays(i);
                String k = date.format(fmt);
                buckets.put(k, 0L);
            }

            String sql = "SELECT DATE(created_at) as d, COUNT(*) as count "
                    + "FROM users "
                    + "WHERE DATE(created_at) >= :startDate AND DATE(created_at) <= :endDate "
                    + "GROUP BY d ORDER BY d";
            Query q = em.createNativeQuery(sql);
            q.setParameter("startDate", startDate.toString());
            q.setParameter("endDate", startDate.plusDays(6).toString());

            @SuppressWarnings("unchecked")
            List<Object[]> rows = q.getResultList();
            for (Object[] r : rows) {
                String key = (r[0] == null) ? "" : r[0].toString();
                Number num = (Number) r[1];
                if (buckets.containsKey(key)) {
                    buckets.put(key, num == null ? 0L : num.longValue());
                }
            }
        }
        return buckets;
    }
}
