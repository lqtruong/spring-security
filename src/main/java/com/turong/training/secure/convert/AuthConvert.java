package com.turong.training.secure.convert;

import com.turong.training.secure.controller.auth.AuthRequest;
import com.turong.training.secure.controller.auth.AuthResponse;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface AuthConvert {

    AuthResponse toResponse(AuthRequest request);

}
