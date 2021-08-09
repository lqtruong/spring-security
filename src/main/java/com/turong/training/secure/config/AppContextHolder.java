package com.turong.training.secure.config;

import com.turong.training.secure.model.TenantUserDetails;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.UtilityClass;
import lombok.extern.slf4j.Slf4j;

import static java.util.Objects.isNull;
import static org.apache.commons.lang3.StringUtils.isBlank;

@UtilityClass
@Slf4j
public class AppContextHolder {

    @Getter
    @Setter
    @ToString
    private static class AppContext {

        private TenantUserDetails currentUser;

        public void printAll() {
            log.debug("Context properties={}", this);
        }
    }

    private static final ThreadLocal<AppContext> CONTEXT = new ThreadLocal<>();

    public static String getTenant() {
        if (!hasContext()) {
            return null;
        }
        if (!hasUserTenant()) {
            return null;
        }
        return CONTEXT.get().getCurrentUser().getTenantId();
    }

    public static void setUser(final TenantUserDetails user) {
        initializeIfEmpty();
        CONTEXT.get().setCurrentUser(user);
    }

    public static TenantUserDetails getUser() {
        if (!hasContext()) {
            return null;
        }
        return CONTEXT.get().getCurrentUser();
    }

    private static void initializeIfEmpty() {
        if (!hasContext()) {
            CONTEXT.set(new AppContext());
        }
    }

    private static boolean hasContext() {
        return !isNull(CONTEXT.get());
    }

    private static boolean hasUserTenant() {
        return hasContext() && !isNull(CONTEXT.get().getCurrentUser()) && !isBlank(CONTEXT.get().getCurrentUser().getTenantId());
    }

    public void clear() {
        if (hasContext()) {
            CONTEXT.remove();
        }
    }
}
