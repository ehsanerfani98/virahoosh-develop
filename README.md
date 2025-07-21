project_root/
│
├── main.py                        
├── alembic.ini                   
│
├── core/
│   └── config.py                
│
├── database/
│   └── session.py               
│
├── middlewares/
│   └── auth_required.py               
│
├── models/                       
│   ├── otp.py
│   ├── permission.py
│   ├── refreshtoken.py
│   ├── role.py
│   ├── token.py
│   ├── user_role.py
│   └── user.py
│
├── crud/                         
│   ├── permission.py
│   ├── role_permission.py
│   ├── role.py
│   ├── token.py
│   ├── user_role.py
│   └── user.py
│
├── schemas/                      
│   ├── permission.py
│   ├── role.py
│   ├── token.py
│   └── user.py
│
├── routers/                      
│   ├── auth.py
│   ├── public.py
│   └── role.py
│
├── controllers/                  
│   ├── auth_controller.py
│   └── role_controller.py
│
├── services/                    
│   ├── auth_service.py
│   ├── auth_session_service.py
│   └── permission_service.py
│
├── static/                    
│   ├── css
│   └── js
│
├── templates/                    
│   ├── auth
│   │   ├── login.html
│   │   └── otp_login.html
│   ├── base.html
│   ├── dashboard.html
│   └── welcome.html
│
└── utils/                       
    └── token.py
