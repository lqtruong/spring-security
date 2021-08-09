package com.turong.training.secure.entity;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
public class BaseEntity {

    private Long id;
    private String tenantId;
    private String createdBy;
    private String modifiedBy;
    private Date createdAt;
    private Date modifiedAt;

}
