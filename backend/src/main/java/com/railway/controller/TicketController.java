package com.railway.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.railway.common.Result;
import com.railway.entity.*;
import com.railway.mapper.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequiredArgsConstructor
public class TicketController {

    private final StationMapper stationMapper;
    private final TrainMapper trainMapper;
    private final TrainStationMapper trainStationMapper;
    private final TrainStationPriceMapper trainStationPriceMapper;
    private final TrainStationRelationMapper trainStationRelationMapper;
    private final CarriageMapper carriageMapper;

    @GetMapping("/api/ticket-service/station/all")
    public Result<?> getAllStations() {
        List<Station> stations = stationMapper.selectList(
                new LambdaQueryWrapper<Station>().orderByAsc(Station::getId));
        return Result.success(stations);
    }

    @GetMapping("/api/ticket-service/ticket/query")
    public Result<?> queryTickets(
            @RequestParam String fromStation,
            @RequestParam String toStation,
            @RequestParam String departureDate) {

        // Find station names by code
        Station from = stationMapper.selectOne(
                new LambdaQueryWrapper<Station>().eq(Station::getCode, fromStation));
        Station to = stationMapper.selectOne(
                new LambdaQueryWrapper<Station>().eq(Station::getCode, toStation));
        if (from == null || to == null) {
            Map<String, Object> emptyResult = new HashMap<>();
            emptyResult.put("trainList", Collections.emptyList());
            emptyResult.put("trainBrandList", Collections.emptyList());
            emptyResult.put("seatClassTypeList", Collections.emptyList());
            emptyResult.put("departureStationList", Collections.emptyList());
            emptyResult.put("arrivalStationList", Collections.emptyList());
            return Result.success(emptyResult);
        }

        String fromRegion = from.getRegionName();
        String toRegion = to.getRegionName();

        // Find train-station relations for this route
        List<TrainStationRelation> relations = trainStationRelationMapper.selectList(
                new LambdaQueryWrapper<TrainStationRelation>()
                        .eq(TrainStationRelation::getStartRegion, fromRegion)
                        .eq(TrainStationRelation::getEndRegion, toRegion));

        Set<Long> trainIds = relations.stream()
                .map(TrainStationRelation::getTrainId)
                .collect(Collectors.toSet());

        if (trainIds.isEmpty()) {
            Map<String, Object> emptyResult = new HashMap<>();
            emptyResult.put("trainList", Collections.emptyList());
            emptyResult.put("trainBrandList", Collections.emptyList());
            emptyResult.put("seatClassTypeList", Collections.emptyList());
            emptyResult.put("departureStationList", Collections.emptyList());
            emptyResult.put("arrivalStationList", Collections.emptyList());
            return Result.success(emptyResult);
        }

        List<Train> trains = trainMapper.selectBatchIds(trainIds);

        // Build train list with seat class info
        List<Map<String, Object>> trainList = new ArrayList<>();
        Set<Integer> brandSet = new HashSet<>();
        Set<Integer> seatTypeSet = new HashSet<>();
        Set<String> departureStationSet = new HashSet<>();
        Set<String> arrivalStationSet = new HashSet<>();

        for (Train train : trains) {
            // Find this specific relation
            TrainStationRelation rel = relations.stream()
                    .filter(r -> r.getTrainId().equals(train.getId()))
                    .findFirst().orElse(null);
            if (rel == null)
                continue;

            Map<String, Object> trainInfo = new HashMap<>();
            trainInfo.put("trainId", String.valueOf(train.getId()));
            trainInfo.put("trainNumber", train.getTrainNumber());
            trainInfo.put("trainType", train.getTrainType());
            trainInfo.put("trainTag", train.getTrainTag());
            trainInfo.put("trainBrand", train.getTrainBrand());
            trainInfo.put("departure", rel.getDeparture());
            trainInfo.put("arrival", rel.getArrival());

            // Format times
            DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");
            trainInfo.put("departureTime", rel.getDepartureTime().format(timeFormat));
            trainInfo.put("arrivalTime", rel.getArrivalTime().format(timeFormat));

            // Calculate duration
            Duration duration = Duration.between(rel.getDepartureTime(), rel.getArrivalTime());
            long hours = duration.toHours();
            long minutes = duration.toMinutesPart();
            trainInfo.put("duration", String.format("%02d:%02d", hours, minutes));
            trainInfo.put("departureFlag", rel.getDepartureFlag());
            trainInfo.put("arrivalFlag", rel.getArrivalFlag());
            trainInfo.put("saleStatus", train.getSaleStatus());
            trainInfo.put("daysArrived", 0);

            // Get prices for this route
            List<TrainStationPrice> prices = trainStationPriceMapper.selectList(
                    new LambdaQueryWrapper<TrainStationPrice>()
                            .eq(TrainStationPrice::getTrainId, train.getId())
                            .eq(TrainStationPrice::getDeparture, rel.getDeparture())
                            .eq(TrainStationPrice::getArrival, rel.getArrival()));

            // Get carriages for seat count
            List<Carriage> carriages = carriageMapper.selectList(
                    new LambdaQueryWrapper<Carriage>()
                            .eq(Carriage::getTrainId, train.getId()));

            // Build seatClassList
            List<Map<String, Object>> seatClassList = new ArrayList<>();
            for (TrainStationPrice price : prices) {
                Map<String, Object> seatClass = new HashMap<>();
                seatClass.put("type", price.getSeatType());
                seatClass.put("price", price.getPrice());

                // Count available seats from carriages of this type
                int quantity = carriages.stream()
                        .filter(c -> Objects.equals(c.getCarriageType(), price.getSeatType()))
                        .mapToInt(Carriage::getSeatCount)
                        .sum();
                seatClass.put("quantity", quantity);
                seatClass.put("candidate", false);
                seatClassList.add(seatClass);
                seatTypeSet.add(price.getSeatType());
            }
            trainInfo.put("seatClassList", seatClassList);

            // Collect brands
            if (train.getTrainBrand() != null) {
                Arrays.stream(train.getTrainBrand().split(","))
                        .filter(s -> !s.isEmpty())
                        .forEach(b -> brandSet.add(Integer.parseInt(b.trim())));
            }

            departureStationSet.add(rel.getDeparture());
            arrivalStationSet.add(rel.getArrival());

            trainList.add(trainInfo);
        }

        // Sort by departure time
        trainList.sort((a, b) -> ((String) a.get("departureTime")).compareTo((String) b.get("departureTime")));

        Map<String, Object> result = new HashMap<>();
        result.put("trainList", trainList);
        result.put("trainBrandList", new ArrayList<>(brandSet));
        result.put("seatClassTypeList", new ArrayList<>(seatTypeSet));
        result.put("departureStationList", new ArrayList<>(departureStationSet));
        result.put("arrivalStationList", new ArrayList<>(arrivalStationSet));

        return Result.success(result);
    }

    @GetMapping("/api/ticket-service/train-station/query")
    public Result<?> queryTrainStation(@RequestParam String trainId) {
        List<TrainStation> stations = trainStationMapper.selectList(
                new LambdaQueryWrapper<TrainStation>()
                        .eq(TrainStation::getTrainId, Long.parseLong(trainId))
                        .orderByAsc(TrainStation::getSequence));

        DateTimeFormatter timeFormat = DateTimeFormatter.ofPattern("HH:mm");
        List<Map<String, Object>> result = stations.stream().map(s -> {
            Map<String, Object> map = new HashMap<>();
            map.put("sequence", s.getSequence());
            map.put("departure", s.getDeparture());
            map.put("arrivalTime", s.getArrivalTime() != null ? s.getArrivalTime().format(timeFormat) : "-");
            map.put("departureTime", s.getDepartureTime() != null ? s.getDepartureTime().format(timeFormat) : "-");
            map.put("stopoverTime", s.getStopoverTime() != null ? s.getStopoverTime() + "分" : "-");
            return map;
        }).collect(Collectors.toList());

        return Result.success(result);
    }

    @GetMapping("/api/ticket-service/region-station/query")
    public Result<?> queryRegionStation(@RequestParam(required = false) String name) {
        LambdaQueryWrapper<Station> wrapper = new LambdaQueryWrapper<>();
        if (name != null && !name.isEmpty()) {
            wrapper.like(Station::getRegionName, name);
        }
        List<Station> stations = stationMapper.selectList(wrapper);
        return Result.success(stations);
    }

    @PostMapping("/api/ticket-service/ticket/purchase/v2")
    public Result<?> purchaseTicket(@RequestBody PurchaseRequest req) {
        // Simplified purchase - just return success with order SN
        String orderSn = "OR" + System.currentTimeMillis();
        Map<String, Object> result = new HashMap<>();
        result.put("orderSn", orderSn);
        return Result.success(result);
    }

    @PostMapping("/api/ticket-service/ticket/cancel")
    public Result<?> cancelTicket(@RequestBody Map<String, Object> req) {
        return Result.success(null);
    }

    @PostMapping("/api/ticket-service/ticket/refund")
    public Result<?> refundTicket(@RequestBody Map<String, Object> req) {
        return Result.success(null);
    }

    @Data
    public static class PurchaseRequest {
        private String trainId;
        private List<Map<String, Object>> passengers;
        private String departure;
        private String arrival;
        private Integer chooseType;
    }
}
