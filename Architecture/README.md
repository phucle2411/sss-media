# Flow
Clients -> https://media.sssmarket.com/background.jpg -> round robind -> 2 nginx facing -> nếu cached thì trả về lập tức cho client -> nếu không cache thì request xuống 1 trong 3 nginx cache layer 2 -> nếu cache thì trả về kết quả -> nếu không thì upstream vào MinIO cluster 

# Giải Thích Chi Tiết 
Request sẽ đến 1 trong 2 nginx internet facing theo DNS roundrobin (config domain media.sssmarket.com trỏ vào 2 public ip của 2 nginx servers)

** Note: Nếu server provider bên VN support thì ta có thể config keepalived để tăng khả năng high availability cho 2 con nginx internet facing này

Khi request tới 1 trong 2 con nginx, nginx sẽ check xem content (file ảnh background.jpg) của key "https://media.sssmarket.com/background.jpg" đã được cache chưa? nếu chưa cache sẽ forward xuống những layers phía dưới.

** Note: Mỗi nginx ta có thể add thêm additional cache 100gb cho mỗi nginx internet facing, LRU, expired time khoảng 30-40 ngày. Vì sử dụng roundrobin loadbalancing strategy, nên có khả năng là cùng file ảnh sẽ được cache trên cả 2 nginx, cache storage space có thể nhanh chóng bị đầy, LRU sẽ tự động xoá những ảnh/file ít sử dụng nhất, hoặc xoá trong trường hợp reach expired time. Trong trường hợp cần tiết kiệm resource thì ta có thể dùng 1 nginx internet facing (not recommended)

Trên 2 nginx servers này ta config upstream tới 3 nginx cache layer 2 theo   ** hash $request_uri consistent;
request_uri sẽ được hash, và modulo cho sum của total backend, trong trường hợp này là 3 (3 nginx cache layer 2), Như vậy với mỗi 1 uri, chỉ đc forward tới duy nhất 1 nginx layer 2, không như round robin, và vì thế ảnh background.jpg sẽ được cache duy nhất 1 trong 3 con nginx layer 2, do đó 3 nginx ở layer này sẽ cache được nhiều items khác nhau hơn so với layer internet facing.

** Note: Có thể giảm từ 3 server nginx xuống thành 2. Not recommended

Cuối cùng trong trường hợp https://media.sssmarket.com/background.jpg chưa đc cache ở layer 2, thì sẽ được forward tới MinIO để fetch item từ origin storage, khi có item trả về thì sẽ cache lại ở layer 2 và layer 1. Lần sau Clients khác gọi cùng respurce này thì sẽ không cần đi xuống tận MinIO để lấy item nữa.
