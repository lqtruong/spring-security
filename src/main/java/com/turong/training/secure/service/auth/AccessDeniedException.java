package com.turong.training.secure.service.auth;

public class AccessDeniedException extends Exception {

    private String adminId;
    private String role;
    private String tenant;

    AccessDeniedException(String adminId, String role, String tenant) {
        super("User has no configured permissions. Please contact the admin.");
        this.adminId = adminId;
        this.role = role;
        this.tenant = tenant;
    }

}
