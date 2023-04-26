//
//  RegisterProductMultipartForm.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

struct RegisterProductMultipartForm: MultipartFormable {
    var id: String
    var headers: [HTTPHeader]
}
