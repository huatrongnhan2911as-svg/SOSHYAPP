# 🍔 SOSHY - Online Food Ordering & Payment System
> **Đề tài:** Xây dựng ứng dụng đặt món ăn trực tuyến tích hợp thanh toán cho nhà hàng SOSHY.

Dự án tập trung vào việc tối ưu hóa quy trình vận hành cho nhà hàng và mang lại trải nghiệm đặt món hiện đại, bảo mật cho khách hàng.

---

## 👥 Đội ngũ thực hiện (Project Team)

Dự án được triển khai bởi nhóm với sự phân công chuyên biệt theo từng giai đoạn:

| Thành viên | Vai trò chính | Nhiệm vụ cụ thể |
| :--- | :--- | :--- |
| **Ngân** | Business Analyst (BA) | Khảo sát quy trình, đặc tả yêu cầu nghiệp vụ hệ thống. |
| **Trung** | Business Analyst (BA) | Phân tích luồng dữ liệu, xây dựng tài liệu SRS. |
| **Thanh** | UI/UX Designer | Thiết kế bản vẽ Prototype, Wireframe và nhận diện thương hiệu. |
| **Nhân** | Fullstack Developer | Phát triển toàn bộ Backend, Frontend và tích hợp thanh toán. |
| **Uy** | BA & QA Specialist | Kiểm thử chất lượng (Manual Test), UAT và quản lý tiến độ. |

---

## 📅 Lộ trình chi tiết (Timeline 23/03 - 29/04)

Dựa trên bảng kế hoạch chi tiết của nhóm, các giai đoạn được phân bổ như sau:

### Giai đoạn 1: Phân tích & Thiết kế (23/03 - 05/04)
- **23/03 - 29/03:** Khảo sát thực tế nhà hàng SOSHY, xác định các nghiệp vụ cần thiết (Menu, đặt bàn, thanh toán).
- **30/03 - 05/04:** Thiết kế giao diện UI/UX trên Figma. Xây dựng sơ đồ cơ sở dữ liệu (ERD).

### Giai đoạn 2: Phát triển hệ thống (06/04 - 23/04)
- **Xây dựng Backend:** Thiết lập API, quản lý người dùng và lưu trữ dữ liệu món ăn.
- **Xây dựng Frontend:** Code giao diện tương tác, giỏ hàng động và bộ lọc món ăn.
- **Tích hợp thanh toán:** Kết nối cổng thanh toán trực tuyến (VNPay/MoMo/Thẻ nội địa).

### Giai đoạn 3: Kiểm thử & Hoàn thiện (24/04 - 29/04)
- **24/04 - 27/04:** Kiểm thử toàn bộ tính năng (Testing), sửa lỗi giao diện và logic thanh toán.
- **28/04 - 29/04:** Hoàn thiện tài liệu dự án, viết README và đóng gói mã nguồn để báo cáo.

---

## 🛠 Công nghệ áp dụng (Tech Stack)

- **Ngôn ngữ & Framework:** React.js (Frontend), Node.js/PHP (Backend).
- **Cơ sở dữ liệu:** MySQL / PostgreSQL.
- **Thanh toán:** Tích hợp API cổng thanh toán trực tuyến.
- **Công cụ quản lý:** GitHub, Figma, Excel (Timeline tracking).

---

## 📈 Sơ đồ tiến độ (Gantt Chart)

```mermaid
gantt
    title SOSHY Project Timeline (23/03 - 29/04)
    dateFormat  YYYY-MM-DD
    section BA Phase
    Phân tích nghiệp vụ (Ngân, Trung) :2026-03-23, 7d
    Xác định yêu cầu hệ thống       :2026-03-30, 5d
    section Design Phase
    Thiết kế UI/UX (Thanh)          :2026-03-30, 7d
    section Dev Phase
    Lập trình Backend & FE (Nhân)   :2026-04-06, 17d
    Tích hợp cổng thanh toán        :2026-04-18, 5d
    section QA Phase
    Kiểm thử & Fix Bug (Uy)         :2026-04-24, 4d
    Hoàn thiện & Đóng gói           :2026-04-28, 2d
