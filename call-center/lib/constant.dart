const isDev = true;
const BASE_URL =
    isDev ? "http://localhost:3000/api/v1" : "http://hausuper-s.me:4000/api/v1";
const LOGIN_URL = "$BASE_URL/staffs/login";
const SOCKET_URL = isDev
    ? "ws://localhost:3003/coord-system"
    : "ws://hausuper-s.me:4003/coord-system";
const TOP5_ADDRESS_URL = "$BASE_URL/booking-system/top-address";
const BOOKING_HISTORY_URL = "$BASE_URL/booking-system/history";
const BOOKCAR_URL = "$BASE_URL/booking-system/book";
