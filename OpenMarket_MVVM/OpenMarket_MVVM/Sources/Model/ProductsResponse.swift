//
//  ProductsResponse.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.


import Foundation

struct ProductsResponse: Codable {
    let pageNumber: Int
    let pageItemCount: Int
    let itemCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let items: [Product]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNo"
        case pageItemCount = "itemsPerPage"
        case itemCount = "totalCount"
        case items = "pages"
        case offset, limit, lastPage, hasNext, hasPrev
    }
}

enum Currency: String, Codable {
    case KRW
    case USD
}

struct Product: Codable, Hashable {
    let id: Int
    let vendorId: Int
    let vendorName: String
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdDate: String
    let issuedDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, vendorName, name, description, thumbnail, currency, price, stock
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdDate = "created_at"
        case issuedDate = "issued_at"
    }
}

extension Product {
    static func mockData() -> [Self] {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            let data = try decoder.decode(ProductsResponse.self, from: ProductsResponse.mockData)
            return data.items
        } catch {
            print(error)
            return []
        }
    }
}

extension ProductsResponse {
    static let mockData: Data = """
{
  "pageNo": 1,
  "itemsPerPage": 30,
  "totalCount": 1178,
  "offset": 0,
  "limit": 30,
  "lastPage": 40,
  "hasNext": true,
  "hasPrev": false,
  "pages": [
    {
      "id": 1934,
      "vendor_id": 50,
      "vendorName": "kyo12",
      "name": "삼다수 ㅍ",
      "description": "99",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/50/20230321/a91f008dc7c111edacad49030678a921_thumb",
      "currency": "KRW",
      "price": 800,
      "bargain_price": 740,
      "discounted_price": 60,
      "stock": 999,
      "created_at": "2023-03-21T00:00:00",
      "issued_at": "2023-03-21T00:00:00"
    },
    {
      "id": 1915,
      "vendor_id": 65,
      "vendorName": "seohyeon2",
      "name": "봄이 왔네요",
      "description": "봄봄봄 봄이 왔네요~",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/65/20230319/10743bb2c66611edacad0bff25c36d4f_thumb",
      "currency": "KRW",
      "price": 1000,
      "bargain_price": 1000,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-03-19T00:00:00",
      "issued_at": "2023-03-19T00:00:00"
    },
    {
      "id": 1914,
      "vendor_id": 48,
      "vendorName": "zhilly",
      "name": "오랜만ㅇㅇ",
      "description": "오랜만이네요. 오픈마켓 하하하",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/48/20230319/95ead57fc62811edacad4bde98385c42_thumb.png",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 1,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-03-19T00:00:00",
      "issued_at": "2023-03-19T00:00:00"
    },
    {
      "id": 1891,
      "vendor_id": 50,
      "vendorName": "kyo12",
      "name": "1",
      "description": "",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/50/20230318/114acb58c56011edacada924ee94d71c_thumb",
      "currency": "KRW",
      "price": 123123,
      "bargain_price": 123123,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-03-18T00:00:00",
      "issued_at": "2023-03-18T00:00:00"
    },
    {
      "id": 1889,
      "vendor_id": 43,
      "vendorName": "gundy93",
      "name": "고당도 수박",
      "description": "크루인 수박입니다 떨이로 판매합니다~",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/43/20230318/612ea6f2c55611edacad91801306fdb6_thumb.jpeg",
      "currency": "KRW",
      "price": 8000,
      "bargain_price": 7900,
      "discounted_price": 100,
      "stock": 1,
      "created_at": "2023-03-18T00:00:00",
      "issued_at": "2023-03-18T00:00:00"
    },
    {
      "id": 1888,
      "vendor_id": 50,
      "vendorName": "kyo12",
      "name": "123",
      "description": "1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/50/20230318/6a0f661fc54611edacad5fa4e94cf77a_thumb",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 1,
      "discounted_price": 0,
      "stock": 1213,
      "created_at": "2023-03-18T00:00:00",
      "issued_at": "2023-03-18T00:00:00"
    },
    {
      "id": 1887,
      "vendor_id": 65,
      "vendorName": "seohyeon2",
      "name": "세상에나",
      "description": "123",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/65/20230317/be5020bcc4cf11edacad29a483cf602e_thumb",
      "currency": "KRW",
      "price": 1000,
      "bargain_price": 1000,
      "discounted_price": 0,
      "stock": 0,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1886,
      "vendor_id": 9,
      "vendorName": "sixthVendor",
      "name": "",
      "description": "",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/9/20230317/69b315b9c4cc11edacad018139a26d85_thumb.png",
      "currency": "KRW",
      "price": 0,
      "bargain_price": 0,
      "discounted_price": 0,
      "stock": 0,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1885,
      "vendor_id": 9,
      "vendorName": "sixthVendor",
      "name": "",
      "description": "",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/9/20230317/69475b96c4cc11edacade54d5af17d89_thumb.png",
      "currency": "KRW",
      "price": 0,
      "bargain_price": 0,
      "discounted_price": 0,
      "stock": 0,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1884,
      "vendor_id": 9,
      "vendorName": "sixthVendor",
      "name": "",
      "description": "",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/9/20230317/675b4303c4cc11edacadcd030c84923a_thumb.png",
      "currency": "KRW",
      "price": 0,
      "bargain_price": 0,
      "discounted_price": 0,
      "stock": 0,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1883,
      "vendor_id": 31,
      "vendorName": "sunny2",
      "name": "Ty’s",
      "description": "상품평을 입력하는 곳입니다.",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/31/20230317/97caf0d0c4a911edacad6136b5ce45dd_thumb",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 1,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1882,
      "vendor_id": 65,
      "vendorName": "seohyeon2",
      "name": "ttt",
      "description": "t1t1t1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/65/20230317/815ef36dc49811edacad45082e5ceee9_thumb.jpeg",
      "currency": "KRW",
      "price": 10000,
      "bargain_price": 9500,
      "discounted_price": 500,
      "stock": 1234567,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1881,
      "vendor_id": 63,
      "vendorName": "unchain",
      "name": "ttt",
      "description": "t1t1t1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/63/20230317/27af77a9c49711edacada71d4cf66369_thumb.png",
      "currency": "KRW",
      "price": 10000,
      "bargain_price": 9500,
      "discounted_price": 500,
      "stock": 1234567,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1880,
      "vendor_id": 1,
      "vendorName": "soobak1234",
      "name": "ttt",
      "description": "t1t1t1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/1/20230317/ee09edf6c49611edacadc908db767b63_thumb.jpeg",
      "currency": "KRW",
      "price": 10000,
      "bargain_price": 9500,
      "discounted_price": 500,
      "stock": 1234567,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1879,
      "vendor_id": 1,
      "vendorName": "soobak1234",
      "name": "ttt",
      "description": "t1t1t1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/1/20230317/baaef4f3c49611edacad990c7cfa6ff2_thumb.png",
      "currency": "KRW",
      "price": 10000,
      "bargain_price": 9500,
      "discounted_price": 500,
      "stock": 1234567,
      "created_at": "2023-03-17T00:00:00",
      "issued_at": "2023-03-17T00:00:00"
    },
    {
      "id": 1878,
      "vendor_id": 50,
      "vendorName": "kyo12",
      "name": "10",
      "description": "1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/50/20230309/259efa5ebe4511edacad17d4a7850474_thumb",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 1,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-03-09T00:00:00",
      "issued_at": "2023-03-09T00:00:00"
    },
    {
      "id": 1877,
      "vendor_id": 50,
      "vendorName": "kyo12",
      "name": "123",
      "description": "11111",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/50/20230309/d0f6eb7bbe4411edacad953d25d37773_thumb",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 0,
      "discounted_price": 1,
      "stock": 1,
      "created_at": "2023-03-09T00:00:00",
      "issued_at": "2023-03-09T00:00:00"
    },
    {
      "id": 1874,
      "vendor_id": 15,
      "vendorName": "red123",
      "name": "12312312",
      "description": "1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/15/20230227/a593eb52b6d411edbe103fd3cfcea491_thumb",
      "currency": "KRW",
      "price": 11,
      "bargain_price": 10,
      "discounted_price": 1,
      "stock": 1,
      "created_at": "2023-02-27T00:00:00",
      "issued_at": "2023-02-27T00:00:00"
    },
    {
      "id": 1825,
      "vendor_id": 30,
      "vendorName": "zaezae",
      "name": "A",
      "description": "1",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/30/20230217/2f7f3449aec111edbe109b7ab4aa45e3_thumb.png",
      "currency": "KRW",
      "price": 1,
      "bargain_price": 0,
      "discounted_price": 1,
      "stock": 1,
      "created_at": "2023-02-17T00:00:00",
      "issued_at": "2023-02-17T00:00:00"
    },
    {
      "id": 1783,
      "vendor_id": 58,
      "vendorName": "derrick",
      "name": "운동기구",
      "description": "운동기구 팝니다",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/58/20230212/1d5e8f03aaa711edbe103bc3b2913c11_thumb.png",
      "currency": "KRW",
      "price": 5000,
      "bargain_price": 5000,
      "discounted_price": 0,
      "stock": 10,
      "created_at": "2023-02-12T00:00:00",
      "issued_at": "2023-02-12T00:00:00"
    },
    {
      "id": 1782,
      "vendor_id": 11,
      "vendorName": "borysarang",
      "name": "맥북 2019",
      "description": "사용하던 맥북입니다.",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20230211/f2153020a9ab11edbe10813c0ab3090e_thumb.png",
      "currency": "KRW",
      "price": 1500000,
      "bargain_price": 1400000,
      "discounted_price": 100000,
      "stock": 1,
      "created_at": "2023-02-11T00:00:00",
      "issued_at": "2023-02-11T00:00:00"
    },
    {
      "id": 1781,
      "vendor_id": 29,
      "vendorName": "wongbing",
      "name": "m1 Mac mini",
      "description": "맥미니 ㅡ1사고싶다",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20230209/cee636c7a82a11edbe107773d1744486_thumb.png",
      "currency": "KRW",
      "price": 2100000,
      "bargain_price": 2100000,
      "discounted_price": 0,
      "stock": 10,
      "created_at": "2023-02-09T00:00:00",
      "issued_at": "2023-02-09T00:00:00"
    },
    {
      "id": 1780,
      "vendor_id": 29,
      "vendorName": "wongbing",
      "name": "Airpod Max3",
      "description": "에어팟 맥스2 신형D",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20230206/a6280a8ea61111edbe108f206c80ca52_thumb.png",
      "currency": "KRW",
      "price": 600000,
      "bargain_price": 600000,
      "discounted_price": 0,
      "stock": 10,
      "created_at": "2023-02-06T00:00:00",
      "issued_at": "2023-02-06T00:00:00"
    },
    {
      "id": 1779,
      "vendor_id": 29,
      "vendorName": "wongbing",
      "name": "Apple Watch SE15",
      "description": "애플워치 신형 긴 글",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20230206/ccc93335a5fd11edbe109d4aaf8398e9_thumb.png",
      "currency": "KRW",
      "price": 2019000,
      "bargain_price": 2019000,
      "discounted_price": 0,
      "stock": 10,
      "created_at": "2023-02-06T00:00:00",
      "issued_at": "2023-02-06T00:00:00"
    },
    {
      "id": 1778,
      "vendor_id": 29,
      "vendorName": "wongbing",
      "name": "iPhone 14 pro",
      "description": "아이폰 14 pro 신형 모델",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20230206/9ead4e4ca5fd11edbe10813e3e79defc_thumb.png",
      "currency": "KRW",
      "price": 1430000,
      "bargain_price": 1430000,
      "discounted_price": 0,
      "stock": 10,
      "created_at": "2023-02-06T00:00:00",
      "issued_at": "2023-02-06T00:00:00"
    },
    {
      "id": 1775,
      "vendor_id": 11,
      "vendorName": "borysarang",
      "name": "AirPods(2세대)",
      "description": "무료 각인 서비스 이모티콘, 이름, 이니셜, 숫자를 조합한 각인으로 나만의 AirPods 만들기. 오직 Apple에서만.",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20230203/dba78af0a3bd11edbe1007ad79a78491_thumb.png",
      "currency": "KRW",
      "price": 199000,
      "bargain_price": 199000,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-02-03T00:00:00",
      "issued_at": "2023-02-03T00:00:00"
    },
    {
      "id": 1774,
      "vendor_id": 11,
      "vendorName": "borysarang",
      "name": " Apple Watch SE",
      "description": "알루미늄 케이스는 가볍고 100% 재활용된 항공우주 등급의 합금으로 만들어집니다. 앞뒤가 다른 두 개의 나일론 레이어로 짜여 부드럽고 통기성이 좋은 스포츠 루프. 구조는 후크 앤드 루프 패스너 타입이라 빠르고 간편하게 길이 조절을 할 수 있습니다.",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20230203/b6b11c1da3bd11edbe108f62c5ead27f_thumb.png",
      "currency": "KRW",
      "price": 359000,
      "bargain_price": 359000,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-02-03T00:00:00",
      "issued_at": "2023-02-03T00:00:00"
    },
    {
      "id": 1772,
      "vendor_id": 11,
      "vendorName": "borysarang",
      "name": "iPhone14",
      "description": "17.0cm 또는 15.4cm Super Retina XDR 디스플레이",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20230203/3bc33b07a3bd11edbe10051d3aa6cb1d_thumb.png",
      "currency": "KRW",
      "price": 1550000,
      "bargain_price": 1550000,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-02-03T00:00:00",
      "issued_at": "2023-02-03T00:00:00"
    },
    {
      "id": 1771,
      "vendor_id": 11,
      "vendorName": "borysarang",
      "name": "Mac mini",
      "description": "8코어 CPU 10코어 GPU 8GB 통합 메모리 256GB SSD 저장 장치",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/11/20230203/12ec84c4a3bd11edbe10d93872b7569b_thumb.png",
      "currency": "KRW",
      "price": 850000,
      "bargain_price": 850000,
      "discounted_price": 0,
      "stock": 1,
      "created_at": "2023-02-03T00:00:00",
      "issued_at": "2023-02-03T00:00:00"
    }
  ]
}
""".data(using: .utf8)!
}
