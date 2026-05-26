## 项目规范

- **框架**：React 18 + TypeScript
- **UI 库**：Ant Design 5.x（antd 组件）
- **路由**：React Router 6，src/routes/ 下独立文件，使用 createBrowserRouter
- **API**：ES Module 风格，import request from '@/utils/request'（基于 axios）
- **Mock**：Mock.js + axios-mock-adapter，或 MSW（Mock Service Worker）
- **状态管理**：Zustand，src/stores/ 下按模块组织
- **视图组织**：src/pages/{模块名}/index.tsx 主页面 + components/ 子组件
- **类型定义**：src/types/{模块名}/ 下集中管理
- **工具函数**：src/utils/ 下按功能组织
