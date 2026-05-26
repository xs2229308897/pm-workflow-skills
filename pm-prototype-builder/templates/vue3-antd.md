## 项目规范

- **框架**：Vue 3 + TypeScript
- **UI 库**：Ant Design Vue 4.x（a- 前缀组件）
- **路由**：Vue Router 4，src/router/modules/ 下独立文件，导出数组
- **API**：ES Module 风格，import request from '@/utils/request'
- **Mock**：{ url, type, response } 路由定义，使用 success()/fail() 格式化
- **状态管理**：Pinia，Composition API + TypeScript，defineStore setup 风格
- **视图组织**：src/views/{模块名}/index.vue 主页面 + components/ 子组件
- **类型定义**：src/types/{模块名}/ 下集中管理
- **工具函数**：src/utils/ 下按功能组织
