package com.railway.common;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result<T> {
    private String code;
    private String message;
    private T data;
    private boolean success;
    private String requestId;

    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setCode("0");
        result.setMessage("success");
        result.setData(data);
        result.setSuccess(true);
        result.setRequestId(String.valueOf(System.currentTimeMillis()));
        return result;
    }

    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.setCode("1");
        result.setMessage(message);
        result.setSuccess(false);
        result.setRequestId(String.valueOf(System.currentTimeMillis()));
        return result;
    }

    public static <T> Result<T> error(String code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        result.setSuccess(false);
        result.setRequestId(String.valueOf(System.currentTimeMillis()));
        return result;
    }
}
